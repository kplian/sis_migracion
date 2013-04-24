CREATE OR REPLACE FUNCTION migracion.f_mig_ini_tsg_usuario_tusuario (
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
						       v_consulta = 'select pxp.f_add_remove_foraneas(''tusuario'',''SEGU'',''eliminar'')';                   
						       raise notice '%',v_consulta;
						       PERFORM * FROM dblink(v_consulta,true) AS ( xx varchar);
						        v_res_cone=(select dblink_disconnect());
						     END IF;
						
						
						   --consulta los registro de la tabla origen
						    FOR g_registros in (
						        SELECT 
						login,
						id_usuario,
						id_nivel_seguridad,
						id_persona,
						autentificacion,
						contrasenia,
						estado_usuario,
						estilo_usuario,
						fecha_expiracion,
						fecha_registro,
						fecha_ultima_modificacion,
						filtro_avanzado,
						hora_registro,
						hora_ultima_modificacion,
						login_anterior,
						login_nuevo
FROM 
						          SSS.tsg_usuario) LOOP
						        
						        -- inserta en el destino
						      
						            v_cadena_resp = migracion.f_trans_tsg_usuario_tusuario(
						            'INSERT',g_registros.login
					,g_registros.id_usuario
					,g_registros.id_nivel_seguridad
					,g_registros.id_persona
					,g_registros.autentificacion
					,g_registros.contrasenia
					,g_registros.estado_usuario
					,g_registros.estilo_usuario
					,g_registros.fecha_expiracion
					,g_registros.fecha_registro
					,g_registros.fecha_ultima_modificacion
					,g_registros.filtro_avanzado
					,g_registros.hora_registro
					,g_registros.hora_ultima_modificacion
					,g_registros.login_anterior
					,g_registros.login_nuevo
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
						       v_consulta = 'select pxp.f_add_remove_foraneas(''tusuario'',''SEGU'',''insertar'')';                   
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