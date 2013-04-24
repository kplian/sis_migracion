CREATE OR REPLACE FUNCTION migracion.f_trans_tpm_periodo_tperiodo (
			  v_operacion varchar,p_id_periodo int4,p_id_gestion int4,p_estado_peri_gral varchar,p_fecha_final date,p_fecha_inicio date,p_periodo numeric)
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
			v_id_periodo int4;
			v_id_gestion int4;
			v_estado_reg varchar;
			v_fecha_fin date;
			v_fecha_ini date;
			v_fecha_mod timestamp;
			v_fecha_reg timestamp;
			v_id_usuario_mod int4;
			v_id_usuario_reg int4;
			v_periodo int4;
BEGIN
			
			
			          --funcion para obtener cadena de conexion
			          v_cadena_cnx =  migracion.f_obtener_cadena_con_dblink();
			          
			          
			           ---------------------------------------
			           --previamente se tranforman los datos  (descomentar)
			           ---------------------------------------

			           
			v_id_periodo=p_id_periodo::int4;
			v_id_gestion=p_id_gestion::int4;
			v_estado_reg=convert('activo'::varchar, 'LATIN1', 'UTF8');
			v_fecha_fin=p_fecha_final::date;
			v_fecha_ini=p_fecha_inicio::date;
			v_fecha_mod=NULL::timestamp;
			v_fecha_reg=now()::timestamp;
			v_id_usuario_mod=NULL::int4;
			v_id_usuario_reg=1::int4;
			v_periodo=p_periodo::int4;
   
			    --cadena para la llamada a la funcion de insercion en la base de datos destino
			      
			        
			          v_consulta = 'select migra.f__on_trig_tpm_periodo_tperiodo (
			               '''||v_operacion::varchar||''','||COALESCE(v_id_periodo::varchar,'NULL')||','||COALESCE(v_id_gestion::varchar,'NULL')||','||COALESCE(''''||v_estado_reg::varchar||'''','NULL')||','||COALESCE(''''||v_fecha_fin::varchar||'''','NULL')||','||COALESCE(''''||v_fecha_ini::varchar||'''','NULL')||','||COALESCE(''''||v_fecha_mod::varchar||'''','NULL')||','||COALESCE(''''||v_fecha_reg::varchar||'''','NULL')||','||COALESCE(v_id_usuario_mod::varchar,'NULL')||','||COALESCE(v_id_usuario_reg::varchar,'NULL')||','||COALESCE(v_periodo::varchar,'NULL')||')';
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