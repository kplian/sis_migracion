CREATE OR REPLACE FUNCTION migra.f__on_trig_tkp_cargo_ttemporal_cargo (
  v_operacion varchar,
  p_id_temporal_cargo integer,
  p_id_temporal_jerarquia_aprobacion integer,
  p_estado varchar,
  p_estado_reg varchar,
  p_fecha_mod timestamp,
  p_fecha_reg timestamp,
  p_id_usuario_ai integer,
  p_id_usuario_mod integer,
  p_id_usuario_reg integer,
  p_nombre varchar,
  p_usuario_ai varchar,
  p_fecha_ini date,
  p_fecha_fin date,
  p_id_cargo_padre integer
  
)
RETURNS text AS
$body$
/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  June 3, 2014, 3:11 pm
						Autor: autogenerado (JAIME RIVERA ROJAS)
						
						*/
						
						DECLARE
						
						BEGIN
						
						    if(v_operacion = 'INSERT') THEN
						
						          INSERT INTO 
						            ORGA.ttemporal_cargo (
						id_temporal_cargo,
						id_temporal_jerarquia_aprobacion,
						estado,
						estado_reg,
						fecha_mod,
						fecha_reg,
						id_usuario_ai,
						id_usuario_mod,
						id_usuario_reg,
						nombre,
						usuario_ai,
						fecha_ini,
						id_cargo_padre)
				VALUES (
						p_id_temporal_cargo,
						p_id_temporal_jerarquia_aprobacion,
						p_estado,
						p_estado_reg,
						p_fecha_mod,
						p_fecha_reg,
						p_id_usuario_ai,
						p_id_usuario_mod,
						p_id_usuario_reg,
						p_nombre,
						p_usuario_ai,
						p_fecha_ini,
						p_id_cargo_padre);

						       
							    ELSEIF  v_operacion = 'UPDATE' THEN
						               
						               IF  not EXISTS(select 1 
                                           from ORGA.ttemporal_cargo
 
                                           where id_temporal_cargo=p_id_temporal_cargo) THEN
                                       
                                            raise exception 'No existe el registro que  desea modificar';
                                            
                                       END IF;
						               
						               
						               UPDATE 
						                  ORGA.ttemporal_cargo  
						                SET						 id_temporal_jerarquia_aprobacion=p_id_temporal_jerarquia_aprobacion
						 ,estado=p_estado
						 ,estado_reg=p_estado_reg
						 ,fecha_mod=p_fecha_mod
						 ,fecha_reg=p_fecha_reg
						 ,id_usuario_ai=p_id_usuario_ai
						 ,id_usuario_mod=p_id_usuario_mod
						 ,id_usuario_reg=p_id_usuario_reg
						 ,nombre=p_nombre
						 ,usuario_ai=p_usuario_ai
						 ,fecha_ini = p_fecha_ini
						 ,fecha_fin = p_fecha_fin
						 ,id_cargo_padre = p_id_cargo_padre
						 
						 WHERE id_temporal_cargo=p_id_temporal_cargo;

						       
						       ELSEIF  v_operacion = 'DELETE' THEN
						       
						         
						         IF  not EXISTS(select 1 
                                           from ORGA.ttemporal_cargo
 
                                           where id_temporal_cargo=p_id_temporal_cargo) THEN
                                       
                                            raise exception 'No existe el registro que  desea eliminar';
                                            
                                END IF;
						         
						         
						         DELETE FROM 
						              ORGA.ttemporal_cargo
 
						              						 WHERE id_temporal_cargo=p_id_temporal_cargo;

						       
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