CREATE OR REPLACE FUNCTION migra.f__on_trig_tkp_oficina_toficina (
  v_operacion varchar,
  p_id_oficina integer,
  p_id_lugar integer,
  p_aeropuerto varchar,
  p_codigo varchar,
  p_estado_reg varchar,
  p_fecha_mod timestamp,
  p_fecha_reg timestamp,
  p_frontera varchar,
  p_id_usuario_ai integer,
  p_id_usuario_mod integer,
  p_id_usuario_reg integer,
  p_nombre varchar,
  p_usuario_ai varchar,
  p_zona_franca varchar
)
RETURNS text AS
$body$
/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  June 3, 2014, 4:17 pm
						Autor: autogenerado (JAIME RIVERA ROJAS)
						
						*/
						
						DECLARE
						
						BEGIN
						
						    if(v_operacion = 'INSERT') THEN
						
						          INSERT INTO 
						            ORGA.toficina (
						id_oficina,
						id_lugar,
						aeropuerto,
						codigo,
						estado_reg,
						fecha_mod,
						fecha_reg,
						frontera,
						id_usuario_ai,
						id_usuario_mod,
						id_usuario_reg,
						nombre,
						usuario_ai,
						zona_franca)
				VALUES (
						p_id_oficina,
						p_id_lugar,
						p_aeropuerto,
						p_codigo,
						p_estado_reg,
						p_fecha_mod,
						p_fecha_reg,
						p_frontera,
						p_id_usuario_ai,
						p_id_usuario_mod,
						p_id_usuario_reg,
						p_nombre,
						p_usuario_ai,
						p_zona_franca);

						       
							    ELSEIF  v_operacion = 'UPDATE' THEN
						               
						               IF  not EXISTS(select 1 
                                           from ORGA.toficina
 
                                           where id_oficina=p_id_oficina) THEN
                                       
                                            raise exception 'No existe el registro que  desea modificar';
                                            
                                       END IF;
						               
						               
						               UPDATE 
						                  ORGA.toficina  
						                SET						 id_lugar=p_id_lugar
						 ,aeropuerto=p_aeropuerto
						 ,codigo=p_codigo
						 ,estado_reg=p_estado_reg
						 ,fecha_mod=p_fecha_mod
						 ,fecha_reg=p_fecha_reg
						 ,frontera=p_frontera
						 ,id_usuario_ai=p_id_usuario_ai
						 ,id_usuario_mod=p_id_usuario_mod
						 ,id_usuario_reg=p_id_usuario_reg
						 ,nombre=p_nombre
						 ,usuario_ai=p_usuario_ai
						 ,zona_franca=p_zona_franca
						 WHERE id_oficina=p_id_oficina;

						       
						       ELSEIF  v_operacion = 'DELETE' THEN
						       
						         
						         IF  not EXISTS(select 1 
                                           from ORGA.toficina
 
                                           where id_oficina=p_id_oficina) THEN
                                       
                                            raise exception 'No existe el registro que  desea eliminar';
                                            
                                END IF;
						         
						         
						         DELETE FROM 
						              ORGA.toficina
 
						              						 WHERE id_oficina=p_id_oficina;

						       
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