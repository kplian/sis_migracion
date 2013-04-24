CREATE OR REPLACE FUNCTION migra.f__on_trig_tct_cuenta_tcuenta (
  v_operacion varchar,
  p_id_cuenta integer,
  p_cuenta_flujo_sigma varchar,
  p_cuenta_sigma varchar,
  p_desc_cuenta varchar,
  p_descripcion varchar,
  p_estado_reg varchar,
  p_fecha_mod timestamp,
  p_fecha_reg timestamp,
  p_id_auxiliar_dif integer,
  p_id_auxliar_actualizacion integer,
  p_id_cuenta_actualizacion integer,
  p_id_cuenta_dif integer,
  p_id_cuenta_padre integer,
  p_id_cuenta_sigma integer,
  p_id_empresa integer,
  p_id_gestion integer,
  p_id_moneda integer,
  p_id_parametro integer,
  p_id_usuario_mod integer,
  p_id_usuario_reg integer,
  p_nivel_cuenta integer,
  p_nombre_cuenta varchar,
  p_nro_cuenta varchar,
  p_obs varchar,
  p_plantilla varchar,
  p_sw_auxiliar integer,
  p_sw_oec integer,
  p_sw_sigma varchar,
  p_sw_sistema_actualizacion varchar,
  p_sw_transaccional varchar,
  p_tipo_cuenta varchar,
  p_tipo_cuenta_pat varchar,
  p_tipo_plantilla varchar,
  p_vigente varchar
)
RETURNS text AS
$body$
/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  February 21, 2013, 7:18 pm
						Autor: autogenerado (ADMINISTRADOR DEL SISTEMA )
						
						*/
						
						DECLARE
						
						BEGIN
						    if(v_operacion = 'INSERT') THEN
						
						          INSERT INTO 
						            CONTA.tcuenta (
						id_cuenta,
						cuenta_flujo_sigma,
						cuenta_sigma,
						desc_cuenta,
						estado_reg,
						fecha_mod,
						fecha_reg,
						id_auxiliar_dif,
						id_auxliar_actualizacion,
						id_cuenta_actualizacion,
						id_cuenta_dif,
						id_cuenta_padre,
						id_cuenta_sigma,
						id_empresa,
						id_gestion,
						id_moneda,
						id_parametro,
						id_usuario_mod,
						id_usuario_reg,
						nivel_cuenta,
						nombre_cuenta,
						nro_cuenta,
						sw_auxiliar,
						sw_oec,
						sw_sigma,
						sw_sistema_actualizacion,
						sw_transaccional,
						tipo_cuenta,
						tipo_cuenta_pat)
				VALUES (
						p_id_cuenta,
						p_cuenta_flujo_sigma,
						p_cuenta_sigma,
						p_desc_cuenta,
						p_estado_reg,
						p_fecha_mod,
						p_fecha_reg,
						p_id_auxiliar_dif,
						p_id_auxliar_actualizacion,
						p_id_cuenta_actualizacion,
						p_id_cuenta_dif,
						p_id_cuenta_padre,
						p_id_cuenta_sigma,
						p_id_empresa,
						p_id_gestion,
						p_id_moneda,
						p_id_parametro,
						p_id_usuario_mod,
						p_id_usuario_reg,
						p_nivel_cuenta,
						p_nombre_cuenta,
						p_nro_cuenta,
						p_sw_auxiliar,
						p_sw_oec,
						p_sw_sigma,
						p_sw_sistema_actualizacion,
						p_sw_transaccional,
						p_tipo_cuenta,
						p_tipo_cuenta_pat);

						       
							    ELSEIF  v_operacion = 'UPDATE' THEN
						               UPDATE 
						                  CONTA.tcuenta  
						                SET						 cuenta_flujo_sigma=p_cuenta_flujo_sigma
						 ,cuenta_sigma=p_cuenta_sigma
						 ,desc_cuenta=p_desc_cuenta
						 ,estado_reg=p_estado_reg
						 ,fecha_mod=p_fecha_mod
						 ,fecha_reg=p_fecha_reg
						 ,id_auxiliar_dif=p_id_auxiliar_dif
						 ,id_auxliar_actualizacion=p_id_auxliar_actualizacion
						 ,id_cuenta_actualizacion=p_id_cuenta_actualizacion
						 ,id_cuenta_dif=p_id_cuenta_dif
						 ,id_cuenta_padre=p_id_cuenta_padre
						 ,id_cuenta_sigma=p_id_cuenta_sigma
						 ,id_empresa=p_id_empresa
						 ,id_gestion=p_id_gestion
						 ,id_moneda=p_id_moneda
						 ,id_parametro=p_id_parametro
						 ,id_usuario_mod=p_id_usuario_mod
						 ,id_usuario_reg=p_id_usuario_reg
						 ,nivel_cuenta=p_nivel_cuenta
						 ,nombre_cuenta=p_nombre_cuenta
						 ,nro_cuenta=p_nro_cuenta
						 ,sw_auxiliar=p_sw_auxiliar
						 ,sw_oec=p_sw_oec
						 ,sw_sigma=p_sw_sigma
						 ,sw_sistema_actualizacion=p_sw_sistema_actualizacion
						 ,sw_transaccional=p_sw_transaccional
						 ,tipo_cuenta=p_tipo_cuenta
						 ,tipo_cuenta_pat=p_tipo_cuenta_pat
						 WHERE id_cuenta=p_id_cuenta;

						       
						       ELSEIF  v_operacion = 'DELETE' THEN
						       
						         DELETE FROM 
						              CONTA.tcuenta
 
						              						 WHERE id_cuenta=p_id_cuenta;

						       
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