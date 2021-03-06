CREATE OR REPLACE FUNCTION migracion.f_tri_tpr_presupuesto_tcentro_costo (
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
		   
			 v_consulta =  'SELECT migracion.f_trans_tpr_presupuesto_tcentro_costo_tpresupuesto (
                  '''||TG_OP::varchar||''','||COALESCE(NEW.id_presupuesto::varchar,'NULL')||','||COALESCE(NEW.id_concepto_colectivo::varchar,'NULL')||','||COALESCE(NEW.id_fina_regi_prog_proy_acti::varchar,'NULL')||','||COALESCE(NEW.id_fuente_financiamiento::varchar,'NULL')||','||COALESCE(NEW.id_parametro::varchar,'NULL')||','||COALESCE(''''||NEW.cod_act::varchar||'''','NULL')||','||COALESCE(''''||NEW.cod_fin::varchar||'''','NULL')||','||COALESCE(''''||NEW.cod_prg::varchar||'''','NULL')||','||COALESCE(''''||NEW.cod_proy::varchar||'''','NULL')||','||COALESCE(NEW.estado_pres::varchar,'NULL')||','||COALESCE(''''||NEW.fecha_mod::varchar||'''','NULL')||','||COALESCE(''''||NEW.fecha_presentacion::varchar||'''','NULL')||','||COALESCE(''''||NEW.fecha_reg::varchar||'''','NULL')||','||COALESCE(NEW.id_categoria_prog::varchar,'NULL')||','||COALESCE(NEW.id_unidad_organizacional::varchar,'NULL')||','||COALESCE(NEW.id_usr_mod::varchar,'NULL')||','||COALESCE(NEW.id_usr_reg::varchar,'NULL')||','||COALESCE(''''||NEW.nombre_agrupador::varchar||'''','NULL')||','||COALESCE(NEW.tipo_pres::varchar,'NULL')||') as res';				  
		  ELSE 
		      v_consulta =  ' SELECT migracion.f_trans_tpr_presupuesto_tcentro_costo_tpresupuesto (
		              '''||TG_OP::varchar||''','||OLD.id_presupuesto||',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) as res';
		       
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