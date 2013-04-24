--------------- SQL ---------------

CREATE OR REPLACE FUNCTION migracion.f_trans_tpm_gestion_tgestion (
  v_operacion varchar,
  p_id_gestion integer,
  p_id_empresa integer,
  p_id_moneda_base integer,
  p_estado_ges_gral varchar,
  p_gestion numeric
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
			v_id_gestion int4;
			v_id_moneda_base int4;
			v_estado varchar;
			v_estado_reg varchar;
			v_fecha_mod timestamp;
			v_fecha_reg timestamp;
			v_gestion int4;
			v_id_empresa int4;
			v_id_usuario_mod int4;
			v_id_usuario_reg int4;
BEGIN
			
			
			          --funcion para obtener cadena de conexion
			          v_cadena_cnx =  migracion.f_obtener_cadena_con_dblink();
			          
			          
			           ---------------------------------------
			           --previamente se tranforman los datos  (descomentar)
			           ---------------------------------------

			v_id_gestion=p_id_gestion::int4;
			v_id_moneda_base=p_id_moneda_base::int4;
			v_estado=convert(p_estado_ges_gral::varchar, 'LATIN1', 'UTF8');
			v_estado_reg='activo';
			v_fecha_mod=NULL;
			v_fecha_reg=now();
			v_gestion=p_gestion::int4;
			v_id_empresa=p_id_empresa::int4;
			v_id_usuario_mod=NULL;
			v_id_usuario_reg=1;
 
			    --cadena para la llamada a la funcion de insercion en la base de datos destino
			      
			        
			          v_consulta = 'select migra.f__on_trig_tpm_gestion_tgestion (
			               '''||v_operacion::varchar||''','||COALESCE(v_id_gestion::varchar,'NULL')||','||COALESCE(v_id_moneda_base::varchar,'NULL')||','||COALESCE(''''||v_estado::varchar||'''','NULL')||','||COALESCE(''''||v_estado_reg::varchar||'''','NULL')||','||COALESCE(''''||v_fecha_mod::varchar||'''','NULL')||','||COALESCE(''''||v_fecha_reg::varchar||'''','NULL')||','||COALESCE(v_gestion::varchar,'NULL')||','||COALESCE(v_id_empresa::varchar,'NULL')||','||COALESCE(v_id_usuario_mod::varchar,'NULL')||','||COALESCE(v_id_usuario_reg::varchar,'NULL')||')';
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