--------------- SQL ---------------

CREATE OR REPLACE FUNCTION migra.f__on_trig_tct_orden_trabajo_torden_trabajo (
  v_operacion varchar,
  p_id_orden_trabajo integer,
  p_desc_orden varchar,
  p_estado_reg varchar,
  p_fecha_final date,
  p_fecha_inicio date,
  p_fecha_mod timestamp,
  p_fecha_reg timestamp,
  p_id_usuario_mod integer,
  p_id_usuario_reg integer,
  p_motivo_orden varchar
)
RETURNS text AS
$body$
/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  February 22, 2013, 9:55 am
						Autor: autogenerado (ADMINISTRADOR DEL SISTEMA )
						
						*/
						
						DECLARE
						
						BEGIN
						
						    if(v_operacion = 'INSERT') THEN
						
						          INSERT INTO 
						            CONTA.torden_trabajo (
						id_orden_trabajo,
						desc_orden,
						estado_reg,
						fecha_final,
						fecha_inicio,
						fecha_mod,
						fecha_reg,
						id_usuario_mod,
						id_usuario_reg,
						motivo_orden)
				VALUES (
						p_id_orden_trabajo,
						p_desc_orden,
						p_estado_reg,
						p_fecha_final,
						p_fecha_inicio,
						p_fecha_mod,
						p_fecha_reg,
						p_id_usuario_mod,
						p_id_usuario_reg,
						p_motivo_orden);

						       
							    ELSEIF  v_operacion = 'UPDATE' THEN
						               
                                       --chequear si ya existe el auxiliar si no sacar un error
                                       IF  not EXISTS(select 1 
                                           from conta.torden_trabajo 
                                           where id_orden_trabajo=p_id_orden_trabajo) THEN
                                       
                                            raise exception 'No existe el registro que desea modificar';
                                            
                                        END IF;
                                       
                                       
                                       
                                       UPDATE 
						                  CONTA.torden_trabajo  
						                SET						 desc_orden=p_desc_orden
						 ,estado_reg=p_estado_reg
						 ,fecha_final=p_fecha_final
						 ,fecha_inicio=p_fecha_inicio
						 ,fecha_mod=p_fecha_mod
						 ,fecha_reg=p_fecha_reg
						 ,id_usuario_mod=p_id_usuario_mod
						 ,id_usuario_reg=p_id_usuario_reg
						 ,motivo_orden=p_motivo_orden
						 WHERE id_orden_trabajo=p_id_orden_trabajo;

						       
						       ELSEIF  v_operacion = 'DELETE' THEN
						       
						         
                                 --chequear si ya existe el auxiliar si no sacar un error
                                 IF  not EXISTS(select 1 
                                     from conta.torden_trabajo 
                                     where id_orden_trabajo=p_id_orden_trabajo) THEN
                                           
                                      raise exception 'No existe el registro que desea eliminar';
                                                
                                  END IF;
                                 
                                 
                                 DELETE FROM 
						              CONTA.torden_trabajo
 
						              						 WHERE id_orden_trabajo=p_id_orden_trabajo;

						       
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