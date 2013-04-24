CREATE OR REPLACE FUNCTION migra.f__on_trig_tad_proveedor_tproveedor (
						  v_operacion varchar,p_id_proveedor int4,p_id_institucion int4,p_id_persona int4,p_codigo varchar,p_estado_reg varchar,p_fecha_mod timestamp,p_fecha_reg timestamp,p_id_lugar int4,p_id_usuario_mod int4,p_id_usuario_reg int4,p_nit varchar,p_numero_sigma varchar,p_tipo varchar)
						RETURNS text AS
						$BODY$

/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  March 5, 2013, 10:25 am
						Autor: autogenerado (ADMINISTRADOR DEL SISTEMA )
						
						*/
						
						DECLARE
						
						BEGIN
						
						    if(v_operacion = 'INSERT') THEN
						
						          INSERT INTO 
						            PARAM.tproveedor (
						id_proveedor,
						id_institucion,
						id_persona,
						codigo,
						estado_reg,
						fecha_mod,
						fecha_reg,
						id_lugar,
						id_usuario_mod,
						id_usuario_reg,
						nit,
						numero_sigma,
						tipo)
				VALUES (
						p_id_proveedor,
						p_id_institucion,
						p_id_persona,
						p_codigo,
						p_estado_reg,
						p_fecha_mod,
						p_fecha_reg,
						p_id_lugar,
						p_id_usuario_mod,
						p_id_usuario_reg,
						p_nit,
						p_numero_sigma,
						p_tipo);

						       
							    ELSEIF  v_operacion = 'UPDATE' THEN
						               UPDATE 
						                  PARAM.tproveedor  
						                SET						 id_institucion=p_id_institucion
						 ,id_persona=p_id_persona
						 ,codigo=p_codigo
						 ,estado_reg=p_estado_reg
						 ,fecha_mod=p_fecha_mod
						 ,fecha_reg=p_fecha_reg
						 ,id_lugar=p_id_lugar
						 ,id_usuario_mod=p_id_usuario_mod
						 ,id_usuario_reg=p_id_usuario_reg
						 ,nit=p_nit
						 ,numero_sigma=p_numero_sigma
						 ,tipo=p_tipo
						 WHERE id_proveedor=p_id_proveedor;

						       
						       ELSEIF  v_operacion = 'DELETE' THEN
						       
						         DELETE FROM 
						              PARAM.tproveedor
 
						              						 WHERE id_proveedor=p_id_proveedor;

						       
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