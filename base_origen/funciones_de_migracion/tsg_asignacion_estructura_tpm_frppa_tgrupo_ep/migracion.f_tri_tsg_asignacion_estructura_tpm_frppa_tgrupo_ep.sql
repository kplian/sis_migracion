
		CREATE OR REPLACE FUNCTION migracion.f_tri_tsg_asignacion_estructura_tpm_frppa_tgrupo_ep ()
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
		   
			 v_consulta =  'SELECT migracion.f_trans_tsg_asignacion_estructura_tpm_frppa_tgrupo_ep (
                  '''||TG_OP::varchar||''','||COALESCE(NEW.id_asignacion_estructura_frppa::varchar,'NULL')||','||COALESCE(NEW.id_asignacion_estructura::varchar,'NULL')||','||COALESCE(NEW.id_fina_regi_prog_proy_acti::varchar,'NULL')||','||COALESCE(''''||NEW.fecha_registro::varchar||'''','NULL')||','||COALESCE(''''||NEW.hora_registro::varchar||'''','NULL')||') as res';				  
		  ELSE 
		      v_consulta =  ' SELECT migracion.f_trans_tsg_asignacion_estructura_tpm_frppa_tgrupo_ep (
		              '''||TG_OP::varchar||''','||OLD.id_asignacion_estructura_frppa||',NULL,NULL,NULL,NULL) as res';
		       
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