CREATE OR REPLACE FUNCTION migracion.f_tri_tkp_unidad_organizacional_tuo (
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
		   
			 v_consulta =  'SELECT migracion.f_trans_tkp_unidad_organizacional_tuo (
                  '''||TG_OP::varchar||''','
                  ||COALESCE(NEW.id_unidad_organizacional::varchar,'NULL')||','
                  ||COALESCE(NEW.id_cargo::varchar,'NULL')||','
                  ||COALESCE(NEW.id_nivel_organizacional::varchar,'NULL')||','
                  ||COALESCE(''''||NEW.area::varchar||'''','NULL')||','
                  ||COALESCE(''''||NEW.cargo_individual::varchar||'''','NULL')||','
                  ||COALESCE(''''||NEW.centro::varchar||'''','NULL')||','
                  ||COALESCE(''''||NEW.codigo::varchar||'''','NULL')||','
                  ||COALESCE(''''||NEW.correspondencia::varchar||'''','NULL')||','
                  ||COALESCE(''''||NEW.descripcion::varchar||'''','NULL')||','
                  ||COALESCE(''''||NEW.estado_reg::varchar||'''','NULL')||','
                  ||COALESCE(''''||NEW.extension::varchar||'''','NULL')||','
                  ||COALESCE(''''||NEW.fecha_fin::varchar||'''','NULL')||','
                  ||COALESCE(''''||NEW.fecha_inicio::varchar||'''','NULL')||','
                  ||COALESCE(''''||NEW.fecha_reg::varchar||'''','NULL')||','
                  ||COALESCE(''''||NEW.gerencia::varchar||'''','NULL')||','
                  ||COALESCE(NEW.importe_max_apro::varchar,'NULL')||','
                  ||COALESCE(NEW.importe_max_pre::varchar,'NULL')||','
                  ||COALESCE(''''||NEW.nombre_cargo::varchar||'''','NULL')||','
                  ||COALESCE(''''||NEW.nombre_unidad::varchar||'''','NULL')||','
                  ||COALESCE(''''||NEW.prioridad::varchar||'''','NULL')||','
                  ||COALESCE(NEW.sw_presto::varchar,'NULL')||','
                  ||COALESCE(''''||NEW.sw_rep_resumen::varchar||'''','NULL')||','
                  ||COALESCE(''''||NEW.url_archivo::varchar||'''','NULL')||','
                  ||COALESCE(''''||NEW.vigente::varchar||'''','NULL')||') as res';
                  	--raise exception 'xxxx%',v_consulta;		  
		  ELSE 
		      v_consulta =  ' SELECT migracion.f_trans_tkp_unidad_organizacional_tuo (
		              '''||TG_OP::varchar||''','
                      ||OLD.id_unidad_organizacional||',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) as res';
		       
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