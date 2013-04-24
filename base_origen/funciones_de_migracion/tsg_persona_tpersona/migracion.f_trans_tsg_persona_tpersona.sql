CREATE OR REPLACE FUNCTION migracion.f_trans_tsg_persona_tpersona (
  v_operacion varchar,
  p_apellido_paterno varchar,
  p_id_persona integer,
  p_id_tipo_doc_identificacion integer,
  p_apellido_materno varchar,
  p_casilla varchar,
  p_celular1 varchar,
  p_celular2 varchar,
  p_direccion varchar,
  p_doc_id varchar,
  p_email1 varchar,
  p_email1_orig varchar,
  p_email2 varchar,
  p_email3 varchar,
  p_extension varchar,
  p_fecha_nacimiento date,
  p_fecha_registro date,
  p_fecha_ultima_modificacion date,
  p_genero varchar,
  p_hora_registro time,
  p_hora_ultima_modificacion time,
  p_nombre varchar,
  p_nombre_foto varchar,
  p_nro_registro varchar,
  p_numero bigint,
  p_observaciones text,
  p_pag_web varchar,
  p_telefono1 varchar,
  p_telefono2 varchar
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
			v_id_persona int4;
			v_apellido_materno varchar;
			v_apellido_paterno varchar;
			v_celular1 varchar;
			v_celular2 varchar;
			v_ci varchar;
			v_correo varchar;
			v_direccion varchar;
			v_estado_reg varchar;
			v_extension varchar;
			v_fecha_mod timestamp;
			v_fecha_nacimiento date;
			v_fecha_reg timestamp;
			v_foto bytea;
			v_genero varchar;
			v_id_usuario_mod int4;
			v_id_usuario_reg int4;
			v_nombre varchar;
			v_num_documento int4;
			v_telefono1 varchar;
			v_telefono2 varchar;
BEGIN
			
			
			          --funcion para obtener cadena de conexion
			          v_cadena_cnx =  migracion.f_obtener_cadena_con_dblink();
			          
			          
			           ---------------------------------------
			           --previamente se tranforman los datos  (descomentar)
			           ---------------------------------------


			v_id_persona=p_id_persona::int4;
			v_apellido_materno=convert(p_apellido_materno::varchar, 'LATIN1', 'UTF8');
			v_apellido_paterno=convert(p_apellido_paterno::varchar, 'LATIN1', 'UTF8');
			v_celular1=convert(p_celular1::varchar, 'LATIN1', 'UTF8');
			v_celular2=convert(p_celular2::varchar, 'LATIN1', 'UTF8');
			v_ci=convert(p_doc_id::varchar, 'LATIN1', 'UTF8');
			v_correo=convert(p_email1::varchar, 'LATIN1', 'UTF8');
			v_direccion=convert(p_direccion::varchar, 'LATIN1', 'UTF8');
			v_estado_reg=convert('activo'::varchar, 'LATIN1', 'UTF8');
			v_extension=convert(p_extension::varchar, 'LATIN1', 'UTF8');
			v_fecha_mod=p_fecha_ultima_modificacion::timestamp;
			v_fecha_nacimiento=p_fecha_nacimiento::date;
			v_fecha_reg=p_fecha_registro::timestamp;
			v_genero=substr(convert(p_genero::varchar, 'LATIN1', 'UTF8')::varchar,0,1);
			v_id_usuario_mod=NULL::int4;
			v_id_usuario_reg=1::int4;
			v_nombre=convert(p_nombre::varchar, 'LATIN1', 'UTF8');
			v_num_documento=NULL::int4;
			v_telefono1=convert(p_telefono1::varchar, 'LATIN1', 'UTF8');
			v_telefono2=convert(p_telefono2::varchar, 'LATIN1', 'UTF8');

			    --cadena para la llamada a la funcion de insercion en la base de datos destino
			      
			        
			          v_consulta = 'select migra.f__on_trig_tsg_persona_tpersona (
			               '''||v_operacion::varchar||''','||COALESCE(v_id_persona::varchar,'NULL')||','||COALESCE(''''||v_apellido_materno::varchar||'''','NULL')||','||COALESCE(''''||v_apellido_paterno::varchar||'''','NULL')||','||COALESCE(''''||v_celular1::varchar||'''','NULL')||','||COALESCE(''''||v_celular2::varchar||'''','NULL')||','||COALESCE(''''||v_ci::varchar||'''','NULL')||','||COALESCE(''''||v_correo::varchar||'''','NULL')||','||COALESCE(''''||v_direccion::varchar||'''','NULL')||','||COALESCE(''''||v_estado_reg::varchar||'''','NULL')||','||COALESCE(''''||v_extension::varchar||'''','NULL')||','||COALESCE(''''||v_fecha_mod::varchar||'''','NULL')||','||COALESCE(''''||v_fecha_nacimiento::varchar||'''','NULL')||','||COALESCE(''''||v_fecha_reg::varchar||'''','NULL')||','||COALESCE(''''||v_genero::varchar||'''','NULL')||','||COALESCE(v_id_usuario_mod::varchar,'NULL')||','||COALESCE(v_id_usuario_reg::varchar,'NULL')||','||COALESCE(''''||v_nombre::varchar||'''','NULL')||','||COALESCE(v_num_documento::varchar,'NULL')||','||COALESCE(''''||v_telefono1::varchar||'''','NULL')||','||COALESCE(''''||v_telefono2::varchar||'''','NULL')||')';
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