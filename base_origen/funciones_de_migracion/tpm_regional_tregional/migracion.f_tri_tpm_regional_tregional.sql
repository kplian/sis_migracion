CREATE OR REPLACE FUNCTION migracion.f_tri_tpm_regional_tregional (
)
RETURNS trigger AS
$body$
DECLARE
		 
		g_registros record;
		v_consulta varchar;
		v_res_cone  varchar;
		v_cadena_cnx varchar;
		v_cadena_con varchar;
		resp boolean;
		
		BEGIN
		   IF(TG_OP = 'INSERT' or  TG_OP ='UPDATE' ) THEN
		   
			 v_consulta =  'SELECT migracion.f_trans_tpm_regional_tregional (
                  '''||TG_OP::varchar||''','||COALESCE(''''||NEW.codigo_regional::varchar||'''','NULL')||','||COALESCE(NEW.id_regional::varchar,'NULL')||','||COALESCE(NEW.id_usuario::varchar,'NULL')||','||COALESCE(''''||NEW.descripcion_regional::varchar||'''','NULL')||','||COALESCE(''''||NEW.fecha_registro::varchar||'''','NULL')||','||COALESCE(''''||NEW.fecha_ultima_modificacion::varchar||'''','NULL')||','||COALESCE(''''||NEW.hora_registro::varchar||'''','NULL')||','||COALESCE(''''||NEW.hora_ultima_modificacion::varchar||'''','NULL')||','||COALESCE(NEW.id_regional_actif::varchar,'NULL')||','||COALESCE(''''||NEW.nombre_regional::varchar||'''','NULL')||') as res';				  
		  ELSE 
		      v_consulta =  ' SELECT migracion.f_trans_tpm_regional_tregional (
		              '''||TG_OP::varchar||''',NULL,'||OLD.id_regional||',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) as res';
		       
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
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER;