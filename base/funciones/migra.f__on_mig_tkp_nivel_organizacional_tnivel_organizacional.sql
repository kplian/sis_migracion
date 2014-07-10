CREATE OR REPLACE FUNCTION migra.f__on_trig_tkp_nivel_organizacional_tnivel_organizacional (
  v_operacion varchar,
  p_numero_nivel integer,
  p_id_nivel_organizacional integer,
  p_estado_reg varchar,
  p_fecha_mod timestamp,
  p_fecha_reg timestamp,
  p_id_usuario_ai integer,
  p_id_usuario_mod integer,
  p_id_usuario_reg integer,
  p_nombre_nivel varchar,
  p_usuario_ai varchar
)
RETURNS text AS
$body$
/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  June 4, 2014, 3:14 pm
						Autor: autogenerado (JAIME RIVERA ROJAS)
						
						*/
						
						DECLARE
						
						BEGIN
						
						    if(v_operacion = 'INSERT') THEN
						
						          INSERT INTO 
						            ORGA.tnivel_organizacional (
						numero_nivel,
						id_nivel_organizacional,
						estado_reg,
						fecha_mod,
						fecha_reg,
						id_usuario_ai,
						id_usuario_mod,
						id_usuario_reg,
						nombre_nivel,
						usuario_ai)
				VALUES (
						p_numero_nivel,
						p_id_nivel_organizacional,
						p_estado_reg,
						p_fecha_mod,
						p_fecha_reg,
						p_id_usuario_ai,
						p_id_usuario_mod,
						p_id_usuario_reg,
						p_nombre_nivel,
						p_usuario_ai);

						       
							    ELSEIF  v_operacion = 'UPDATE' THEN
						               
						               IF  not EXISTS(select 1 
                                           from ORGA.tnivel_organizacional
 
                                           where id_nivel_organizacional=p_id_nivel_organizacional) THEN
                                       
                                            raise exception 'No existe el registro que  desea modificar';
                                            
                                       END IF;
						               
						               
						               UPDATE 
						                  ORGA.tnivel_organizacional  
						                SET						 numero_nivel=p_numero_nivel
						 ,estado_reg=p_estado_reg
						 ,fecha_mod=p_fecha_mod
						 ,fecha_reg=p_fecha_reg
						 ,id_usuario_ai=p_id_usuario_ai
						 ,id_usuario_mod=p_id_usuario_mod
						 ,id_usuario_reg=p_id_usuario_reg
						 ,nombre_nivel=p_nombre_nivel
						 ,usuario_ai=p_usuario_ai
						 WHERE id_nivel_organizacional=p_id_nivel_organizacional;

						       
						       ELSEIF  v_operacion = 'DELETE' THEN
						       
						         
						         IF  not EXISTS(select 1 
                                           from ORGA.tnivel_organizacional
 
                                           where id_nivel_organizacional=p_id_nivel_organizacional) THEN
                                       
                                            raise exception 'No existe el registro que  desea eliminar';
                                            
                                END IF;
						         
						         
						         DELETE FROM 
						              ORGA.tnivel_organizacional
 
						              						 WHERE id_nivel_organizacional=p_id_nivel_organizacional;

						       
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