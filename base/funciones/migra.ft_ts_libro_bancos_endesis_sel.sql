--------------- SQL ---------------

CREATE OR REPLACE FUNCTION migra.ft_ts_libro_bancos_endesis_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS SETOF record AS
$body$
/**************************************************************************
 SISTEMA ENDESIS - SISTEMA DE ...
***************************************************************************
 SCRIPT: 		migra.ft_ts_libro_bancos_endesis_sel
 DESCRIPCIÓN: 	Lista los depósitos habilitados desde ENDESIS
 AUTOR: 		RCM
 FECHA:			27/12/2013
 COMENTARIOS:	
***************************************************************************
 HISTORIA DE MODIFICACIONES:

 DESCRIPCIÓN:
 AUTOR:       
 FECHA:      

***************************************************************************/
--------------------------
-- CUERPO DE LA FUNCIÓN --
--------------------------

-- PARÁMETROS FIJOS
/*
pm_id_usuario                               integer (si))
pm_ip_origen                                varchar(40) (si)
pm_mac_maquina                              macaddr (si)
pm_log_error                                varchar -- log -- error //variable interna (si)
pm_codigo_procedimiento                     varchar  // valor que identifica el tipo
                                                        de operacion a realizar
                                                        insert  (insertar)
                                                        delete  (eliminar)
                                                        update  (actualizar)
                                                        select  (visualizar)
pm_proc_almacenado                          varchar  // para colocar el nombre del procedimiento en caso de ser llamado
                                                        por otro procedimiento
*/

DECLARE

	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
    v_rec  				record;  -- PARA ALMACENAR EL CONJUNTO DE DATOS RESULTADO DEL SELECT
    pm_criterio_filtro 	varchar;
    v_consulta			varchar;
    v_cnx 				varchar;
    v_res_cone  		varchar;
    v_id_cuenta_bancaria integer;
    v_id_gestion		integer;

BEGIN


    v_nombre_funcion = 'migra.ft_ts_libro_bancos_endesis_sel';
    v_parametros = pxp.f_get_record(p_tabla);
    
	/*********************************    
 	#TRANSACCION:  'MIG_CBANESIS_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:			RCM	
 	#FECHA:			27/12/2013
	***********************************/

	if(p_transaccion='MIG_CBANESIS_SEL')then
     				
    	begin
        
        	--1. Obtención de cadena de conexión a ENDESIS
            v_cnx = migra.f_obtener_cadena_conexion();
            
            --1.1 Apertura de la conexión
            v_resp = (SELECT dblink_connect(v_cnx));
            
            if v_resp != 'OK' then
                raise exception 'No se pudo conectar con el servidor: No existe ninguna ruta hasta el host';
            end if;
            
            ------------------------------------------------------------------------------------
            --Obtiene el id_cuenta_bancaria original de ENDESIS de la gestión en base a la fecha
            ------------------------------------------------------------------------------------
            --Obtiene el id_gestion
            select id_gestion
            into v_id_gestion
            from param.tgestion
            where gestion = to_char(v_parametros.fecha::date,'yyyy')::integer;
            
            if v_id_gestion is null then
            	raise exception 'Gestión nula. No se pudo encontrar Depósitos, verifique la fecha de pago.';
            end if;
            
            select id_cuenta_bancaria
            into v_id_cuenta_bancaria
            from migra.tts_cuenta_bancaria
            where id_cuenta_bancaria_pxp = v_parametros.id_cuenta_bancaria
            and id_gestion = v_id_gestion;
            
            if v_id_cuenta_bancaria is null then
            	raise exception 'Cuenta Bancaria no encontrada para obtener los depósitos. Verifique que se haya seleccionado una Cuenta Bancaria válida y la fecha de pago (%)',v_parametros.fecha;
            end if;
        
    		--Sentencia de la consulta
			v_consulta:='SELECT
            			id_libro_bancos, 
                        id_cuenta_bancaria, 
                        fecha, 
                        a_favor, 
                        detalle,
						observaciones,
                        nro_liquidacion, 
                        nro_comprobante,
						nro_cheque, 
                        tipo, 
                        importe_deposito, 
                        importe_cheque,
                        saldo, 
                        origen, 
                        estado, 
                        usr_reg,  --16
						fecha_reg, 
                        usr_mod, 
                        fecha_mod,
						fk_libro_bancos, 
                        fecha_cheque_literal, 
                        emparejado, 
                        origen_cbte
                        
                        
						FROM tesoro.f_tts_libro_bancos_sel(
                        18, 
                        ''172.17.45.12'', 
                        ''00:19:d1:09:22:7e'',
						''TS_LBRBANSAL_SEL'',
                         NULL, 
                         200, 
                         0,
						''fecha desc, id_libro_bancos desc,fecha desc, id_libro_bancos desc,fecha desc, id_libro_bancos desc'',
						''desc'',
						''LBRBAN.id_cuenta_bancaria = ' || v_id_cuenta_bancaria ||' AND LBRBAN.tipo = ''''deposito'''' AND LBRBAN.fk_libro_bancos is null'',
						''%'', 
                        ''%'', 
                        ''%'', 
                        ''%'', 
                        ''%'', 
                        NULL, 
                        NULL, 
                        NULL, 
                        NULL, 
                        NULL,
                        NULL) 
                        
                        AS (
                        id_libro_bancos int4,
                        id_cuenta_bancaria int4,
                        fecha date,
                        a_favor varchar,
                        detalle text,
						observaciones text,
                        nro_liquidacion varchar,
                        nro_comprobante varchar,
						nro_cheque int4,
                        tipo varchar,
                        importe_deposito numeric,
                        importe_cheque numeric,
                        saldo numeric, 
                        origen varchar, 
                        estado varchar, 
                        usr_reg varchar,
						fecha_reg timestamp, 
                        usr_mod varchar, 
                        fecha_mod timestamp,
						fk_libro_bancos int4, 
                        fecha_cheque_literal text, 
                        emparejado varchar,
                        origen_cbte varchar)';
                        
                         
              for v_rec in (select *
                          from dblink(v_consulta,true)
                          as (
                          id_libro_bancos int4,
                          id_cuenta_bancaria int4,
                          fecha date,
                          a_favor varchar,
                          detalle text,
                          observaciones text,
                          nro_liquidacion varchar,
                          nro_comprobante varchar,
                          nro_cheque int4,
                          tipo varchar,
                          importe_deposito numeric,
                          importe_cheque numeric,
                          saldo numeric, 
                          origen varchar, 
                          estado varchar, 
                          usr_reg varchar,
                          fecha_reg timestamp, 
                          usr_mod varchar, 
                          fecha_mod timestamp,
                          fk_libro_bancos int4, 
                          fecha_cheque_literal text, 
                          emparejado varchar,
                          origen_cbte varchar/*,
                          notificado varchar,
                          id_comprobante_libro_bancos int4,
                          desc_comprobante_libro_bancos varchar,
                          id_finalidad int4,
                          desc_finalidad varchar,
                          color varchar*/)) loop
                              
            	return next v_rec;
			end loop;
            
            v_res_cone=(select dblink_disconnect());

            return;
						
		end;
    
    
 END IF;


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
COST 100 ROWS 1000;