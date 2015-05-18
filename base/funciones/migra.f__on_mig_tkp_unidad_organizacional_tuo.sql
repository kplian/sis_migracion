CREATE OR REPLACE FUNCTION migra.f__on_trig_tkp_unidad_organizacional_tuo (
  v_operacion varchar,
  p_id_uo integer,
  p_cargo_individual varchar,
  p_codigo varchar,
  p_correspondencia varchar,
  p_descripcion varchar,
  p_estado_reg varchar,
  p_fecha_mod timestamp,
  p_fecha_reg timestamp,
  p_gerencia varchar,
  p_id_usuario_mod integer,
  p_id_usuario_reg integer,
  p_nodo_base varchar,
  p_nombre_cargo varchar,
  p_nombre_unidad varchar,
  p_presupuesta varchar,
  p_id_nivel integer,
  p_prioridad varchar
)
RETURNS text AS
$body$
/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  February 25, 2013, 6:38 pm
						Autor: autogenerado (ADMINISTRADOR DEL SISTEMA )
						
						*/
						
						DECLARE
						
						BEGIN
						
						    if(v_operacion = 'INSERT') THEN
						
						          INSERT INTO 
						            ORGA.tuo (
						id_uo,
						cargo_individual,
						codigo,
						correspondencia,
						descripcion,
						estado_reg,
						fecha_mod,
						fecha_reg,
						gerencia,
						id_usuario_mod,
						id_usuario_reg,
						nodo_base,
						nombre_cargo,
						nombre_unidad,
						presupuesta,
                        id_nivel_organizacional,
                        prioridad)
				VALUES (
						p_id_uo,
						p_cargo_individual,
						p_codigo,
						p_correspondencia,
						p_descripcion,
						p_estado_reg,
						p_fecha_mod,
						p_fecha_reg,
						p_gerencia,
						p_id_usuario_mod,
						p_id_usuario_reg,
						p_nodo_base,
						p_nombre_cargo,
						p_nombre_unidad,
						p_presupuesta,
                        p_id_nivel,
                        p_prioridad);

						       
							    ELSEIF  v_operacion = 'UPDATE' THEN
						               
                                 IF  not EXISTS(select 1 
                                     from  ORGA.tuo  
                                     where id_uo=p_id_uo) THEN
                                               
                                      raise exception 'No existe el registro que desea modificar';
                                                    
                                  END IF;
                                       
                                       
                                       
                                       UPDATE 
						                  ORGA.tuo  
						                SET						 cargo_individual=p_cargo_individual
						 ,codigo=p_codigo
						 ,correspondencia=p_correspondencia
						 ,descripcion=p_descripcion
						 ,estado_reg=p_estado_reg
						 ,fecha_mod=p_fecha_mod
						 ,fecha_reg=p_fecha_reg
						 ,gerencia=p_gerencia
						 ,id_usuario_mod=p_id_usuario_mod
						 ,id_usuario_reg=p_id_usuario_reg
						 ,nodo_base=p_nodo_base
						 ,nombre_cargo=p_nombre_cargo
						 ,nombre_unidad=p_nombre_unidad
						 ,presupuesta=p_presupuesta
                         ,id_nivel_organizacional = p_id_nivel
                         ,prioridad = p_prioridad
						 WHERE id_uo=p_id_uo;

						       
						       ELSEIF  v_operacion = 'DELETE' THEN
						       
						         
                                 IF  not EXISTS(select 1 
                                     from  ORGA.tuo  
                                     where id_uo=p_id_uo) THEN
                                               
                                      raise exception 'No existe el registro que desea eliminar';
                                                    
                                  END IF;
                                 
                                 
                                 
                                 DELETE FROM 
						              ORGA.tuo
 
						              						 WHERE id_uo=p_id_uo;

						       
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