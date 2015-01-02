CREATE OR REPLACE FUNCTION migra.f__on_trig_tpr_categoria_prog_tcategoria_programatica (
						  v_operacion varchar,p_id_categoria_programatica int4,p_descripcion text,p_estado_reg varchar,p_fecha_mod timestamp,p_fecha_reg timestamp,p_id_gestion int4,p_id_usuario_mod int4,p_id_usuario_reg int4)
						RETURNS text AS
						$BODY$

/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  January 2, 2015, 5:57 pm
						Autor: autogenerado (GROVER VELASQUEZ COLQUE)
						
						*/
						
						DECLARE
						
						BEGIN
						
						    if(v_operacion = 'INSERT') THEN
						
						          INSERT INTO 
						            PRE.tcategoria_programatica (
						id_categoria_programatica,
						descripcion,
						estado_reg,
						fecha_mod,
						fecha_reg,
						id_gestion,
						id_usuario_mod,
						id_usuario_reg)
				VALUES (
						p_id_categoria_programatica,
						p_descripcion,
						p_estado_reg,
						p_fecha_mod,
						p_fecha_reg,
						p_id_gestion,
						p_id_usuario_mod,
						p_id_usuario_reg);

                               
                                ELSEIF  v_operacion = 'UPDATE' THEN
                                       
                                       IF  not EXISTS(select 1 
                                           from PRE.tcategoria_programatica
 
                                           						 WHERE id_categoria_programatica=p_id_categoria_programatica) THEN
                                       
                                            raise exception 'No existe el registro que  desea modificar';
                                            
                                       END IF;
						               
						               
						               UPDATE 
						                  PRE.tcategoria_programatica  
						                SET						 descripcion=p_descripcion
						 ,estado_reg=p_estado_reg
						 ,fecha_mod=p_fecha_mod
						 ,fecha_reg=p_fecha_reg
						 ,id_gestion=p_id_gestion
						 ,id_usuario_mod=p_id_usuario_mod
						 ,id_usuario_reg=p_id_usuario_reg
						 WHERE id_categoria_programatica=p_id_categoria_programatica;

						       
						       ELSEIF  v_operacion = 'DELETE' THEN
						       
						         
						         IF  not EXISTS(select 1 
                                           from PRE.tcategoria_programatica
						 WHERE id_categoria_programatica=p_id_categoria_programatica) THEN
                                       
                                            raise exception 'No existe el registro que  desea eliminar';
                                            
                                END IF;
						         
						         
						         DELETE FROM 
						              PRE.tcategoria_programatica
 
						              						 WHERE id_categoria_programatica=p_id_categoria_programatica;

						       
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