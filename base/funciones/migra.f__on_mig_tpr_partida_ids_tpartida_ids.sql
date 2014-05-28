--------------- SQL ---------------

CREATE OR REPLACE FUNCTION migra.f__on_trig_tpr_partida_ids_tpartida_ids (
  v_operacion varchar,
  p_id_partida_uno integer,
  p_id_partida_dos integer,
  p_sw_cambio_gestion varchar
)
RETURNS text AS
$body$
/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  December 13, 2013, 2:44 am
						Autor: autogenerado (ADMINISTRADOR DEL SISTEMA )
						
						*/
						
						DECLARE
						
						BEGIN
						
						    if(v_operacion = 'INSERT') THEN
						
						          INSERT INTO 
						            PRE.tpartida_ids (
						id_partida_uno,
						id_partida_dos,
						sw_cambio_gestion)
				VALUES (
						p_id_partida_uno,
						p_id_partida_dos,
						p_sw_cambio_gestion);

						       
							    ELSEIF  v_operacion = 'UPDATE' THEN
						               
                                       
                                         --chequear si ya existe el auxiliar si no sacar un error
                               IF  not EXISTS(select 1 
                                 from  PRE.tpartida_ids
                                 where id_partida_uno=p_id_partida_uno) THEN
                                                       
                                  raise exception 'No existe el registro que desea modificar';
                                                            
                               END IF;
                                       
                                       
                                       
                                       UPDATE 
						                  PRE.tpartida_ids  
						                SET						 id_partida_dos=p_id_partida_dos
						 ,sw_cambio_gestion=p_sw_cambio_gestion
						 WHERE id_partida_uno=p_id_partida_uno;

						       
						       ELSEIF  v_operacion = 'DELETE' THEN
						       
						                  --chequear si ya existe el auxiliar si no sacar un error
                               IF  not EXISTS(select 1 
                                 from  PRE.tpartida_ids
                                 where id_partida_uno=p_id_partida_uno) THEN
                                                       
                                  raise exception 'No existe el registro que desea eliminar';
                                                            
                               END IF ;
                                 
                                 
                                 
                                 DELETE FROM 
						              PRE.tpartida_ids
 
						              						 WHERE id_partida_uno=p_id_partida_uno;

						       
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