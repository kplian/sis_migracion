CREATE OR REPLACE FUNCTION migracion.f_mig_ini_tpm_financiador_tfinanciador (
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
						       v_consulta = 'select pxp.f_add_remove_foraneas(''tfinanciador'',''PARAM'',''eliminar'')';                   
						       --raise notice '%',v_consulta;
						       PERFORM * FROM dblink(v_consulta,true) AS ( xx varchar);
						        v_res_cone=(select dblink_disconnect());
						     END IF;
						
						
						   --consulta los registro de la tabla origen
						    FOR g_registros in (
						        SELECT 
						codigo_financiador,
						id_financiador,
						id_usuario,
						descripcion_financiador,
						fecha_registro,
						fecha_ultima_modificacion,
						hora_registro,
						hora_ultima_modificacion,
						id_financiador_actif,
						nombre_financiador
FROM 
						          PARAM.tpm_financiador) LOOP
						        
						        -- inserta en el destino
						      
						            v_cadena_resp = migracion.f_trans_tpm_financiador_tfinanciador(
						            'INSERT',g_registros.codigo_financiador
					,g_registros.id_financiador
					,g_registros.id_usuario
					,g_registros.descripcion_financiador
					,g_registros.fecha_registro
					,g_registros.fecha_ultima_modificacion
					,g_registros.hora_registro
					,g_registros.hora_ultima_modificacion
					,g_registros.id_financiador_actif
					,g_registros.nombre_financiador
					);		
						
						
						    END LOOP;
						
						     --reconstruye llaves foraneas
						     v_resp =  (SELECT dblink_connect(v_cadena_cnx));
									            
						     IF(v_resp!='OK') THEN
									            
						        --modificar bandera de fallo  
						         raise exception 'FALLA CONEXION A LA BASE DE DATOS CON DBLINK';
									                 
						     ELSE
						       v_consulta = 'select pxp.f_add_remove_foraneas(''tfinanciador'',''PARAM'',''insertar'')';                   
						       --raise notice '%',v_consulta;
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