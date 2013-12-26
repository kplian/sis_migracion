
		CREATE OR REPLACE FUNCTION migracion.f_tri_tpr_presupuesto_ids_tpresupuesto_ids ()
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
		   
			 v_consulta =  'SELECT migracion.f_trans_tpr_presupuesto_ids_tpresupuesto_ids (
                  '''||TG_OP::varchar||''','||COALESCE(NEW.id_presupuesto_uno::varchar,'NULL')||','||COALESCE(NEW.id_presupuesto_dos::varchar,'NULL')||','||COALESCE(NEW.id_presupuesto_uno::varchar,'NULL')||','||COALESCE(''''||NEW.sw_cambio_gestion::varchar||'''','NULL')||') as res';				  
		  ELSE 
		      v_consulta =  ' SELECT migracion.f_trans_tpr_presupuesto_ids_tpresupuesto_ids (
		              '''||TG_OP::varchar||''','||OLD.id_presupuesto_uno||',NULL,NULL,NULL) as res';
		       
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