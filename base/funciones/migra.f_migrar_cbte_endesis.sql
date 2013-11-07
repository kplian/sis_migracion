--------------- SQL ---------------

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
    v_dat record;
    v_cont integer;
    
    va_id_int_transaccion integer[]; 
    va_id_cuenta integer[]; 
    va_id_auxiliar integer[]; 
    va_id_centro_costo integer[];
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
    
    v_id_depto_endesis  integer;

BEGIN

	--Verificación de existencia de parámetro
    if not exists(select 1 from conta.tint_comprobante
    			where id_int_comprobante = p_id_int_comprobante) then
    	raise exception 'Migración de comprobante no realizada: comprobante inexistente';
    end if;
    
    --Obtiene los datos del comprobante
    select  
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
    cbte.id_usuario_reg,
	cla.codigo as codigo_clase_cbte
    into
    v_rec
    from conta.tint_comprobante cbte
    inner join conta.tclase_comprobante cla
	on cla.id_clase_comprobante = cbte.id_clase_comprobante
    where cbte.id_int_comprobante = p_id_int_comprobante;
    
    
    select 
        dd.id_depto_endesis 
      into 
        v_id_depto_endesis 
    from migra.tdepto_to_depto_endesis dd 
    where dd.id_depto_pxp = v_rec.id_depto;
    
    
    v_rec.id_depto = v_id_depto_endesis;
    
    --Obtiene los datos de la transacción
    v_cont = 1;
    for v_dat in (select
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
                  cco.id_uo,
                  cco.id_ep
                  from conta.tint_transaccion tra
                  inner join param.tcentro_costo cco
                  on cco.id_centro_costo = tra.id_centro_costo
                  where tra.id_int_comprobante = p_id_int_comprobante) loop
                  
    	va_id_int_transaccion[v_cont]=v_dat.id_int_transaccion;
        va_id_cuenta[v_cont]=v_dat.id_cuenta;
        va_id_auxiliar[v_cont]=v_dat.id_auxiliar;
        va_id_centro_costo[v_cont]=v_dat.id_centro_costo;
        va_id_partida[v_cont]=v_dat.id_partida;
        va_id_partida_ejecucion[v_cont]=v_dat.id_partida_ejecucion;
        va_id_int_transaccion_fk[v_cont]=v_dat.id_int_transaccion_fk;
        va_glosa[v_cont]=COALESCE(v_dat.glosa,'--');
        va_importe_debe[v_cont]=v_dat.importe_debe;
        va_importe_haber[v_cont]=v_dat.importe_haber;
        va_importe_recurso[v_cont]=v_dat.importe_recurso;
        va_importe_gasto[v_cont]=v_dat.importe_gasto;
        va_id_uo[v_cont]=v_dat.id_uo;
        va_id_ep[v_cont]=v_dat.id_ep;
        v_cont = v_cont + 1;
   	end loop;
    
    --Forma la llamada para enviar los datos del comprobante al servidor destino
    v_sql:='select migracion.f_migrar_cbte_pxp('||
                v_rec.id_int_comprobante ||','|| --p_id_int_comprobante,
                v_rec.id_clase_comprobante ||','||
                'null' ||','||
                v_rec.id_subsistema ||','||
                v_rec.id_depto ||','||
                v_rec.id_moneda ||','||
                v_rec.id_periodo ||','||
                ''''||coalesce(v_rec.nro_cbte,'') ||''','||
                ''''||coalesce(v_rec.momento,'') ||''','||
                ''''||coalesce(v_rec.glosa1,'') ||''','||
                ''''||coalesce(v_rec.glosa2,'') ||''','||
                ''''||coalesce(v_rec.beneficiario,'') ||''','||
                coalesce(v_rec.tipo_cambio,1) ||','||
                'null' ||','|| --id_funcionario_firma1
                'null' ||','|| --id_funcionario_firma2
                'null' ||','|| --id_funcionario_firma3
                ''''||v_rec.fecha ||''','||
                ''''||coalesce(v_rec.nro_tramite,'') ||''',
                '||COALESCE(('array['|| array_to_string(va_id_int_transaccion, ',')||']::integer[]')::varchar,'NULL::integer[]')||',
                '||COALESCE(('array['|| array_to_string(va_id_cuenta, ',')||']::integer[]')::varchar,'NULL::integer[]')||',
                '||COALESCE(('array['|| array_to_string(va_id_auxiliar, ',')||']::integer[]')::varchar,'NULL::integer[]')||',
                '||COALESCE(('array['|| array_to_string(va_id_centro_costo, ',')||']::integer[]')::varchar,'NULL::integer[]')||',
                '||COALESCE(('array['|| array_to_string(va_id_partida, ',')||']::integer[]')::varchar,'NULL::integer[]')||', 
                '||COALESCE(('array['|| pxp.f_iif(array_to_string(va_id_partida_ejecucion, ',')='','null',array_to_string(va_id_partida_ejecucion, ','))||']::integer[]')::varchar,'NULL::integer[]')||',
                '||COALESCE(('array['''|| array_to_string(va_glosa, ''',''')||''']::varchar[]')::varchar,'NULL::varchar[]')||', 
                '||COALESCE(('array['|| array_to_string(va_importe_debe, ',')||']::numeric[]')::varchar,'NULL::numeric[]')||',
                '||COALESCE(('array['|| array_to_string(va_importe_haber, ',')||']::numeric[]')::varchar,'NULL::numeric[]')||',
                '||COALESCE(('array['|| array_to_string(va_importe_recurso, ',')||']::numeric[]')::varchar,'NULL::numeric[]')||',
                '||COALESCE(('array['|| array_to_string(va_importe_gasto, ',')||']::numeric[]')::varchar,'NULL::numeric[]')||','||
                v_rec.id_usuario_reg ||','||
                ''''||coalesce(v_rec.codigo_clase_cbte,'') ||''','||'
                '||COALESCE(('array['|| array_to_string(va_id_uo, ',')||']::integer[]')::varchar,'NULL::integer[]')||',
                '||COALESCE(('array['|| array_to_string(va_id_ep, ',')||']::integer[]')::varchar,'NULL::integer[]')||') ';
                
                raise notice '>>>>>>>>>>>>>>>>>>>>>>>>FASS: %',pxp.f_iif(array_to_string(va_id_partida_ejecucion, ',')='','null',array_to_string(va_id_partida_ejecucion, ','));

    --Obtención de cadana de conexión
	v_cadena_cnx =  migra.f_obtener_cadena_conexion();
    
    --Abrir conexión
    v_resp = dblink_connect(v_cadena_cnx);

    IF v_resp!='OK' THEN
        raise exception 'FALLO LA CONEXION A LA BASE DE DATOS CON DBLINK';
    END IF;
    --raise exception 'dd:%',v_sql;
    --Ejecuta la función remotamente
    perform * from dblink(v_sql, true) as (respuesta varchar);

	--Cierra la conexión abierta
	perform dblink_disconnect();
    
    --Devuelve la respuesta
    return 'Hecho';

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;