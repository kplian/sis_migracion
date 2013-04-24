CREATE OR REPLACE FUNCTION migracion.f_trans_tpm_tipo_cambio_ttipo_cambio (
			  v_operacion varchar,p_id_tipo_cambio int4,p_compra numeric,p_estado varchar,p_fecha date,p_fecha_reg timestamp,p_hora time,p_id_moneda int4,p_observaciones varchar,p_oficial numeric,p_venta numeric)
			RETURNS varchar [] AS
			$BODY$

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
			v_id_tipo_cambio int4;
			v_compra numeric;
			v_estado_reg varchar;
			v_fecha date;
			v_fecha_mod timestamp;
			v_fecha_reg timestamp;
			v_id_moneda int4;
			v_id_usuario_mod int4;
			v_id_usuario_reg int4;
			v_observaciones varchar;
			v_oficial numeric;
			v_venta numeric;
BEGIN
			
			
			          --funcion para obtener cadena de conexion
			          v_cadena_cnx =  migracion.f_obtener_cadena_con_dblink();
			          
			          
			           ---------------------------------------
			           --previamente se tranforman los datos  (descomentar)
			           ---------------------------------------

			           
			v_id_tipo_cambio=p_id_tipo_cambio::int4;
			v_compra=p_compra::numeric;
			v_estado_reg=convert(p_estado::varchar, 'LATIN1', 'UTF8');
			v_fecha=p_fecha::date;
			v_fecha_mod=NULL::timestamp;
			v_fecha_reg=p_fecha_reg::timestamp;
			v_id_moneda=p_id_moneda::int4;
			v_id_usuario_mod=NULL::int4;
			v_id_usuario_reg=1::int4;
			v_observaciones=convert(p_observaciones::varchar, 'LATIN1', 'UTF8');
			v_oficial=p_oficial::numeric;
			v_venta=p_venta::numeric;
    
			    --cadena para la llamada a la funcion de insercion en la base de datos destino
			      
			        
			          v_consulta = 'select migra.f__on_trig_tpm_tipo_cambio_ttipo_cambio (
			               '''||v_operacion::varchar||''','||COALESCE(v_id_tipo_cambio::varchar,'NULL')||','||COALESCE(v_compra::varchar,'NULL')||','||COALESCE(''''||v_estado_reg::varchar||'''','NULL')||','||COALESCE(''''||v_fecha::varchar||'''','NULL')||','||COALESCE(''''||v_fecha_mod::varchar||'''','NULL')||','||COALESCE(''''||v_fecha_reg::varchar||'''','NULL')||','||COALESCE(v_id_moneda::varchar,'NULL')||','||COALESCE(v_id_usuario_mod::varchar,'NULL')||','||COALESCE(v_id_usuario_reg::varchar,'NULL')||','||COALESCE(''''||v_observaciones::varchar||'''','NULL')||','||COALESCE(v_oficial::varchar,'NULL')||','||COALESCE(v_venta::varchar,'NULL')||')';
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
			$BODY$

LANGUAGE 'plpgsql'
			VOLATILE
			CALLED ON NULL INPUT
			SECURITY INVOKER;