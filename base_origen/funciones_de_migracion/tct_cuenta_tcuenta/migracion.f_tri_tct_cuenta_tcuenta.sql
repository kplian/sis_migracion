CREATE OR REPLACE FUNCTION migracion.f_tri_tct_cuenta_tcuenta (
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
		   
			 v_consulta =  'SELECT migracion.f_trans_tct_cuenta_tcuenta (
                  '''||TG_OP::varchar||''','||COALESCE(''''||NEW.nro_cuenta::varchar||'''','NULL')||','||COALESCE(NEW.id_cuenta::varchar,'NULL')||','||COALESCE(NEW.id_auxiliar_actualizacion::varchar,'NULL')||','||COALESCE(NEW.id_auxiliar_dif::varchar,'NULL')||','||COALESCE(NEW.id_cuenta_actualizacion::varchar,'NULL')||','||COALESCE(NEW.id_cuenta_dif::varchar,'NULL')||','||COALESCE(NEW.id_cuenta_padre::varchar,'NULL')||','||COALESCE(NEW.id_cuenta_sigma::varchar,'NULL')||','||COALESCE(NEW.id_moneda::varchar,'NULL')||','||COALESCE(NEW.id_parametro::varchar,'NULL')||','||COALESCE(''''||NEW.cuenta_flujo_sigma::varchar||'''','NULL')||','||COALESCE(''''||NEW.cuenta_sigma::varchar||'''','NULL')||','||COALESCE(''''||NEW.desc_cuenta::varchar||'''','NULL')||','||COALESCE(''''||NEW.descripcion::varchar||'''','NULL')||','||COALESCE(NEW.nivel_cuenta::varchar,'NULL')||','||COALESCE(''''||NEW.nombre_cuenta::varchar||'''','NULL')||','||COALESCE(NEW.sw_aux::varchar,'NULL')||','||COALESCE(NEW.sw_oec::varchar,'NULL')||','||COALESCE(''''||NEW.sw_sigma::varchar||'''','NULL')||','||COALESCE(''''||NEW.sw_sistema_actualizacion::varchar||'''','NULL')||','||COALESCE(NEW.sw_transaccional::varchar,'NULL')||','||COALESCE(NEW.tipo_cuenta::varchar,'NULL')||','||COALESCE(''''||NEW.tipo_cuenta_pat::varchar||'''','NULL')||') as res';				  
		  ELSE 
		      v_consulta =  ' SELECT migracion.f_trans_tct_cuenta_tcuenta (
		              '''||TG_OP::varchar||''',NULL,'||OLD.id_cuenta||',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) as res';
		       
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