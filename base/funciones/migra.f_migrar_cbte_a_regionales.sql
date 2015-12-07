--------------- SQL ---------------

CREATE OR REPLACE FUNCTION migra.f_migrar_cbte_a_regionales (
  p_id_int_comprobante integer,
  p_id_plan_pago integer,
  p_conexion varchar = NULL::character varying
)
RETURNS varchar AS
$body$
/*
Autor: RAC
Fecha: 02/09/2015
Descripción: 

    Migrar el comprobante Temporal generado en PXP central a PXP en as estaciones internacionales 
*/
DECLARE

    v_nombre_funcion        text;
    v_cadena_cnx 			varchar;
    v_resp 					varchar;
    v_sql 					varchar;
    v_rec 					record;
    v_dat 					record;
    v_dat_rel				record;
    v_cont 					integer;
    v_id_depto_lb			integer;
    
    va_id_int_transaccion integer[]; 
    va_id_cuenta integer[]; 
    va_id_auxiliar integer[]; 
    va_id_centro_costo integer[];
    va_id_orden_trabajo integer[];
    va_id_partida integer[];
    va_id_partida_ejecucion integer[];
    va_id_int_transaccion_fk integer[];
    va_glosa varchar[];
    va_importe_debe numeric[];
    va_importe_haber numeric[];
    va_importe_recurso numeric[];
    va_importe_gasto numeric[];
    va_id_uo integer[];
	va_id_ep integer[];    
    v_id_depto_endesis  			integer;    
    v_tipo_cambio 					numeric;    
    va_id_cuenta_bancaria 			integer[];
    va_nombre_cheque_trans 			varchar[];
    va_nro_cheque 					integer[];
    va_tipo 						varchar[];
    va_id_libro_bancos 				integer[];
    va_id_cuenta_bancaria_endesis 	integer[];    
    v_glosa1 						varchar;
    v_glosa2 						varchar;
    v_id_depto_libro  				integer;
    v_id_depto_origen_pxp			integer;
    v_conexion 						varchar;
    v_resp_dblink 					varchar;
    v_resp_dblink_tra				varchar;
    v_resp_dblink_tra_rel 			varchar;
    v_id_moneda_base_reg			integer;
    v_importe_debe_mb				numeric;
    v_importe_haber_mb				numeric;
    v_sw_mon 						integer;
    v_id_int_comprobante_reg		integer;
    v_id_int_transaccion_reg		integer;
    v_id_moneda_tri_reg				integer;

BEGIN


   v_nombre_funcion:='migra.f_migrar_cbte_a_regionales';

	
    --Verificación la existencia del parámetro
    if not exists(select 1 from conta.tint_comprobante
    			where id_int_comprobante = p_id_int_comprobante) then
    	raise exception 'Migración de comprobante no realizada: comprobante inexistente';
    end if;
    
    
    --recuperar datos de la estacion            
 	
    select 
       pp.id_depto_lb
    into 
       v_id_depto_lb
    from tes.tplan_pago pp 
    where pp.id_plan_pago = p_id_plan_pago;
    
    --si la conexion por defecto es nula
    IF  p_conexion is null THEN
    	v_conexion = migra.f_crear_conexion(v_id_depto_lb,'tes.testacion');
    ELSE
        v_conexion = p_conexion;
    END IF;
    
    IF v_conexion is null or v_conexion = '' THEN
      raise exception 'No se pudo conectar con la base de datos destino';
      
    END IF;
    
    -- Obtiene los datos del comprobante
    select  
      cbte.*
    into
    	v_rec
    from conta.tint_comprobante cbte
    where cbte.id_int_comprobante = p_id_int_comprobante;
    
    
    -- verificar moneda
    
    v_sql = 'select 
                     1::integer
                    from param.tmoneda m
                    where m.id_moneda = '||v_rec.id_moneda;
                    
                    
    SELECT * FROM  dblink(v_conexion,v_sql, true) AS (sw integer) into v_sw_mon;
    
   
     
    IF  v_sw_mon != 1 or v_sw_mon is  null THEN
       raise exception 'No se encontro un registro para la moneda en la estación destino';
    END IF;
    
   
    --recuperamos la moneda base en la estación destino
    
    v_sql = 'select  param.f_get_moneda_base()';
   
    SELECT * FROM  dblink(v_conexion,v_sql, true) AS (sw integer) into v_id_moneda_base_reg;
    
    IF  v_id_moneda_base_reg is null THEN
       raise exception 'No se encontro un registro para la moneda base en la estación destino';
    END IF;
    
    
    v_sql = 'select  param.f_get_moneda_triangulacion()';
   
    SELECT * FROM  dblink(v_conexion,v_sql, true) AS (sw integer) into v_id_moneda_tri_reg;
    
    IF  v_id_moneda_base_reg is null THEN
       raise exception 'No se encontro un registro para la moneda de triangulación  en la estación destino';
    END IF;
    
   
    
    IF v_rec.id_moneda = v_id_moneda_base_reg THEN
        v_tipo_cambio = 1;
    ELSE
        v_tipo_cambio = NULL;
    END IF;
   
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
                          
                          
                          
                          id_int_comprobante_origen_central,
                          funcion_comprobante_validado,
                          funcion_comprobante_eliminado,
                          origen,
                          tipo_cambio,
                          fecha_costo_ini,
                          fecha_costo_fin,
                          id_moneda_tri
                          
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
                          
                          COALESCE(p_id_int_comprobante::varchar,'NULL')||',
                          ''conta.f_validar_comprobante_central'',
                          ''conta.f_eliminar_comprobante_central'',
                          ''central'','||
                          COALESCE(v_tipo_cambio::varchar,'NULL')||','||
                          COALESCE(''''||v_rec.fecha_costo_ini::varchar||'''','NULL')||','||
                          COALESCE(''''||v_rec.fecha_costo_fin::varchar||'''','NULL')||','||
                          v_id_moneda_tri_reg::varchar||') RETURNING id_int_comprobante'; 
    
  
    
    SELECT * FROM  dblink(v_conexion,v_sql, true) AS (id_int_comprobante integer) into v_id_int_comprobante_reg;
    
    
    --almacena el id del comprobante migrado
    update conta.tint_comprobante c set
     id_int_comprobante_origen_regional = v_id_int_comprobante_reg
    where id_int_comprobante = p_id_int_comprobante; 
    
  
    ----------------------------------------
    -- inserta la trasacciones del cbte
    -------------------------------------
    for v_dat in (select
                  tra.*
                  from conta.tint_transaccion tra
                  where tra.id_int_comprobante = p_id_int_comprobante) loop
                  
                  
           IF v_tipo_cambio = 1 then 
             v_importe_debe_mb  =  v_rec.importe_debe;
             v_importe_haber_mb =  v_rec.importe_haber;   
           END  IF;       
                  
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
                                  importe_gasto,
                                  importe_recurso,
                                 
                                 
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
                                  
                                   COALESCE(v_id_int_comprobante_reg::varchar,'NULL')||','||
                                   COALESCE(v_dat.id_cuenta::varchar,'NULL')||','||
                                   COALESCE(v_dat.id_auxiliar::varchar,'NULL')||','||
                                   COALESCE(v_dat.id_centro_costo::varchar,'NULL')||','||
                                   COALESCE(v_dat.id_partida::varchar,'NULL')||','||
                                   COALESCE(v_dat.id_partida_ejecucion::varchar,'NULL')||','||
                                   COALESCE(v_dat.id_int_transaccion_fk::varchar,'NULL')||','||
                                   COALESCE(''''||v_dat.glosa::varchar||'''','NULL')||','||
                                   COALESCE(v_dat.importe_debe::varchar,'NULL')||','||
                                   COALESCE(v_dat.importe_haber::varchar,'NULL')||','||
                                   COALESCE(v_dat.importe_gasto::varchar,'NULL')||','||
                                   COALESCE(v_dat.importe_recurso::varchar,'NULL')||','||
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
                                   
            
            SELECT * FROM  dblink(v_conexion,v_sql, true) AS (id_int_transaccion integer) into v_id_int_transaccion_reg;
          
           -- actualizar en trasaccion destino en el origen
           
           update conta.tint_transaccion t set
             id_int_transaccion_origen = v_id_int_transaccion_reg
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
                                      monto_pago
                                    )
                                    VALUES ('||
                                      COALESCE(v_dat_rel.id_usuario_reg::varchar,'NULL')||',
                                      now(),
                                      ''activo'','||
                                      COALESCE(v_dat_rel.id_int_transaccion_origen::varchar,'NULL')||','||
                                      COALESCE(v_id_int_transaccion_reg::varchar,'NULL')||','||
                                      COALESCE(v_dat_rel.monto_pago::varchar,'NULL')||' ) RETURNING id_int_rel_devengado;';
                                      
                                      
                  SELECT * FROM  dblink(v_conexion,v_sql, true) AS (id_int_rel_devengado integer) into v_resp_dblink_tra_rel;
            
            end loop;
    
             
    
    END LOOP;  
    
    --validaciones del comprobante
    v_sql = 'select conta.f_int_trans_procesar('||v_id_int_comprobante_reg||' );';
    SELECT * FROM  dblink(v_conexion,v_sql, true) as (res varchar) into v_resp_dblink_tra_rel;
    
    
    
    --calula configuracion  cambiaria, tipos de cambio y conversiones en la transacciones en el servidor remoto  
     v_sql = 'select  conta.f_act_trans_cbte_generados('||v_id_int_comprobante_reg||',''Internacional'');';
     SELECT * FROM  dblink(v_conexion,v_sql, true) as (res varchar) into v_resp_dblink_tra_rel;
    
   
    --si la conexion por  defecto es nula cerramos la conexion que creamos
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