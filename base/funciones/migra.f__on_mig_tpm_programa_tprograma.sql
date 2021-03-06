--------------- SQL ---------------

CREATE OR REPLACE FUNCTION migra.f__on_trig_tpm_programa_tprograma (
  v_operacion varchar,
  p_codigo_programa varchar,
  p_id_programa integer,
  p_descripcion_programa text,
  p_estado_reg varchar,
  p_fecha_mod timestamp,
  p_fecha_reg timestamp,
  p_id_programa_actif integer,
  p_id_usuario_mod integer,
  p_id_usuario_reg integer,
  p_nombre_programa varchar
)
RETURNS text AS
$body$
/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  February 5, 2013, 12:21 pm
						Autor: autogenerado (ADMINISTRADOR DEL SISTEMA )
						
						*/
						
						DECLARE
						
						BEGIN
						
						    if(v_operacion = 'INSERT') THEN
						
						          INSERT INTO 
						            PARAM.tprograma (
						codigo_programa,
						id_programa,
						descripcion_programa,
						estado_reg,
						fecha_mod,
						fecha_reg,
						id_programa_actif,
						id_usuario_mod,
						id_usuario_reg,
						nombre_programa)
				VALUES (
						p_codigo_programa,
						p_id_programa,
						p_descripcion_programa,
						p_estado_reg,
						p_fecha_mod,
						p_fecha_reg,
						p_id_programa_actif,
						p_id_usuario_mod,
						p_id_usuario_reg,
						p_nombre_programa);

						       
							    ELSEIF  v_operacion = 'UPDATE' THEN
						              
                              --chequear si ya existe el auxiliar si no sacar un error
                                 IF  not EXISTS(select 1 
                                   from  PARAM.tprograma 
                                   where id_programa=p_id_programa) THEN
                                             
                                    raise exception 'No existe el registro que desea modificar';
                                                  
                                 END IF; 
                                
                                
                                 UPDATE 
						                  PARAM.tprograma  
						                SET						 codigo_programa=p_codigo_programa
						 ,descripcion_programa=p_descripcion_programa
						 ,estado_reg=p_estado_reg
						 ,fecha_mod=p_fecha_mod
						 ,fecha_reg=p_fecha_reg
						 ,id_programa_actif=p_id_programa_actif
						 ,id_usuario_mod=p_id_usuario_mod
						 ,id_usuario_reg=p_id_usuario_reg
						 ,nombre_programa=p_nombre_programa
						 WHERE id_programa=p_id_programa;

						       
						       ELSEIF  v_operacion = 'DELETE' THEN
						       
						        --chequear si ya existe el auxiliar si no sacar un error
                                 IF  not EXISTS(select 1 
                                   from  PARAM.tprograma 
                                   where id_programa=p_id_programa) THEN
                                             
                                    raise exception 'No existe el registro que desea eliminar';
                                                  
                                 END IF;
                               
                               
                                DELETE FROM 
						              PARAM.tprograma
 
						              						 WHERE id_programa=p_id_programa;

						       
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