CREATE OR REPLACE FUNCTION migracion.f_trans_tct_plantilla_tplantilla (
  v_operacion varchar,
  p_id_plantilla integer,
  p_desc_plantilla varchar,
  p_nro_linea numeric,
  p_sw_compro numeric,
  p_sw_tesoro numeric,
  p_tipo numeric,
  p_tipo_plantilla numeric
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
			v_id_plantilla int4;
			v_desc_plantilla varchar;
			v_estado_reg varchar;
			v_fecha_mod timestamp;
			v_fecha_reg timestamp;
			v_id_usuario_mod int4;
			v_id_usuario_reg int4;
			v_nro_linea numeric;
			v_sw_compro varchar;
			v_sw_tesoro varchar;
			v_tipo numeric;
BEGIN
			
			
			          --funcion para obtener cadena de conexion
			          v_cadena_cnx =  migracion.f_obtener_cadena_con_dblink();
			select *
            into g_registros
            from sci.tct_plantilla
            where p_tipo_plantilla =  p_tipo_plantilla;
                     
			          
			           ---------------------------------------
			           --previamente se tranforman los datos  (descomentar)
			           ---------------------------------------
			
			v_id_plantilla=p_tipo_plantilla::int4;
			v_desc_plantilla=convert(p_desc_plantilla::varchar, 'LATIN1', 'UTF8');
			v_estado_reg=convert(g_registros.estado_reg::varchar, 'LATIN1', 'UTF8');
			v_fecha_mod=g_registros.fecha_mod::timestamp;
			v_fecha_reg=g_registros.fecha_reg::timestamp;
			v_id_usuario_mod=NULL::int4;
			v_id_usuario_reg=1::int4;
			v_nro_linea=p_nro_linea::numeric;
			if p_sw_compro=1 then
				v_sw_compro=convert('si'::varchar, 'LATIN1', 'UTF8');
            else 
            	v_sw_compro=convert('no'::varchar, 'LATIN1', 'UTF8');
            end if;
            
            v_sw_tesoro=convert(g_registros.sw_obligacion_pago::varchar, 'LATIN1', 'UTF8');
            
            v_tipo=p_tipo::numeric;
 
			    --cadena para la llamada a la funcion de insercion en la base de datos destino
			      
			        
			          v_consulta = 'select migra.f__on_trig_tct_plantilla_tplantilla (
			               '''||v_operacion::varchar||''','||COALESCE(v_id_plantilla::varchar,'NULL')||','||COALESCE(''''||v_desc_plantilla::varchar||'''','NULL')||','||COALESCE(''''||v_estado_reg::varchar||'''','NULL')||','||COALESCE(''''||v_fecha_mod::varchar||'''','NULL')||','||COALESCE(''''||v_fecha_reg::varchar||'''','NULL')||','||COALESCE(v_id_usuario_mod::varchar,'NULL')||','||COALESCE(v_id_usuario_reg::varchar,'NULL')||','||COALESCE(v_nro_linea::varchar,'NULL')||','||COALESCE(''''||v_sw_compro::varchar||'''','NULL')||','||COALESCE(''''||v_sw_tesoro::varchar||'''','NULL')||','||COALESCE(v_tipo::varchar,'NULL')||')';
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