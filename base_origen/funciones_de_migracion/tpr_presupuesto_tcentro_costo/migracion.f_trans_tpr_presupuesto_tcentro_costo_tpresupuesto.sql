CREATE OR REPLACE FUNCTION migracion.f_trans_tpr_presupuesto_tcentro_costo_tpresupuesto (
  v_operacion varchar,
  p_id_presupuesto integer,
  p_id_concepto_colectivo integer,
  p_id_fina_regi_prog_proy_acti integer,
  p_id_fuente_financiamiento integer,
  p_id_parametro integer,
  p_cod_act varchar,
  p_cod_fin varchar,
  p_cod_prg varchar,
  p_cod_proy varchar,
  p_estado_pres numeric,
  p_fecha_mod timestamp,
  p_fecha_presentacion date,
  p_fecha_reg timestamp,
  p_id_categoria_prog integer,
  p_id_unidad_organizacional integer,
  p_id_usr_mod integer,
  p_id_usr_reg integer,
  p_nombre_agrupador varchar,
  p_tipo_pres numeric
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
			v_id_centro_costo int4;
            v_id_presupuesto int4;
			v_cod_act varchar;
			v_cod_fin varchar;
			v_codigo varchar;
			v_cod_prg varchar;
			v_cod_pry varchar;
			v_descripcion varchar;
			v_estado_pres varchar;
			v_estado_reg varchar;
			v_fecha_mod timestamp;
			v_fecha_reg timestamp;
			v_id_categoria_prog int4;
			v_id_concepto_colectivo int4;
			v_id_ep int4;
			v_id_fuente_financiamiento int4;
			v_id_gestion int4;
			v_id_parametro int4;
			v_id_uo int4;
			v_id_usuario_mod int4;
			v_id_usuario_reg int4;
			v_nombre_agrupador varchar;
			v_tipo_pres varchar;
            
            v_aux 		varchar;            
BEGIN
			
			
			          --funcion para obtener cadena de conexion
			          v_cadena_cnx =  migracion.f_obtener_cadena_con_dblink();
			          
			          
			           ---------------------------------------
			           --previamente se tranforman los datos  (descomentar)
			           ---------------------------------------
			select par.id_gestion into v_aux from presto.tpr_presupuesto pre
			inner join presto.tpr_parametro par on par.id_parametro=pre.id_parametro where pre.id_presupuesto=p_id_presupuesto; 
			
            v_id_presupuesto=p_id_presupuesto::int4;                    
			v_id_centro_costo=p_id_presupuesto::int4;
			v_cod_act=convert(p_cod_act::varchar, 'LATIN1', 'UTF8');
			v_cod_fin=convert(p_cod_fin::varchar, 'LATIN1', 'UTF8');
			v_cod_prg=convert(p_cod_prg::varchar, 'LATIN1', 'UTF8');
			v_cod_pry=convert(p_cod_proy::varchar, 'LATIN1', 'UTF8');
            if p_estado_pres=1 then            
				v_estado_pres=convert('Formulación'::varchar, 'LATIN1', 'UTF8');
			elsif p_estado_pres=2 then
            	v_estado_pres=convert('Verificación Previa'::varchar, 'LATIN1', 'UTF8');
            elsif p_estado_pres=3 then
            	v_estado_pres=convert('Revisión Final'::varchar, 'LATIN1', 'UTF8');
            elsif p_estado_pres=4 then
            	v_estado_pres=convert('Anteproyecto'::varchar, 'LATIN1', 'UTF8');
            elsif p_estado_pres=5 then
            	v_estado_pres=convert('Aprobado'::varchar, 'LATIN1', 'UTF8');
            end if;
            v_estado_reg=convert('activo'::varchar, 'LATIN1', 'UTF8');
			v_fecha_mod=p_fecha_mod::timestamp;
			v_fecha_reg=p_fecha_reg::timestamp;
			v_id_categoria_prog=p_id_categoria_prog::int4;
			v_id_concepto_colectivo=p_id_concepto_colectivo::int4;
			v_id_ep=p_id_fina_regi_prog_proy_acti::int4;
			v_id_fuente_financiamiento=p_id_fuente_financiamiento::int4;
            v_id_gestion = v_aux::int4;
			
			v_id_parametro=p_id_parametro::int4;
			v_id_uo=p_id_unidad_organizacional::int4;
			v_id_usuario_mod=p_id_usr_mod::int4;
			v_id_usuario_reg=p_id_usr_reg::int4;
			v_tipo_pres=convert(p_tipo_pres::varchar, 'LATIN1', 'UTF8');

			    --cadena para la llamada a la funcion de insercion en la base de datos destino tcentro_costo
			      
  			          v_consulta = 'select migra.f__on_trig_tpr_presupuesto_tcentro_costo (
			               '''||v_operacion::varchar||''','||COALESCE(v_id_centro_costo::varchar,'NULL')||','||COALESCE(''''||v_estado_reg::varchar||'''','NULL')||','||COALESCE(''''||v_fecha_mod::varchar||'''','NULL')||
                           ','||COALESCE(''''||v_fecha_reg::varchar||'''','NULL')||','||COALESCE(v_id_ep::varchar,'NULL')||','||COALESCE(v_id_gestion::varchar,'NULL')||','||COALESCE(v_id_uo::varchar,'NULL')||
                           ','||COALESCE(v_id_usuario_mod::varchar,'NULL')||','||COALESCE(v_id_usuario_reg::varchar,'NULL')||')';

								        
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

			    --cadena para la llamada a la funcion de insercion en la base de datos destino tpresupuesto
                                        
                        v_consulta = 'select migra.f__on_trig_tpr_presupuesto_tpresupuesto (
			               '''||v_operacion::varchar||''','||COALESCE(v_id_presupuesto::varchar,'NULL')||','||COALESCE(v_id_centro_costo::varchar,'NULL')||
                           ','||COALESCE(''''||v_cod_act::varchar||'''','NULL')||','||COALESCE(''''||v_cod_fin::varchar||'''','NULL')||
                           ','||COALESCE(''''||v_cod_prg::varchar||'''','NULL')||','||COALESCE(''''||v_cod_pry::varchar||'''','NULL')||
                           ','||COALESCE(''''||v_estado_pres::varchar||'''','NULL')||','||COALESCE(''''||v_estado_reg::varchar||'''','NULL')||
                           ','||COALESCE(''''||v_fecha_mod::varchar||'''','NULL')||','||COALESCE(''''||v_fecha_reg::varchar||'''','NULL')||
                           ','||COALESCE(v_id_categoria_prog::varchar,'NULL')||','||COALESCE(v_id_concepto_colectivo::varchar,'NULL')||
                           ','||COALESCE(v_id_fuente_financiamiento::varchar,'NULL')||','||COALESCE(v_id_parametro::varchar,'NULL')||
                           ','||COALESCE(v_id_usuario_mod::varchar,'NULL')||','||COALESCE(v_id_usuario_reg::varchar,'NULL')||
                           ','||COALESCE(''''||v_tipo_pres::varchar||'''','NULL')||')';
			    
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