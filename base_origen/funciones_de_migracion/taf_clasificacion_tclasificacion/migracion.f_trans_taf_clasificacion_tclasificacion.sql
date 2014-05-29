CREATE OR REPLACE FUNCTION migracion.f_trans_taf_clasificacion_tclasificacion (
  v_operacion varchar,
  p_codigo varchar,
  p_id_clasificacion integer,
  p_correlativo_act integer,
  p_descripcion varchar,
  p_estado varchar,
  p_fecha_mod date,
  p_fecha_reg date,
  p_fk_id_clasificacion integer,
  p_flag_depreciacion varchar,
  p_id integer,
  p_id_metodo_depreciacion integer,
  p_id_padre integer,
  p_id_usuario_mod integer,
  p_id_usuario_reg integer,
  p_ini_correlativo integer,
  p_nivel integer,
  p_tipo varchar,
  p_vida_util integer
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
			v_codigo varchar;
			v_id_clasificacion int4;
			v_correlativo_act int4;
			v_descripcion varchar;
			v_estado varchar;
			v_estado_reg varchar;
			v_fecha_mod timestamp;
			v_fecha_reg timestamp;
			v_id_clasificacion_fk int4;
			v_id_metodo_depreciacion int4;
			v_id_usuario_mod int4;
			v_id_usuario_reg int4;
			v_ini_correlativo int4;
			v_nivel int4;
			v_sw_dep varchar;
			v_tipo varchar;
			v_vida_util int4;
BEGIN
			
			
			          --funcion para obtener cadena de conexion
			          v_cadena_cnx =  migracion.f_obtener_cadena_con_dblink();
			          
			          
			           ---------------------------------------
			           --previamente se tranforman los datos  (descomentar)
			           ---------------------------------------

			           
			v_codigo=convert(p_codigo::varchar, 'LATIN1', 'UTF8');
			v_id_clasificacion=p_id_clasificacion::int4;
			v_correlativo_act=p_correlativo_act::int4;
			v_descripcion=convert(p_descripcion::varchar, 'LATIN1', 'UTF8');
			v_estado=convert(p_estado::varchar, 'LATIN1', 'UTF8');
			v_estado_reg=convert(p_estado::varchar, 'LATIN1', 'UTF8');
			v_fecha_mod=NULL;
			v_fecha_reg=NULL;
			v_id_clasificacion_fk=p_fk_id_clasificacion::int4;
			v_id_metodo_depreciacion=p_id_metodo_depreciacion::int4;
			v_id_usuario_mod=NULL;
			v_id_usuario_reg=1;
			v_ini_correlativo=p_ini_correlativo::int4;
			v_nivel=p_nivel::int4;
			v_sw_dep=convert(p_flag_depreciacion::varchar, 'LATIN1', 'UTF8');
			v_tipo=convert(p_tipo::varchar, 'LATIN1', 'UTF8');
			v_vida_util=p_vida_util::int4;
 
			    --cadena para la llamada a la funcion de insercion en la base de datos destino
			      
			        
			          v_consulta = 'select migra.f__on_trig_taf_clasificacion_tclasificacion (
			               '''||v_operacion::varchar||''','||COALESCE(''''||v_codigo::varchar||'''','NULL')||','||COALESCE(v_id_clasificacion::varchar,'NULL')||','||COALESCE(v_correlativo_act::varchar,'NULL')||','||COALESCE(''''||v_descripcion::varchar||'''','NULL')||','||COALESCE(''''||v_estado::varchar||'''','NULL')||','||COALESCE(''''||v_estado_reg::varchar||'''','NULL')||','||COALESCE(''''||v_fecha_mod::varchar||'''','NULL')||','||COALESCE(''''||v_fecha_reg::varchar||'''','NULL')||','||COALESCE(v_id_clasificacion_fk::varchar,'NULL')||','||COALESCE(v_id_metodo_depreciacion::varchar,'NULL')||','||COALESCE(v_id_usuario_mod::varchar,'NULL')||','||COALESCE(v_id_usuario_reg::varchar,'NULL')||','||COALESCE(v_ini_correlativo::varchar,'NULL')||','||COALESCE(v_nivel::varchar,'NULL')||','||COALESCE(''''||v_sw_dep::varchar||'''','NULL')||','||COALESCE(''''||v_tipo::varchar||'''','NULL')||','||COALESCE(v_vida_util::varchar,'NULL')||')';
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