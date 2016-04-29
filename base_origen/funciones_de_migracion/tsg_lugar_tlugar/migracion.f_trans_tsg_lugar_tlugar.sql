CREATE OR REPLACE FUNCTION migracion.f_trans_tsg_lugar_tlugar (
  v_operacion varchar,
  p_nombre varchar,
  p_id_lugar integer,
  p_codigo varchar,
  p_fk_id_lugar integer,
  p_nivel integer,
  p_prioridad_kard varchar,
  p_sw_impuesto varchar,
  p_sw_municipio varchar
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
			v_id_lugar int4;
			v_id_lugar_fk int4;
			v_codigo varchar;
			v_codigo_largo varchar;
			v_estado_reg varchar;
			v_fecha_mod timestamp;
			v_fecha_reg timestamp;
			v_id_usuario_mod int4;
			v_id_usuario_reg int4;
			v_nombre varchar;
			v_sw_impuesto varchar;
			v_sw_municipio varchar;
			v_tipo varchar;
            v_es_regional varchar;
BEGIN
			
			
			          --funcion para obtener cadena de conexion
			          v_cadena_cnx =  migracion.f_obtener_cadena_con_dblink();
			          
			          
			           ---------------------------------------
			           --previamente se tranforman los datos  (descomentar)
			           ---------------------------------------

			select es_regional into v_es_regional
            from sss.tsg_lugar
            where id_lugar = p_id_lugar; 
            
                      
			v_id_lugar=p_id_lugar::int4;
			v_id_lugar_fk=p_fk_id_lugar::int4;
            v_es_regional = convert(v_es_regional::varchar, 'LATIN1', 'UTF8');
			v_codigo=convert(p_codigo::varchar, 'LATIN1', 'UTF8');
			v_codigo_largo=NULL::varchar;
			v_estado_reg=convert('activo'::varchar, 'LATIN1', 'UTF8');
			v_fecha_mod=NULL::timestamp;
			v_fecha_reg=now()::timestamp;
			v_id_usuario_mod=NULL::int4;
			v_id_usuario_reg=1::int4;
			v_nombre=convert(p_nombre::varchar, 'LATIN1', 'UTF8');
			v_sw_impuesto=convert(p_sw_impuesto::varchar, 'LATIN1', 'UTF8');
			v_sw_municipio=convert(p_sw_municipio::varchar, 'LATIN1', 'UTF8');
			if p_nivel=0 then
                v_tipo='pais'::varchar;                
				v_id_lugar_fk=NULL::int4;
            elsif p_nivel=1 then
            	v_tipo='departamento'::varchar;
    		elsif p_nivel=2 then
            	v_tipo='provincia'::varchar;
            elsif p_nivel=3 then
            	v_tipo='localidad'::varchar;
            else
            	v_tipo='barrio'::varchar;
            end if;
			    --cadena para la llamada a la funcion de insercion en la base de datos destino
			      
			        
			          v_consulta = 'select migra.f__on_trig_tsg_lugar_tlugar (
			               '''||v_operacion::varchar||''','||COALESCE(v_id_lugar::varchar,'NULL')||','||COALESCE(v_id_lugar_fk::varchar,'NULL')||','||COALESCE(''''||v_codigo::varchar||'''','NULL')||','||COALESCE(''''||v_codigo_largo::varchar||'''','NULL')||','||COALESCE(''''||v_estado_reg::varchar||'''','NULL')||','||COALESCE(''''||v_fecha_mod::varchar||'''','NULL')||','||COALESCE(''''||v_fecha_reg::varchar||'''','NULL')||','||COALESCE(v_id_usuario_mod::varchar,'NULL')||','||COALESCE(v_id_usuario_reg::varchar,'NULL')||','||COALESCE(''''||v_nombre::varchar||'''','NULL')||','||COALESCE(''''||v_sw_impuesto::varchar||'''','NULL')||','||COALESCE(''''||v_sw_municipio::varchar||'''','NULL')||','||COALESCE(''''||v_tipo::varchar||'''','NULL')||','||COALESCE(''''||v_es_regional::varchar||'''','NULL')||')';
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
SECURITY INVOKER
COST 100;