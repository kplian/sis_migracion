
		CREATE OR REPLACE FUNCTION migracion.f_tri_tpm_empresa_tempresa ()
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
		   
			 v_consulta =  'SELECT migracion.f_trans_tpm_empresa_tempresa (
                  '''||TG_OP::varchar||''','||COALESCE(''''||NEW.codigo::varchar||'''','NULL')||','||COALESCE(NEW.id_empresa::varchar,'NULL')||','||COALESCE(NEW.id_institucion::varchar,'NULL')||','||COALESCE(''''||NEW.denominacion::varchar||'''','NULL')||','||COALESCE(NEW.dir_adm::varchar,'NULL')||','||COALESCE(NEW.nro_nit::varchar,'NULL')||','||COALESCE(''''||NEW.razon_social::varchar||'''','NULL')||') as res';				  
		  ELSE 
		      v_consulta =  ' SELECT migracion.f_trans_tpm_empresa_tempresa (
		              '''||TG_OP::varchar||''',NULL,'||OLD.id_empresa||',NULL,NULL,NULL,NULL,NULL) as res';
		       
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