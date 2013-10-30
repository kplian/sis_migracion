CREATE OR REPLACE FUNCTION migra.f__on_trig_tct_cuenta_ids_tcuenta_ids (
						  v_operacion varchar,p_id_cuenta_uno int4,p_id_cuenta_dos int4,p_sw_cambio_gestion varchar)
						RETURNS text AS
						$BODY$

/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  October 29, 2013, 6:49 pm
						Autor: autogenerado (ADMINISTRADOR DEL SISTEMA )
						
						*/
						
						DECLARE
						
						BEGIN
						
						    if(v_operacion = 'INSERT') THEN
						
						          INSERT INTO 
						            CONTA.tcuenta_ids (
						id_cuenta_uno,
						id_cuenta_dos,
						sw_cambio_gestion)
				VALUES (
						p_id_cuenta_uno,
						p_id_cuenta_dos,
						p_sw_cambio_gestion);

						       
							    ELSEIF  v_operacion = 'UPDATE' THEN
						               UPDATE 
						                  CONTA.tcuenta_ids  
						                SET						 id_cuenta_dos=p_id_cuenta_dos
						 ,sw_cambio_gestion=p_sw_cambio_gestion
						 WHERE id_cuenta_uno=p_id_cuenta_uno;

						       
						       ELSEIF  v_operacion = 'DELETE' THEN
						       
						         DELETE FROM 
						              CONTA.tcuenta_ids
 
						              						 WHERE id_cuenta_uno=p_id_cuenta_uno;

						       
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