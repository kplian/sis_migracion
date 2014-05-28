--------------- SQL ---------------

CREATE OR REPLACE FUNCTION migra.f__on_trig_tpr_partida_presupuesto_tpresup_partida (
  v_operacion varchar,
  p_id_presup_partida integer,
  p_id_partida integer,
  p_id_presupuesto integer,
  p_id_usuario_reg integer
)
RETURNS text AS
$body$
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
						               
                                       
                                --chequear si ya existe el registro si no sacar un error
                               IF  not EXISTS(select 1 
                                 from  PRE.tpresup_partida
                                 where id_presup_partida=p_id_presup_partida) THEN
                                                       
                                  raise exception 'No existe el registro que desea modificar';
                                                            
                               END IF;
                                       
                                       
                                       UPDATE 
						                  PRE.tpresup_partida  
						                SET						 id_partida=p_id_partida
						 ,id_presupuesto=p_id_presupuesto
						 ,id_centro_costo=p_id_presupuesto
						 ,id_usuario_reg=p_id_usuario_reg
						 WHERE id_presup_partida=p_id_presup_partida;

						       
						 ELSEIF  v_operacion = 'DELETE' THEN
						       
						       --chequear si ya existe el registro
                               IF  not EXISTS(select 1 
                                 from  PRE.tpresup_partida
                                 where id_presup_partida=p_id_presup_partida) THEN
                                                       
                                  raise exception 'No existe el registro que desea eliminar';
                                                            
                               END IF;
                                 
                                 
                                 
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
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;