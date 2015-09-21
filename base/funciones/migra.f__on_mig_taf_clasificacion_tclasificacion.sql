CREATE OR REPLACE FUNCTION migra.f__on_trig_taf_clasificacion_tclasificacion (
  v_operacion varchar,
  p_codigo varchar,
  p_id_clasificacion integer,
  p_correlativo_act integer,
  p_descripcion varchar,
  p_estado varchar,
  p_estado_reg varchar,
  p_fecha_mod timestamp,
  p_fecha_reg timestamp,
  p_id_clasificacion_fk integer,
  p_id_metodo_depreciacion integer,
  p_id_usuario_mod integer,
  p_id_usuario_reg integer,
  p_ini_correlativo integer,
  p_nivel integer,
  p_sw_dep varchar,
  p_tipo varchar,
  p_vida_util integer
)
RETURNS text AS
$body$
/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  October 3, 2013, 11:09 pm
						Autor: autogenerado (ADMINISTRADOR DEL SISTEMA )
						
						*/
						
						DECLARE
						
						BEGIN
						
						    if(v_operacion = 'INSERT') THEN
						
						          INSERT INTO 
						            af.tclasificacion (
						codigo,
						id_clasificacion,
						--correlativo_act,
						descripcion,
						estado,
						estado_reg,
						fecha_mod,
						fecha_reg,
						id_clasificacion_fk,
						--id_metodo_depreciacion,
						id_usuario_mod,
						id_usuario_reg
						--ini_correlativo,
						--nivel,
						--sw_dep,
						--tipo,
						--vida_util
                        )
				VALUES (
						p_codigo,
						p_id_clasificacion,
						--p_correlativo_act,
						p_descripcion,
						p_estado,
						p_estado_reg,
						p_fecha_mod,
						p_fecha_reg,
						p_id_clasificacion_fk,
						--p_id_metodo_depreciacion,
						p_id_usuario_mod,
						p_id_usuario_reg
						--p_ini_correlativo,
						--p_nivel,
						--p_sw_dep,
						--p_tipo,
						--p_vida_util
                        );

						       
							    ELSEIF  v_operacion = 'UPDATE' THEN
						              
                                IF  not EXISTS(select 1 
                                           from af.tclasificacion 
                                           where id_clasificacion=p_id_clasificacion) THEN
                                       
                                            raise exception 'No existe el registro que   desea eliminsr';
                                            
                                END IF;
                                
                                
                                
                                 UPDATE 
						                  af.tclasificacion  
						                SET						 codigo=p_codigo						 
						 ,descripcion=p_descripcion
						 ,estado=p_estado
						 ,estado_reg=p_estado_reg
						 ,fecha_mod=p_fecha_mod
						 ,fecha_reg=p_fecha_reg
						 ,id_clasificacion_fk=p_id_clasificacion_fk
						 ,id_usuario_mod=p_id_usuario_mod
						 ,id_usuario_reg=p_id_usuario_reg		
						 
						 
						 WHERE id_clasificacion=p_id_clasificacion;

						       
						       ELSEIF  v_operacion = 'DELETE' THEN
						       
						         
                                IF  not EXISTS(select 1 
                                           from af.tclasificacion 
                                           where id_clasificacion=p_id_clasificacion) THEN
                                       
                                            raise exception 'No existe el registro que   desea modificar';
                                            
                                END IF;
                                 
                                 DELETE FROM 
						              af.tclasificacion
 
						              						 WHERE id_clasificacion=p_id_clasificacion;

						       
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