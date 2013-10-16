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

BEGIN

	--Obtención de cadana de conexión
	v_cadena_cnx =  migra.f_obtener_cadena_conexion();
    
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
            inner join adq.tcotizacion cot on cot.id_cotizacion = ping.id_preingreso
            inner join adq.tproceso_compra pro on pro.id_proceso_compra = cot.id_proceso_compra
            inner join adq.tsolicitud sol on sol.id_solicitud = pro.id_solicitud
            inner join adq.tsolicitud_det sdet on sdet.id_solicitud = sol.id_solicitud
            inner join param.tcentro_costo cc on cc.id_centro_costo = sdet.id_centro_costo
            where ping.id_preingreso = '||p_id_preingreso;
    
    for v_rec in (select * from dblink_exec(v_sql,true) as (descripcion TEXT,
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
        where v_rec.id_clasificacion;
        
        --Obtener la ep
        select p.id_presupuesto
        into v_id_presupuesto
        from presto.tpr_parametro par
        inner join presto.tpr_presupuesto p
        on p.id_parametro = par.id_parametro
        where par.id_gestion = v_rec.id_gestion
        and p.id_fina_regi_prop_proy_acti = v_rec.id_ep
        and p.id_unidad_organizacional = v_rec.id_uo;
        
        --Obtener deposito
        select id_deposito
        into v_id_deposito
        from actif.taf_deposito
        where id_depto_af = v_rec.id_depto;
        
        --Registro del activo fijo en función de la cantidad
        SELECT * FROM actif.f_taf_activo_fijo_iud(
        p_id_usuario,
        '192.168.225.0',
        '',
        'AF_AF_INS',
        NULL,
        pm_id_fina_regi_prog_proy_acti,
        NULL,
        NULL,
        v_desc,
        v_rec.descripcion,
        v_vida_util,
        v_vida_util,
        v_vida_util/100,
        NULL,
        0,
        0,
        0,
        'no',
        1,
        v_rec.fecha_adju,
        v_rec.precio_compra,
        v_rec.precio_compra,
        v_rec.precio_compra,
        'no',
        NULL,
        NULL,
        now(),
        NULL,
        NULL,
        1,
        'registrado',
        v_rec.observaciones,
        NULL, 
        NULL, 
        v_rec.id_moneda, 
        v_rec.id_moneda, 
        NULL, 
        NULL, 
        NULL,
        v_rec.numero_oc,
        1, v_rec.precio_compra, 
        v_rec.precio_compra, 
        0, 
        0, 
        0, 
        v_vida_util, 
        v_vida_util, 
        v_rec.id_depto, 
        v_rec.id_cotizacion,
        v_rec.id_cotizacion_det, 
        NULL,
        v_id_presupuesto,
        NULL,
        v_rec.id_gestion,
        v_rec.id_solicitud,
        'si',
        v_rec.cantidad_det-1,
        v_id_deposito,
        'activo',
        'no',
        v_rec.id_clasificacion, 
        NULL,
        NULL,
        v_rec.precio_compra);
    
    end loop;
    
    return 'Hecho';
    

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER;