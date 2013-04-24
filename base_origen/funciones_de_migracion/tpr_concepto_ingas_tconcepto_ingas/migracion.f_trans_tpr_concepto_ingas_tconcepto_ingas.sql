CREATE OR REPLACE FUNCTION migracion.f_trans_tpr_concepto_ingas_tconcepto_ingas (
  v_operacion varchar,
  p_id_concepto_ingas integer,
  p_id_item integer,
  p_id_oec integer,
  p_id_partida integer,
  p_id_servicio integer,
  p_desc_ingas varchar,
  p_fecha_reg timestamp,
  p_id_usr_reg integer,
  p_sw_tesoro numeric
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
			v_id_concepto_ingas int4;
			v_desc_ingas varchar;
			v_estado_reg varchar;
			v_fecha_mod timestamp;
			v_fecha_reg timestamp;
			v_id_item int4;
			v_id_oec int4;
			v_id_servicio int4;
			v_id_usuario_mod int4;
			v_id_usuario_reg int4;
			v_sw_tesoro int4;
			v_tipo varchar;
            v_id_partida int4;
BEGIN
			
			
			          --funcion para obtener cadena de conexion
			          v_cadena_cnx =  migracion.f_obtener_cadena_con_dblink();
			          
			          
			           ---------------------------------------
			           --previamente se tranforman los datos  (descomentar)
			           ---------------------------------------


			v_id_concepto_ingas=p_id_concepto_ingas::int4;
			v_desc_ingas=convert(p_desc_ingas::varchar, 'LATIN1', 'UTF8');
			v_estado_reg=convert('activo'::varchar, 'LATIN1', 'UTF8');
			v_fecha_mod=NULL::timestamp;
			v_fecha_reg=p_fecha_reg::timestamp;
			v_id_item=p_id_item::int4;
			v_id_oec=p_id_oec::int4;
			v_id_servicio=p_id_servicio::int4;
			v_id_usuario_mod=NULL::int4;
			v_id_usuario_reg=p_id_usr_reg::int4;
			v_sw_tesoro=p_sw_tesoro::int4;
			v_tipo=convert(NULL::varchar, 'LATIN1', 'UTF8');
 			v_id_partida=p_id_partida::int4;
			    --cadena para la llamada a la funcion de insercion en la base de datos destino
			      
			        
			          v_consulta = 'select migra.f__on_trig_tpr_concepto_ingas_tconcepto_ingas (
			               '''||v_operacion::varchar||''','||COALESCE(v_id_concepto_ingas::varchar,'NULL')||','||COALESCE(''''||v_desc_ingas::varchar||'''','NULL')||','||COALESCE(''''||v_estado_reg::varchar||'''','NULL')||','||COALESCE(''''||v_fecha_mod::varchar||'''','NULL')||','||COALESCE(''''||v_fecha_reg::varchar||'''','NULL')||','||COALESCE(v_id_item::varchar,'NULL')||','||COALESCE(v_id_oec::varchar,'NULL')||','||COALESCE(v_id_servicio::varchar,'NULL')||','||COALESCE(v_id_usuario_mod::varchar,'NULL')||','||COALESCE(v_id_usuario_reg::varchar,'NULL')||','||COALESCE(v_sw_tesoro::varchar,'NULL')||','||COALESCE(''''||v_tipo::varchar||'''','NULL')||','||COALESCE(''''||v_id_partida::varchar||'''','NULL')||')';
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