CREATE OR REPLACE FUNCTION migracion.f_mig_ini_tpr_partida_tpartida (
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
						       v_consulta = 'select pxp.f_add_remove_foraneas(''tpartida'',''PRE'',''eliminar'')';                   
						       raise notice '%',v_consulta;
						       PERFORM * FROM dblink(v_consulta,true) AS ( xx varchar);
						        v_res_cone=(select dblink_disconnect());
						     END IF;
						
						
						   --consulta los registro de la tabla origen
						    FOR g_registros in (
						        SELECT 
						id_partida,
						id_concepto_colectivo,
						id_oec_sigma,
						id_parametro,
						id_partida_padre,
						cod_ascii,
						cod_excel,
						codigo_partida,
						cod_trans,
						desc_partida,
						ent_trf,
						fecha_reg,
						id_usr_reg,
						nivel_partida,
						nombre_partida,
						sw_movimiento,
						sw_transaccional,
						tipo_memoria,
						tipo_partida
FROM 
						          PRESTO.tpr_partida) LOOP
						        
						        -- inserta en el destino
						      
						            v_cadena_resp = migracion.f_trans_tpr_partida_tpartida(
						            'INSERT',g_registros.id_partida
					,g_registros.id_concepto_colectivo
					,g_registros.id_oec_sigma
					,g_registros.id_parametro
					,g_registros.id_partida_padre
					,g_registros.cod_ascii
					,g_registros.cod_excel
					,g_registros.codigo_partida
					,g_registros.cod_trans
					,g_registros.desc_partida
					,g_registros.ent_trf
					,g_registros.fecha_reg
					,g_registros.id_usr_reg
					,g_registros.nivel_partida
					,g_registros.nombre_partida
					,g_registros.sw_movimiento
					,g_registros.sw_transaccional
					,g_registros.tipo_memoria
					,g_registros.tipo_partida
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
						       v_consulta = 'select pxp.f_add_remove_foraneas(''tpartida'',''PRE'',''insertar'')';                   
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