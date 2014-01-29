CREATE OR REPLACE FUNCTION migracion.f_trans_tts_libro_bancos_tts_libro_bancos (
  v_operacion varchar,
  p_id_cuenta_bancaria integer,
  p_id_libro_bancos integer,
  p_fk_libro_bancos integer,
  p_id_cuenta_bancaria integer,
  p_a_favor varchar,
  p_detalle text,
  p_estado varchar,
  p_fecha date,
  p_fecha_mod timestamp,
  p_fecha_reg timestamp,
  p_importe_cheque numeric,
  p_importe_deposito numeric,
  p_indice numeric,
  p_nro_cheque integer,
  p_nro_comprobante varchar,
  p_nro_liquidacion varchar,
  p_observaciones text,
  p_origen varchar,
  p_tipo varchar,
  p_usr_mod varchar,
  p_usr_reg varchar
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
			v_id_libro_bancos int4;
			v_a_favor varchar;
			v_detalle text;
			v_estado varchar;
			v_estado_reg varchar;
			v_fecha date;
			v_fecha_mod timestamp;
			v_fecha_reg timestamp;
			v_id_libro_bancos_fk int4;
			v_id_usuario_mod int4;
			v_id_usuario_reg int4;
			v_importe_cheque numeric;
			v_importe_deposito numeric;
			v_indice numeric;
			v_nro_cheque int4;
			v_nro_comprobante varchar;
			v_nro_liquidacion varchar;
			v_observaciones text;
			v_origen varchar;
			v_tipo varchar;
            v_nro_cuenta varchar;
BEGIN
			
			
			          --funcion para obtener cadena de conexion
			          v_cadena_cnx =  migracion.f_obtener_cadena_con_dblink();
			          
			          
			           ---------------------------------------
			           --previamente se tranforman los datos  (descomentar)
			           ---------------------------------------
			select cb.nro_cuenta_banco into v_nro_cuenta
            from tesoro.tts_cuenta_bancaria cb
            where id_cuenta_bancaria = p_id_cuenta_bancaria;
			
            v_nro_cuenta=convert(v_nro_cuenta::varchar, 'LATIN1', 'UTF8');
			v_id_libro_bancos=p_id_libro_bancos::int4;
			v_a_favor=convert(p_a_favor::varchar, 'LATIN1', 'UTF8');
			v_detalle=convert(p_detalle::text, 'LATIN1', 'UTF8');
			v_estado=convert(p_estado::varchar, 'LATIN1', 'UTF8');
			v_estado_reg=convert('activo'::varchar, 'LATIN1', 'UTF8');
			v_fecha=p_fecha::date;
			v_fecha_mod=p_fecha_mod::timestamp;
			v_fecha_reg=p_fecha_reg::timestamp;
			v_id_libro_bancos_fk=p_fk_libro_bancos::int4;
			v_id_usuario_mod=1::int4;
			v_id_usuario_reg=1::int4;
			v_importe_cheque=p_importe_cheque::numeric;
			v_importe_deposito=p_importe_deposito::numeric;
			v_indice=p_indice::numeric;
			v_nro_cheque=p_nro_cheque::int4;
			v_nro_comprobante=convert(p_nro_comprobante::varchar, 'LATIN1', 'UTF8');
			v_nro_liquidacion=convert(p_nro_liquidacion::varchar, 'LATIN1', 'UTF8');
			v_observaciones=convert(p_observaciones::text, 'LATIN1', 'UTF8');
			v_origen=convert(p_origen::varchar, 'LATIN1', 'UTF8');
			v_tipo=convert(p_tipo::varchar, 'LATIN1', 'UTF8');
   
			    --cadena para la llamada a la funcion de insercion en la base de datos destino
			      
			        
			          v_consulta = 'select migra.f__on_trig_tts_libro_bancos_tts_libro_bancos (
			               '''||v_operacion::varchar||''','||COALESCE(''''||v_nro_cuenta::varchar||'''','NULL')||','||COALESCE(v_id_libro_bancos::varchar,'NULL')||','||COALESCE(''''||v_a_favor::varchar||'''','NULL')||','||COALESCE(''''||v_detalle::varchar||'''','NULL')||','||COALESCE(''''||v_estado::varchar||'''','NULL')||','||COALESCE(''''||v_estado_reg::varchar||'''','NULL')||','||COALESCE(''''||v_fecha::varchar||'''','NULL')||','||COALESCE(''''||v_fecha_mod::varchar||'''','NULL')||','||COALESCE(''''||v_fecha_reg::varchar||'''','NULL')||','||COALESCE(v_id_libro_bancos_fk::varchar,'NULL')||','||COALESCE(v_id_usuario_mod::varchar,'NULL')||','||COALESCE(v_id_usuario_reg::varchar,'NULL')||','||COALESCE(v_importe_cheque::varchar,'NULL')||','||COALESCE(v_importe_deposito::varchar,'NULL')||','||COALESCE(v_indice::varchar,'NULL')||','||COALESCE(v_nro_cheque::varchar,'NULL')||','||COALESCE(''''||v_nro_comprobante::varchar||'''','NULL')||','||COALESCE(''''||v_nro_liquidacion::varchar||'''','NULL')||','||COALESCE(''''||v_observaciones::varchar||'''','NULL')||','||COALESCE(''''||v_origen::varchar||'''','NULL')||','||COALESCE(''''||v_tipo::varchar||'''','NULL')||')';
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