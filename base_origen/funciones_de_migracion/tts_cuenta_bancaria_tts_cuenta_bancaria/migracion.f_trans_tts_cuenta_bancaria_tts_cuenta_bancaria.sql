CREATE OR REPLACE FUNCTION migracion.f_trans_tts_cuenta_bancaria_tts_cuenta_bancaria (
  v_operacion varchar,
  p_id_cuenta_bancaria integer,
  p_id_auxiliar integer,
  p_id_cuenta integer,
  p_id_institucion integer,
  p_id_parametro integer,
  p_estado_cuenta numeric,
  p_nro_cheque integer,
  p_nro_cuenta_banco varchar,
  p_id_gestion integer,
  p_central varchar
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
			v_id_cuenta_bancaria int4;
			v_estado_cuenta numeric;
			v_id_auxiliar int4;
			v_id_cuenta int4;
			v_id_institucion int4;
			v_id_parametro int4;
			v_nro_cheque int4;
			v_nro_cuenta_banco varchar;
            v_id_gestion integer;
            v_central varchar;
BEGIN
		
			
			          --funcion para obtener cadena de conexion
			          v_cadena_cnx =  migracion.f_obtener_cadena_con_dblink();
			          

			           ---------------------------------------
			           --previamente se tranforman los datos  (descomentar)
			           ---------------------------------------

			           
			           			v_id_cuenta_bancaria=p_id_cuenta_bancaria::int4;
			v_estado_cuenta=p_estado_cuenta::numeric;
			v_id_auxiliar=p_id_auxiliar::int4;
			v_id_cuenta=p_id_cuenta::int4;
			v_id_institucion=p_id_institucion::int4;
			v_id_parametro=p_id_parametro::int4;
			v_nro_cheque=p_nro_cheque::int4;
			v_nro_cuenta_banco=convert(p_nro_cuenta_banco::varchar, 'LATIN1', 'UTF8');
            v_central=convert(p_central::varchar, 'LATIN1', 'UTF8');
            v_id_gestion=p_id_gestion::int4;
    
			    --cadena para la llamada a la funcion de insercion en la base de datos destino
			      

			          v_consulta = 'select migra.f__on_trig_tts_cuenta_bancaria_tts_cuenta_bancaria (
			               '''||v_operacion::varchar||''','||COALESCE(v_id_cuenta_bancaria::varchar,'NULL')||','||COALESCE(v_estado_cuenta::varchar,'NULL')||','||COALESCE(v_id_auxiliar::varchar,'NULL')||','||COALESCE(v_id_cuenta::varchar,'NULL')||','||COALESCE(v_id_institucion::varchar,'NULL')||','||COALESCE(v_id_parametro::varchar,'NULL')||','||COALESCE(v_nro_cheque::varchar,'NULL')||','||COALESCE(''''||v_nro_cuenta_banco::varchar||'''','NULL')||','||COALESCE(v_id_gestion::varchar,'NULL')||','||COALESCE(''''||v_central::varchar||'''','NULL')||')';
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
			   
			    --v_res_cone=(select dblink_disconnect());
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