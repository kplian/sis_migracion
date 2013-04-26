CREATE OR REPLACE FUNCTION migra.f__on_trig_tsg_asignacion_estructura_tgrupo (
						  v_operacion varchar,p_id_grupo int4,p_estado_reg varchar,p_fecha_mod timestamp,p_fecha_reg timestamp,p_id_usuario_mod int4,p_id_usuario_reg int4,p_nombre varchar,p_obs varchar)
						RETURNS text AS
						$BODY$

/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  April 24, 2013, 7:09 pm
						Autor: autogenerado (ADMINISTRADOR DEL SISTEMA )
						
						*/
						
						DECLARE
						
						BEGIN
						
						    if(v_operacion = 'INSERT') THEN
						
						          INSERT INTO 
						            PARAM.tgrupo (
						id_grupo,
						estado_reg,
						fecha_mod,
						fecha_reg,
						id_usuario_mod,
						id_usuario_reg,
						nombre,
						obs)
				VALUES (
						p_id_grupo,
						p_estado_reg,
						p_fecha_mod,
						p_fecha_reg,
						p_id_usuario_mod,
						p_id_usuario_reg,
						p_nombre,
						p_obs);

						       
							    ELSEIF  v_operacion = 'UPDATE' THEN
						               UPDATE 
						                  PARAM.tgrupo  
						                SET						 estado_reg=p_estado_reg
						 ,fecha_mod=p_fecha_mod
						 ,fecha_reg=p_fecha_reg
						 ,id_usuario_mod=p_id_usuario_mod
						 ,id_usuario_reg=p_id_usuario_reg
						 ,nombre=p_nombre
						 ,obs=p_obs
						 WHERE id_grupo=p_id_grupo;

						       
						       ELSEIF  v_operacion = 'DELETE' THEN
						       
						         DELETE FROM 
						              PARAM.tgrupo
 
						              						 WHERE id_grupo=p_id_grupo;

						       
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