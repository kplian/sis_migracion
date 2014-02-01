CREATE OR REPLACE FUNCTION migracion.f_mig_ini_tts_libro_bancos_tts_libro_bancos()
						RETURNS boolean AS
						$BODY$


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
						       v_consulta = 'select pxp.f_add_remove_foraneas(''tts_libro_bancos'',''MIGRA'',''eliminar'')';                   
						       raise notice '%',v_consulta;
						       PERFORM * FROM dblink(v_consulta,true) AS ( xx varchar);
						        v_res_cone=(select dblink_disconnect());
						     END IF;
						
						
						   --consulta los registro de la tabla origen
						    FOR g_registros in (
						        SELECT 
						id_cuenta_bancaria,
						id_libro_bancos,
						fk_libro_bancos,
						id_cuenta_bancaria,
						a_favor,
						detalle,
						estado,
						fecha,
						fecha_mod,
						fecha_reg,
						importe_cheque,
						importe_deposito,
						indice,
						nro_cheque,
						nro_comprobante,
						nro_liquidacion,
						observaciones,
						origen,
						tipo,
						usr_mod,
						usr_reg
FROM 
						          TESORO.tts_libro_bancos) LOOP
						        
						        -- inserta en el destino
						      
						            v_cadena_resp = migracion.f_trans_tts_libro_bancos_tts_libro_bancos(
						            'INSERT',g_registros.id_cuenta_bancaria
					,g_registros.id_libro_bancos
					,g_registros.fk_libro_bancos
					,g_registros.id_cuenta_bancaria
					,g_registros.a_favor
					,g_registros.detalle
					,g_registros.estado
					,g_registros.fecha
					,g_registros.fecha_mod
					,g_registros.fecha_reg
					,g_registros.importe_cheque
					,g_registros.importe_deposito
					,g_registros.indice
					,g_registros.nro_cheque
					,g_registros.nro_comprobante
					,g_registros.nro_liquidacion
					,g_registros.observaciones
					,g_registros.origen
					,g_registros.tipo
					,g_registros.usr_mod
					,g_registros.usr_reg
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
						       v_consulta = 'select pxp.f_add_remove_foraneas(''tts_libro_bancos'',''MIGRA'',''insertar'')';                   
						       raise notice '%',v_consulta;
						       PERFORM * FROM dblink(v_consulta,true) AS ( xx varchar);
						        v_res_cone=(select dblink_disconnect());
						     END IF;
						
						RETURN TRUE;
						END;
						$BODY$


						LANGUAGE 'plpgsql'
						VOLATILE
						CALLED ON NULL INPUT
						SECURITY INVOKER;