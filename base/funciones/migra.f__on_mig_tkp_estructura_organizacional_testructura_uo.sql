CREATE OR REPLACE FUNCTION migra.f__on_trig_tkp_estructura_organizacional_testructura_uo (
  v_operacion varchar,
  p_id_estructura_uo integer,
  p_id_uo_hijo integer,
  p_id_uo_padre integer,
  p_estado_reg varchar,
  p_fecha_mod timestamp,
  p_fecha_reg timestamp,
  p_id_usuario_mod integer,
  p_id_usuario_reg integer
)
RETURNS text AS
$body$
/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  February 25, 2013, 8:36 pm
						Autor: autogenerado (ADMINISTRADOR DEL SISTEMA )
						
						*/
						
						DECLARE
						
						BEGIN
						
						    if(v_operacion = 'INSERT') THEN
						
						          INSERT INTO 
						            ORGA.testructura_uo (
						id_estructura_uo,
						id_uo_hijo,
						id_uo_padre,
						estado_reg,
						fecha_mod,
						fecha_reg,
						id_usuario_mod,
						id_usuario_reg)
				VALUES (
						p_id_estructura_uo,
						p_id_uo_hijo,
						p_id_uo_padre,
						p_estado_reg,
						p_fecha_mod,
						p_fecha_reg,
						p_id_usuario_mod,
						p_id_usuario_reg);

						       
							    ELSEIF  v_operacion = 'UPDATE' THEN
						               UPDATE 
						                  ORGA.testructura_uo  
						                SET						 id_uo_hijo=p_id_uo_hijo
						 ,id_uo_padre=p_id_uo_padre
						 ,estado_reg=p_estado_reg
						 ,fecha_mod=p_fecha_mod
						 ,fecha_reg=p_fecha_reg
						 ,id_usuario_mod=p_id_usuario_mod
						 ,id_usuario_reg=p_id_usuario_reg
						 WHERE id_estructura_uo=p_id_estructura_uo;

						       
						       ELSEIF  v_operacion = 'DELETE' THEN
						       
						         DELETE FROM 
						              ORGA.testructura_uo
 
						              						 WHERE id_estructura_uo=p_id_estructura_uo;

						       
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