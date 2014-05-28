--------------- SQL ---------------

CREATE OR REPLACE FUNCTION migra.f__on_trig_tpm_financiador_tfinanciador (
  v_operacion varchar,
  p_codigo_financiador varchar,
  p_id_financiador integer,
  p_descripcion_financiador text,
  p_estado_reg varchar,
  p_fecha_mod timestamp,
  p_fecha_reg timestamp,
  p_id_financiador_actif integer,
  p_id_usuario_mod integer,
  p_id_usuario_reg integer,
  p_nombre_financiador varchar
)
RETURNS text AS
$body$
/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  January 30, 2013, 1:26 pm
						Autor: autogenerado (ADMINISTRADOR DEL SISTEMA )
						
						*/
						
						DECLARE
						
						BEGIN
						
						    if(v_operacion = 'INSERT') THEN
						
						          INSERT INTO 
						            PARAM.tfinanciador (
						codigo_financiador,
						id_financiador,
						descripcion_financiador,
						estado_reg,
						fecha_mod,
						fecha_reg,
						id_financiador_actif,
						id_usuario_mod,
						id_usuario_reg,
						nombre_financiador)
				VALUES (
						p_codigo_financiador,
						p_id_financiador,
						p_descripcion_financiador,
						p_estado_reg,
						p_fecha_mod,
						p_fecha_reg,
						p_id_financiador_actif,
						p_id_usuario_mod,
						p_id_usuario_reg,
						p_nombre_financiador);

						       
							    ELSEIF  v_operacion = 'UPDATE' THEN
						              
                                     --chequear si ya existe el auxiliar si no sacar un error
                                 IF  not EXISTS(select 1 
                                   from  PARAM.tfinanciador 
                                   where id_financiador=p_id_financiador) THEN
                                             
                                    raise exception 'No existe el registro que desea modificar';
                                                  
                                 END IF;
                                
                                
                                 UPDATE 
						                  PARAM.tfinanciador  
						                SET						 codigo_financiador=p_codigo_financiador
						 ,descripcion_financiador=p_descripcion_financiador
						 ,estado_reg=p_estado_reg
						 ,fecha_mod=p_fecha_mod
						 ,fecha_reg=p_fecha_reg
						 ,id_financiador_actif=p_id_financiador_actif
						 ,id_usuario_mod=p_id_usuario_mod
						 ,id_usuario_reg=p_id_usuario_reg
						 ,nombre_financiador=p_nombre_financiador
						 WHERE id_financiador=p_id_financiador;

						       
						       ELSEIF  v_operacion = 'DELETE' THEN
						       
						          --chequear si ya existe el auxiliar si no sacar un error
                                 IF  not EXISTS(select 1 
                                   from  PARAM.tfinanciador 
                                   where id_financiador=p_id_financiador) THEN
                                             
                                    raise exception 'No existe el registro que desea eliminar';
                                                  
                                 END IF;
                                 
                                 
                                 DELETE FROM 
						              PARAM.tfinanciador
 
						              						 WHERE id_financiador=p_id_financiador;

						       
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