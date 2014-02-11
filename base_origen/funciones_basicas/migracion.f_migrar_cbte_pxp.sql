CREATE OR REPLACE FUNCTION migracion.f_migrar_cbte_pxp (
  p_id_int_comprobante integer,
  p_id_clase_comprobante integer,
  p_id_int_comprobante_fk integer,
  p_id_subsistema integer,
  p_id_depto integer,
  p_id_moneda integer,
  p_id_periodo integer,
  p_nro_cbte varchar,
  p_momento varchar,
  p_glosa1 varchar,
  p_glosa2 varchar,
  p_beneficiario varchar,
  p_tipo_cambio numeric,
  p_id_funcionario_firma1 integer,
  p_id_funcionario_firma2 integer,
  p_id_funcionario_firma3 integer,
  p_fecha date,
  p_nro_tramite varchar,
  p_id_int_transaccion integer [],
  p_id_cuenta integer [],
  p_id_auxiliar integer [],
  p_id_centro_costo integer [],
  p_id_partida integer [],
  p_id_partida_ejecucion integer [],
  p_glosa varchar [],
  p_importe_debe numeric [],
  p_importe_haber numeric [],
  p_importe_recurso numeric [],
  p_importe_gasto numeric [],
  p_id_usuario_reg integer,
  p_codigo_clase_cbte varchar,
  p_id_uo integer [],
  p_id_ep integer [],
  p_momento_comprometido varchar,
  p_momento_ejecutado varchar,
  p_momento_pagado varchar,
  p_id_cuenta_bancaria integer [],
  p_nombre_cheque varchar [],
  p_nro_cheque integer [],
  p_tipo varchar [],
  p_id_libro_bancos integer []
)
RETURNS varchar AS
$body$
/*
Autor: RCM
Fecha: 23/09/2013
Descripcion: Transforma los datos del comprobante generado a la estructura de CONIN
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
    v_size integer;
    
    v_id_cuenta_bancaria integer;
    v_nombre_cheque varchar;
    v_nro_cheque integer;
    v_tipo varchar;
    v_id_libro_bancos integer;

BEGIN
	
	v_id_comprobante = -1;
    v_mensaje_verif='';
    v_id_subsistema=9;
    v_momento_cbte=0;
    v_origen='pxp';
    v_ip_origen='0.0.0.0';
    v_importe_ejecucion=0;
    v_mac_maquina='autogenerado';
    v_resp='';

    v_size = array_upper(p_id_int_transaccion, 1);

    for i in 1..v_size loop
    
    	if p_id_cuenta_bancaria[i] = -1 then
        	v_id_cuenta_bancaria = null;
        else
        	v_id_cuenta_bancaria = p_id_cuenta_bancaria[i];
        end if;
        
        if p_nro_cheque[i] = -1 then
        	v_nro_cheque = null;
        else
        	v_nro_cheque = p_nro_cheque[i];
        end if;
        
        if p_id_libro_bancos[i] = -1 then
        	v_id_libro_bancos = null;
        else
        	v_id_libro_bancos = p_id_libro_bancos[i];
        end if;
    
    	insert into migracion.tct_comprobante
        values(
            p_id_int_comprobante, 
            p_id_clase_comprobante, 
            p_id_int_comprobante_fk, 
            p_id_subsistema, 
            p_id_depto, 
            p_id_moneda, 
            p_id_periodo, 
            p_nro_cbte, 
            p_momento, 
            p_glosa1, 
            p_glosa2, 
            p_beneficiario, 
            p_tipo_cambio, 
            p_id_funcionario_firma1, 
            p_id_funcionario_firma2, 
            p_id_funcionario_firma3, 
            p_fecha, 
            p_nro_tramite, 
            p_id_int_transaccion[i], 
            p_id_cuenta[i], 
            p_id_auxiliar[i], 
            p_id_centro_costo[i], 
            p_id_partida[i], 
            p_id_partida_ejecucion[i], 
            p_glosa[i], 
            p_importe_debe[i], 
            p_importe_haber[i], 
            p_importe_recurso[i], 
            p_importe_gasto[i], 
            null, 
            null, 
            null, 
            null,
            p_id_usuario_reg,
            p_codigo_clase_cbte,
            p_id_uo[i],
            p_id_ep[i],
            p_momento_comprometido,
            p_momento_ejecutado,
            p_momento_pagado,
            
            v_id_cuenta_bancaria,
            p_nombre_cheque[i],
            v_nro_cheque,
            p_tipo[i],
            v_id_libro_bancos
        );
    
    end loop;
    
	--1. Recorrer la tabla temporal de comprobantes
    for v_rec in (select * from migracion.tct_comprobante
    			where id_int_comprobante = p_id_int_comprobante) loop

		--Obtencion de parametros
        --id_parametro, momento_cbte, id_periodo_subsis, id_subsistema, id_usuario, id_clase_cbte,id_depto

        --Obtener id_parametro
        select id_parametro
        into v_id_parametro
        from sci.tct_parametro
        where gestion_conta = to_char(v_rec.fecha,'yyyy');
   
        if v_id_parametro is null then
        	v_mensaje_verif = 'Gestion no encontrada.\n';
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
        where codigo_clase = v_rec.codigo_clase_cbte
        and momento = v_rec.momento;
        
        if v_id_clase_cbte is null then
        	v_mensaje_verif = v_mensaje_verif || 'Clase de comprobante no encontrada.\n';
        end if;
        
        --RCM:08/02/2014: REgla de los momentos contables
        if v_rec.momento = 'presupuestario' then
        	--Presupuestario
			if v_rec.momento_pagado = 'si' then
            	v_momento_cbte = 4;
            elsif v_rec.momento_ejecutado = 'si' and v_rec.momento_pagado = 'no' then
            	v_momento_cbte = 1;
            else
            	v_momento_cbte = 0;
            end if;            
            
        else
        	--Por defecto contable si no tiene un momento válido
            v_momento_cbte = 0;
        end if;
        --FIN RCM
        
        
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
            tipo_cambio,
            id_int_comprobante
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
            v_rec.tipo_cambio,
            v_rec.id_int_comprobante
            );
        end if;
        
        insert into sci.tct_cbte_estado(
        id_comprobante,id_usuario,estado_cbte,fecha_estado,sw_estado
        ) VALUES(
        v_id_comprobante,v_rec.id_usuario_reg,2.00,CURRENT_DATE,1.00 );

        --3. Registro de las transacciones
        v_resp = sci.f_tct_gestionar_transaccion_iud(
        					v_rec.id_usuario_reg,--pm_id_usuario integer, 
                            v_ip_origen,--pm_ip_origen varchar, 
                            v_mac_maquina,--pm_mac_maquina text, 
                            'CT_REGTRA_INS',--pm_codigo_procedimiento varchar, 
                            NULL,--pm_proc_almacenado varchar, 
                            NULL,--ct_id_transaccion integer, 
                            v_rec.glosa,--ct_concepto_tran varchar, 
                            v_rec.id_auxiliar,--ct_id_auxiliar integer, 
                            v_id_comprobante,--ct_id_comprobante integer, 
                            NULL,--ct_id_oec integer, 
                            NULL,--ct_id_orden_trabajo integer, 
                            v_rec.id_partida,--ct_id_partida integer, 
                            v_rec.id_cuenta,--ct_id_cuenta integer, 
                            v_rec.id_centro_costo,--ct_id_presupuesto integer, 
                            v_rec.importe_debe,--ct_importe_debe numeric, 
                            v_rec.importe_haber,--ct_importe_haber numeric, 
                            v_rec.importe_gasto,--ct_importe_gasto numeric, 
                            v_rec.importe_recurso);--ct_importe_recurso numeric);
                            
        
		/*v_resp = sci.f_tct_transaccion_iud(
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
        );*/
        
        if substring(v_resp,1,1)!='t' then
        	raise exception 'Error al generar transacciÃ³n: %',v_resp;
        end if;
        
    
    end loop;

    --Respuesta
    return 'Comprobante generado!'::varchar;

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER;