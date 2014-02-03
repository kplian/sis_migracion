--------------- SQL ---------------

CREATE OR REPLACE FUNCTION migracion.f_mig_ini_tts_cuenta_bancaria_tts_cuenta_bancaria (
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
						       v_consulta = 'select pxp.f_add_remove_foraneas(''tts_cuenta_bancaria'',''MIGRA'',''eliminar'')';                   
						       raise notice '%',v_consulta;
						       PERFORM * FROM dblink(v_consulta,true) AS ( xx varchar);

						        v_res_cone=(select dblink_disconnect());
						     END IF;
						

						   --consulta los registro de la tabla origen
						    FOR g_registros in (
						        SELECT 
                                cb.id_cuenta_bancaria,
                                cb.id_auxiliar,
                                cb.id_cuenta,
                                cb.id_institucion,
                                cb.id_parametro,
                                cb.estado_cuenta,
                                cb.nro_cheque,
                                cb.nro_cuenta_banco,
                                pa.id_gestion,
                                cb.central
                                FROM TESORO.tts_cuenta_bancaria cb
                                INNER JOIN tesoro.tts_parametro pa
                                ON pa.id_parametro = cb.id_parametro
                                ORDER BY pa.id_gestion
                                ) LOOP
						        
						        -- inserta en el destino
						            v_cadena_resp = migracion.f_trans_tts_cuenta_bancaria_tts_cuenta_bancaria(
						            'INSERT',g_registros.id_cuenta_bancaria
					,g_registros.id_auxiliar
					,g_registros.id_cuenta
					,g_registros.id_institucion
					,g_registros.id_parametro
					,g_registros.estado_cuenta
					,g_registros.nro_cheque
					,g_registros.nro_cuenta_banco
                    ,g_registros.id_gestion
                    ,g_registros.central
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
						       v_consulta = 'select pxp.f_add_remove_foraneas(''tts_cuenta_bancaria'',''MIGRA'',''insertar'')';                   
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