CREATE OR REPLACE FUNCTION migra.f__on_trig_tad_proveedor_tproveedor (
  v_operacion varchar,
  p_id_proveedor integer,
  p_id_institucion integer,
  p_id_persona integer,
  p_codigo varchar,
  p_estado_reg varchar,
  p_fecha_mod timestamp,
  p_fecha_reg timestamp,
  p_id_lugar integer,
  p_id_usuario_mod integer,
  p_id_usuario_reg integer,
  p_nit varchar,
  p_numero_sigma varchar,
  p_tipo varchar,
  p_rotulo_comercial varchar
)
RETURNS text AS
$body$
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
						tipo,
                        rotulo_comercial)
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
						p_tipo,
                        p_rotulo_comercial);

						       
							    ELSEIF  v_operacion = 'UPDATE' THEN
                                --raise exception 'llega%',p_rotulo_comercial;
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
                         ,rotulo_comercial=p_rotulo_comercial
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
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;