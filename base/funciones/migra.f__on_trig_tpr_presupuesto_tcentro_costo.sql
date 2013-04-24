CREATE OR REPLACE FUNCTION migra.f__on_trig_tpr_presupuesto_tcentro_costo (
  v_operacion varchar,
  p_id_centro_costo integer,
  p_estado_reg varchar,
  p_fecha_mod timestamp,
  p_fecha_reg timestamp,
  p_id_ep integer,
  p_id_gestion integer,
  p_id_uo integer,
  p_id_usuario_mod integer,
  p_id_usuario_reg integer
)
RETURNS text AS
$body$
/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  February 15, 2013, 6:17 pm
						Autor: autogenerado (ADMINISTRADOR DEL SISTEMA )
						
						*/
						
						DECLARE
						
						BEGIN
						
						    if(v_operacion = 'INSERT') THEN
						
						          INSERT INTO 
						            PARAM.tcentro_costo (
						id_centro_costo,
						estado_reg,
						fecha_mod,
						fecha_reg,
						id_ep,
						id_gestion,
						id_uo,
						id_usuario_mod,
						id_usuario_reg)
				VALUES (
						p_id_centro_costo,
						p_estado_reg,
						p_fecha_mod,
						p_fecha_reg,
						p_id_ep,
						p_id_gestion,
						p_id_uo,
						p_id_usuario_mod,
						p_id_usuario_reg);

						       
							    ELSEIF  v_operacion = 'UPDATE' THEN
						               UPDATE 
						                  PARAM.tcentro_costo  
						                SET						 estado_reg=p_estado_reg
						 ,fecha_mod=p_fecha_mod
						 ,fecha_reg=p_fecha_reg
						 ,id_ep=p_id_ep
						 ,id_gestion=p_id_gestion
						 ,id_uo=p_id_uo
						 ,id_usuario_mod=p_id_usuario_mod
						 ,id_usuario_reg=p_id_usuario_reg
						 WHERE id_centro_costo=p_id_centro_costo;

						       
						       ELSEIF  v_operacion = 'DELETE' THEN
						       
						         DELETE FROM 
						              PARAM.tcentro_costo
 
						              						 WHERE id_centro_costo=p_id_centro_costo;

						       
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