CREATE OR REPLACE FUNCTION migra.f__on_trig_tpr_presupuesto_ids_tpresupuesto_ids (
  v_operacion varchar,
  p_id_presupuesto_uno integer,
  p_id_presupuesto_dos integer,
  p_sw_cambio_gestion varchar
)
RETURNS text AS
$body$
/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  December 13, 2013, 2:51 am
						Autor: autogenerado (ADMINISTRADOR DEL SISTEMA )
						
						*/
						
						DECLARE
						
						BEGIN
						
						    if(v_operacion = 'INSERT') THEN
						
						          INSERT INTO 
						            pre.tpresupuesto_ids (
						id_presupuesto_uno,
						id_presupuesto_dos,
						sw_cambio_gestion)
				VALUES (
						p_id_presupuesto_uno,
						p_id_presupuesto_dos,
						p_sw_cambio_gestion);

						       
							    ELSEIF  v_operacion = 'UPDATE' THEN
						               UPDATE 
						                  pre.tpresupuesto_ids  
						                SET						 id_presupuesto_dos=p_id_presupuesto_dos
						 ,sw_cambio_gestion=p_sw_cambio_gestion
						 WHERE id_presupuesto_uno=p_id_presupuesto_uno;

						       
						       ELSEIF  v_operacion = 'DELETE' THEN
						       
						         DELETE FROM 
						              pre.tpresupuesto_ids
 
						              						 WHERE id_presupuesto_uno=p_id_presupuesto_uno;

						       
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