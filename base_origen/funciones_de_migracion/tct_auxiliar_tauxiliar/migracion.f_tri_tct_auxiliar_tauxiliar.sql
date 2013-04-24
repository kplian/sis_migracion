CREATE OR REPLACE FUNCTION migracion.f_tri_tct_auxiliar_tauxiliar (
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
		   
			 v_consulta =  'SELECT migracion.f_trans_tct_auxiliar_tauxiliar (
                  '''||TG_OP::varchar||''','||COALESCE(''''||NEW.nombre_auxiliar::varchar||'''','NULL')||','||COALESCE(NEW.id_auxiliar::varchar,'NULL')||','||COALESCE(''''||NEW.codigo_auxiliar::varchar||'''','NULL')||','||COALESCE(NEW.estado_auxiliar::varchar,'NULL')||','||COALESCE(''''||NEW.fecha_reg::varchar||'''','NULL')||','||COALESCE(''''||NEW.usuario_reg::varchar||'''','NULL')||') as res';				  
		  ELSE 
		      v_consulta =  ' SELECT migracion.f_trans_tct_auxiliar_tauxiliar (
		              '''||TG_OP::varchar||''',NULL,'||OLD.id_auxiliar||',NULL,NULL,NULL,NULL) as res';
		       
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