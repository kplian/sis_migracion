CREATE OR REPLACE FUNCTION migracion.f_mig_ini_tad_proveedor_tproveedor()
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
						       v_consulta = 'select pxp.f_add_remove_foraneas(''tproveedor'',''PARAM'',''eliminar'')';                   
						       raise notice '%',v_consulta;
						       PERFORM * FROM dblink(v_consulta,true) AS ( xx varchar);
						        v_res_cone=(select dblink_disconnect());
						     END IF;
						
						
						   --consulta los registro de la tabla origen
						    FOR g_registros in (
						        SELECT 
						id_proveedor,
						id_lugar,
						id_supergrupo,
						id_tipo_servicio,
						id_usuario_reg,
						codigo,
						confirmado,
						contrasena,
						fecha_reg,
						id_institucion,
						id_persona,
						nombre_pago,
						observaciones,
						rubro,
						rubro1,
						rubro2,
						tipo,
						usuario
FROM 
						          COMPRO.tad_proveedor) LOOP
						        
						        -- inserta en el destino
						      
						            v_cadena_resp = migracion.f_trans_tad_proveedor_tproveedor(
						            'INSERT',g_registros.id_proveedor
					,g_registros.id_lugar
					,g_registros.id_supergrupo
					,g_registros.id_tipo_servicio
					,g_registros.id_usuario_reg
					,g_registros.codigo
					,g_registros.confirmado
					,g_registros.contrasena
					,g_registros.fecha_reg
					,g_registros.id_institucion
					,g_registros.id_persona
					,g_registros.nombre_pago
					,g_registros.observaciones
					,g_registros.rubro
					,g_registros.rubro1
					,g_registros.rubro2
					,g_registros.tipo
					,g_registros.usuario
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
						       v_consulta = 'select pxp.f_add_remove_foraneas(''tproveedor'',''PARAM'',''insertar'')';                   
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