CREATE OR REPLACE FUNCTION migracion.f_mig_ini_tkp_unidad_organizacional_tuo (
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
						       v_consulta = 'select pxp.f_add_remove_foraneas(''tuo'',''ORGA'',''eliminar'')';                   
						       raise notice '%',v_consulta;
						       PERFORM * FROM dblink(v_consulta,true) AS ( xx varchar);
						        v_res_cone=(select dblink_disconnect());
						     END IF;
						
						
						   --consulta los registro de la tabla origen
						    FOR g_registros in (
						        SELECT 
						id_unidad_organizacional,
						id_cargo,
						id_nivel_organizacional,
						area,
						cargo_individual,
						centro,
						codigo,
						correspondencia,
						descripcion,
						estado_reg,
						extension,
						fecha_fin,
						fecha_inicio,
						fecha_reg,
						gerencia,
						importe_max_apro,
						importe_max_pre,
						nombre_cargo,
						nombre_unidad,
						prioridad,
						sw_presto,
						sw_rep_resumen,
						url_archivo,
						vigente
FROM 
						          KARD.tkp_unidad_organizacional) LOOP
						        
						        -- inserta en el destino
						      
						            v_cadena_resp = migracion.f_trans_tkp_unidad_organizacional_tuo(
						            'INSERT',g_registros.id_unidad_organizacional
					,g_registros.id_cargo
					,g_registros.id_nivel_organizacional
					,g_registros.area
					,g_registros.cargo_individual
					,g_registros.centro
					,g_registros.codigo
					,g_registros.correspondencia
					,g_registros.descripcion
					,g_registros.estado_reg
					,g_registros.extension
					,g_registros.fecha_fin
					,g_registros.fecha_inicio
					,g_registros.fecha_reg
					,g_registros.gerencia
					,g_registros.importe_max_apro
					,g_registros.importe_max_pre
					,g_registros.nombre_cargo
					,g_registros.nombre_unidad
					,g_registros.prioridad
					,g_registros.sw_presto
					,g_registros.sw_rep_resumen
					,g_registros.url_archivo
					,g_registros.vigente
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
						       v_consulta = 'select pxp.f_add_remove_foraneas(''tuo'',''ORGA'',''insertar'')';                   
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