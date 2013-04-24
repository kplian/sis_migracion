CREATE OR REPLACE FUNCTION migracion.f_trans_tpm_fina_regi_prog_proy_acti_tep (
  v_operacion varchar,
  p_id_fina_regi_prog_proy_acti integer,
  p_id_financiador integer,
  p_id_prog_proy_acti integer,
  p_id_regional integer,
  p_id_usuario integer,
  p_ep_actif varchar,
  p_fecha_reg timestamp,
  p_id_ep_actif integer,
  p_sw_presto numeric
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
			v_id_ep int4;
			v_estado_reg varchar;
			v_fecha_mod timestamp;
			v_fecha_reg timestamp;
			v_id_financiador int4;
			v_id_prog_pory_acti int4;
			v_id_regional int4;
			v_id_usuario_mod int4;
			v_id_usuario_reg int4;
			v_sw_presto int4;
BEGIN
			
			
			          --funcion para obtener cadena de conexion
			          v_cadena_cnx =  migracion.f_obtener_cadena_con_dblink();
			          
			          
			           ---------------------------------------
			           --previamente se tranforman los datos  (descomentar)
			           ---------------------------------------


			v_id_ep=p_id_fina_regi_prog_proy_acti::int4;
			v_estado_reg=convert('activo'::varchar, 'LATIN1', 'UTF8');
			v_fecha_mod=NULL::timestamp;
			v_fecha_reg=p_fecha_reg::timestamp;
			v_id_financiador=p_id_financiador::int4;
			v_id_prog_pory_acti=p_id_prog_proy_acti::int4;
			v_id_regional=p_id_regional::int4;
			v_id_usuario_mod=NULL::int4;
            IF(p_id_usuario IS NULL)THEN 			
                v_id_usuario_reg=1::int4;
            ELSE 
                v_id_usuario_reg=p_id_usuario::int4;
            END IF;
			v_sw_presto=p_sw_presto::int4;
			
			    --cadena para la llamada a la funcion de insercion en la base de datos destino
			      
			        
			          v_consulta = 'select migra.f__on_trig_tpm_fina_regi_prog_proy_acti_tep (
			               '''||v_operacion::varchar||''','||COALESCE(v_id_ep::varchar,'NULL')||','||COALESCE(''''||v_estado_reg::varchar||'''','NULL')||','||COALESCE(''''||v_fecha_mod::varchar||'''','NULL')||','||COALESCE(''''||v_fecha_reg::varchar||'''','NULL')||','||COALESCE(v_id_financiador::varchar,'NULL')||','||COALESCE(v_id_prog_pory_acti::varchar,'NULL')||','||COALESCE(v_id_regional::varchar,'NULL')||','||COALESCE(v_id_usuario_mod::varchar,'NULL')||','||COALESCE(v_id_usuario_reg::varchar,'NULL')||','||COALESCE(v_sw_presto::varchar,'NULL')||')';
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