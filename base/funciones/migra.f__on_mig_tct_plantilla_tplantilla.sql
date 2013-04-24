CREATE OR REPLACE FUNCTION migra.f__on_trig_tct_plantilla_tplantilla (
						  v_operacion varchar,p_id_plantilla int4,p_desc_plantilla varchar,p_estado_reg varchar,p_fecha_mod timestamp,p_fecha_reg timestamp,p_id_usuario_mod int4,p_id_usuario_reg int4,p_nro_linea numeric,p_sw_compro varchar,p_sw_tesoro varchar,p_tipo numeric)
						RETURNS text AS
						$BODY$

/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  April 1, 2013, 5:27 pm
						Autor: autogenerado (ADMINISTRADOR DEL SISTEMA )
						
						*/
						
						DECLARE
						
						BEGIN
						
						    if(v_operacion = 'INSERT') THEN
						
						          INSERT INTO 
						            PARAM.tplantilla (
						id_plantilla,
						desc_plantilla,
						estado_reg,
						fecha_mod,
						fecha_reg,
						id_usuario_mod,
						id_usuario_reg,
						nro_linea,
						sw_compro,
						sw_tesoro,
						tipo)
				VALUES (
						p_id_plantilla,
						p_desc_plantilla,
						p_estado_reg,
						p_fecha_mod,
						p_fecha_reg,
						p_id_usuario_mod,
						p_id_usuario_reg,
						p_nro_linea,
						p_sw_compro,
						p_sw_tesoro,
						p_tipo);

						       
							    ELSEIF  v_operacion = 'UPDATE' THEN
						               UPDATE 
						                  PARAM.tplantilla  
						                SET						 desc_plantilla=p_desc_plantilla
						 ,estado_reg=p_estado_reg
						 ,fecha_mod=p_fecha_mod
						 ,fecha_reg=p_fecha_reg
						 ,id_usuario_mod=p_id_usuario_mod
						 ,id_usuario_reg=p_id_usuario_reg
						 ,nro_linea=p_nro_linea
						 ,sw_compro=p_sw_compro
						 ,sw_tesoro=p_sw_tesoro
						 ,tipo=p_tipo
						 WHERE id_plantilla=p_id_plantilla;

						       
						       ELSEIF  v_operacion = 'DELETE' THEN
						       
						         DELETE FROM 
						              CONTA.tplantilla
 
						              						 WHERE id_plantilla=p_id_plantilla;

						       
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