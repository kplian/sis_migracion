CREATE OR REPLACE FUNCTION migra.f__on_trig_tsg_asignacion_estructura_tpm_frppa_tgrupo_ep (
						  v_operacion varchar,p_id_grupo_ep int4,p_estado_reg varchar,p_fecha_mod timestamp,p_fecha_reg timestamp,p_id_ep int4,p_id_grupo int4,p_id_usuario_mod int4,p_id_usuario_reg int4)
						RETURNS text AS
						$BODY$

/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  April 24, 2013, 4:46 pm
						Autor: autogenerado (ADMINISTRADOR DEL SISTEMA )
						
						*/
						
						DECLARE
						
						BEGIN
						
						    if(v_operacion = 'INSERT') THEN
						
						          INSERT INTO 
						            PARAM.tgrupo_ep (
						id_grupo_ep,
						estado_reg,
						fecha_mod,
						fecha_reg,
						id_ep,
						id_grupo,
						id_usuario_mod,
						id_usuario_reg)
				VALUES (
						p_id_grupo_ep,
						p_estado_reg,
						p_fecha_mod,
						p_fecha_reg,
						p_id_ep,
						p_id_grupo,
						p_id_usuario_mod,
						p_id_usuario_reg);

						       
							    ELSEIF  v_operacion = 'UPDATE' THEN
						               UPDATE 
						                  PARAM.tgrupo_ep  
						                SET						 estado_reg=p_estado_reg
						 ,fecha_mod=p_fecha_mod
						 ,fecha_reg=p_fecha_reg
						 ,id_ep=p_id_ep
						 ,id_grupo=p_id_grupo
						 ,id_usuario_mod=p_id_usuario_mod
						 ,id_usuario_reg=p_id_usuario_reg
						 WHERE id_grupo_ep=p_id_grupo_ep;

						       
						       ELSEIF  v_operacion = 'DELETE' THEN
						       
						         DELETE FROM 
						              PARAM.tgrupo_ep
 
						              						 WHERE id_grupo_ep=p_id_grupo_ep;

						       
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