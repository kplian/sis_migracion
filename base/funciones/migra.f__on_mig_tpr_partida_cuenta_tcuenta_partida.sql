--------------- SQL ---------------

CREATE OR REPLACE FUNCTION migra.f__on_trig_tpr_partida_cuenta_tcuenta_partida (
  v_operacion varchar,
  p_id_cuenta integer,
  p_id_partida integer,
  p_id_cuenta_partida integer,
  p_estado_reg varchar,
  p_fecha_mod timestamp,
  p_fecha_reg timestamp,
  p_id_usuario_mod integer,
  p_id_usuario_reg integer,
  p_se_rega varchar,
  p_sw_deha varchar
)
RETURNS text AS
$body$
/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  November 6, 2013, 7:47 am
						Autor: autogenerado (ADMINISTRADOR DEL SISTEMA )
						
						*/
						
						DECLARE
						
						BEGIN
						
						    if(v_operacion = 'INSERT') THEN
						
						          INSERT INTO 
						            CONTA.tcuenta_partida (
						id_cuenta,
						id_partida,
						id_cuenta_partida,
						estado_reg,
						fecha_mod,
						fecha_reg,
						id_usuario_mod,
						id_usuario_reg,
						se_rega,
						sw_deha)
				VALUES (
						p_id_cuenta,
						p_id_partida,
						p_id_cuenta_partida,
						p_estado_reg,
						p_fecha_mod,
						p_fecha_reg,
						p_id_usuario_mod,
						p_id_usuario_reg,
						p_se_rega,
						p_sw_deha);

						       
							    ELSEIF  v_operacion = 'UPDATE' THEN
						              
                                --chequear si ya existe el auxiliar si no sacar un error
                               IF  not EXISTS(select 1 
                                 from  CONTA.tcuenta_partida
                                 where id_cuenta_partida=p_id_cuenta_partida) THEN
                                                       
                                  raise exception 'No existe el registro que desea modificar';
                                                            
                               END IF;
                                
                                
                                
                                 UPDATE 
						                  CONTA.tcuenta_partida  
						                SET						 id_cuenta=p_id_cuenta
						 ,id_partida=p_id_partida
						 ,estado_reg=p_estado_reg
						 ,fecha_mod=p_fecha_mod
						 ,fecha_reg=p_fecha_reg
						 ,id_usuario_mod=p_id_usuario_mod
						 ,id_usuario_reg=p_id_usuario_reg
						 ,se_rega=p_se_rega
						 ,sw_deha=p_sw_deha
						 WHERE id_cuenta_partida=p_id_cuenta_partida;

						       
						       ELSEIF  v_operacion = 'DELETE' THEN
						       
						           --chequear si ya existe el auxiliar si no sacar un error
                               IF  not EXISTS(select 1 
                                 from  CONTA.tcuenta_partida
                                 where id_cuenta_partida=p_id_cuenta_partida) THEN
                                                       
                                  raise exception 'No existe el registro que desea eliminar';
                                                            
                               END IF;
                                 
                                 
                                 DELETE FROM 
						              CONTA.tcuenta_partida
 
						              						 WHERE id_cuenta_partida=p_id_cuenta_partida;

						       
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