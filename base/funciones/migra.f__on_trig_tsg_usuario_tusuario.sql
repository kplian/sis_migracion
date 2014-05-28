--------------- SQL ---------------

CREATE OR REPLACE FUNCTION migra.f__on_trig_tsg_usuario_tusuario (
  v_operacion varchar,
  p_cuenta varchar,
  p_id_usuario integer,
  p_id_clasificador integer,
  p_id_persona integer,
  p_autentificacion varchar,
  p_contrasena varchar,
  p_contrasena_anterior varchar,
  p_estado_reg varchar,
  p_estilo varchar,
  p_fecha_caducidad date,
  p_fecha_reg date
)
RETURNS text AS
$body$
/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  February 8, 2013, 3:33 pm
						Autor: autogenerado (ADMINISTRADOR DEL SISTEMA )
						
						*/
						
						DECLARE
						
						BEGIN
						
						    if(v_operacion = 'INSERT') THEN
						
						          INSERT INTO 
						            SEGU.tusuario (
						cuenta,
						id_usuario,
						id_clasificador,
						id_persona,
						autentificacion,
						contrasena,
						contrasena_anterior,
						estado_reg,
						estilo,
						fecha_caducidad,
						fecha_reg)
				VALUES (
						p_cuenta,
						p_id_usuario,
						p_id_clasificador,
						p_id_persona,
						p_autentificacion,
						p_contrasena,
						p_contrasena_anterior,
						p_estado_reg::pxp.estado_reg,
						p_estilo,
						p_fecha_caducidad,
						p_fecha_reg);

						       
							    ELSEIF  v_operacion = 'UPDATE' THEN
						               
                                       
                                --chequear si ya existe el registro si no sacar un error
                              IF  not EXISTS(select 1 
                                 from SEGU.tusuario  
                                 where id_usuario=p_id_usuario) THEN
                                                       
                                  raise exception 'No existe el registro que desea modificar';
                                                            
                               END IF;   
                                       
                                       
                                       
                                       
                                       
                                       UPDATE 
						                  SEGU.tusuario  
						                SET						 cuenta=p_cuenta
						 ,id_clasificador=p_id_clasificador
						 ,id_persona=p_id_persona
						 ,autentificacion=p_autentificacion
						 ,contrasena=p_contrasena
						 ,contrasena_anterior=p_contrasena_anterior
						 ,estado_reg=p_estado_reg::pxp.estado_reg
						 ,estilo=p_estilo
						 ,fecha_caducidad=p_fecha_caducidad
						 ,fecha_reg=p_fecha_reg
						 WHERE id_usuario=p_id_usuario;

						       
						       ELSEIF  v_operacion = 'DELETE' THEN
						       
						          --chequear si ya existe el registro si no sacar un error
                                 IF  not EXISTS(select 1 
                                   from SEGU.tusuario  
                                    where id_usuario=p_id_usuario) THEN
                                                       
                                     raise exception 'No existe el registro que desea eliminar';
                                                            
                                 END IF;
                                 
                                 
                                 DELETE FROM 
						              SEGU.tusuario
 
						              						 WHERE id_usuario=p_id_usuario;

						       
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