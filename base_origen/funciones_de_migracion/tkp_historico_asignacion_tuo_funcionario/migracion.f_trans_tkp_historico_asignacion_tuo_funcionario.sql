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
			v_id_uo_funcionario int4;
			v_id_funcionario int4;
			v_id_uo int4;
			v_estado_reg varchar;
			v_fecha_asignacion date;
			v_fecha_finalizacion date;
			v_fecha_mod timestamp;
			v_fecha_reg timestamp;
			v_id_usuario_mod int4;
			v_id_usuario_reg int4;
			v_nro_documento_asignacion varchar;
			v_id_cargo integer;
			v_fecha_documento_asignacion date;
			v_observaciones_finalizacion varchar;
            v_id_oficina integer;
BEGIN
			
			
			          --funcion para obtener cadena de conexion
			          v_cadena_cnx =  migracion.f_obtener_cadena_con_dblink();
			          
			          
			           ---------------------------------------
			           --previamente se tranforman los datos  (descomentar)
			           ---------------------------------------

			           
			v_id_uo_funcionario=p_id_historico_asignacion::int4;
			v_id_funcionario=p_id_empleado::int4;
			v_id_uo=p_id_unidad_organizacional::int4;
			v_id_cargo=p_id_item::int4;
			v_estado_reg=convert(case when p_estado = 'eliminado' then 'inactivo' else 'activo' end::varchar, 'LATIN1', 'UTF8');
			v_estado_reg=convert(case when p_estado = 'eliminado' then 'inactivo' else 'activo' end::varchar, 'LATIN1', 'UTF8');
			v_nro_documento_asignacion = convert(p_nro_resolucion_memo::varchar, 'LATIN1', 'UTF8');
			v_fecha_documento_asignacion = p_fecha_memo::date;
			v_observaciones_finalizacion = convert(case when p_motivo_retiro = 'RETIRO' then 'retiro'
														when p_motivo_retiro = 'TRANSFERENCIA' then 'transferencia'
														when p_motivo_retiro = 'PROMOCION' then 'promocion'  
													else 'fin contrato' end::varchar, 'LATIN1', 'UTF8');
			v_fecha_asignacion=p_fecha_asignacion::date;
			v_fecha_finalizacion=p_fecha_finalizacion::date;
			v_fecha_mod=p_fecha_ultima_mod::timestamp;
			v_fecha_reg=p_fecha_registro::timestamp;
			v_id_usuario_mod=p_id_usuario_mod::int4;
			v_id_usuario_reg=p_id_usuario_reg::int4;
 			
            select id_oficina into v_id_oficina
            from kard.tkp_empleado
            where id_empleado = p_id_empleado;
			    --cadena para la llamada a la funcion de insercion en la base de datos destino
			      
			        
			          v_consulta = 'select migra.f__on_trig_tkp_historico_asignacion_tuo_funcionario (
			               '''||v_operacion::varchar||''','||COALESCE(v_id_uo_funcionario::varchar,'NULL')||','||COALESCE(v_id_funcionario::varchar,'NULL')||','||COALESCE(v_id_uo::varchar,'NULL')||','||COALESCE(''''||v_estado_reg::varchar||'''','NULL')||','||COALESCE(''''||v_fecha_asignacion::varchar||'''','NULL')||','||COALESCE(''''||v_fecha_finalizacion::varchar||'''','NULL')||','||COALESCE(''''||v_fecha_mod::varchar||'''','NULL')||','||COALESCE(''''||v_fecha_reg::varchar||'''','NULL')||','||COALESCE(v_id_usuario_mod::varchar,'NULL')||','||COALESCE(v_id_usuario_reg::varchar,'NULL')||','||COALESCE(v_id_cargo::varchar,'NULL')||','||COALESCE(''''||v_nro_documento_asignacion::varchar||'''','NULL')||','||COALESCE(''''||v_fecha_documento_asignacion::varchar||'''','NULL')||','||
                           COALESCE(''''||v_observaciones_finalizacion::varchar||'''','NULL')||','||COALESCE(v_id_oficina::varchar,'NULL')||')';
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