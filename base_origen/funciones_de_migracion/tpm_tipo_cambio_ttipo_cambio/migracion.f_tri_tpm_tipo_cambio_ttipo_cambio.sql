
		CREATE OR REPLACE FUNCTION migracion.f_tri_tpm_tipo_cambio_ttipo_cambio ()
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
		   
			 v_consulta =  'SELECT migracion.f_trans_tpm_tipo_cambio_ttipo_cambio (
                  '''||TG_OP::varchar||''','||COALESCE(NEW.id_tipo_cambio::varchar,'NULL')||','||COALESCE(NEW.compra::varchar,'NULL')||','||COALESCE(''''||NEW.estado::varchar||'''','NULL')||','||COALESCE(''''||NEW.fecha::varchar||'''','NULL')||','||COALESCE(''''||NEW.fecha_reg::varchar||'''','NULL')||','||COALESCE(''''||NEW.hora::varchar||'''','NULL')||','||COALESCE(NEW.id_moneda::varchar,'NULL')||','||COALESCE(''''||NEW.observaciones::varchar||'''','NULL')||','||COALESCE(NEW.oficial::varchar,'NULL')||','||COALESCE(NEW.venta::varchar,'NULL')||') as res';				  
		  ELSE 
		      v_consulta =  ' SELECT migracion.f_trans_tpm_tipo_cambio_ttipo_cambio (
		              '''||TG_OP::varchar||''','||OLD.id_tipo_cambio||',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) as res';
		       
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