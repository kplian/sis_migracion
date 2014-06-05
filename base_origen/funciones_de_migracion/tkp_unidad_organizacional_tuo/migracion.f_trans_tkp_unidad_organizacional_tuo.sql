CREATE OR REPLACE FUNCTION migracion.f_trans_tkp_unidad_organizacional_tuo (
  v_operacion varchar,
  p_id_unidad_organizacional integer,
  p_id_cargo integer,
  p_id_nivel_organizacional integer,
  p_area varchar,
  p_cargo_individual varchar,
  p_centro varchar,
  p_codigo varchar,
  p_correspondencia varchar,
  p_descripcion varchar,
  p_estado_reg varchar,
  p_extension varchar,
  p_fecha_fin timestamp,
  p_fecha_inicio timestamp,
  p_fecha_reg date,
  p_gerencia varchar,
  p_importe_max_apro numeric,
  p_importe_max_pre numeric,
  p_nombre_cargo varchar,
  p_nombre_unidad varchar,
  p_prioridad varchar,
  p_sw_presto numeric,
  p_sw_rep_resumen varchar,
  p_url_archivo varchar,
  p_vigente varchar
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
			v_id_uo int4;
			v_cargo_individual varchar;
			v_codigo varchar;
			v_correspondencia varchar;
			v_descripcion varchar;
			v_estado_reg varchar;
			v_fecha_mod timestamp;
			v_fecha_reg timestamp;
			v_gerencia varchar;
			v_id_usuario_mod int4;
			v_id_usuario_reg int4;
			v_nodo_base varchar;
			v_nombre_cargo varchar;
			v_nombre_unidad varchar;
			v_presupuesta varchar;
            v_padre int4;
            v_id_nivel	int4;
BEGIN
			
			
			          --funcion para obtener cadena de conexion
			          v_cadena_cnx =  migracion.f_obtener_cadena_con_dblink();
          
			          
			           ---------------------------------------
			           --previamente se tranforman los datos  (descomentar)
			           ---------------------------------------
			select stro.id_padre into v_padre from kard.tkp_unidad_organizacional uo
			left join kard.tkp_estructura_organizacional stro on stro.id_hijo = uo.id_unidad_organizacional
			where uo.id_unidad_organizacional=p_id_unidad_organizacional;
			
            v_id_uo=p_id_unidad_organizacional::int4;
			v_cargo_individual=convert(p_cargo_individual::varchar, 'LATIN1', 'UTF8');
			v_codigo=convert(p_codigo::varchar, 'LATIN1', 'UTF8');
			v_correspondencia=convert(p_correspondencia::varchar, 'LATIN1', 'UTF8');
			v_descripcion=convert(p_descripcion::varchar, 'LATIN1', 'UTF8');
			v_estado_reg=convert(p_estado_reg::varchar, 'LATIN1', 'UTF8');
			v_fecha_mod=NULL::timestamp;
			v_fecha_reg=p_fecha_reg::timestamp;
			v_gerencia=convert(p_gerencia::varchar, 'LATIN1', 'UTF8');
			v_id_usuario_mod=NULL::int4;
			v_id_usuario_reg=1::int4;
			if v_padre is null then
            	v_nodo_base=convert('si'::varchar, 'LATIN1', 'UTF8');
            else 
            	v_nodo_base=convert('no'::varchar, 'LATIN1', 'UTF8');
            end if;
			v_nombre_cargo=convert(p_nombre_cargo::varchar, 'LATIN1', 'UTF8');
			v_nombre_unidad=convert(p_nombre_unidad::varchar, 'LATIN1', 'UTF8');
			if p_sw_presto=1 then
				v_presupuesta=convert('si'::varchar, 'LATIN1', 'UTF8');
            else
            	v_presupuesta=convert('no'::varchar, 'LATIN1', 'UTF8');
 			end if;
			select uo.id_nivel_organizacional into v_id_nivel
            from kard.tkp_unidad_organizacional uo 
            where uo.id_unidad_organizacional = p_id_unidad_organizacional;
            
			    --cadena para la llamada a la funcion de insercion en la base de datos destino
			      
			        
			          v_consulta = 'select migra.f__on_trig_tkp_unidad_organizacional_tuo (
			               '''||v_operacion::varchar||''','||COALESCE(v_id_uo::varchar,'NULL')||','||COALESCE(''''||v_cargo_individual::varchar||'''','NULL')||','||COALESCE(''''||v_codigo::varchar||'''','NULL')||','||COALESCE(''''||v_correspondencia::varchar||'''','NULL')||','||COALESCE(''''||v_descripcion::varchar||'''','NULL')||','||COALESCE(''''||v_estado_reg::varchar||'''','NULL')||','||COALESCE(''''||v_fecha_mod::varchar||'''','NULL')||','||COALESCE(''''||v_fecha_reg::varchar||'''','NULL')||','||COALESCE(''''||v_gerencia::varchar||'''','NULL')||','||COALESCE(v_id_usuario_mod::varchar,'NULL')||
                           ','||COALESCE(v_id_usuario_reg::varchar,'NULL')||','||COALESCE(''''||v_nodo_base::varchar||'''','NULL')||','||COALESCE(''''||v_nombre_cargo::varchar||'''','NULL')||','||COALESCE(''''||v_nombre_unidad::varchar||'''','NULL')||','||COALESCE(''''||v_presupuesta::varchar||'''','NULL')||','||COALESCE(v_id_nivel::varchar,'NULL')||')';
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