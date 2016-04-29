CREATE OR REPLACE FUNCTION migra.f__on_trig_tpr_proyecto_tcp_proyecto (
						  v_operacion varchar,p_id_cp_proyecto int4,p_codigo varchar,p_codigo_sisin varchar,p_descripcion varchar,p_estado_reg varchar,p_fecha_reg timestamp,p_id_gestion int4,p_id_usuario_reg int4)
						RETURNS text AS
						$BODY$

/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  April 19, 2016, 1:39 pm
						Autor: autogenerado (ENDESIS ROOT SISTEMA)
						
						*/
						
						DECLARE
						
						BEGIN
						
						    if(v_operacion = 'INSERT') THEN
						
						          INSERT INTO 
						            PRE.tcp_proyecto (
						id_cp_proyecto,
						codigo,
						codigo_sisin,
						descripcion,
						estado_reg,
						fecha_reg,
						id_gestion,
						id_usuario_reg)
				VALUES (
						p_id_cp_proyecto,
						p_codigo,
						p_codigo_sisin,
						p_descripcion,
						p_estado_reg,
						p_fecha_reg,
						p_id_gestion,
						p_id_usuario_reg);

                               
                                ELSEIF  v_operacion = 'UPDATE' THEN
                                       
                                       IF  not EXISTS(select 1 
                                           from PRE.tcp_proyecto
 
                                           						 WHERE id_cp_proyecto=p_id_cp_proyecto) THEN
                                       
                                            raise exception 'No existe el registro que  desea modificar';
                                            
                                       END IF;
						               
						               
						               UPDATE 
						                  PRE.tcp_proyecto  
						                SET						 codigo=p_codigo
						 ,codigo_sisin=p_codigo_sisin
						 ,descripcion=p_descripcion
						 ,estado_reg=p_estado_reg
						 ,fecha_reg=p_fecha_reg
						 ,id_gestion=p_id_gestion
						 ,id_usuario_reg=p_id_usuario_reg
						 WHERE id_cp_proyecto=p_id_cp_proyecto;

						       
						       ELSEIF  v_operacion = 'DELETE' THEN
						       
						         
						         IF  not EXISTS(select 1 
                                           from PRE.tcp_proyecto
						 WHERE id_cp_proyecto=p_id_cp_proyecto) THEN
                                       
                                            raise exception 'No existe el registro que  desea eliminar';
                                            
                                END IF;
						         
						         
						         DELETE FROM 
						              PRE.tcp_proyecto
 
						              						 WHERE id_cp_proyecto=p_id_cp_proyecto;

						       
						       END IF;  
						  
						 return 'true';
						
						-- statements;
						--EXCEPTION
						--WHEN exception_name THEN
						--  statements;
						END;
						$BODY$


						LANGUAGE 'plpgsql'
						VOLATILE
						CALLED ON NULL INPUT
						SECURITY INVOKER
						COST 100;