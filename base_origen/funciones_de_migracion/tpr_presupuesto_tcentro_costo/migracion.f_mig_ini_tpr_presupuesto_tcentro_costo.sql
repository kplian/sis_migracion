CREATE OR REPLACE FUNCTION migracion.f_mig_ini_tpr_presupuesto_tcentro_costo (
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
						       v_consulta = 'select pxp.f_add_remove_foraneas(''tcentro_costo'',''PARAM'',''eliminar'')';                   
						       raise notice '%',v_consulta;
						       PERFORM * FROM dblink(v_consulta,true) AS ( xx varchar);
						       v_consulta = 'select pxp.f_add_remove_foraneas(''tpresupuesto'',''PRE'',''eliminar'')';                   
						       raise notice '%',v_consulta;
						       PERFORM * FROM dblink(v_consulta,true) AS ( xx varchar);
						       v_res_cone=(select dblink_disconnect());
						     END IF;
						
						
						   --consulta los registro de la tabla origen
						    FOR g_registros in (
						        SELECT 
						id_presupuesto,
						id_concepto_colectivo,
						id_fina_regi_prog_proy_acti,
						id_fuente_financiamiento,
						id_parametro,
						cod_act,
						cod_fin,
						cod_prg,
						cod_proy,
						estado_pres,
						fecha_mod,
						fecha_presentacion,
						fecha_reg,
						id_categoria_prog,
						id_unidad_organizacional,
						id_usr_mod,
						id_usr_reg,
						nombre_agrupador,
						tipo_pres
FROM 
						          PRESTO.tpr_presupuesto) LOOP
						        
						        -- inserta en el destino
						      
						            v_cadena_resp = migracion.f_trans_tpr_presupuesto_tcentro_costo_tpresupuesto(
						            'INSERT',g_registros.id_presupuesto
					,g_registros.id_concepto_colectivo
					,g_registros.id_fina_regi_prog_proy_acti
					,g_registros.id_fuente_financiamiento
					,g_registros.id_parametro
					,g_registros.cod_act
					,g_registros.cod_fin
					,g_registros.cod_prg
					,g_registros.cod_proy
					,g_registros.estado_pres
					,g_registros.fecha_mod
					,g_registros.fecha_presentacion
					,g_registros.fecha_reg
					,g_registros.id_categoria_prog
					,g_registros.id_unidad_organizacional
					,g_registros.id_usr_mod
					,g_registros.id_usr_reg
					,g_registros.nombre_agrupador
					,g_registros.tipo_pres
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
						       v_consulta = 'select pxp.f_add_remove_foraneas(''tcentro_costo'',''PARAM'',''insertar'')';                   
						       raise notice '%',v_consulta;
						       PERFORM * FROM dblink(v_consulta,true) AS ( xx varchar);
                               v_consulta = 'select pxp.f_add_remove_foraneas(''tpresupuesto'',''PRE'',''insertar'')';                   
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