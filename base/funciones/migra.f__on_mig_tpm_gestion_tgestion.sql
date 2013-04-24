CREATE OR REPLACE FUNCTION migra.f__on_trig_tpm_gestion_tgestion (
						  v_operacion varchar,p_id_gestion int4,p_id_moneda_base int4,p_estado varchar,p_estado_reg varchar,p_fecha_mod timestamp,p_fecha_reg timestamp,p_gestion int4,p_id_empresa int4,p_id_usuario_mod int4,p_id_usuario_reg int4)
						RETURNS text AS
						$BODY$

/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  February 5, 2013, 7:40 am
						Autor: autogenerado (ADMINISTRADOR DEL SISTEMA )
						
						*/
						
						DECLARE
						
						BEGIN
						
						    if(v_operacion = 'INSERT') THEN
						
						          INSERT INTO 
						            PARAM.tgestion (
						id_gestion,
						id_moneda_base,
						estado,
						estado_reg,
						fecha_mod,
						fecha_reg,
						gestion,
						id_empresa,
						id_usuario_mod,
						id_usuario_reg)
				VALUES (
						p_id_gestion,
						p_id_moneda_base,
						p_estado,
						p_estado_reg,
						p_fecha_mod,
						p_fecha_reg,
						p_gestion,
						p_id_empresa,
						p_id_usuario_mod,
						p_id_usuario_reg);

						       
							    ELSEIF  v_operacion = 'UPDATE' THEN
						               UPDATE 
						                  PARAM.tgestion  
						                SET						 id_moneda_base=p_id_moneda_base
						 ,estado=p_estado
						 ,estado_reg=p_estado_reg
						 ,fecha_mod=p_fecha_mod
						 ,fecha_reg=p_fecha_reg
						 ,gestion=p_gestion
						 ,id_empresa=p_id_empresa
						 ,id_usuario_mod=p_id_usuario_mod
						 ,id_usuario_reg=p_id_usuario_reg
						 WHERE id_gestion=p_id_gestion;

						       
						       ELSEIF  v_operacion = 'DELETE' THEN
						       
						         DELETE FROM 
						              PARAM.tgestion
 
						              						 WHERE id_gestion=p_id_gestion;

						       
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