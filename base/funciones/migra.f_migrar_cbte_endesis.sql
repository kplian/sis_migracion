CREATE OR REPLACE FUNCTION migra.f_migrar_cbte_endesis (
  p_id_int_comprobante integer
)
RETURNS varchar AS
$body$
/*
Autor: RCM
Fecha: 24/09/2013
Descripción: Migrar el comprobante generado en PXP a ENDESIS utilizando dblink entre las bases de datos
*/
DECLARE

	v_cadena_cnx varchar;
    v_resp varchar;
    v_sql varchar;
    v_rec record;

BEGIN

	--Verificación de existencia de parámetro
    if not exists(select 1 from conta.tint_comprobante
    			where id_int_comprobante = p_id_int_comprobante) then
    	raise exception 'Migración de comprobante no realizada: comprobante inexistente';
    end if;
    
    --Obtención de cadana de conexión
	v_cadena_cnx =  migra.f_obtener_cadena_conexion();
    
    --Abrir conexión
    v_resp = dblink_connect(v_cadena_cnx);
    
    IF v_resp!='OK' THEN
        raise exception 'FALLO LA CONEXION A LA BASE DE DATOS CON DBLINK';
    END IF;
    
    /*--Recorrido de las transacciones
    for v_rec in (select  
                  cbte.id_int_comprobante, 
                  cbte.id_clase_comprobante, 
                  cbte.id_int_comprobante_fk, 
                  cbte.id_subsistema, 
                  cbte.id_depto, 
                  cbte.id_moneda, 
                  cbte.id_periodo, 
                  cbte.nro_cbte, 
                  cbte.momento, 
                  cbte.glosa1, 
                  cbte.glosa2, 
                  cbte.beneficiario, 
                  cbte.tipo_cambio, 
                  cbte.id_funcionario_firma1, 
                  cbte.id_funcionario_firma2, 
                  cbte.id_funcionario_firma3, 
                  cbte.fecha, 
                  cbte.nro_tramite, 
                  tra.id_int_transaccion, 
                  tra.id_cuenta, 
                  tra.id_auxiliar, 
                  tra.id_centro_costo, 
                  tra.id_partida, 
                  tra.id_partida_ejecucion, 
                  tra.id_int_transaccion_fk, 
                  tra.glosa, 
                  tra.importe_debe, 
                  tra.importe_haber, 
                  tra.importe_recurso, 
                  tra.importe_gasto, 
                  tra.importe_debe_mb, 
                  tra.importe_haber_mb, 
                  tra.importe_recurso_mb, 
                  tra.importe_gasto_mb,
                  cbte.id_usuario_reg,
                  cla.codigo as codigo_clase_cbte,
                  cco.id_uo,
                  cco.id_ep
                  from conta.tint_comprobante cbte
                  inner join  conta.tint_transaccion tra
                  on tra.id_int_comprobante = cbte.id_int_comprobante
                  inner join conta.tclase_comprobante cla
                  on cla.id_clase_comprobante = cbte.id_clase_comprobante
                  inner join param.tcentro_costo cco
                  on cco.id_centro_costo = tra.id_centro_costo
                  where cbte.id_int_comprobante = p_id_int_comprobante) loop
                  
    	--Forma la cadena de inserción del registro
        v_sql = 'insert into migracion.tct_comprobante
                values('|| 
                coalesce(v_rec.id_int_comprobante::varchar,'NULL')||','||
                coalesce(v_rec.id_clase_comprobante::varchar,'NULL')||','||
                coalesce(v_rec.id_int_comprobante_fk::varchar,'NULL')||','||
                coalesce(v_rec.id_subsistema::varchar,'NULL')||','||
                coalesce(v_rec.id_depto::varchar,'NULL')||','||
                coalesce(v_rec.id_moneda::varchar,'NULL')||','||
                coalesce(v_rec.id_periodo::varchar,'NULL')||','||
                quote_literal(coalesce(v_rec.nro_cbte,'NULL'))||','||
                quote_literal(coalesce(v_rec.momento,'NULL'))||','||
                quote_literal(coalesce(v_rec.glosa1,'NULL'))||','||
                quote_literal(coalesce(v_rec.glosa2,'NULL'))||','||
                quote_literal(coalesce(v_rec.beneficiario,'NULL'))||','||
                coalesce(v_rec.tipo_cambio::varchar,'NULL')||','||
                coalesce(v_rec.id_funcionario_firma1::varchar,'NULL')||','||
                coalesce(v_rec.id_funcionario_firma2::varchar,'NULL')||','||
                coalesce(v_rec.id_funcionario_firma3::varchar,'NULL')||','||
                quote_literal(coalesce(v_rec.fecha::varchar,'NULL'))||','||
                quote_literal(coalesce(v_rec.nro_tramite,'NULL'))||','||
                coalesce(v_rec.id_int_transaccion::varchar,'NULL')||','||
                coalesce(v_rec.id_cuenta::varchar,'NULL')||','||
                coalesce(v_rec.id_auxiliar::varchar,'NULL')||','||
                coalesce(v_rec.id_centro_costo::varchar,'NULL')||','||
                coalesce(v_rec.id_partida::varchar,'NULL')||','||
                coalesce(v_rec.id_partida_ejecucion::varchar,'NULL')||','||
                coalesce(v_rec.id_int_transaccion_fk::varchar,'NULL')||','||
                quote_literal(coalesce(v_rec.glosa,'NULL'))||','||
                coalesce(v_rec.importe_debe::varchar,'NULL')||','||
                coalesce(v_rec.importe_haber::varchar,'NULL')||','||
                coalesce(v_rec.importe_recurso::varchar,'NULL')||','||
                coalesce(v_rec.importe_gasto::varchar,'NULL')||','||
                coalesce(v_rec.importe_debe_mb::varchar,'NULL')||','||
                coalesce(v_rec.importe_haber_mb::varchar,'NULL')||','||
                coalesce(v_rec.importe_recurso_mb::varchar,'NULL')||','||
                coalesce(v_rec.importe_gasto_mb::varchar,'NULL')||','||
                coalesce(v_rec.id_usuario_reg::varchar,'NULL')||','||
                quote_literal(coalesce(v_rec.codigo_clase_cbte,'NULL'))||','||
                coalesce(v_rec.id_uo::varchar,'NULL')||','||
                coalesce(v_rec.id_ep::varchar,'NULL')||'
                )';
                
    	perform dblink_exec(v_sql,TRUE);
    
    end loop;
    
    --Ejecución de función local de endesis para generar el comprobante
    v_sql = 'select migracion.f_migrar_cbte_pxp('||p_id_int_comprobante||')';
    v_resp = dblink_exec(v_sql,TRUE);

	v_sql := 'commit;';
    perform dblink_exec(v_sql, true);
    perform dblink_disconnect();*/
    
    v_sql='select migracion.f_migrar_cbte_pxp('||p_id_int_comprobante||')';
    v_sql = dblink_exec(v_sql, true);

	perform dblink_disconnect();
    
    return 'Hecho';
    
/*exception
    when others then
        v_sql := 'rollback;';
        perform dblink_exec(v_sql, true);
        perform dblink_disconnect();
        raise exception '%', sqlerrm;*/

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;