CREATE OR REPLACE FUNCTION migracion.f_trans_tpr_partida_tpartida (
  v_operacion varchar,
  p_id_partida integer,
  p_id_concepto_colectivo integer,
  p_id_oec_sigma integer,
  p_id_parametro integer,
  p_id_partida_padre integer,
  p_cod_ascii varchar,
  p_cod_excel varchar,
  p_codigo_partida varchar,
  p_cod_trans varchar,
  p_desc_partida varchar,
  p_ent_trf varchar,
  p_fecha_reg timestamp,
  p_id_usr_reg integer,
  p_nivel_partida numeric,
  p_nombre_partida varchar,
  p_sw_movimiento numeric,
  p_sw_transaccional numeric,
  p_tipo_memoria numeric,
  p_tipo_partida numeric
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
			v_id_partida int4;
			v_id_partida_fk int4;
			v_cod_ascii varchar;
			v_cod_excel varchar;
			v_codigo varchar;
			v_cod_trans varchar;
			v_descripcion varchar;
			v_ent_trf varchar;
			v_estado_reg varchar;
			v_fecha_mod timestamp;
			v_fecha_reg timestamp;
			v_id_gestion int4;
			v_id_parametros int4;
			v_id_usuario_mod int4;
			v_id_usuario_reg int4;
			v_nivel_partida int4;
			v_nombre_partida varchar;
			v_sw_movimiento varchar;
			v_sw_transaccional varchar;
			v_tipo varchar;
            v_aux varchar;
BEGIN
			
			
			          --funcion para obtener cadena de conexion
			          v_cadena_cnx =  migracion.f_obtener_cadena_con_dblink();
			          
			          
			           ---------------------------------------
			           --previamente se tranforman los datos  (descomentar)
			           ---------------------------------------
			select par.id_gestion into v_aux from presto.tpr_parametro par where par.id_parametro=p_id_parametro;
			           
			v_id_partida=p_id_partida::int4;
			v_id_partida_fk=p_id_partida_padre::int4;
			v_cod_ascii=convert(p_cod_ascii::varchar, 'LATIN1', 'UTF8');
			v_cod_excel=convert(p_cod_excel::varchar, 'LATIN1', 'UTF8');
			v_codigo=convert(p_codigo_partida::varchar, 'LATIN1', 'UTF8');
			v_cod_trans=convert(p_cod_trans::varchar, 'LATIN1', 'UTF8');
			v_descripcion=convert(p_desc_partida::varchar, 'LATIN1', 'UTF8');
			v_ent_trf=convert(p_ent_trf::varchar, 'LATIN1', 'UTF8');
			v_estado_reg=convert('activo'::varchar, 'LATIN1', 'UTF8');
			v_fecha_mod=NULL::timestamp;
			v_fecha_reg=p_fecha_reg::timestamp;
			v_id_gestion=v_aux::int4;
			v_id_parametros=p_id_parametro::int4;
			v_id_usuario_mod=NULL::int4;
			v_id_usuario_reg=p_id_usr_reg::int4;
			v_nivel_partida=p_nivel_partida::int4;
			v_nombre_partida=convert(p_nombre_partida::varchar, 'LATIN1', 'UTF8');
            if p_sw_movimiento=1 then 
				v_sw_movimiento=convert('presupuestaria'::varchar, 'LATIN1', 'UTF8');
            else 
            	v_sw_movimiento=convert('flujo'::varchar, 'LATIN1', 'UTF8');
            end if;
			if p_sw_transaccional=1 then
	            v_sw_transaccional=convert('movimiento'::varchar, 'LATIN1', 'UTF8');
			else 
                v_sw_transaccional=convert('titular'::varchar, 'LATIN1', 'UTF8');
            end if;
            if p_tipo_partida=1 then
				v_tipo=convert('recurso'::varchar, 'LATIN1', 'UTF8');
 			else
            	v_tipo=convert('gasto'::varchar, 'LATIN1', 'UTF8');
            end if;
			    --cadena para la llamada a la funcion de insercion en la base de datos destino
			      
			        
			          v_consulta = 'select migra.f__on_trig_tpr_partida_tpartida (
			               '''||v_operacion::varchar||''','||COALESCE(v_id_partida::varchar,'NULL')||','||COALESCE(v_id_partida_fk::varchar,'NULL')||','||COALESCE(''''||v_cod_ascii::varchar||'''','NULL')||','||COALESCE(''''||v_cod_excel::varchar||'''','NULL')||','||COALESCE(''''||v_codigo::varchar||'''','NULL')||','||COALESCE(''''||v_cod_trans::varchar||'''','NULL')||','||COALESCE(''''||v_descripcion::varchar||'''','NULL')||','||COALESCE(''''||v_ent_trf::varchar||'''','NULL')||','||COALESCE(''''||v_estado_reg::varchar||'''','NULL')||','||COALESCE(''''||v_fecha_mod::varchar||'''','NULL')||','||COALESCE(''''||v_fecha_reg::varchar||'''','NULL')||','||COALESCE(v_id_gestion::varchar,'NULL')||','||COALESCE(v_id_parametros::varchar,'NULL')||','||COALESCE(v_id_usuario_mod::varchar,'NULL')||','||COALESCE(v_id_usuario_reg::varchar,'NULL')||','||COALESCE(v_nivel_partida::varchar,'NULL')||','||COALESCE(''''||v_nombre_partida::varchar||'''','NULL')||','||COALESCE(''''||v_sw_movimiento::varchar||'''','NULL')||','||COALESCE(''''||v_sw_transaccional::varchar||'''','NULL')||','||COALESCE(''''||v_tipo::varchar||'''','NULL')||')';
			          --probar la conexion con dblink
			          
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