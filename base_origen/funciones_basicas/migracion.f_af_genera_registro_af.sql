CREATE OR REPLACE FUNCTION migracion.f_af_genera_registro_af (
  p_id_usuario integer,
  p_id_preingreso integer
)
RETURNS varchar AS
$body$
/*
Autor: RCM
Fecha: 06/10/2013
Descripción: genera un registro de activo fijo a partir de pxp con una conexión dblink
*/
DECLARE

	v_cadena_cnx varchar;
    v_resp varchar;
    v_sql varchar;
    v_rec record;
    v_desc varchar;
    v_cont integer;
    v_vida_util integer;
    v_id_presupuesto integer;
    v_id_deposito integer;
    v_result	varchar;

BEGIN

	--Obtención de cadana de conexión
	v_cadena_cnx =  migracion.f_obtener_cadena_con_dblink();
    
    --Abrir conexión
    v_resp = dblink_connect(v_cadena_cnx);
    
    if v_resp!='OK' THEN
        raise exception 'FALLO LA CONEXION A LA BASE DE DATOS CON DBLINK';
    end if;

	--Valor por defecto para la descripción de los activos fijos
    v_desc = '[REGISTRADO POR SISTEMA DE COMPRAS, MODIFIQUE Y COMPLETE LA INFORMACIÓN]';

    v_sql = 'select
    		sdet.descripcion, cot.fecha_adju, pdet.precio_compra, ping.id_moneda,
            pdet.cantidad_det, pdet.id_depto, pdet.id_clasificacion,pdet.observaciones,
            cot.numero_oc, cot.id_cotizacion, pdet.id_cotizacion_det, sol.id_solicitud,
            cc.id_centro_costo,cc.id_ep,cc.id_uo,cc.id_gestion
    		from alm.tpreingreso ping
            inner join alm.tpreingreso_det pdet on pdet.id_preingreso = ping.id_preingreso
            inner join adq.tcotizacion cot on cot.id_cotizacion = ping.id_cotizacion
            inner join adq.tproceso_compra pro on pro.id_proceso_compra = cot.id_proceso_compra
            inner join adq.tsolicitud sol on sol.id_solicitud = pro.id_solicitud
            inner join adq.tsolicitud_det sdet on sdet.id_solicitud = sol.id_solicitud
            inner join param.tcentro_costo cc on cc.id_centro_costo = sdet.id_centro_costo
            where ping.id_preingreso = '||p_id_preingreso;
            
    
    for v_rec in (select * from dblink(v_sql,true) as (descripcion TEXT,
                                                            fecha_adju DATE,
                                                            precio_compra NUMERIC,
                                                            id_moneda INTEGER,
                                                            cantidad_det NUMERIC,
                                                            id_depto INTEGER,
                                                            id_clasificacion INTEGER,
                                                            observaciones VARCHAR,
                                                            numero_oc VARCHAR,
                                                            id_cotizacion INTEGER,
                                                            id_cotizacion_det INTEGER,
                                                            id_solicitud INTEGER,
                                                            id_centro_costo INTEGER,
                                                            id_ep INTEGER,
                                                            id_uo INTEGER,
                                                            id_gestion INTEGER)) loop
    	--Obtener la vida útil
        select vida_util
        into v_vida_util
        from actif.taf_clasificacion
        where id_clasificacion = v_rec.id_clasificacion;
        
        --Obtener la ep
        select p.id_presupuesto
        into v_id_presupuesto
        from presto.tpr_parametro par
        inner join presto.tpr_presupuesto p
        on p.id_parametro = par.id_parametro
        where par.id_gestion = v_rec.id_gestion
        and p.id_fina_regi_prog_proy_acti = v_rec.id_ep
        and p.id_unidad_organizacional = v_rec.id_uo;
        
        --Obtener deposito
        select id_deposito
        into v_id_deposito
        from actif.taf_deposito
        where id_depto_af = v_rec.id_depto;
        
        --Registro del activo fijo en función de la cantidad
        v_result = actif.f_taf_activo_fijo_iud(
        p_id_usuario::integer,
        '192.168.225.0'::varchar,
        '99:99:99:99:99:99'::text,
        'AF_AF_INS'::varchar,
        NULL::varchar,
        v_rec.id_ep::integer,
        NULL::integer,
        NULL::varchar,
        v_desc::varchar,
        v_rec.descripcion::varchar, --10
        v_vida_util::integer,
        v_vida_util::integer,
        (v_vida_util/100)::numeric,
        NULL::date,  --fecha_ult_deprec
        0::numeric,
        0::numeric,
        0::numeric,
        'no'::varchar,
        1::numeric,
        v_rec.fecha_adju::date, --20
        v_rec.precio_compra::numeric,
        v_rec.precio_compra::numeric,
        v_rec.precio_compra::numeric,
        'no'::varchar,
        NULL::varchar,
        NULL::date,
        now()::date,
        NULL::bytea,
        NULL::varchar,
        1::numeric,--30
        'registrado'::varchar,
        v_rec.observaciones::varchar,
        NULL::integer, 
        NULL::integer, 
        v_rec.id_moneda::integer, 
        v_rec.id_moneda::integer, 
        NULL::integer, 
        NULL::date, 
        NULL::varchar,
        v_rec.numero_oc::varchar, --40
        1::integer,
        v_rec.precio_compra::numeric, 
        v_rec.precio_compra::numeric, 
        0::numeric, 
        0::numeric, 
        0::numeric, 
        v_vida_util::integer, 
        v_vida_util::integer, 
        v_rec.id_depto::integer, 
        v_rec.id_cotizacion::integer, --50
        v_rec.id_cotizacion_det::integer, 
        NULL::varchar,
        v_id_presupuesto::integer,
        NULL::integer,
        v_rec.id_gestion::integer,
        v_rec.id_solicitud::integer,
        'no',--'si'::varchar,
        NULL::integer,--(v_rec.cantidad_det-1)::integer,
        v_id_deposito::integer,
        'activo'::varchar, --60
        'no'::varchar, 
        v_rec.id_clasificacion::integer, 
        NULL::varchar,
        NULL::date,
        v_rec.precio_compra::numeric --65
        );

        if substr(v_result,1,1) = 'f' then
        	raise exception '%',v_result;
        end if;
    
    end loop;
    raise exception 'fuck';
    return 'Hecho';
    

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER;