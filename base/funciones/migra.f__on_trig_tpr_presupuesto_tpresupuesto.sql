CREATE OR REPLACE FUNCTION migra.f__on_trig_tpr_presupuesto_tpresupuesto (
  v_operacion varchar,
  p_id_presupuesto integer,
  p_id_centro_costo integer,
  p_cod_act varchar,
  p_cod_fin varchar,
  p_cod_prg varchar,
  p_cod_pry varchar,
  p_estado_pres varchar,
  p_estado_reg varchar,
  p_fecha_mod timestamp,
  p_fecha_reg timestamp,
  p_id_categoria_prog integer,
  p_id_concepto_colectivo integer,
  p_id_fuente_financiamiento integer,
  p_id_parametro integer,
  p_id_usuario_mod integer,
  p_id_usuario_reg integer,
  p_tipo_pres varchar
)
RETURNS text AS
$body$
/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  February 15, 2013, 6:17 pm
						Autor: autogenerado (ADMINISTRADOR DEL SISTEMA )
						
						*/
						
						DECLARE
						
						BEGIN
						
						    if(v_operacion = 'INSERT') THEN
						
						          INSERT INTO 
						            PRE.tpresupuesto (
                        id_presupuesto,
						id_centro_costo,
						cod_act,
						cod_fin,
						cod_prg,
						cod_pry,
						estado_pres,
						estado_reg,
						fecha_mod,
						fecha_reg,
						id_categoria_prog,
						id_concepto_colectivo,
						id_fuente_financiamiento,
						id_parametro,
						id_usuario_mod,
						id_usuario_reg,
						tipo_pres)
				VALUES (
                		p_id_presupuesto,
						p_id_centro_costo,
						p_cod_act,
						p_cod_fin,
						p_cod_prg,
						p_cod_pry,
						p_estado_pres,
						p_estado_reg,
						p_fecha_mod,
						p_fecha_reg,
						p_id_categoria_prog,
						p_id_concepto_colectivo,
						p_id_fuente_financiamiento,
						p_id_parametro,
						p_id_usuario_mod,
						p_id_usuario_reg,
						p_tipo_pres);

						       
							    ELSEIF  v_operacion = 'UPDATE' THEN
						               UPDATE 
						                  PRE.tpresupuesto  
						                SET			id_centro_costo=p_id_centro_costo			 
                         ,cod_act=p_cod_act
						 ,cod_fin=p_cod_fin
						 ,cod_prg=p_cod_prg
						 ,cod_pry=p_cod_pry
						 ,estado_pres=p_estado_pres
						 ,estado_reg=p_estado_reg
						 ,fecha_mod=p_fecha_mod
						 ,fecha_reg=p_fecha_reg
						 ,id_categoria_prog=p_id_categoria_prog
						 ,id_concepto_colectivo=p_id_concepto_colectivo
						 ,id_fuente_financiamiento=p_id_fuente_financiamiento
						 ,id_parametro=p_id_parametro
						 ,id_usuario_mod=p_id_usuario_mod
						 ,id_usuario_reg=p_id_usuario_reg
						 ,tipo_pres=p_tipo_pres
						 WHERE id_presupuesto=p_id_presupuesto;

						       
						       ELSEIF  v_operacion = 'DELETE' THEN
						       
						         DELETE FROM 
						              PRE.tpresupuesto
 
						              						 WHERE id_presupuesto=p_id_presupuesto;

						       
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