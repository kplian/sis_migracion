--------------- SQL ---------------

CREATE OR REPLACE FUNCTION migracion.f_trans_tct_cuenta_ids_tcuenta_ids (
  v_operacion varchar,
  p_id_cuenta_uno integer,
  p_id_cuenta_dos integer,
  p_sw_cambio_gestion varchar
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
			v_id_cuenta_uno int4;
			v_id_cuenta_dos int4;
			v_sw_cambio_gestion varchar;
BEGIN
			
			
			          --funcion para obtener cadena de conexion
			          v_cadena_cnx =  migracion.f_obtener_cadena_con_dblink();
			          
			          
			           ---------------------------------------
			           --previamente se tranforman los datos  (descomentar)
			           ---------------------------------------

			           
			           v_id_cuenta_uno=p_id_cuenta_uno::int4;
			           v_id_cuenta_dos=p_id_cuenta_dos::int4;
			           v_sw_cambio_gestion=convert(p_sw_cambio_gestion::varchar, 'LATIN1', 'UTF8');
   
			    --cadena para la llamada a la funcion de insercion en la base de datos destino
			      
			        
			          v_consulta = 'select migra.f__on_trig_tct_cuenta_ids_tcuenta_ids (
			               '''||v_operacion::varchar||''','||COALESCE(v_id_cuenta_uno::varchar,'NULL')||','||COALESCE(v_id_cuenta_dos::varchar,'NULL')||','||COALESCE(''''||v_sw_cambio_gestion::varchar||'''','NULL')||')';
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