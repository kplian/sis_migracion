CREATE OR REPLACE FUNCTION migracion.f_tri_tsg_persona_tpersona (
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
		   
			 v_consulta =  'SELECT migracion.f_trans_tsg_persona_tpersona (
                  '''||TG_OP::varchar||''','||COALESCE(''''||NEW.apellido_paterno::varchar||'''','NULL')||','||COALESCE(NEW.id_persona::varchar,'NULL')||','||COALESCE(NEW.id_tipo_doc_identificacion::varchar,'NULL')||','||COALESCE(''''||NEW.apellido_materno::varchar||'''','NULL')||','||COALESCE(''''||NEW.casilla::varchar||'''','NULL')||','||COALESCE(''''||NEW.celular1::varchar||'''','NULL')||','||COALESCE(''''||NEW.celular2::varchar||'''','NULL')||','||COALESCE(''''||NEW.direccion::varchar||'''','NULL')||','||COALESCE(''''||NEW.doc_id::varchar||'''','NULL')||','||COALESCE(''''||NEW.email1::varchar||'''','NULL')||','||COALESCE(''''||NEW.email1_orig::varchar||'''','NULL')||','||COALESCE(''''||NEW.email2::varchar||'''','NULL')||','||COALESCE(''''||NEW.email3::varchar||'''','NULL')||','||COALESCE(''''||NEW.extension::varchar||'''','NULL')||','||COALESCE(''''||NEW.fecha_nacimiento::varchar||'''','NULL')||','||COALESCE(''''||NEW.fecha_registro::varchar||'''','NULL')||','||COALESCE(''''||NEW.fecha_ultima_modificacion::varchar||'''','NULL')||','||COALESCE(''''||NEW.genero::varchar||'''','NULL')||','||COALESCE(''''||NEW.hora_registro::varchar||'''','NULL')||','||COALESCE(''''||NEW.hora_ultima_modificacion::varchar||'''','NULL')||','||COALESCE(''''||NEW.nombre::varchar||'''','NULL')||','||COALESCE(''''||NEW.nombre_foto::varchar||'''','NULL')||','||COALESCE(''''||NEW.nro_registro::varchar||'''','NULL')||','||COALESCE(NEW.numero::varchar,'NULL')||','||COALESCE(''''||NEW.observaciones::varchar||'''','NULL')||','||COALESCE(''''||NEW.pag_web::varchar||'''','NULL')||','||COALESCE(''''||NEW.telefono1::varchar||'''','NULL')||','||COALESCE(''''||NEW.telefono2::varchar||'''','NULL')||') as res';				  
		  ELSE 
		      v_consulta =  ' SELECT migracion.f_trans_tsg_persona_tpersona (
		              '''||TG_OP::varchar||''',NULL,'||OLD.id_persona||',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) as res';
		       
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