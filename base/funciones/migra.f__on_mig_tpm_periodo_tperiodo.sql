--------------- SQL ---------------

CREATE OR REPLACE FUNCTION migra.f__on_trig_tpm_periodo_tperiodo (
  v_operacion varchar,
  p_id_periodo integer,
  p_id_gestion integer,
  p_estado_reg varchar,
  p_fecha_fin date,
  p_fecha_ini date,
  p_fecha_mod timestamp,
  p_fecha_reg timestamp,
  p_id_usuario_mod integer,
  p_id_usuario_reg integer,
  p_periodo integer
)
RETURNS text AS
$body$
/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  March 20, 2013, 3:28 pm
						Autor: autogenerado (ADMINISTRADOR DEL SISTEMA )
						
						*/
						
						DECLARE
						
						BEGIN
						
						    if(v_operacion = 'INSERT') THEN
						
						          INSERT INTO 
						            PARAM.tperiodo (
						id_periodo,
						id_gestion,
						estado_reg,
						fecha_fin,
						fecha_ini,
						fecha_mod,
						fecha_reg,
						id_usuario_mod,
						id_usuario_reg,
						periodo)
				VALUES (
						p_id_periodo,
						p_id_gestion,
						p_estado_reg,
						p_fecha_fin,
						p_fecha_ini,
						p_fecha_mod,
						p_fecha_reg,
						p_id_usuario_mod,
						p_id_usuario_reg,
						p_periodo);

						       
							    ELSEIF  v_operacion = 'UPDATE' THEN
						               
                                       
                                       --chequear si ya existe el auxiliar si no sacar un error
                                 IF  not EXISTS(select 1 
                                   from  PARAM.tperiodo 
                                   where id_periodo=p_id_periodo) THEN
                                             
                                    raise exception 'No existe el registro que desea modificar';
                                                  
                                 END IF; 
                                       
                                       
                                       UPDATE 
						                  PARAM.tperiodo  
						                SET						 id_gestion=p_id_gestion
						 ,estado_reg=p_estado_reg
						 ,fecha_fin=p_fecha_fin
						 ,fecha_ini=p_fecha_ini
						 ,fecha_mod=p_fecha_mod
						 ,fecha_reg=p_fecha_reg
						 ,id_usuario_mod=p_id_usuario_mod
						 ,id_usuario_reg=p_id_usuario_reg
						 ,periodo=p_periodo
						 WHERE id_periodo=p_id_periodo;

						       
						       ELSEIF  v_operacion = 'DELETE' THEN
						       
						               --chequear si ya existe el auxiliar si no sacar un error
                                 IF  not EXISTS(select 1 
                                   from  PARAM.tperiodo 
                                   where id_periodo=p_id_periodo) THEN
                                             
                                    raise exception 'No existe el registro que desea eliminar';
                                                  
                                 END IF;
                                 
                                 
                                 DELETE FROM 
						              PARAM.tperiodo
 
						              						 WHERE id_periodo=p_id_periodo;

						       
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