CREATE OR REPLACE FUNCTION migra.f__on_trig_tkp_historico_asignacion_tuo_funcionario (
  v_operacion varchar,
  p_id_uo_funcionario integer,
  p_id_funcionario integer,
  p_id_uo integer,
  p_estado_reg varchar,
  p_fecha_asignacion date,
  p_fecha_finalizacion date,
  p_fecha_mod timestamp,
  p_fecha_reg timestamp,
  p_id_usuario_mod integer,
  p_id_usuario_reg integer
)
RETURNS text AS
$body$
/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  April 19, 2013, 6:55 pm
						Autor: autogenerado (ADMINISTRADOR DEL SISTEMA )
						
						*/
						
						DECLARE
						BEGIN
                        IF EXISTS(select 1
                        from orga.tuo_funcionario
                        where id_uo_funcionario=p_id_uo_funcionario
                        ) THEN v_operacion='UPDATE'; 
                        END IF;
						    if(v_operacion = 'INSERT') THEN
						
						          INSERT INTO 
						            ORGA.tuo_funcionario (
						id_uo_funcionario,
						id_funcionario,
						id_uo,
						estado_reg,
						fecha_asignacion,
						fecha_finalizacion,
						fecha_mod,
						fecha_reg,
						id_usuario_mod,
						id_usuario_reg)
				VALUES (
						p_id_uo_funcionario,
						p_id_funcionario,
						p_id_uo,
						p_estado_reg,
						p_fecha_asignacion,
						p_fecha_finalizacion,
						p_fecha_mod,
						p_fecha_reg,
						p_id_usuario_mod,
						p_id_usuario_reg);

						       
							    ELSEIF  v_operacion = 'UPDATE' THEN
						               UPDATE 
						                  ORGA.tuo_funcionario  
						                SET						 id_funcionario=p_id_funcionario
						 ,id_uo=p_id_uo
						 ,estado_reg=p_estado_reg
						 ,fecha_asignacion=p_fecha_asignacion
						 ,fecha_finalizacion=p_fecha_finalizacion
						 ,fecha_mod=p_fecha_mod
						 ,fecha_reg=p_fecha_reg
						 ,id_usuario_mod=p_id_usuario_mod
						 ,id_usuario_reg=p_id_usuario_reg
						 WHERE id_uo_funcionario=p_id_uo_funcionario;

						       
						       ELSEIF  v_operacion = 'DELETE' THEN
						       
						         DELETE FROM 
						              ORGA.tuo_funcionario
 
						              						 WHERE id_uo_funcionario=p_id_uo_funcionario;

						       
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