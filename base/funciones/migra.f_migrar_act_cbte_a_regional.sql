--------------- SQL ---------------

CREATE OR REPLACE FUNCTION migra.f_migrar_act_cbte_a_regional (
  p_id_int_comprobante integer,
  p_id_usuario integer,
  p_conexion varchar = NULL::character varying
)
RETURNS varchar AS
$body$
/*
Autor: RAC
Fecha: 01/10/2015
Descripción: 

    Migrar el comprobante de la estacion regional a la central, solo en la moneda base
*/
DECLARE

    v_nombre_funcion        text;
    v_cadena_cnx 			varchar;
    v_resp 					varchar;
    v_sql 					varchar;
    v_rec 					record;
    v_rec_cbte				record;
    v_dat_rel				record;
    v_registros_tran		record;
    v_cont 					integer;
    v_conexion 				varchar;
    v_conta_codigo_estacion varchar;
    v_id_int_cbte			integer;
    v_resp_dblink			record;
    v_resp_dblink_tra		record;
    v_resp_dblink_tra_rel	record;
    
    
    v_sum_debe				numeric;
    v_sum_haber				numeric;
    v_sum_debe_bk			numeric;
    v_sum_haber_bk			numeric;
    v_id_int_comprobante_bk		integer;
    v_tran_ori				text;

BEGIN


   v_nombre_funcion:='migra.f_migrar_act_cbte_a_regional';
   v_conta_codigo_estacion = pxp.f_get_variable_global('conta_codigo_estacion');

	--Verificación de existencia de parámetro
    if not exists(select 1 from conta.tint_comprobante
    			where id_int_comprobante = p_id_int_comprobante) then
    	raise exception 'Migración de comprobante no realizada: comprobante inexistente';
    end if;
    
    
    select 
        c.*
      into 
        v_rec
    from conta.tint_comprobante c
    where id_int_comprobante = p_id_int_comprobante;
    
    
    --si la conexion por defecto es nula, creamos una conexion
    IF  p_conexion is null THEN
    	v_conexion  = migra.f_crear_conexion(v_id_depto_lb,'tes.testacion', v_rec.codigo_estacion_origen);
    ELSE
        v_conexion = p_conexion;
    END IF;
    
    IF v_conexion is null or v_conexion = '' THEN
      raise exception 'No se pudo conectar con la base de datos destino';
    END IF;
    
   
    ---------------------------------------------------------------------
    -- validar que el monto total debe y haber  igualen con   el backup
    ----------------------------------------------------------------------
    
      select 
        sum(t.importe_debe),
        sum(t.importe_haber)
      INTO  
        v_sum_debe,
        v_sum_haber
      from conta.tint_transaccion t
      where t.estado_reg = 'activo' and 
            t.id_int_comprobante = p_id_int_comprobante;
    
     select 
        sum(t.importe_debe),
        sum(t.importe_haber)
      INTO  
        v_sum_debe_bk,
        v_sum_haber_bk
      from conta.tint_transaccion_bk t
      where t.estado_reg = 'activo' and 
            t.id_int_comprobante_bk = v_rec.id_int_comprobante_bk;
    
    IF v_sum_debe_bk != v_sum_debe  or v_sum_haber_bk  = v_sum_haber  THEN    
       raise exception 'los montos totales no pueden variar con respecto al original  (debe: %, haber %) !=  BK(debe: %, haber %)' ,v_sum_debe, v_sum_haber, v_sum_debe_bk, v_sum_haber_bk ;   
    END IF;
    
    
    --------------------------------------
    --  generar un backup en la regional
    --------------------------------------
    
    v_sql = 'select conta.f_backup_int_comprobante('||v_rec.id_int_comprobante_origen_regional::varchar||' );';
    SELECT * FROM  dblink(v_conexion,v_sql, true) as (res varchar) into v_id_int_comprobante_bk;
    
   
    
   
    
   
    ------------------------------------------------------
    -- Actualizar los  datos de la cabecera del comprobante
    --   tipo de cambio no peuden variar
    --   ¿que puede cambiar?
    --         las fechas del costo 
    --         almacena el ide del backup
    --         ...
    ---------------------------------------------------------
    
    
    v_sql = 'update conta.tint_comprobante set 
    				sw_editable = ''si'',
    				id_int_comprobante_bk = '||v_id_int_comprobante_bk::Varchar||',
                    fecha_costo_ini = '''||   v_rec.fecha_costo_ini::varchar||''',
                    fecha_costo_fin = '''||   v_rec.fecha_costo_fin::varchar||'''
                  where id_int_comprobante = '||v_rec.id_int_comprobante_origen_regional::varchar; 
                            
     PERFORM  dblink(v_nombre_conexion, v_sql, true);
    
   
    -------------------------------------------------
    --  Borrar la relacion devengado pago en la 
    --  estacion internacional
    -------------------------------------------------
   
     v_sql = 'select 
               pxp.list(t.id_int_transaccion::varchar)  as lista
             from conta.tint_transaccion t
             where t.id_int_comprobante = '||v_rec.id_int_comprobante_origen_regional::varchar ||'
                   and t.id_estado_reg = ''activo''';
           
    select * FROM dblink(v_nombre_conexion, v_sql,TRUE)AS t1(contador integer) into v_resp_dblink_tra;
   
    --borrar relacion con las transacciones 
    
    v_sql = ' DELETE FROM 
                conta.tint_rel_devengado 
              WHERE 
                   id_int_transaccion_dev in ('||v_resp_dblink_tra.lista::varchar||')
                or id_int_transaccion_pag in ('||v_resp_dblink_tra.lista::varchar||')';
                
    PERFORM dblink(v_nombre_conexion,v_sql, true);
    
  
    -------------------------------------------------
    -- eliminar las transaciones en el cbte internacional 
    -- que no esten el el cbte de la central
    ---------------------------------------------------   
   
     select 
       pxp.list(t.id_int_transaccion_origen::varchar)
     into
       v_tran_ori  
     from conta.tint_transaccion t
     where t.id_int_comprobante = p_id_int_comprobante
           and t.id_estado_reg = 'activo'
           and ( t.importe_debe_mt > 0 or  t.importe_haber_mt > 0);
   
   
   
   --borrar transacciones 
    v_sql = 'delete from conta.tint_transaccion 
             where id_int_transaccion not in ( '||v_tran_ori||')';
                
    PERFORM dblink(v_nombre_conexion,v_consulta, true);
   
   
    --------------------------------------------------------------------
    --  ACTUALIZAR  
    --  transacciones del cbte en la central hacia la regional
    ---------------------------------------------------------------------
    
    FOR v_registros_tran in (
                               select 
                                  t.*
                               from conta.tint_transaccion t
                               where t.id_int_comprobante = p_id_int_comprobante
                                     and t.id_estado_reg = 'activo'
                                     and ( t.importe_debe_mt > 0 or  t.importe_haber_mt > 0)
                              ) LOOP
    
    
            v_sql = 'select 1::integer as contador 
                          from conta.tint_transaccion 
                          where id_int_transaccion = '||v_registros_tran.id_int_transaccion_origen::varchar ;
                
               select * FROM dblink(v_nombre_conexion, v_sql,TRUE)AS t1(contador integer) into v_resp_dblink_tra;
              
               -- si la transaccion exite en el destino ->  modificar transacion con equivalente en la central
               
               IF v_resp_dblink_tra.contador = 1 THEN
               
                   v_sql = 'update conta.tint_transaccion set
                                   id_moneda_tri =  '||COALESCE(v_registros_tran.id_moneda_tri::varchar,'NULL')||',
                                   glosa =  '||COALESCE(''''||v_registros_tran.glosa::varchar||'''','NULL')||',
                                   tipo_cambio_2  =  '||COALESCE(v_registros_tran.tipo_cambio::varchar,'NULL')||',
                                   id_moneda  =  '||COALESCE(v_registros_tran.id_moneda::varchar,'NULL')||',
                                   importe_debe =  '||COALESCE(v_registros_tran.importe_debe::varchar,'NULL')||',
                                   importe_haber =  '||COALESCE(v_registros_tran.importe_haber::varchar,'NULL')||',
                                   importe_gasto =  '||COALESCE(v_registros_tran.importe_gasto::varchar,'NULL')||',
                                   importe_recurso =  '||COALESCE(v_registros_tran.importe_recurso::varchar,'NULL')||',
                                   importe_debe_mt =  '||COALESCE(v_registros_tran.importe_debe_mt::varchar,'NULL')||',
                                   importe_haber_mt =  '||COALESCE(v_registros_tran.importe_haber_mt::varchar,'NULL')||',
                                   importe_gasto_mt =  '||COALESCE(v_registros_tran.importe_gasto_mt::varchar,'NULL')||',
                                   importe_recurso_mt =  '||COALESCE(v_registros_tran.importe_recurso_mt::varchar,'NULL')||',
                                   id_orden_trabajo =  '||COALESCE(v_registros_tran.id_orden_trabajo::varchar,'NULL')||',
                                   id_partida =  '||COALESCE(v_registros_tran.id_partida::varchar,'NULL')||',
                                   id_cuenta =  '||COALESCE(v_registros_tran.id_cuenta::varchar,'NULL')||',
                                   id_centro_costo =  '||COALESCE(v_registros_tran.id_centro_costo::varchar,'NULL')||',
                                   id_auxiliar =  '||COALESCE(v_registros_tran.id_auxiliar::varchar,'NULL')||'
                                   
                                 where id_int_transaccion = '||v_registros_tran.id_int_transaccion_origen::varchar ;
                  
                   
                   PERFORM dblink(v_nombre_conexion,v_consulta, true);
               
               
               ELSE
               --  Insertamos la transaccion que no tiene equivalente 
                      
                            v_sql= 'INSERT INTO 
                                              conta.tint_transaccion
                                            (
                                              id_usuario_reg,
                                              id_usuario_mod,
                                              fecha_reg,
                                              fecha_mod,
                                              estado_reg,
                                              id_usuario_ai,
                                              usuario_ai,
                                             
                                              id_int_comprobante,
                                              id_cuenta,
                                              id_auxiliar,
                                              id_centro_costo,
                                              id_partida,
                                              id_int_transaccion_fk,
                                              glosa,
                                              importe_debe,
                                              importe_haber,
                                              importe_recurso,
                                              importe_gasto,
                                              
                                              importe_debe_mt,
                                              importe_haber_mt,
                                              importe_recurso_mt,
                                              importe_gasto_mt,
                                             
                                              id_detalle_plantilla_comprobante,
                                              importe_reversion,
                                              monto_pagado_revertido,
                                              id_cuenta_bancaria,
                                              id_cuenta_bancaria_mov,
                                              nro_cheque,
                                              nro_cuenta_bancaria_trans,
                                              porc_monto_excento_var,
                                              nombre_cheque_trans,
                                              factor_reversion,
                                              id_orden_trabajo,
                                              forma_pago,
                                              banco,
                                              id_int_transaccion_origen,
                                              id_moneda,
                                              id_moneda_tri,
                                              tipo_cambio_2
                                            )
                                            VALUES ('||
                                               COALESCE(v_registros_tran.id_usuario_reg::varchar,'NULL')||','||
                                               COALESCE(v_registros_tran.id_usuario_mod::varchar,'NULL')||','||
                                               COALESCE(''''||v_dat.fecha_reg::varchar||'''','NULL')||','||
                                               COALESCE(''''||v_dat.fecha_mod::varchar||'''','NULL')||','||
                                               COALESCE(''''||v_dat.estado_reg::varchar||'''','NULL')||','||
                                               COALESCE(v_registros_tran.id_usuario_ai::varchar,'NULL')||','||
                                               COALESCE(''''||v_dat.usuario_ai::varchar||'''','NULL')||','||                                              
                                               COALESCE(v_registros_tran.id_int_comprobante_origen_regional::varchar,'NULL')||','||
                                               COALESCE(v_registros_tran.id_cuenta::varchar,'NULL')||','||
                                               COALESCE(v_registros_tran.id_auxiliar::varchar,'NULL')||','||
                                               COALESCE(v_registros_tran.id_centro_costo::varchar,'NULL')||','||
                                               COALESCE(v_registros_tran.id_partida::varchar,'NULL')||','||                                             
                                               COALESCE(v_registros_tran.id_int_transaccion_fk::varchar,'NULL')||','||
                                               COALESCE(''''||v_registros_tran.glosa::varchar||'''','NULL')||','||                                               
                                               COALESCE(v_registros_tran.importe_debe::varchar,'NULL')||','||
                                               COALESCE(v_registros_tran.importe_haber::varchar,'NULL')||','||
                                               COALESCE(v_registros_tran.importe_recurso::varchar,'NULL')||','||
                                               COALESCE(v_registros_tran.importe_gasto::varchar,'NULL')||','||
                                               
                                               COALESCE(v_registros_tran.importe_debe_mt::varchar,'NULL')||','||
                                               COALESCE(v_registros_tran.importe_haber_mt::varchar,'NULL')||','||
                                               COALESCE(v_registros_tran.importe_recurso_mt::varchar,'NULL')||','||
                                               COALESCE(v_registros_tran.importe_gasto_mt::varchar,'NULL')||','||
                                              
                                               COALESCE(v_registros_tran.id_detalle_plantilla_comprobante::varchar,'NULL')||','||
                                               COALESCE(v_registros_tran.importe_reversion::varchar,'NULL')||','||
                                               COALESCE(v_registros_tran.monto_pagado_revertido::varchar,'NULL')||','||
                                               COALESCE(v_registros_tran.id_cuenta_bancaria::varchar,'NULL')||','||
                                               COALESCE(v_registros_tran.id_cuenta_bancaria_mov::varchar,'NULL')||','||
                                               COALESCE(v_registros_tran.nro_cheque::varchar,'NULL')||','||
                                               COALESCE(''''||v_registros_tran.nro_cuenta_bancaria_trans::varchar||'''','NULL')||','||
                                               COALESCE(v_registros_tran.porc_monto_excento_var::varchar,'NULL')||','||
                                               COALESCE(''''||v_registros_tran.nombre_cheque_trans::varchar||'''','NULL')||','||
                                               COALESCE(v_registros_tran.factor_reversion::varchar,'NULL')||','||
                                               COALESCE(v_registros_tran.id_orden_trabajo::varchar,'NULL')||','||
                                               COALESCE(''''||v_registros_tran.forma_pago::varchar||'''','NULL')||','||
                                               COALESCE(''''||v_registros_tran.banco::varchar||'''','NULL')||','||
                                               COALESCE(v_registros_tran.id_int_transaccion::varchar,'NULL')||','||
                                               COALESCE(v_registros_tran.id_moneda::varchar,'NULL')||','||
                                               COALESCE(v_registros_tran.id_moneda_tri::varchar,'NULL')||','||
                                               COALESCE(v_registros_tran.tipo_cambio::varchar,'NULL')||'
                                               
                                               ) RETURNING id_int_transaccion'; 
                                               
                        
                        SELECT * FROM  dblink(v_conexion,v_sql, true) AS (id_int_transaccion integer) into v_resp_dblink_tra;
                      
                       --  Actulizar referencia de la transaccion origen y destino
              
                       update conta.tint_transaccion t set
                         id_int_transaccion_origen = v_resp_dblink_tra.id_int_transaccion
                       where id_int_transaccion = v_registros_tran.id_int_transaccion;
               
                END IF;
                
                
                ------------------------------------------------
                --  Migrar relacion devengado pagado 
                --  si existe en la central, hacia la regional
                -------------------------------------------------
                
                -- FOR listar las relaciones de pago
                for v_dat_rel in (
                               select   
                                 rd.monto_pago,
                                 rd.monto_pago_mt,
                                 rd.id_usuario_reg,
                                 it.id_int_transaccion_origen 
                               from conta.tint_rel_devengado rd
                               inner join conta.tint_transaccion  it on it.id_int_transaccion = rd.id_int_transaccion_dev 
                               where rd.id_int_transaccion_pag = v_registros_tran.id_int_transaccion) loop
                      
                      --insertar relacion devengado pago 
                      v_sql = 'INSERT INTO 
                                          conta.tint_rel_devengado
                                        (
                                          id_usuario_reg,
                                          fecha_reg,
                                          estado_reg,
                                          id_int_transaccion_dev,
                                          id_int_transaccion_pag,
                                          monto_pago,
                                          monto_pago_mt
                                        )
                                        VALUES ('||
                                          COALESCE(v_dat_rel.id_usuario_reg::varchar,'NULL')||',
                                          now(),
                                          ''activo'','||
                                          COALESCE(v_dat_rel.id_int_transaccion_origen::varchar,'NULL')||','||
                                          COALESCE(v_resp_dblink_tra.id_int_transaccion::varchar,'NULL')||','||
                                          COALESCE(v_dat_rel.monto_pago::varchar,'NULL')||' ,'||
                                          COALESCE(v_dat_rel.monto_pago_mt::varchar,'NULL')||' 
                                          
                                          ) RETURNING id_int_rel_devengado;';
                                          
                                          
                      SELECT * FROM  dblink(v_conexion,v_sql, true) AS (id_int_transaccion integer) into v_resp_dblink_tra_rel;
                
                end loop;
 

      
        
    END LOOP;
    
    
    -----------------------------------------------------
    -- llamada a la funcion que calcula equivalencia en 
    -- moneda base en la estacion internacional
    --------------------------------------------------------
    
    
    v_sql = 'SELECT * FROM conta.f_act_trans_cbte_generados('||v_rec.id_int_comprobante_origen_regional::varchar||',''Regional'')'; 
                            
    SELECT * FROM dblink(v_conexion,v_sql,TRUE)AS t1(resp boolean) into v_resp_dblink_tra;
     
    
    ---------------------------------------------------------------
    --  llamada la funcion que iguala el comprobante 
    --  (por si existiera diferencias por redondeo o tipo de cambio)
    ------------------------------------------------------------------
    
     v_sql = 'SELECT * FROM conta.f_igualar_cbte('||v_rec.id_int_comprobante_origen_regional::varchar||','||p_id_usuario ||')'; 
                            
     SELECT * FROM dblink(v_conexion,v_sql,TRUE)AS t1(resp boolean) into v_resp_dblink_tra;
     
     
    
    --si la conexion pro defecto es nula cerramso la conexion que creamos
    IF p_conexion is null THEN
    	select * into v_resp from migra.f_cerrar_conexion(v_conexion,'exito');
    END IF;
    --Devuelve la respuesta
    return 'Hecho';


EXCEPTION
WHEN OTHERS THEN
			v_resp='';
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
			v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
			v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
			raise exception '%',v_resp;



END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;