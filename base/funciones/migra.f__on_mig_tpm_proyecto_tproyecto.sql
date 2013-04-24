CREATE OR REPLACE FUNCTION migra.f__on_trig_tpm_proyecto_tproyecto (
						  v_operacion varchar,p_codigo_proyecto varchar,p_id_proyecto int4,p_codigo_sisin int8,p_descripcion_proyecto text,p_estado_reg varchar,p_fecha_mod timestamp,p_fecha_reg timestamp,p_hidro varchar,p_id_proyecto_actif int4,p_id_proyecto_cat_prog int4,p_id_usuario_mod int4,p_id_usuario_reg int4,p_nombre_corto varchar,p_nombre_proyecto varchar)
						RETURNS text AS
						$BODY$

/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  February 5, 2013, 12:29 pm
						Autor: autogenerado (ADMINISTRADOR DEL SISTEMA )
						
						*/
						
						DECLARE
						
						BEGIN
						
						    if(v_operacion = 'INSERT') THEN
						
						          INSERT INTO 
						            PARAM.tproyecto (
						codigo_proyecto,
						id_proyecto,
						codigo_sisin,
						descripcion_proyecto,
						estado_reg,
						fecha_mod,
						fecha_reg,
						hidro,
						id_proyecto_actif,
						id_proyecto_cat_prog,
						id_usuario_mod,
						id_usuario_reg,
						nombre_corto,
						nombre_proyecto)
				VALUES (
						p_codigo_proyecto,
						p_id_proyecto,
						p_codigo_sisin,
						p_descripcion_proyecto,
						p_estado_reg,
						p_fecha_mod,
						p_fecha_reg,
						p_hidro,
						p_id_proyecto_actif,
						p_id_proyecto_cat_prog,
						p_id_usuario_mod,
						p_id_usuario_reg,
						p_nombre_corto,
						p_nombre_proyecto);

						       
							    ELSEIF  v_operacion = 'UPDATE' THEN
						               UPDATE 
						                  PARAM.tproyecto  
						                SET						 codigo_proyecto=p_codigo_proyecto
						 ,codigo_sisin=p_codigo_sisin
						 ,descripcion_proyecto=p_descripcion_proyecto
						 ,estado_reg=p_estado_reg
						 ,fecha_mod=p_fecha_mod
						 ,fecha_reg=p_fecha_reg
						 ,hidro=p_hidro
						 ,id_proyecto_actif=p_id_proyecto_actif
						 ,id_proyecto_cat_prog=p_id_proyecto_cat_prog
						 ,id_usuario_mod=p_id_usuario_mod
						 ,id_usuario_reg=p_id_usuario_reg
						 ,nombre_corto=p_nombre_corto
						 ,nombre_proyecto=p_nombre_proyecto
						 WHERE id_proyecto=p_id_proyecto;

						       
						       ELSEIF  v_operacion = 'DELETE' THEN
						       
						         DELETE FROM 
						              PARAM.tproyecto
 
						              						 WHERE id_proyecto=p_id_proyecto;

						       
						       END IF;  
						  
						 return 'true';
						
						-- statements;
						--EXCEPTION
						--WHEN exception_name THEN
						--  statements;
						END;
						$BODY$


						LANGUAGE 'plpgsql'
						VOLATILE
						CALLED ON NULL INPUT
						SECURITY INVOKER
						COST 100;