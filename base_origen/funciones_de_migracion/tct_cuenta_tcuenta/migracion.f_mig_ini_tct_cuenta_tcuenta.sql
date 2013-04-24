CREATE OR REPLACE FUNCTION migracion.f_mig_ini_tct_cuenta_tcuenta (
)
RETURNS boolean AS
$body$
						DECLARE
						 
						g_registros record;
						v_consulta varchar;
						v_res_cone varchar;
						v_cadena_cnx varchar;
						v_resp varchar;
						
						v_cadena_resp varchar[];
						
						BEGIN
						     --funcion para obtener cadena de conexion
							 v_cadena_cnx =  migracion.f_obtener_cadena_con_dblink();
									          
						  
						    --quirta llaves foraneas en el destino
						     v_resp =  (SELECT dblink_connect(v_cadena_cnx));
									            
						     IF(v_resp!='OK') THEN
									            
						        --modificar bandera de fallo  
						         raise exception 'FALLA CONEXION A LA BASE DE DATOS CON DBLINK';
									                 
						     ELSE
						       v_consulta = 'select pxp.f_add_remove_foraneas(''tcuenta'',''CONTA'',''eliminar'')';                   
						       raise notice '%',v_consulta;
						       PERFORM * FROM dblink(v_consulta,true) AS ( xx varchar);
						       v_res_cone=(select dblink_disconnect());
						     END IF;
						
						
						   --consulta los registro de la tabla origen
						    FOR g_registros in (
						        SELECT 
						nro_cuenta,
						id_cuenta,
						id_auxiliar_actualizacion,
						id_auxiliar_dif,
						id_cuenta_actualizacion,
						id_cuenta_dif,
						id_cuenta_padre,
						id_cuenta_sigma,
						id_moneda,
						id_parametro,
						cuenta_flujo_sigma,
						cuenta_sigma,
						desc_cuenta,
						descripcion,
						nivel_cuenta,
						nombre_cuenta,
						sw_aux,
						sw_oec,
						sw_sigma,
						sw_sistema_actualizacion,
						sw_transaccional,
						tipo_cuenta,
						tipo_cuenta_pat
FROM 
						          SCI.tct_cuenta) LOOP
						        
						        -- inserta en el destino
						      
						            v_cadena_resp = migracion.f_trans_tct_cuenta_tcuenta(
						            'INSERT',g_registros.nro_cuenta
					,g_registros.id_cuenta
					,g_registros.id_auxiliar_actualizacion
					,g_registros.id_auxiliar_dif
					,g_registros.id_cuenta_actualizacion
					,g_registros.id_cuenta_dif
					,g_registros.id_cuenta_padre
					,g_registros.id_cuenta_sigma
					,g_registros.id_moneda
					,g_registros.id_parametro
					,g_registros.cuenta_flujo_sigma
					,g_registros.cuenta_sigma
					,g_registros.desc_cuenta
					,g_registros.descripcion
					,g_registros.nivel_cuenta
					,g_registros.nombre_cuenta
					,g_registros.sw_aux
					,g_registros.sw_oec
					,g_registros.sw_sigma
					,g_registros.sw_sistema_actualizacion
					,g_registros.sw_transaccional
					,g_registros.tipo_cuenta
					,g_registros.tipo_cuenta_pat
					);	
					            IF v_cadena_resp[1] = 'FALSE' THEN
					              RAISE NOTICE 'ERROR ->>>  (%),(%) - %   ', v_cadena_resp[3], v_cadena_resp[2], v_cadena_resp[4];
					            END IF; 	
						 END LOOP;
						
						     --reconstruye llaves foraneas
						     v_resp =  (SELECT dblink_connect(v_cadena_cnx));
									            
						     IF(v_resp!='OK') THEN
									            
						        --modificar bandera de fallo  
						         raise exception 'FALLA CONEXION A LA BASE DE DATOS CON DBLINK';
									                 
						     ELSE
						       v_consulta = 'select pxp.f_add_remove_foraneas(''tcuenta'',''CONTA'',''insertar'')';                   
						       raise notice '%',v_consulta;
						       PERFORM * FROM dblink(v_consulta,true) AS ( xx varchar);
						        v_res_cone=(select dblink_disconnect());
						     END IF;
						
						RETURN TRUE;
						END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER;