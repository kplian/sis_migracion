--------------- SQL ---------------

CREATE OR REPLACE FUNCTION migra.f__on_trig_tpm_actividad_tactividad (
  v_operacion varchar,
  p_id_actividad integer,
  p_codigo_actividad varchar,
  p_descripcion_actividad varchar,
  p_estado_reg varchar,
  p_fecha_mod timestamp,
  p_fecha_reg timestamp,
  p_id_usuario_mod integer,
  p_id_usuario_reg integer,
  p_nombre_actividad varchar
)
RETURNS text AS
$body$
/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  February 5, 2013, 4:14 pm
						Autor: autogenerado (ADMINISTRADOR DEL SISTEMA )
						
						*/
						
						DECLARE
						
						BEGIN
						
						    if(v_operacion = 'INSERT') THEN
						
						          INSERT INTO 
						            PARAM.tactividad (
						id_actividad,
						codigo_actividad,
						descripcion_actividad,
						estado_reg,
						fecha_mod,
						fecha_reg,
						id_usuario_mod,
						id_usuario_reg,
						nombre_actividad)
				VALUES (
						p_id_actividad,
						p_codigo_actividad,
						p_descripcion_actividad,
						p_estado_reg,
						p_fecha_mod,
						p_fecha_reg,
						p_id_usuario_mod,
						p_id_usuario_reg,
						p_nombre_actividad);

						       
							    ELSEIF  v_operacion = 'UPDATE' THEN
						               
                                       
                                 --chequear si ya existe el auxiliar si no sacar un error
                                 IF  not EXISTS(select 1 
                                   from  PARAM.tactividad 
                                   where id_actividad=p_id_actividad) THEN
                                             
                                    raise exception 'No existe el registro que desea modificar';
                                                  
                                 END IF;
                                       
                                       
                                       
                                       UPDATE 
						                  PARAM.tactividad  
						                SET						 codigo_actividad=p_codigo_actividad
						 ,descripcion_actividad=p_descripcion_actividad
						 ,estado_reg=p_estado_reg
						 ,fecha_mod=p_fecha_mod
						 ,fecha_reg=p_fecha_reg
						 ,id_usuario_mod=p_id_usuario_mod
						 ,id_usuario_reg=p_id_usuario_reg
						 ,nombre_actividad=p_nombre_actividad
						 WHERE id_actividad=p_id_actividad;

						       
						       ELSEIF  v_operacion = 'DELETE' THEN
						       
						          IF  not EXISTS(select 1 
                                   from  PARAM.tactividad 
                                   where id_actividad=p_id_actividad) THEN
                                             
                                    raise exception 'No existe el registro que desea eliminar';
                                                  
                                END IF;
                                 
                                 
                                 DELETE FROM 
						              PARAM.tactividad
 
						              						 WHERE id_actividad=p_id_actividad;

						       
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