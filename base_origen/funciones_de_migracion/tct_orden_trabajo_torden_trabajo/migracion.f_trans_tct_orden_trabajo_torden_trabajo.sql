CREATE OR REPLACE FUNCTION migracion.f_trans_tct_orden_trabajo_torden_trabajo (
  v_operacion varchar,
  p_id_orden_trabajo integer,
  p_id_usuario integer,
  p_desc_orden varchar,
  p_estado_orden numeric,
  p_fecha_final date,
  p_fecha_inicio date,
  p_motivo_orden varchar
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
			v_id_orden_trabajo int4;
			v_desc_orden varchar;
			v_estado_reg varchar;
			v_fecha_final date;
			v_fecha_inicio date;
			v_fecha_mod timestamp;
			v_fecha_reg timestamp;
			v_id_usuario_mod int4;
			v_id_usuario_reg int4;
			v_motivo_orden varchar;
BEGIN
			
			
			          --funcion para obtener cadena de conexion
			          v_cadena_cnx =  migracion.f_obtener_cadena_con_dblink();
			          
			          
			           ---------------------------------------
			           --previamente se tranforman los datos  (descomentar)
			           ---------------------------------------

			           
			v_id_orden_trabajo=p_id_orden_trabajo::int4;
			v_desc_orden=convert(p_desc_orden::varchar, 'LATIN1', 'UTF8');
			v_estado_reg=convert('activo'::varchar, 'LATIN1', 'UTF8');
			v_fecha_final=p_fecha_final::date;
			v_fecha_inicio=p_fecha_inicio::date;
			v_fecha_mod=NULL::timestamp;
			v_fecha_reg=now()::timestamp;
			v_id_usuario_mod=NULL::int4;
			v_id_usuario_reg=p_id_usuario::int4;
			v_motivo_orden=convert(p_motivo_orden::varchar, 'LATIN1', 'UTF8');
 
			    --cadena para la llamada a la funcion de insercion en la base de datos destino
			      
			        
			          v_consulta = 'select migra.f__on_trig_tct_orden_trabajo_torden_trabajo (
			               '''||v_operacion::varchar||''','||COALESCE(v_id_orden_trabajo::varchar,'NULL')||','||COALESCE(''''||v_desc_orden::varchar||'''','NULL')||','||COALESCE(''''||v_estado_reg::varchar||'''','NULL')||','||COALESCE(''''||v_fecha_final::varchar||'''','NULL')||','||COALESCE(''''||v_fecha_inicio::varchar||'''','NULL')||','||COALESCE(''''||v_fecha_mod::varchar||'''','NULL')||','||COALESCE(''''||v_fecha_reg::varchar||'''','NULL')||','||COALESCE(v_id_usuario_mod::varchar,'NULL')||','||COALESCE(v_id_usuario_reg::varchar,'NULL')||','||COALESCE(''''||v_motivo_orden::varchar||'''','NULL')||')';
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