
		CREATE OR REPLACE FUNCTION migracion.f_tri_taf_clasificacion_tclasificacion ()
		RETURNS trigger AS
		$BODY$

DECLARE
		 
		g_registros record;
		v_consulta varchar;
		v_res_cone  varchar;
		v_cadena_cnx varchar;
		v_cadena_con varchar;
		resp boolean;
		
		BEGIN
		   IF(TG_OP = 'INSERT' or  TG_OP ='UPDATE' ) THEN
		   
			 v_consulta =  'SELECT migracion.f_trans_taf_clasificacion_tclasificacion (
                  '''||TG_OP::varchar||''','||COALESCE(''''||NEW.codigo::varchar||'''','NULL')||','||COALESCE(NEW.id_clasificacion::varchar,'NULL')||','||COALESCE(NEW.correlativo_act::varchar,'NULL')||','||COALESCE(''''||NEW.descripcion::varchar||'''','NULL')||','||COALESCE(''''||NEW.estado::varchar||'''','NULL')||','||COALESCE(''''||NEW.fecha_mod::varchar||'''','NULL')||','||COALESCE(''''||NEW.fecha_reg::varchar||'''','NULL')||','||COALESCE(NEW.fk_id_clasificacion::varchar,'NULL')||','||COALESCE(''''||NEW.flag_depreciacion::varchar||'''','NULL')||','||COALESCE(NEW.id::varchar,'NULL')||','||COALESCE(NEW.id_metodo_depreciacion::varchar,'NULL')||','||COALESCE(NEW.id_padre::varchar,'NULL')||','||COALESCE(NEW.id_usuario_mod::varchar,'NULL')||','||COALESCE(NEW.id_usuario_reg::varchar,'NULL')||','||COALESCE(NEW.ini_correlativo::varchar,'NULL')||','||COALESCE(NEW.nivel::varchar,'NULL')||','||COALESCE(''''||NEW.tipo::varchar||'''','NULL')||','||COALESCE(NEW.vida_util::varchar,'NULL')||') as res';				  
		  ELSE 
		      v_consulta =  ' SELECT migracion.f_trans_taf_clasificacion_tclasificacion (
		              '''||TG_OP::varchar||''',NULL,'||OLD.id_clasificacion||',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) as res';
		       
		   END IF;
		   --------------------------------------
		   -- PARA PROBAR SI FUNCIONA LA FUNCION DE TRANFROMACION, HABILITAR EXECUTE
		   ------------------------------------------
		     --EXECUTE (v_consulta);
		   
		   
		    INSERT INTO 
		                      migracion.tmig_migracion
		                    (
		                      verificado,
		                      consulta,
		                      operacion
		                    ) 
		                    VALUES (
		                      'no',
		                       v_consulta,
		                       TG_OP::varchar
		                       
		                    );
		
		  RETURN NULL;
		
		END;
		$BODY$LANGUAGE 'plpgsql'
		VOLATILE
		CALLED ON NULL INPUT
		SECURITY INVOKER;