CREATE OR REPLACE FUNCTION migracion.f_mig_ini_tsg_persona_tpersona (
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
						       v_consulta = 'select pxp.f_add_remove_foraneas(''tpersona'',''SEGU'',''eliminar'')';                   
						       raise notice '%',v_consulta;
						       PERFORM * FROM dblink(v_consulta,true) AS ( xx varchar);
						        v_res_cone=(select dblink_disconnect());
						     END IF;
						
						
						   --consulta los registro de la tabla origen
						    FOR g_registros in (
						        SELECT 
						apellido_paterno,
						id_persona,
						id_tipo_doc_identificacion,
						apellido_materno,
						casilla,
						celular1,
						celular2,
						direccion,
						doc_id,
						email1,
						email1_orig,
						email2,
						email3,
						extension,
						fecha_nacimiento,
						fecha_registro,
						fecha_ultima_modificacion,
						genero,
						hora_registro,
						hora_ultima_modificacion,
						nombre,
						nombre_foto,
						nro_registro,
						numero,
						observaciones,
						pag_web,
						telefono1,
						telefono2
FROM 
						          SSS.tsg_persona) LOOP
						        
						        -- inserta en el destino
						      
						            v_cadena_resp = migracion.f_trans_tsg_persona_tpersona(
						            'INSERT',g_registros.apellido_paterno
					,g_registros.id_persona
					,g_registros.id_tipo_doc_identificacion
					,g_registros.apellido_materno
					,g_registros.casilla
					,g_registros.celular1
					,g_registros.celular2
					,g_registros.direccion
					,g_registros.doc_id
					,g_registros.email1
					,g_registros.email1_orig
					,g_registros.email2
					,g_registros.email3
					,g_registros.extension
					,g_registros.fecha_nacimiento
					,g_registros.fecha_registro
					,g_registros.fecha_ultima_modificacion
					,g_registros.genero
					,g_registros.hora_registro
					,g_registros.hora_ultima_modificacion
					,g_registros.nombre
					,g_registros.nombre_foto
					,g_registros.nro_registro
					,g_registros.numero
					,g_registros.observaciones
					,g_registros.pag_web
					,g_registros.telefono1
					,g_registros.telefono2
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
						       v_consulta = 'select pxp.f_add_remove_foraneas(''tpersona'',''SEGU'',''insertar'')';                   
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