--------------- SQL ---------------

CREATE OR REPLACE FUNCTION migra.f_migrar_cbte_a_central (
  p_id_int_comprobante integer,
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
    v_dat_rel				record;
    v_dat 					record;
    v_cont 					integer;
    v_conexion 				varchar;
    v_conta_codigo_estacion varchar;
    v_id_int_cbte			integer;
    v_resp_dblink			record;
    v_resp_dblink_tra		record;
    v_resp_dblink_tra_rel	record;

BEGIN


   v_nombre_funcion:='migra.f_migrar_cbte_a_central';
   v_conta_codigo_estacion = pxp.f_get_variable_global('conta_codigo_estacion');

	--Verificación de existencia de parámetro
    if not exists(select 1 from conta.tint_comprobante
    			where id_int_comprobante = p_id_int_comprobante) then
    	raise exception 'Migración de comprobante no realizada: comprobante inexistente';
    end if;
    
    --si la conexion por defecto es nula, creamos una conexion
    IF  p_conexion is null THEN
    	v_conexion =  migra.f_crear_conexion();
    ELSE
        v_conexion = p_conexion;
    END IF;
    
    IF v_conexion is null or v_conexion = '' THEN
      raise exception 'No se pudo conectar con la base de datos destino';
    END IF;
    
    --Obtiene los datos del comprobante
    select  
      cbte.*
    into
    	v_rec
    from conta.tint_comprobante cbte
    where cbte.id_int_comprobante = p_id_int_comprobante;
    
    -------------------------------------------
    -- Insertar el cbte
    ----------------------------------------
    
    v_sql= 'INSERT INTO  conta.tint_comprobante
                        (
                          id_usuario_reg,
                          id_usuario_mod,
                          fecha_reg,
                          fecha_mod,
                          estado_reg,
                          id_usuario_ai,
                          usuario_ai,
                          id_clase_comprobante,
                          id_subsistema,
                          id_depto,
                          id_moneda,
                          id_periodo,
                          nro_cbte,
                          momento,
                          glosa1,
                          glosa2,
                          beneficiario,
                          id_funcionario_firma1,
                          id_funcionario_firma2,
                          id_funcionario_firma3,
                          fecha,
                          nro_tramite,
                        
                          momento_comprometido,
                          momento_ejecutado,
                          momento_pagado,
                          id_cuenta_bancaria,
                          id_cuenta_bancaria_mov,
                          nro_cheque,
                          nro_cuenta_bancaria_trans,
                         
                          manual,
                          id_int_comprobante_fks,
                          id_tipo_relacion_comprobante,
                          id_depto_libro,
                          cbte_cierre,
                          cbte_apertura,
                          cbte_aitb,
                          origen,
                          vbregional,
                          codigo_estacion_origen,
                          id_int_comprobante_origen_regional
                        )
                        VALUES ('||
                          COALESCE(v_rec.id_usuario_reg::varchar,'NULL')||','||
                          COALESCE(v_rec.id_usuario_mod::varchar,'NULL')||','||
                          COALESCE(''''||v_rec.fecha_reg::varchar||'''','NULL')||','||
                          COALESCE(''''||v_rec.fecha_mod::varchar||'''','NULL')||',
                          ''borrador'','||
                          COALESCE(v_rec.id_usuario_ai::varchar,'NULL')||','||
                          COALESCE(''''||v_rec.usuario_ai::varchar||'''','NULL')||','||
                          COALESCE(v_rec.id_clase_comprobante::varchar,'NULL')||','||
                          COALESCE(v_rec.id_subsistema::varchar,'NULL')||','||
                          COALESCE(v_rec.id_depto::varchar,'NULL')||','||
                          COALESCE(v_rec.id_moneda::varchar,'NULL')||','||
                          COALESCE(v_rec.id_periodo::varchar,'NULL')||','||
                          COALESCE(''''||v_rec.nro_cbte::varchar||'''','NULL')||','||
                          COALESCE(''''||v_rec.momento::varchar||'''','NULL')||','||
                          COALESCE(''''||v_rec.glosa1::varchar||'''','NULL')||','||
                          COALESCE(''''||v_rec.glosa2::varchar||'''','NULL')||','||
                          COALESCE(''''||v_rec.beneficiario::varchar||'''','NULL')||','||
                          COALESCE(v_rec.id_funcionario_firma1::varchar,'NULL')||','||
                          COALESCE(v_rec.id_funcionario_firma2::varchar,'NULL')||','||
                          COALESCE(v_rec.id_funcionario_firma3::varchar,'NULL')||','||
                          COALESCE(''''||v_rec.fecha::varchar||'''','NULL')||','||
                          COALESCE(''''||v_rec.nro_tramite::varchar||'''','NULL')||','||
                          
                          COALESCE(''''||v_rec.momento_comprometido::varchar||'''','NULL')||','||
                          COALESCE(''''||v_rec.momento_ejecutado::varchar||'''','NULL')||','||
                          COALESCE(''''||v_rec.momento_pagado::varchar||'''','NULL')||','||
                          COALESCE(v_rec.id_cuenta_bancaria::varchar,'NULL')||','||
                          COALESCE(v_rec.id_cuenta_bancaria_mov::varchar,'NULL')||','||
                          COALESCE(v_rec.nro_cheque::varchar,'NULL')||','||
                          COALESCE(''''||v_rec.nro_cuenta_bancaria_trans::varchar||'''','NULL')||','||
                          
                          COALESCE(''''||v_rec.manual::varchar||'''','NULL')||','||
                          COALESCE(''''||v_rec.id_int_comprobante_fks::varchar||'''','NULL')||','||
                          COALESCE(v_rec.id_tipo_relacion_comprobante::varchar,'NULL')||','||
                          COALESCE(v_rec.id_depto_libro::varchar,'NULL')||','||
                          COALESCE(''''||v_rec.cbte_cierre::varchar||'''','NULL')||','||
                          COALESCE(''''||v_rec.cbte_apertura::varchar||'''','NULL')||','||
                          COALESCE(''''||v_rec.cbte_aitb::varchar||'''','NULL')||','||
                          COALESCE(''''||v_rec.origen::varchar||'''','NULL')||','||
                          '''si'','||
                          COALESCE(''''||v_conta_codigo_estacion::varchar||'''','NULL')||','||
                          COALESCE(p_id_int_comprobante::varchar,'NULL')||') RETURNING id_int_comprobante'; 
    
   
    
    SELECT * FROM  dblink(v_conexion,v_sql, true) AS (id_int_comprobante integer) into v_resp_dblink;
    
    
    --almacena el id del comprobante migrado
    update conta.tint_comprobante c set
     id_int_comprobante_origen_central = v_resp_dblink.id_int_comprobante
    where id_int_comprobante = p_id_int_comprobante; 
    
 
    ----------------------------------------
    -- inserta la trasacciones del cbte
    -------------------------------------
    for v_dat in (select
                  tra.*
                  from conta.tint_transaccion tra
                  where tra.id_int_comprobante = p_id_int_comprobante) loop
                  
    	   --insertar la trasaccion
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
                                  id_partida_ejecucion,
                                  id_int_transaccion_fk,
                                  glosa,
                                  importe_debe,
                                  importe_haber,
                                  importe_recurso,
                                  importe_gasto,
                                 
                                  id_detalle_plantilla_comprobante,
                                  id_partida_ejecucion_dev,
                                  importe_reversion,
                                  monto_pagado_revertido,
                                  id_partida_ejecucion_rev,
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
                                  id_int_transaccion_origen
                                )
                                VALUES ('||
                                   COALESCE(v_dat.id_usuario_reg::varchar,'NULL')||','||
                                   COALESCE(v_dat.id_usuario_mod::varchar,'NULL')||','||
                                   COALESCE(''''||v_dat.fecha_reg::varchar||'''','NULL')||','||
                                   COALESCE(''''||v_dat.fecha_mod::varchar||'''','NULL')||','||
                                   COALESCE(''''||v_dat.estado_reg::varchar||'''','NULL')||','||
                                   COALESCE(v_dat.id_usuario_ai::varchar,'NULL')||','||
                                   COALESCE(''''||v_dat.usuario_ai::varchar||'''','NULL')||','||
                                  
                                   COALESCE(v_resp_dblink.id_int_comprobante::varchar,'NULL')||','||
                                   COALESCE(v_dat.id_cuenta::varchar,'NULL')||','||
                                   COALESCE(v_dat.id_auxiliar::varchar,'NULL')||','||
                                   COALESCE(v_dat.id_centro_costo::varchar,'NULL')||','||
                                   COALESCE(v_dat.id_partida::varchar,'NULL')||','||
                                   COALESCE(v_dat.id_partida_ejecucion::varchar,'NULL')||','||
                                   COALESCE(v_dat.id_int_transaccion_fk::varchar,'NULL')||','||
                                   COALESCE(''''||v_dat.glosa::varchar||'''','NULL')||','||
                                   COALESCE(v_dat.importe_debe::varchar,'NULL')||','||
                                   COALESCE(v_dat.importe_haber::varchar,'NULL')||','||
                                   COALESCE(v_dat.importe_recurso::varchar,'NULL')||','||
                                   COALESCE(v_dat.importe_gasto::varchar,'NULL')||','||
                                  
                                   COALESCE(v_dat.id_detalle_plantilla_comprobante::varchar,'NULL')||','||
                                   COALESCE(v_dat.id_partida_ejecucion_dev::varchar,'NULL')||','||
                                   COALESCE(v_dat.importe_reversion::varchar,'NULL')||','||
                                   COALESCE(v_dat.monto_pagado_revertido::varchar,'NULL')||','||
                                   COALESCE(v_dat.id_partida_ejecucion_rev::varchar,'NULL')||','||
                                   COALESCE(v_dat.id_cuenta_bancaria::varchar,'NULL')||','||
                                   COALESCE(v_dat.id_cuenta_bancaria_mov::varchar,'NULL')||','||
                                   COALESCE(v_dat.nro_cheque::varchar,'NULL')||','||
                                   COALESCE(''''||v_dat.nro_cuenta_bancaria_trans::varchar||'''','NULL')||','||
                                   COALESCE(v_dat.porc_monto_excento_var::varchar,'NULL')||','||
                                   COALESCE(''''||v_dat.nombre_cheque_trans::varchar||'''','NULL')||','||
                                   COALESCE(v_dat.factor_reversion::varchar,'NULL')||','||
                                   COALESCE(v_dat.id_orden_trabajo::varchar,'NULL')||','||
                                   COALESCE(''''||v_dat.forma_pago::varchar||'''','NULL')||','||
                                   COALESCE(''''||v_dat.banco::varchar||'''','NULL')||','||
                                   COALESCE(v_dat.id_int_transaccion::varchar,'NULL')||') RETURNING id_int_transaccion'; 
                                   
            
            SELECT * FROM  dblink(v_conexion,v_sql, true) AS (id_int_transaccion integer) into v_resp_dblink_tra;
          
           -- actualizar en trasaccion destino en el origen
           
           update conta.tint_transaccion t set
             id_int_transaccion_origen = v_resp_dblink_tra.id_int_transaccion
           where id_int_transaccion = v_dat.id_int_transaccion;
           
           
           -- FOR listar las relaciones de pago
            for v_dat_rel in (
                           select   
                             rd.monto_pago,
                             rd.id_usuario_reg,
                             it.id_int_transaccion_origen 
                           from conta.tint_rel_devengado rd
                           inner join conta.tint_transaccion  it on it.id_int_transaccion = rd.id_int_transaccion_dev 
                           where rd.id_int_transaccion_pag = v_dat.id_int_transaccion) loop
                  
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
                                      id_partida_ejecucion_pag
                                    )
                                    VALUES ('||
                                      COALESCE(v_dat_rel.id_usuario_reg::varchar,'NULL')||',
                                      now(),
                                      ''activo'','||
                                      COALESCE(v_dat_rel.id_int_transaccion_origen::varchar,'NULL')||','||
                                      COALESCE(v_resp_dblink_tra.id_int_transaccion::varchar,'NULL')||','||
                                      COALESCE(v_dat_rel.monto_pago::varchar,'NULL')||' ) RETURNING id_int_rel_devengado;';
                                      
                                      
                  SELECT * FROM  dblink(v_conexion,v_sql, true) AS (id_int_transaccion integer) into v_resp_dblink_tra_rel;
            
            end loop;
    
             
    
    END LOOP;     
    
    
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