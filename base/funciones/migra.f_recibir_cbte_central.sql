--------------- SQL ---------------

CREATE OR REPLACE FUNCTION migra.f_recibir_cbte_central (
  p_id_int_comprobante integer,
  p_id_plantilla_comprobante integer,
  p_id_clase_comprobante integer,
  p_id_int_comprobante_fk integer,
  p_id_subsistema integer,
  p_id_depto integer,
  p_id_depto_libro integer,
  p_id_depto_conta_pxp integer,
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
  p_id_orden_trabajo integer [],
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
  p_id_libro_bancos integer [],
  p_id_cuenta_bancaria_endesis integer []
)
RETURNS varchar AS
$body$
/*
Autor: RAC
Fecha: 02/09/2015
Descripcion: Recibe los datos del cbte temporal en la centra, los transforma e inserta el cbte en la estacion regional
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
    
    v_id_cuenta_bancaria		 integer;
    v_nombre_cheque				 varchar;
    v_nro_cheque				 integer;
    v_tipo 					     varchar; 
    v_id_libro_bancos 			 integer;
    v_id_cuenta_bancaria_endesis integer;
    v_nro_cuenta_banco 			 varchar;    
    g_nombre_funcion 			 varchar;
    v_insertar_libro_bancos 	 varchar; 
    v_id_int_comprobante 		 integer;
    v_sw_moneda_base  			 boolean;
    v_tipo_cambio				 numeric;
    v_id_moneda_base 			 integer;
    v_importe_debe_mb  		     numeric;
    v_importe_haber_mb  		 numeric;
BEGIN
	

	v_id_int_comprobante = -1;
    v_resp='';

    v_size = array_upper(p_id_int_transaccion, 1);
    
    
   --  verificar moneda
            
    IF not exists (select 
                     1
                    from param.tmoneda m
                    where m.id_moneda = p_id_moneda) THEN
    
      raise exception 'No se encontro un registro para la moneda en la estación destino';
    END IF;
    
    --crear tabla tamporal
     CREATE TEMPORARY TABLE ttemp_cbte_central (
              id_int_comprobante INTEGER NOT NULL,
              id_clase_comprobante INTEGER,
              id_int_comprobante_fk INTEGER,
              id_subsistema INTEGER,
              id_depto INTEGER,
              id_moneda INTEGER,
              id_periodo INTEGER,
              nro_cbte VARCHAR(30),
              momento VARCHAR(30),
              glosa1 VARCHAR(1500),
              glosa2 VARCHAR(400),
              beneficiario VARCHAR(500),
              tipo_cambio NUMERIC(18,2),
              id_funcionario_firma1 INTEGER,
              id_funcionario_firma2 INTEGER,
              id_funcionario_firma3 INTEGER,
              fecha DATE,
              nro_tramite VARCHAR(70),
              id_int_transaccion INTEGER,
              id_cuenta INTEGER NOT NULL,
              id_auxiliar INTEGER NOT NULL,
              id_centro_costo INTEGER NOT NULL,
              id_partida INTEGER,
              id_partida_ejecucion INTEGER,
              glosa VARCHAR(1000),
              importe_debe NUMERIC(18,2),
              importe_haber NUMERIC(18,2),
              importe_recurso NUMERIC(18,2),
              importe_gasto NUMERIC(18,2),
              importe_debe_mb NUMERIC(18,2),
              importe_haber_mb NUMERIC(18,2),
              importe_recurso_mb NUMERIC(18,2),
              importe_gasto_mb NUMERIC(18,2),
              id_usuario_reg INTEGER,
              codigo_clase_cbte VARCHAR(50),
              id_uo INTEGER,
              id_ep INTEGER,
              momento_comprometido VARCHAR(4) DEFAULT 'no'::character varying,
              momento_ejecutado VARCHAR(4) DEFAULT 'no'::character varying,
              momento_pagado VARCHAR(4) DEFAULT 'no'::character varying,
              id_cuenta_bancaria INTEGER,
              nombre_cheque VARCHAR(200),
              nro_cheque INTEGER,
              tipo VARCHAR(15),
              id_libro_bancos INTEGER,
              id_cuenta_bancaria_endesis INTEGER,
              id_orden_trabajo INTEGER,
              id_depto_libro INTEGER,
              id_depto_conta_pxp INTEGER
            )ON COMMIT DROP;
    
            
     -- Obtener la moneda base
     v_id_moneda_base = param.f_get_moneda_base();
     
     
    
     
     IF p_id_moneda = v_id_moneda_base THEN
        v_sw_moneda_base = TRUE;
        v_tipo_cambio = 1;
     ELSE
        v_sw_moneda_base = FALSE;
        v_tipo_cambio = NULL;
     END IF;
            
            

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
        
        if p_id_cuenta_bancaria_endesis[i] = -1 then
        	v_id_cuenta_bancaria_endesis = null;
        else
        	v_id_cuenta_bancaria_endesis = p_id_cuenta_bancaria_endesis[i];
        end if;
              
    	insert into ttemp_cbte_central
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
            v_id_libro_bancos,
            v_id_cuenta_bancaria_endesis,
            --p_id_orden_trabajo[i]
            pxp.f_iif((p_id_orden_trabajo[i] != 0), p_id_orden_trabajo[i]::text, NULL )::integer,
            p_id_depto_libro,
            p_id_depto_conta_pxp
        );
    
    end loop;
   
    
   
    
	--1. Recorrer la tabla temporal de comprobantes
    /*for v_rec in (select * from migracion.tct_comprobante
    			where id_int_comprobante = p_id_int_comprobante) loop*/
    			
	for v_rec in (SELECT id_int_comprobante,
                         id_clase_comprobante,
                         id_int_comprobante_fk,
                         id_subsistema,
                         id_depto,
                         id_moneda,
                         id_periodo,
                         nro_cbte,
                         momento,
                         glosa1,
                         glosa2,
                         beneficiario,
                         tipo_cambio,
                         id_funcionario_firma1,
                         id_funcionario_firma2,
                         id_funcionario_firma3,
                         fecha,
                         nro_tramite,
                         --id_int_transaccion,
                         id_cuenta,
                         id_auxiliar,
                         id_centro_costo,
                         id_orden_trabajo,
                         id_partida,
                         -- id_partida_ejecucion,
                         glosa,
                         importe_debe,
                         importe_haber,
                         importe_recurso,
                         importe_gasto,
                         importe_debe_mb,
                         importe_haber_mb,
                         importe_recurso_mb,
                         importe_gasto_mb,
                         id_usuario_reg,
                         codigo_clase_cbte,
                         id_uo,
                         id_ep,
                         momento_pagado,
                         momento_ejecutado,
                         id_depto_libro,
                         id_depto_conta_pxp
                  FROM ttemp_cbte_central
				  WHERE id_int_comprobante = p_id_int_comprobante) loop

		
                
    	--2. Registro de la cabecera del comprobante
        if v_id_int_comprobante = -1 then 
            INSERT INTO 
                        conta.tint_comprobante
                      (
                        id_usuario_reg,                      
                        fecha_reg,                       
                        estado_reg,                       
                        id_clase_comprobante,
                        id_subsistema,
                        id_depto,
                        id_depto_libro,
                        id_moneda,
                        id_periodo,
                        momento,
                        momento_comprometido,
                        momento_ejecutado,
                        momento_pagado,
                        id_plantilla_comprobante,
                        glosa1,
                        --glosa2,
                        beneficiario,
                        tipo_cambio,
                        --id_funcionario_firma1,
                        --id_funcionario_firma2,
                        --id_funcionario_firma3,
                        fecha,
                        funcion_comprobante_validado,
                        funcion_comprobante_eliminado,
                        id_cuenta_bancaria, 
                        id_cuenta_bancaria_mov, 
                        nro_cheque, 
                        nro_cuenta_bancaria_trans,
                        nro_tramite,
                        id_usuario_ai,
                        usuario_ai,
                        temporal,
                        id_int_comprobante_origen_central,
                        origen
                               
                      ) 
                      VALUES (
                        p_id_usuario_reg,
                        now(),
                       'borrador',
                        v_rec.id_clase_comprobante, --TODO agregar a la interface de plantilla
                        v_rec.id_subsistema, --TODO agregar a la interface de plantilla,
                        v_rec.id_depto, 
                        v_rec.id_depto_libro,
                        v_rec.id_moneda,
                        v_rec.id_periodo,
                        v_rec.momento,
                        p_momento_comprometido,
                        p_momento_ejecutado,
                        p_momento_pagado,
                        NULL, -- p_id_plantilla_comprobante,  la plantilla de cbte no se migra
                        v_rec.glosa1,
                        v_rec.beneficiario,
                        v_tipo_cambio,--v_tipo_cambio,
                        p_fecha,
                        'conta.f_validar_comprobante_central',    --  v_plantilla.funcion_comprobante_validado,
                        'conta.f_eliminar_comprobante_central',   --  v_plantilla.funcion_comprobante_eliminado,
                        v_id_cuenta_bancaria,
                        NULL, --v_this.columna_id_cuenta_bancaria_mov, 
                        v_nro_cheque,
                        NULL,--v_this.columna_nro_cuenta_bancaria_trans,
                        p_nro_tramite,
                        NULL,
                        NULL,
                        'no',
                        p_id_int_comprobante,
                        'central'
                      )RETURNING id_int_comprobante into v_id_int_comprobante;
                      
                     
            
        end if;
        
        IF v_tipo_cambio = 1 then 
             v_importe_debe_mb  =  v_rec.importe_debe;
             v_importe_haber_mb = v_rec.importe_haber;   
        END  IF; 
        
        --3. Registro de las transacciones
        -----------------------------
        --REGISTRO DE LA TRANSACCIÓN
        -----------------------------
        insert into conta.tint_transaccion(
                id_partida,
                id_centro_costo,
                estado_reg,
                id_cuenta,
                glosa,
                id_int_comprobante,
                id_auxiliar,
                importe_debe,
                importe_haber,
                importe_gasto,
                importe_recurso,
                importe_debe_mb,
                importe_haber_mb,
                importe_gasto_mb,
                importe_recurso_mb,
                id_usuario_reg,
                fecha_reg,
                id_usuario_mod,
                fecha_mod,
                id_orden_trabajo
          	) values(
                v_rec.id_partida,
                v_rec.id_centro_costo,
                'activo',
                v_rec.id_cuenta,
                v_rec.glosa,
                v_id_int_comprobante,
                v_rec.id_auxiliar,
                v_rec.importe_debe,
                v_rec.importe_haber,
                v_rec.importe_debe,
                v_rec.importe_haber,
                v_importe_debe_mb,
                v_importe_haber_mb,
                v_importe_debe_mb,
                v_importe_haber_mb,
                p_id_usuario_reg,
                now(),
                null,
                null,
                v_rec.id_orden_trabajo
			);
            
     end loop;
    
    -- procesar las trasaaciones (con diversos propostios, ejm validar  cuentas bancarias)
    IF not conta.f_int_trans_procesar(v_id_int_comprobante) THEN
      raise exception 'Error al procesar transacciones';
    END IF;
   
    --Respuesta
    return 'Comprobante generado!'::varchar;
	
EXCEPTION
    
	WHEN OTHERS THEN
        g_nombre_funcion = 'migra.f_recibir_cbte_central';
        raise exception ' % - (%)',SQLERRM,g_nombre_funcion ;

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;