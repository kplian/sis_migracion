CREATE OR REPLACE FUNCTION migracion.f_trans_tad_proveedor_tproveedor (
  v_operacion varchar,
  p_id_proveedor integer,
  p_id_lugar integer,
  p_id_supergrupo integer,
  p_id_tipo_servicio integer,
  p_id_usuario_reg integer,
  p_codigo varchar,
  p_confirmado varchar,
  p_contrasena varchar,
  p_fecha_reg date,
  p_id_institucion integer,
  p_id_persona integer,
  p_nombre_pago varchar,
  p_observaciones varchar,
  p_rubro text,
  p_rubro1 text,
  p_rubro2 text,
  p_tipo varchar,
  p_usuario varchar
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
			v_id_proveedor int4;
			v_id_institucion int4;
			v_id_persona int4;
			v_codigo varchar;
			v_estado_reg varchar;
			v_fecha_mod timestamp;
			v_fecha_reg timestamp;
			v_id_lugar int4;
			v_id_usuario_mod int4;
			v_id_usuario_reg int4;
			v_nit varchar;
			v_numero_sigma varchar;
			v_tipo varchar;
            v_doc_id	varchar;
BEGIN
			
			
			          --funcion para obtener cadena de conexion
			          v_cadena_cnx =  migracion.f_obtener_cadena_con_dblink();
			          
			          
			           ---------------------------------------
			           --previamente se tranforman los datos  (descomentar)
			           ---------------------------------------
						
			select inst.doc_id into v_doc_id from compro.tad_proveedor prov
			left join param.tpm_institucion inst on inst.id_institucion=prov.id_institucion
			where prov.id_institucion=p_id_institucion;
			v_id_proveedor=p_id_proveedor::int4;
			v_id_institucion=p_id_institucion::int4;
			v_id_persona=p_id_persona::int4;
			v_codigo=convert(p_codigo::varchar, 'LATIN1', 'UTF8');
			v_estado_reg=convert('activo'::varchar, 'LATIN1', 'UTF8');
			v_fecha_mod=NULL::timestamp;
			v_fecha_reg=p_fecha_reg::timestamp;
			v_id_lugar=p_id_lugar::int4;
			v_id_usuario_mod=NULL::int4;
            if p_id_usuario_reg is NULL then
				v_id_usuario_reg=1::int4;
            else
          		v_id_usuario_reg=p_id_usuario_reg::int4;
	        end if;
			if(v_doc_id='xxx' OR v_doc_id='sss' OR v_doc_id=0 OR v_doc_id=1)then 
                v_nit=convert(NULL::varchar, 'LATIN1', 'UTF8');
            else	
				v_nit=convert(v_doc_id::varchar, 'LATIN1', 'UTF8');
			end if;           
			v_numero_sigma=convert(NULL::varchar, 'LATIN1', 'UTF8');
			v_tipo=convert(p_tipo::varchar, 'LATIN1', 'UTF8');
    
			    --cadena para la llamada a la funcion de insercion en la base de datos destino
			      
			        
			          v_consulta = 'select migra.f__on_trig_tad_proveedor_tproveedor (
			               '''||v_operacion::varchar||''','||COALESCE(v_id_proveedor::varchar,'NULL')||','||COALESCE(v_id_institucion::varchar,'NULL')||','||COALESCE(v_id_persona::varchar,'NULL')||','||COALESCE(''''||v_codigo::varchar||'''','NULL')||','||COALESCE(''''||v_estado_reg::varchar||'''','NULL')||','||COALESCE(''''||v_fecha_mod::varchar||'''','NULL')||','||COALESCE(''''||v_fecha_reg::varchar||'''','NULL')||','||COALESCE(v_id_lugar::varchar,'NULL')||','||COALESCE(v_id_usuario_mod::varchar,'NULL')||','||COALESCE(v_id_usuario_reg::varchar,'NULL')||','||COALESCE(''''||v_nit::varchar||'''','NULL')||','||COALESCE(''''||v_numero_sigma::varchar||'''','NULL')||','||COALESCE(''''||v_tipo::varchar||'''','NULL')||')';
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