--------------- SQL ---------------

CREATE OR REPLACE FUNCTION migra.f__on_trig_tpm_programa_proyecto_actividad_tprograma_proyecto_a (
  v_operacion varchar,
  p_id_prog_pory_acti integer,
  p_estado_reg varchar,
  p_fecha_mod timestamp,
  p_fecha_reg timestamp,
  p_id_actividad integer,
  p_id_programa integer,
  p_id_proyecto integer,
  p_id_usuario_mod integer,
  p_id_usuario_reg integer
)
RETURNS text AS
$body$
/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  February 5, 2013, 4:30 pm
						Autor: autogenerado (ADMINISTRADOR DEL SISTEMA )
						
						*/
						
						DECLARE
						
						BEGIN
						
						    if(v_operacion = 'INSERT') THEN
						
						          INSERT INTO 
						            PARAM.tprograma_proyecto_acttividad (
						id_prog_pory_acti,
						estado_reg,
						fecha_mod,
						fecha_reg,
						id_actividad,
						id_programa,
						id_proyecto,
						id_usuario_mod,
						id_usuario_reg)
				VALUES (
						p_id_prog_pory_acti,
						p_estado_reg,
						p_fecha_mod,
						p_fecha_reg,
						p_id_actividad,
						p_id_programa,
						p_id_proyecto,
						p_id_usuario_mod,
						p_id_usuario_reg);

						       
							    ELSEIF  v_operacion = 'UPDATE' THEN
						                    --chequear si ya existe el auxiliar si no sacar un error
                                 IF  not EXISTS(select 1 
                                   from  PARAM.tprograma_proyecto_acttividad 
                                   where id_prog_pory_acti=p_id_prog_pory_acti) THEN
                                             
                                    raise exception 'No existe el registro que desea modificar';
                                                  
                                 END IF; 
                                       
                                       
                                       
                                       UPDATE 
						                  PARAM.tprograma_proyecto_acttividad  
						                SET						 estado_reg=p_estado_reg
						 ,fecha_mod=p_fecha_mod
						 ,fecha_reg=p_fecha_reg
						 ,id_actividad=p_id_actividad
						 ,id_programa=p_id_programa
						 ,id_proyecto=p_id_proyecto
						 ,id_usuario_mod=p_id_usuario_mod
						 ,id_usuario_reg=p_id_usuario_reg
						 WHERE id_prog_pory_acti=p_id_prog_pory_acti;

						       
						       ELSEIF  v_operacion = 'DELETE' THEN
						       
						         --chequear si ya existe el auxiliar si no sacar un error
                                 IF  not EXISTS(select 1 
                                   from  PARAM.tprograma_proyecto_acttividad 
                                   where id_prog_pory_acti=p_id_prog_pory_acti) THEN
                                             
                                    raise exception 'No existe el registro que desea eliminar';
                                                  
                                 END IF;
                                 
                                 
                                 DELETE FROM 
						              PARAM.tprograma_proyecto_acttividad
 
						              						 WHERE id_prog_pory_acti=p_id_prog_pory_acti;

						       
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