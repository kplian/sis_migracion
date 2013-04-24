CREATE OR REPLACE FUNCTION migracion.f_tri_tsg_usuario_tusuario (
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
		   
			 v_consulta =  'SELECT migracion.f_trans_tsg_usuario_tusuario (
                  '''||TG_OP::varchar||''','||COALESCE(''''||NEW.login::varchar||'''','NULL')||','||COALESCE(NEW.id_usuario::varchar,'NULL')||','||COALESCE(NEW.id_nivel_seguridad::varchar,'NULL')||','||COALESCE(NEW.id_persona::varchar,'NULL')||','||COALESCE(''''||NEW.autentificacion::varchar||'''','NULL')||','||COALESCE(''''||NEW.contrasenia::varchar||'''','NULL')||','||COALESCE(''''||NEW.estado_usuario::varchar||'''','NULL')||','||COALESCE(''''||NEW.estilo_usuario::varchar||'''','NULL')||','||COALESCE(''''||NEW.fecha_expiracion::varchar||'''','NULL')||','||COALESCE(''''||NEW.fecha_registro::varchar||'''','NULL')||','||COALESCE(''''||NEW.fecha_ultima_modificacion::varchar||'''','NULL')||','||COALESCE(''''||NEW.filtro_avanzado::varchar||'''','NULL')||','||COALESCE(''''||NEW.hora_registro::varchar||'''','NULL')||','||COALESCE(''''||NEW.hora_ultima_modificacion::varchar||'''','NULL')||','||COALESCE(''''||NEW.login_anterior::varchar||'''','NULL')||','||COALESCE(''''||NEW.login_nuevo::varchar||'''','NULL')||') as res';				  
		  ELSE 
		      v_consulta =  ' SELECT migracion.f_trans_tsg_usuario_tusuario (
		              '''||TG_OP::varchar||''',NULL,'||OLD.id_usuario||',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) as res';
		       
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