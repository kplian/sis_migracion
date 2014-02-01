--------------- SQL ---------------

CREATE OR REPLACE FUNCTION migracion.f_trans_tpm_moneda_tmoneda (
  v_operacion varchar,
  p_id_moneda integer,
  p_estado varchar,
  p_nombre varchar,
  p_origen varchar,
  p_prioridad integer,
  p_simbolo varchar,
  p_tipo_actualizacion varchar
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
			v_id_moneda int4;
			v_codigo varchar;
			v_estado_reg varchar;
			v_fecha_mod timestamp;
			v_fecha_reg timestamp;
			v_id_usuario_mod int4;
			v_id_usuario_reg int4;
			v_moneda varchar;
			v_origen varchar;
			v_prioridad int4;
			v_tipo_actualizacion varchar;
			v_tipo_moneda varchar;
BEGIN
			
			
			          --funcion para obtener cadena de conexion
			          v_cadena_cnx =  migracion.f_obtener_cadena_con_dblink();
			          
			          
			           ---------------------------------------
			           --previamente se tranforman los datos  (descomentar)
			           ---------------------------------------

  			v_id_moneda=p_id_moneda::int4;
			v_codigo=convert(p_simbolo::varchar, 'LATIN1', 'UTF8');
			v_estado_reg=convert(p_estado::varchar, 'LATIN1', 'UTF8');
			v_fecha_mod=NULL;
			v_fecha_reg=now();
			v_id_usuario_mod=NULL;
			v_id_usuario_reg=1;
			v_moneda=convert(p_nombre::varchar, 'LATIN1', 'UTF8');
			v_origen=convert(p_origen::varchar, 'LATIN1', 'UTF8');
			v_prioridad=p_prioridad::int4;
			v_tipo_actualizacion=convert(p_tipo_actualizacion::varchar, 'LATIN1', 'UTF8');
			v_tipo_moneda=NULL;--no identificado
   
			    --cadena para la llamada a la funcion de insercion en la base de datos destino
			      
			        
			          v_consulta = 'select migra.f__on_trig_tpm_moneda_tmoneda (
			               '''||v_operacion::varchar||''','||COALESCE(v_id_moneda::varchar,'NULL')||','||COALESCE(''''||v_codigo::varchar||'''','NULL')||','||COALESCE(''''||v_estado_reg::varchar||'''','NULL')||','||COALESCE(''''||v_fecha_mod::varchar||'''','NULL')||','||COALESCE(''''||v_fecha_reg::varchar||'''','NULL')||','||COALESCE(v_id_usuario_mod::varchar,'NULL')||','||COALESCE(v_id_usuario_reg::varchar,'NULL')||','||COALESCE(''''||v_moneda::varchar||'''','NULL')||','||COALESCE(''''||v_origen::varchar||'''','NULL')||','||COALESCE(v_prioridad::varchar,'NULL')||','||COALESCE(''''||v_tipo_actualizacion::varchar||'''','NULL')||','||COALESCE(''''||v_tipo_moneda::varchar||'''','NULL')||')';
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