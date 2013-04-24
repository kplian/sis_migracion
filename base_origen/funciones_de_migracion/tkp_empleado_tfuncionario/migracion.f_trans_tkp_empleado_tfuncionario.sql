CREATE OR REPLACE FUNCTION migracion.f_trans_tkp_empleado_tfuncionario (
  v_operacion varchar,
  p_codigo_empleado varchar,
  p_id_empleado integer,
  p_id_auxiliar integer,
  p_id_cuenta integer,
  p_id_depto integer,
  p_id_escala_salarial integer,
  p_id_lugar_trabajo integer,
  p_id_persona integer,
  p_id_usuario_reg integer,
  p_antiguedad_ant integer,
  p_apodo varchar,
  p_compensa varchar,
  p_estado_reg varchar,
  p_fecha_ingreso date,
  p_fecha_reg date,
  p_id_empleado_actif integer,
  p_marca varchar,
  p_nivel_academico varchar
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
			v_id_funcionario int4;
			v_id_persona int4;
			v_id_usuario_mod int4;
			v_id_usuario_reg int4;
			v_codigo varchar;
			v_email_empresa varchar;
			v_estado_reg varchar;
			v_fecha_ingreso date;
			v_fecha_mod timestamp;
			v_fecha_reg timestamp;
			v_interno varchar;
BEGIN
			
			
			          --funcion para obtener cadena de conexion
			          v_cadena_cnx =  migracion.f_obtener_cadena_con_dblink();
			          
			          
			           ---------------------------------------
			           --previamente se tranforman los datos  (descomentar)
			           ---------------------------------------


			v_id_funcionario=p_id_empleado::int4;
			v_id_persona=p_id_persona::int4;
			v_id_usuario_mod=NULL::int4;
            if p_id_usuario_reg is null then
            	v_id_usuario_reg=1::int4;
            else
				v_id_usuario_reg=p_id_usuario_reg::int4;
			end if;
            v_codigo=convert(p_codigo_empleado::varchar, 'LATIN1', 'UTF8');
			v_email_empresa=convert(NULL::varchar, 'LATIN1', 'UTF8');
			v_estado_reg=convert('activo'::varchar, 'LATIN1', 'UTF8');
            if p_fecha_ingreso is null then
            	v_fecha_ingreso=now()::date;
			else
            	v_fecha_ingreso=p_fecha_ingreso::date;
            end if;
            v_fecha_mod=NULL::timestamp;
			v_fecha_reg=p_fecha_reg::timestamp;
			v_interno=convert(NULL::varchar, 'LATIN1', 'UTF8');
            
			    --cadena para la llamada a la funcion de insercion en la base de datos destino
			      
			        
			          v_consulta = 'select migra.f__on_trig_tkp_empleado_tfuncionario (
			               '''||v_operacion::varchar||''','||COALESCE(v_id_funcionario::varchar,'NULL')||','||COALESCE(v_id_persona::varchar,'NULL')||','||COALESCE(v_id_usuario_mod::varchar,'NULL')||','||COALESCE(v_id_usuario_reg::varchar,'NULL')||','||COALESCE(''''||v_codigo::varchar||'''','NULL')||','||COALESCE(''''||v_email_empresa::varchar||'''','NULL')||','||COALESCE(''''||v_estado_reg::varchar||'''','NULL')||','||COALESCE(''''||v_fecha_ingreso::varchar||'''','NULL')||','||COALESCE(''''||v_fecha_mod::varchar||'''','NULL')||','||COALESCE(''''||v_fecha_reg::varchar||'''','NULL')||','||COALESCE(''''||v_interno::varchar||'''','NULL')||')';
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