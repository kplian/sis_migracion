CREATE OR REPLACE FUNCTION migra.f__on_trig_tkp_item_presupuesto_tcargo_presupuesto (
  v_operacion varchar,
  p_id_cargo_presupuesto integer,
  p_id_cargo integer,
  p_id_centro_costo integer,
  p_id_gestion integer,
  p_estado_reg varchar,
  p_fecha_ini date,
  p_fecha_mod timestamp,
  p_fecha_reg timestamp,
  p_id_usuario_ai integer,
  p_id_usuario_mod integer,
  p_id_usuario_reg integer,
  p_porcentaje numeric,
  p_usuario_ai varchar
)
RETURNS text AS
$body$
/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  June 4, 2014, 2:33 pm
						Autor: autogenerado (JAIME RIVERA ROJAS)
						
						*/
						
						DECLARE
						
						BEGIN
						
						    if(v_operacion = 'INSERT') THEN
						
						          INSERT INTO 
						            ORGA.tcargo_presupuesto (
						id_cargo_presupuesto,
						id_cargo,
						id_centro_costo,
						id_gestion,
						estado_reg,
						fecha_ini,
						fecha_mod,
						fecha_reg,
						id_usuario_ai,
						id_usuario_mod,
						id_usuario_reg,
						porcentaje,
						usuario_ai)
				VALUES (
						p_id_cargo_presupuesto,
						p_id_cargo,
						p_id_centro_costo,
						p_id_gestion,
						p_estado_reg,
						p_fecha_ini,
						p_fecha_mod,
						p_fecha_reg,
						p_id_usuario_ai,
						p_id_usuario_mod,
						p_id_usuario_reg,
						p_porcentaje,
						p_usuario_ai);

						       
							    ELSEIF  v_operacion = 'UPDATE' THEN
						               
						               IF  not EXISTS(select 1 
                                           from ORGA.tcargo_presupuesto
 
                                           where id_cargo_presupuesto=p_id_cargo_presupuesto) THEN
                                       
                                            raise exception 'No existe el registro que  desea modificar';
                                            
                                       END IF;
						               
						               
						               UPDATE 
						                  ORGA.tcargo_presupuesto  
						                SET						 id_cargo=p_id_cargo
						 ,id_centro_costo=p_id_centro_costo
						 ,id_gestion=p_id_gestion
						 ,estado_reg=p_estado_reg
						 ,fecha_ini=p_fecha_ini
						 ,fecha_mod=p_fecha_mod
						 ,fecha_reg=p_fecha_reg
						 ,id_usuario_ai=p_id_usuario_ai
						 ,id_usuario_mod=p_id_usuario_mod
						 ,id_usuario_reg=p_id_usuario_reg
						 ,porcentaje=p_porcentaje
						 ,usuario_ai=p_usuario_ai
						 WHERE id_cargo_presupuesto=p_id_cargo_presupuesto;

						       
						       ELSEIF  v_operacion = 'DELETE' THEN
						       
						         
						         IF  not EXISTS(select 1 
                                           from ORGA.tcargo_presupuesto
 
                                           where id_cargo_presupuesto=p_id_cargo_presupuesto) THEN
                                       
                                            raise exception 'No existe el registro que  desea eliminar';
                                            
                                END IF;
						         
						         
						         DELETE FROM 
						              ORGA.tcargo_presupuesto
 
						              						 WHERE id_cargo_presupuesto=p_id_cargo_presupuesto;

						       
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