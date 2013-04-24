CREATE OR REPLACE FUNCTION migra.f__on_trig_tct_auxiliar_tauxiliar (
  v_operacion varchar,
  p_id_auxiliar integer,
  p_id_empresa integer,
  p_codigo_auxiliar varchar,
  p_estado_reg varchar,
  p_fecha_mod timestamp,
  p_fecha_reg timestamp,
  p_id_usuario_mod integer,
  p_id_usuario_reg integer,
  p_nombre_auxiliar varchar
)
RETURNS text AS
$body$
/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  February 22, 2013, 9:21 am
						Autor: autogenerado (ADMINISTRADOR DEL SISTEMA )
						
						*/
						
						DECLARE
						
						BEGIN
						
						    if(v_operacion = 'INSERT') THEN
						
						          INSERT INTO 
						            CONTA.tauxiliar (
						id_auxiliar,
						id_empresa,
						codigo_auxiliar,
						estado_reg,
						fecha_mod,
						fecha_reg,
						id_usuario_mod,
						id_usuario_reg,
						nombre_auxiliar)
				VALUES (
						p_id_auxiliar,
						p_id_empresa,
						p_codigo_auxiliar,
						p_estado_reg,
						p_fecha_mod,
						p_fecha_reg,
						p_id_usuario_mod,
						p_id_usuario_reg,
						p_nombre_auxiliar);

						       
							    ELSEIF  v_operacion = 'UPDATE' THEN
						               UPDATE 
						                  CONTA.tauxiliar  
						                SET						 id_empresa=p_id_empresa
						 ,codigo_auxiliar=p_codigo_auxiliar
						 ,estado_reg=p_estado_reg
						 ,fecha_mod=p_fecha_mod
						 ,fecha_reg=p_fecha_reg
						 ,id_usuario_mod=p_id_usuario_mod
						 ,id_usuario_reg=p_id_usuario_reg
						 ,nombre_auxiliar=p_nombre_auxiliar
						 WHERE id_auxiliar=p_id_auxiliar;

						       
						       ELSEIF  v_operacion = 'DELETE' THEN
						       
						         DELETE FROM 
						              CONTA.tauxiliar
 
						              						 WHERE id_auxiliar=p_id_auxiliar;

						       
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