CREATE OR REPLACE FUNCTION migra.f__on_trig_tpr_partida_presupuesto_tpresup_partida (
						  v_operacion varchar,p_id_presup_partida int4,p_id_partida int4,p_id_presupuesto int4,p_id_usuario_reg int4)
						RETURNS text AS
						$BODY$

/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  February 4, 2014, 11:29 am
						Autor: autogenerado (ADMINISTRADOR DEL SISTEMA )
						
						*/
						
						DECLARE
						
						BEGIN
						
						    if(v_operacion = 'INSERT') THEN
						
						          INSERT INTO 
						            PRE.tpresup_partida (
						id_presup_partida,
						id_partida,
						id_presupuesto,
						id_usuario_reg,
						id_centro_costo,
						estado_reg,
						fecha_reg)
				VALUES (
						p_id_presup_partida,
						p_id_partida,
						p_id_presupuesto,
						p_id_usuario_reg,
						p_id_presupuesto,
						'activo',
						now()::date);

						       
							    ELSEIF  v_operacion = 'UPDATE' THEN
						               UPDATE 
						                  PRE.tpresup_partida  
						                SET						 id_partida=p_id_partida
						 ,id_presupuesto=p_id_presupuesto
						 ,id_centro_costo=p_id_presupuesto
						 ,id_usuario_reg=p_id_usuario_reg
						 WHERE id_presup_partida=p_id_presup_partida;

						       
						       ELSEIF  v_operacion = 'DELETE' THEN
						       
						         DELETE FROM 
						              PRE.tpresup_partida
 
						              						 WHERE id_presup_partida=p_id_presup_partida;

						       
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