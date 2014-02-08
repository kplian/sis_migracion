CREATE OR REPLACE FUNCTION migracion.f_tri_tad_proveedor_tproveedor (
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
		   
			 v_consulta =  'SELECT migracion.f_trans_tad_proveedor_tproveedor (
                  '''||TG_OP::varchar||''','||COALESCE(NEW.id_proveedor::varchar,'NULL')||','||
                  COALESCE(NEW.id_lugar::varchar,'NULL')||','||
                  COALESCE(NEW.id_supergrupo::varchar,'NULL')||','||
                  COALESCE(NEW.id_tipo_servicio::varchar,'NULL')||','||
                  COALESCE(NEW.id_usuario_reg::varchar,'NULL')||','||
                  COALESCE(''''||NEW.codigo::varchar||'''','NULL')||','||
                  COALESCE(''''||NEW.confirmado::varchar||'''','NULL')||','||
                  COALESCE(''''||NEW.contrasena::varchar||'''','NULL')||','||
                  COALESCE(''''||NEW.fecha_reg::varchar||'''','NULL')||','||
                  COALESCE(NEW.id_institucion::varchar,'NULL')||','||
                  COALESCE(NEW.id_persona::varchar,'NULL')||','||
                  COALESCE(''''||NEW.nombre_pago::varchar||'''','NULL')||','||
                  COALESCE(''''||NEW.observaciones::varchar||'''','NULL')||','||
                  COALESCE(''''||NEW.rubro::varchar||'''','NULL')||','||
                  COALESCE(''''||NEW.rubro1::varchar||'''','NULL')||','||
                  COALESCE(''''||NEW.rubro2::varchar||'''','NULL')||','||
                  COALESCE(''''||NEW.tipo::varchar||'''','NULL')||','||
                  COALESCE(''''||NEW.usuario::varchar||'''','NULL')||','||
                  COALESCE(''''||NEW.rotulo_comercial::varchar||'''','NULL')||') as res';				  
		  ELSE 
		      v_consulta =  ' SELECT migracion.f_trans_tad_proveedor_tproveedor (
		              '''||TG_OP::varchar||''','||OLD.id_proveedor||',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) as res';
		       
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