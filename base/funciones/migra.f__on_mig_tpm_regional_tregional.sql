--------------- SQL ---------------

CREATE OR REPLACE FUNCTION migra.f__on_trig_tpm_regional_tregional (
  v_operacion varchar,
  p_codigo_regional varchar,
  p_id_regional integer,
  p_descripcion_regional text,
  p_estado_reg varchar,
  p_fecha_mod timestamp,
  p_fecha_reg timestamp,
  p_id_regional_actif integer,
  p_id_usuario_mod integer,
  p_id_usuario_reg integer,
  p_nombre_regional varchar
)
RETURNS text AS
$body$
/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  February 5, 2013, 12:00 pm
						Autor: autogenerado (ADMINISTRADOR DEL SISTEMA )
						
						*/
						
						DECLARE
						
						BEGIN
						
						    if(v_operacion = 'INSERT') THEN
						
						          INSERT INTO 
						            PARAM.tregional (
						codigo_regional,
						id_regional,
						descripcion_regional,
						estado_reg,
						fecha_mod,
						fecha_reg,
						id_regional_actif,
						id_usuario_mod,
						id_usuario_reg,
						nombre_regional)
				VALUES (
						p_codigo_regional,
						p_id_regional,
						p_descripcion_regional,
						p_estado_reg,
						p_fecha_mod,
						p_fecha_reg,
						p_id_regional_actif,
						p_id_usuario_mod,
						p_id_usuario_reg,
						p_nombre_regional);

						       
							    ELSEIF  v_operacion = 'UPDATE' THEN
						               
                                         --chequear si ya existe el auxiliar si no sacar un error
                                 IF  not EXISTS(select 1 
                                   from  PARAM.tregional 
                                   where id_regional=p_id_regional) THEN
                                             
                                    raise exception 'No existe el registro que desea modificar';
                                                  
                                 END IF; 
                                       
                                       
                                       UPDATE 
						                  PARAM.tregional  
						                SET						 codigo_regional=p_codigo_regional
						 ,descripcion_regional=p_descripcion_regional
						 ,estado_reg=p_estado_reg
						 ,fecha_mod=p_fecha_mod
						 ,fecha_reg=p_fecha_reg
						 ,id_regional_actif=p_id_regional_actif
						 ,id_usuario_mod=p_id_usuario_mod
						 ,id_usuario_reg=p_id_usuario_reg
						 ,nombre_regional=p_nombre_regional
						 WHERE id_regional=p_id_regional;

						       
						       ELSEIF  v_operacion = 'DELETE' THEN
						       
						                --chequear si ya existe el auxiliar si no sacar un error
                                 IF  not EXISTS(select 1 
                                   from  PARAM.tregional 
                                   where id_regional=p_id_regional) THEN
                                             
                                    raise exception 'No existe el registro que desea eliminar';
                                                  
                                 END IF; 
                                 
                                 DELETE FROM 
						              PARAM.tregional
 
						              						 WHERE id_regional=p_id_regional;

						       
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