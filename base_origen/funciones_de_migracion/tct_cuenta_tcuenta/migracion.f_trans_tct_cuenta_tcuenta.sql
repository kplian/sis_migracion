CREATE OR REPLACE FUNCTION migracion.f_trans_tct_cuenta_tcuenta (
  v_operacion varchar,
  p_nro_cuenta varchar,
  p_id_cuenta integer,
  p_id_auxiliar_actualizacion integer,
  p_id_auxiliar_dif integer,
  p_id_cuenta_actualizacion integer,
  p_id_cuenta_dif integer,
  p_id_cuenta_padre integer,
  p_id_cuenta_sigma integer,
  p_id_moneda integer,
  p_id_parametro integer,
  p_cuenta_flujo_sigma varchar,
  p_cuenta_sigma varchar,
  p_desc_cuenta varchar,
  p_descripcion varchar,
  p_nivel_cuenta numeric,
  p_nombre_cuenta varchar,
  p_sw_aux numeric,
  p_sw_oec numeric,
  p_sw_sigma varchar,
  p_sw_sistema_actualizacion varchar,
  p_sw_transaccional numeric,
  p_tipo_cuenta numeric,
  p_tipo_cuenta_pat varchar
)
RETURNS varchar [] AS
$body$
DECLARE
			 
			g_registros record;
			v_consulta varchar;
			v_res_cone  varchar;
			v_cadena_cnx varchar;
			v_cadena_con varchar;
			resp boolean;
			v_resp varchar;
			v_respuesta varchar[];
			
			g_registros_resp record;
			v_id_cuenta int4;
			v_cuenta_flujo_sigma varchar;
			v_cuenta_sigma varchar;
			v_desc_cuenta varchar;
			v_descripcion varchar;
			v_estado_reg varchar;
			v_fecha_mod timestamp;
			v_fecha_reg timestamp;
			v_id_auxiliar_dif int4;
			v_id_auxliar_actualizacion int4;
			v_id_cuenta_actualizacion int4;
			v_id_cuenta_dif int4;
			v_id_cuenta_padre int4;
			v_id_cuenta_sigma int4;
			v_id_empresa int4;
			v_id_gestion int4;
			v_id_moneda int4;
			v_id_parametro int4;
			v_id_usuario_mod int4;
			v_id_usuario_reg int4;
			v_nivel_cuenta int4;
			v_nombre_cuenta varchar;
			v_nro_cuenta varchar;
			v_obs varchar;
			v_plantilla varchar;
			v_sw_auxiliar int4;
			v_sw_oec int4;
			v_sw_sigma varchar;
			v_sw_sistema_actualizacion varchar;
			v_sw_transaccional varchar;
			v_tipo_cuenta varchar;
			v_tipo_cuenta_pat varchar;
			v_tipo_plantilla varchar;
			v_vigente varchar;
            v_id_empresa_aux varchar;
            v_id_gestion_aux varchar;
BEGIN
			
			
			          --funcion para obtener cadena de conexion
			          v_cadena_cnx =  migracion.f_obtener_cadena_con_dblink();
			          
			          
			           ---------------------------------------
			           --previamente se tranforman los datos  (descomentar)
			           ---------------------------------------

            select ges.id_empresa, par.id_gestion into v_id_empresa_aux, v_id_gestion_aux from sci.tct_cuenta cta
			inner join sci.tct_parametro par on par.id_parametro=cta.id_parametro
			inner join param.tpm_gestion ges on ges.id_gestion=par.id_gestion
			where cta.id_cuenta=p_id_cuenta;
			
			v_id_cuenta=p_id_cuenta::int4;
			v_cuenta_flujo_sigma=convert(p_cuenta_flujo_sigma::varchar, 'LATIN1', 'UTF8');
			v_cuenta_sigma=convert(p_cuenta_sigma::varchar, 'LATIN1', 'UTF8');
			v_desc_cuenta=convert(p_desc_cuenta::varchar, 'LATIN1', 'UTF8');
			v_descripcion=convert(p_descripcion::varchar, 'LATIN1', 'UTF8');
			v_estado_reg=convert('activo'::varchar, 'LATIN1', 'UTF8');
			v_fecha_mod=NULL::timestamp;
			v_fecha_reg=now()::timestamp;
			v_id_auxiliar_dif=p_id_auxiliar_dif::int4;
			v_id_auxliar_actualizacion=p_id_auxiliar_actualizacion::int4;
			v_id_cuenta_actualizacion=p_id_cuenta_actualizacion::int4;
			v_id_cuenta_dif=p_id_cuenta_dif::int4;
			v_id_cuenta_padre=p_id_cuenta_padre::int4;
			v_id_cuenta_sigma=p_id_cuenta_sigma::int4;
			v_id_empresa=v_id_empresa_aux::int4;
			v_id_gestion=v_id_gestion_aux::int4;
			v_id_moneda=p_id_moneda::int4;
			v_id_parametro=p_id_parametro::int4;
			v_id_usuario_mod=NULL::int4;
			v_id_usuario_reg=1::int4;
			v_nivel_cuenta=p_nivel_cuenta::int4;
			v_nombre_cuenta=convert(p_nombre_cuenta::varchar, 'LATIN1', 'UTF8');
			v_nro_cuenta=convert(p_nro_cuenta::varchar, 'LATIN1', 'UTF8');
			v_obs=convert(NULL::varchar, 'LATIN1', 'UTF8');
			v_plantilla=convert(NULL::varchar, 'LATIN1', 'UTF8');
			v_sw_auxiliar=p_sw_aux::int4;
			v_sw_oec=p_sw_oec::int4;
			v_sw_sigma=convert(p_sw_sigma::varchar, 'LATIN1', 'UTF8');
			v_sw_sistema_actualizacion=convert(p_sw_sistema_actualizacion::varchar, 'LATIN1', 'UTF8');
			if p_sw_transaccional=1 then 
				v_sw_transaccional=convert('titular'::varchar, 'LATIN1', 'UTF8');
            else 
            	v_sw_transaccional=convert('movimiento'::varchar, 'LATIN1', 'UTF8');
            end if;
            if p_tipo_cuenta=1 then
            	v_tipo_cuenta=convert('activo'::varchar, 'LATIN1', 'UTF8');
			elsif p_tipo_cuenta=2 then
				v_tipo_cuenta=convert('pasivo'::varchar, 'LATIN1', 'UTF8');
            elsif p_tipo_cuenta=3 then
				v_tipo_cuenta=convert('patrimonio'::varchar, 'LATIN1', 'UTF8');
            elsif p_tipo_cuenta=4 then
				v_tipo_cuenta=convert('ingreso'::varchar, 'LATIN1', 'UTF8');
            elsif p_tipo_cuenta=5 then
				v_tipo_cuenta=convert('gasto'::varchar, 'LATIN1', 'UTF8');
            end if;
            v_tipo_cuenta_pat=convert(p_tipo_cuenta_pat::varchar, 'LATIN1', 'UTF8');
			v_tipo_plantilla=convert(NULL::varchar, 'LATIN1', 'UTF8');
			v_vigente=convert(NULL::varchar, 'LATIN1', 'UTF8');
 
			    --cadena para la llamada a la funcion de insercion en la base de datos destino
			      
			        
			          v_consulta = 'select migra.f__on_trig_tct_cuenta_tcuenta (
			               '''||v_operacion::varchar||''','||COALESCE(v_id_cuenta::varchar,'NULL')||','||COALESCE(''''||v_cuenta_flujo_sigma::varchar||'''','NULL')||','||COALESCE(''''||v_cuenta_sigma::varchar||'''','NULL')||','||COALESCE(''''||v_desc_cuenta::varchar||'''','NULL')||','||COALESCE(''''||v_descripcion::varchar||'''','NULL')||','||COALESCE(''''||v_estado_reg::varchar||'''','NULL')||','||COALESCE(''''||v_fecha_mod::varchar||'''','NULL')||','||COALESCE(''''||v_fecha_reg::varchar||'''','NULL')||','||COALESCE(v_id_auxiliar_dif::varchar,'NULL')||','||COALESCE(v_id_auxliar_actualizacion::varchar,'NULL')||','||COALESCE(v_id_cuenta_actualizacion::varchar,'NULL')||','||COALESCE(v_id_cuenta_dif::varchar,'NULL')||','||COALESCE(v_id_cuenta_padre::varchar,'NULL')||','||COALESCE(v_id_cuenta_sigma::varchar,'NULL')||','||COALESCE(v_id_empresa::varchar,'NULL')||','||COALESCE(v_id_gestion::varchar,'NULL')||','||COALESCE(v_id_moneda::varchar,'NULL')||','||COALESCE(v_id_parametro::varchar,'NULL')||','||COALESCE(v_id_usuario_mod::varchar,'NULL')||','||COALESCE(v_id_usuario_reg::varchar,'NULL')||','||COALESCE(v_nivel_cuenta::varchar,'NULL')||','||COALESCE(''''||v_nombre_cuenta::varchar||'''','NULL')||','||COALESCE(''''||v_nro_cuenta::varchar||'''','NULL')||','||COALESCE(''''||v_obs::varchar||'''','NULL')||','||COALESCE(''''||v_plantilla::varchar||'''','NULL')||','||COALESCE(v_sw_auxiliar::varchar,'NULL')||','||COALESCE(v_sw_oec::varchar,'NULL')||','||COALESCE(''''||v_sw_sigma::varchar||'''','NULL')||','||COALESCE(''''||v_sw_sistema_actualizacion::varchar||'''','NULL')||','||COALESCE(''''||v_sw_transaccional::varchar||'''','NULL')||','||COALESCE(''''||v_tipo_cuenta::varchar||'''','NULL')||','||COALESCE(''''||v_tipo_cuenta_pat::varchar||'''','NULL')||','||COALESCE(''''||v_tipo_plantilla::varchar||'''','NULL')||','||COALESCE(''''||v_vigente::varchar||'''','NULL')||')';
					   --probar la conexion con dblink
			          v_resp =  (SELECT dblink_connect(v_cadena_cnx));
			            
			             IF(v_resp!='OK') THEN
			            
			             	--modificar bandera de fallo  
			                 raise exception 'FALLA CONEXION A LA BASE DE DATOS CON DBLINK';
			                 
			             ELSE
					  
			         
			               PERFORM * FROM dblink(v_consulta,true) AS ( xx varchar);
			                v_res_cone=(select dblink_disconnect());
			             END IF;
			            
			            v_respuesta[1]='TRUE';
                       
			           RETURN v_respuesta;
			EXCEPTION
			   WHEN others THEN
			   
			    v_res_cone=(select dblink_disconnect());
			     v_respuesta[1]='FALSE';
                 v_respuesta[2]=SQLERRM;
                 v_respuesta[3]=SQLSTATE;
                 v_respuesta[4]=v_consulta;
                 
    
                 
                 RETURN v_respuesta;
			
			END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER;