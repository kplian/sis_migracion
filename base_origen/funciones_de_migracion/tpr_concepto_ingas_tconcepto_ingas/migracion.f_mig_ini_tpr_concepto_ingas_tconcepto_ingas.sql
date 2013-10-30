--------------- SQL ---------------

CREATE OR REPLACE FUNCTION migracion.f_mig_ini_tpr_concepto_ingas_tconcepto_ingas (
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
						       v_consulta = 'select pxp.f_add_remove_foraneas(''tconcepto_ingas'',''PRE'',''eliminar'')';                   
						       raise notice '%',v_consulta;
						       PERFORM * FROM dblink(v_consulta,true) AS ( xx varchar);
						        v_res_cone=(select dblink_disconnect());
						     END IF;
						
						
						   --consulta los registro de la tabla origen
						    FOR g_registros in (
						        SELECT 
						id_concepto_ingas,
						id_item,
						id_oec,
						id_partida,
						id_servicio,
						desc_ingas,
						fecha_reg,
						id_usr_reg,
						sw_tesoro,
                        almacenable,
                        tipo,
                        activo_fijo
                        FROM 
						          PRESTO.tpr_concepto_ingas) LOOP
						        
						        -- inserta en el destino
						      
						            v_cadena_resp = migracion.f_trans_tpr_concepto_ingas_tconcepto_ingas(
						            'INSERT',g_registros.id_concepto_ingas
					,g_registros.id_item
					,g_registros.id_oec
					,g_registros.id_partida
					,g_registros.id_servicio
					,g_registros.desc_ingas
					,g_registros.fecha_reg
					,g_registros.id_usr_reg
					,g_registros.sw_tesoro
                    ,g_registros.activo_fijo
                    ,g_registros.tipo
                    ,g_registros.almacenable
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
						       v_consulta = 'select pxp.f_add_remove_foraneas(''tconcepto_ingas'',''PRE'',''insertar'')';                   
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