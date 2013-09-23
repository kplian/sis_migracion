CREATE OR REPLACE FUNCTION migracion.f_tri_tsg_lugar_tlugar (
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
		   
			 v_consulta =  'SELECT migracion.f_trans_tsg_lugar_tlugar (
                  '''||TG_OP::varchar||''','||COALESCE(''''||NEW.nombre::varchar||'''','NULL')||','||COALESCE(NEW.id_lugar::varchar,'NULL')||','||COALESCE(''''||NEW.codigo::varchar||'''','NULL')||','||COALESCE(NEW.fk_id_lugar::varchar,'NULL')||','||COALESCE(NEW.nivel::varchar,'NULL')||','||COALESCE(''''||NEW.prioridad_kard::varchar||'''','NULL')||','||COALESCE(''''||NEW.sw_impuesto::varchar||'''','NULL')||','||COALESCE(''''||NEW.sw_municipio::varchar||'''','NULL')||') as res';				  
		  ELSE 
		      v_consulta =  ' SELECT migracion.f_trans_tsg_lugar_tlugar (
		              '''||TG_OP::varchar||''',NULL,'||OLD.id_lugar||',NULL,NULL,NULL,NULL,NULL,NULL) as res';
		       
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