--------------- SQL ---------------

CREATE OR REPLACE FUNCTION migra.f__on_trig_tsg_usuario_asignacion_tusuario_grupo_ep (
  v_operacion varchar,
  p_id_usuario_grupo_ep integer,
  p_estado_reg varchar,
  p_fecha_mod timestamp,
  p_fecha_reg timestamp,
  p_id_grupo integer,
  p_id_usuario integer,
  p_id_usuario_mod integer,
  p_id_usuario_reg integer
)
RETURNS text AS
$body$
/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  April 24, 2013, 6:23 pm
						Autor: autogenerado (ADMINISTRADOR DEL SISTEMA )
						
						*/
						
						DECLARE
						
						BEGIN
						
						    if(v_operacion = 'INSERT') THEN
						
						          INSERT INTO 
						            SEGU.tusuario_grupo_ep (
						id_usuario_grupo_ep,
						estado_reg,
						fecha_mod,
						fecha_reg,
						id_grupo,
						id_usuario,
						id_usuario_mod,
						id_usuario_reg)
				VALUES (
						p_id_usuario_grupo_ep,
						p_estado_reg,
						p_fecha_mod,
						p_fecha_reg,
						p_id_grupo,
						p_id_usuario,
						p_id_usuario_mod,
						p_id_usuario_reg);

						       
							    ELSEIF  v_operacion = 'UPDATE' THEN
						               
                                       
                                     --chequear si ya existe el registro si no sacar un error
                              IF  not EXISTS(select 1 
                                 from SEGU.tusuario_grupo_ep  
                                 where id_usuario_grupo_ep=p_id_usuario_grupo_ep) THEN
                                                       
                                  raise exception 'No existe el registro que desea modificar';
                                                            
                               END IF;  
                                       
                                       
                                       
                                       UPDATE 
						                  SEGU.tusuario_grupo_ep  
						                SET						 estado_reg=p_estado_reg
						 ,fecha_mod=p_fecha_mod
						 ,fecha_reg=p_fecha_reg
						 ,id_grupo=p_id_grupo
						 ,id_usuario=p_id_usuario
						 ,id_usuario_mod=p_id_usuario_mod
						 ,id_usuario_reg=p_id_usuario_reg
						 WHERE id_usuario_grupo_ep=p_id_usuario_grupo_ep;

						       
						       ELSEIF  v_operacion = 'DELETE' THEN
						       
						            --chequear si ya existe el registro si no sacar un error
                              IF  not EXISTS(select 1 
                                 from SEGU.tusuario_grupo_ep  
                                 where id_usuario_grupo_ep=p_id_usuario_grupo_ep) THEN
                                                       
                                  raise exception 'No existe el registro que desea eliminar';
                                                            
                               END IF;  
                                 
                                 
                                 DELETE FROM 
						              SEGU.tusuario_grupo_ep
 
						              						 WHERE id_usuario_grupo_ep=p_id_usuario_grupo_ep;

						       
						       END IF;  
						  
						 return 'true';
						
						-- statements;
						--EXCEPTION
						--WHEN exception_name THEN
						--  statements;
						END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;