CREATE OR REPLACE FUNCTION migracion.f_migrar_cbte_pxp (
  p_id_comprobante integer
)
RETURNS varchar AS
$body$
/*
Autor: RCM
Fecha: 23/09/2013
Descripción: Transforma los datos del comprobante generado a la estructura de CONIN
*/
DECLARE

	v_rec record;
    v_rec_mon record;
    v_sql varchar;
    v_id_comprobante integer;
    v_id_transaccion integer;
    v_id_parametro integer;
    v_momento_cbte integer;
    v_id_periodo_subsis integer;
    v_id_subsistema integer;
    v_id_clase_cbte integer;
    v_id_depto integer;
    v_resp varchar;
    v_mensaje_verif varchar;
    v_origen varchar;
    v_ip_origen varchar;
    v_mac_maquina varchar;
    v_importe_ejecucion numeric;
    v_cadena_cnx varchar;
    v_con varchar;

BEGIN
	
	v_id_comprobante = -1;
    v_mensaje_verif='';
    v_id_subsistema=9;
    v_momento_cbte=0;
    v_origen=NULL;
    v_ip_origen='0.0.0.0';
    v_importe_ejecucion=0;
    v_mac_maquina='autogenerado';
    v_resp='';
    
    v_cadena_cnx = migracion.f_obtener_cadena_con_dblink();
    v_con = dblink_connect(v_cadena_cnx);
    
    v_sql = 'select  
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
            where cbte.id_int_comprobante = ' || p_id_comprobante;
    
    
    --0. Obtener los datos del comprobante de pxp
    insert into migracion.tct_comprobante
    select * from dblink(v_sql,true) as (id_int_comprobante INTEGER, 
                                    id_clase_comprobante INTEGER, 
                                    id_int_comprobante_fk INTEGER, 
                                    id_subsistema INTEGER, 
                                    id_depto INTEGER, 
                                    id_moneda INTEGER, 
                                    id_periodo INTEGER, 
                                    nro_cbte VARCHAR, 
                                    momento VARCHAR, 
                                    glosa1 VARCHAR, 
                                    glosa2 VARCHAR, 
                                    beneficiario VARCHAR, 
                                    tipo_cambio NUMERIC, 
                                    id_funcionario_firma1 INTEGER, 
                                    id_funcionario_firma2 INTEGER, 
                                    id_funcionario_firma3 INTEGER, 
                                    fecha DATE, 
                                    nro_tramite VARCHAR, 
                                    id_int_transaccion INTEGER, 
                                    id_cuenta INTEGER, 
                                    id_auxiliar INTEGER, 
                                    id_centro_costo INTEGER, 
                                    id_partida INTEGER, 
                                    id_partida_ejecucion INTEGER, 
                                    id_int_transaccion_fk INTEGER, 
                                    glosa VARCHAR, 
                                    importe_debe NUMERIC, 
                                    importe_haber NUMERIC, 
                                    importe_recurso NUMERIC, 
                                    importe_gasto NUMERIC, 
                                    importe_debe_mb NUMERIC, 
                                    importe_haber_mb NUMERIC, 
                                    importe_recurso_mb NUMERIC, 
                                    importe_gasto_mb NUMERIC, 
                                    id_usuario_reg INTEGER, 
                                    codigo_clase_cbte VARCHAR, 
                                    id_uo INTEGER, 
                                    id_ep INTEGER);
    
    
	--1. Recorrer la tabla temporal de comprobantes
    for v_rec in (select * from migracion.tct_comprobante
    			where id_int_comprobante = p_id_comprobante) loop
                
		--Obtención de parámetros
        --id_parametro, momento_cbte, id_periodo_subsis, id_subsistema, id_usuario, id_clase_cbte,id_depto
        
        --TODO: sincronizar id_depto para que sean iguales entre pxp y endesis
        --Obtener id_parametro
        select id_parametro
        into v_id_parametro
        from sci.tct_parametro
        where gestion_conta = to_char(v_rec.fecha,'yyyy');
        
        if v_id_parametro is null then
        	v_mensaje_verif = 'Gestión no encontrada.\n';
        end if;
        
        --Periodo subsistema
        select pers.id_periodo_subsistema
        into v_id_periodo_subsis
        from param.tpm_periodo per
        inner join param.tpm_periodo_subsistema pers
        on pers.id_periodo = per.id_periodo
        where v_rec.fecha between per.fecha_inicio and per.fecha_final
        and pers.id_subsistema = v_id_subsistema;
        
        if v_id_periodo_subsis is null then
        	v_mensaje_verif = v_mensaje_verif || 'Periodo subsistema no encontrado.\n';
        end if;
        
        --Clase comprobante
        select id_clase_cbte
        into v_id_clase_cbte
        from migracion.tct_cbte_clase_relacion
        where codigo_clase = v_rec.codigo_clase_cbte;
        
        if v_id_clase_cbte is null then
        	v_mensaje_verif = v_mensaje_verif || 'Clase de comprobante no encontrada.\n';
        end if;
        
        --Verifica si se produjo algun error
		if v_mensaje_verif != '' then        
        	raise exception 'No se pudo replicar el Comprobante en ENDESIS: %',v_mensaje_verif;
        end if;
                
    	--2. Registro de la cabecera del comprobante
        if v_id_comprobante = -1 then 
            v_id_comprobante = nextval('sci.tct_comprobante_id_comprobante_seq'::regclass);
            
            insert into sci.tct_comprobante(
            id_comprobante, 
            id_parametro, 
            momento_cbte, 
            fecha_cbte, 
            concepto_cbte, 
            glosa_cbte, 
            acreedor, 
            aprobacion, 
            conformidad, 
            pedido, 
            id_periodo_subsis, 
            id_usuario, 
            id_subsistema, 
            id_clase_cbte, 
            fk_comprobante, 
            id_depto, 
            nro_cbte_siscon, 
            origen, 
            id_moneda, 
            tipo_cambio
            ) values(
            v_id_comprobante, 
            v_id_parametro, 
            v_momento_cbte, 
            v_rec.fecha, 
            v_rec.glosa1, 
            v_rec.glosa1, 
            v_rec.beneficiario, 
            v_rec.glosa2, 
            v_rec.glosa2, 
            v_rec.glosa2, 
            v_id_periodo_subsis, 
            v_rec.id_usuario_reg, 
            v_id_subsistema, 
            v_id_clase_cbte, 
            NULL, 
            v_rec.id_depto, 
            NULL, 
            v_origen, 
            v_rec.id_moneda, 
            v_rec.tipo_cambio
            );
        end if;
        
        insert into sci.tct_cbte_estado(
        id_comprobante,id_usuario,estado_cbte,fecha_estado,sw_estado
        ) VALUES(
        v_id_comprobante,v_rec.id_usuario_reg,2.00,CURRENT_DATE,1.00 );
        
        --3. Registro de las transacciones
		v_resp = sci.f_tct_transaccion_iud(
                v_rec.id_usuario_reg,--pm_id_usuario integer,
                v_ip_origen,--pm_ip_origen varchar,
                v_mac_maquina,--pm_mac_maquina text,
                'CT_REGTRA_INS',--pm_codigo_procedimiento varchar,
                NULL,--pm_proc_almacenado varchar,
                NULL,--ct_id_transaccion integer,
                v_id_comprobante,--ct_id_comprobante integer,
                NULL,--ct_id_fuente_financiamiento integer,
                v_rec.id_uo,--ct_id_unidad_organizacional integer,
                v_rec.id_cuenta,--ct_id_cuenta integer,
                v_rec.id_partida,--ct_id_partida integer,
                v_rec.id_auxiliar,--ct_id_auxiliar integer,
                NULL,--ct_id_orden_trabajo integer,
                NULL,--ct_id_oec integer,
                NULL,--ct_concepto_tran varchar,
                v_rec.id_ep,--g_id_fina_regi_prog_proy_acti integer,
                v_rec.importe_debe,--ct_importe_debe numeric,
                v_rec.importe_haber,--ct_importe_haber numeric,
                v_rec.id_moneda,--ct_id_moneda integer,
                v_rec.fecha,--ct_fecha_transac date,
                v_rec.tipo_cambio,--ct_tipo_cambio numeric,
                'Oficial',--ct_tipo_cambio_origen varchar,
                v_importe_ejecucion--ct_importe_ejecucion numeric
        );
        
        if substring(v_resp,1,1)!='t' then
        	raise exception 'Error al generar transacción: %',v_resp;
        end if;
        
    
    end loop;
    
    
    --Cierre de conexión
    perform dblink_disconnect();
    
    --Respuesta
    return 'Comprobante generado!';

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER;