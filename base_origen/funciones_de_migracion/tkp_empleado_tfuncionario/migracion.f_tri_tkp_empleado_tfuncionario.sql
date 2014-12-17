CREATE OR REPLACE FUNCTION migracion.f_tri_tkp_empleado_tfuncionario (
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
		   	if (TG_OP ='UPDATE' and NEW.id_oficina  != OLD.id_oficina) then
            	update kard.tkp_historico_asignacion
                set id_empleado_suplente = NULL
                where fecha_asignacion <= now()::date and (fecha_finalizacion is null or fecha_finalizacion >= now()::date)
              	and estado_reg!= 'eliminado' and id_empleado = OLD.id_empleado;
            end if;
			 v_consulta =  'SELECT migracion.f_trans_tkp_empleado_tfuncionario (
                  '''||TG_OP::varchar||''','||COALESCE(''''||NEW.codigo_empleado::varchar||'''','NULL')||','||COALESCE(NEW.id_empleado::varchar,'NULL')||','||COALESCE(NEW.id_auxiliar::varchar,'NULL')||','||COALESCE(NEW.id_cuenta::varchar,'NULL')||','||COALESCE(NEW.id_depto::varchar,'NULL')||','||COALESCE(NEW.id_escala_salarial::varchar,'NULL')||','||COALESCE(NEW.id_lugar_trabajo::varchar,'NULL')||','||COALESCE(NEW.id_persona::varchar,'NULL')||','||COALESCE(NEW.id_usuario_reg::varchar,'NULL')||','||COALESCE(NEW.antiguedad_ant::varchar,'NULL')||','||COALESCE(''''||NEW.apodo::varchar||'''','NULL')||','||COALESCE(''''||NEW.compensa::varchar||'''','NULL')||','||COALESCE(''''||NEW.estado_reg::varchar||'''','NULL')||','||COALESCE(''''||NEW.fecha_ingreso::varchar||'''','NULL')||','||COALESCE(''''||NEW.fecha_reg::varchar||'''','NULL')||','||COALESCE(NEW.id_empleado_actif::varchar,'NULL')||','||COALESCE(''''||NEW.marca::varchar||'''','NULL')||','||COALESCE(''''||NEW.nivel_academico::varchar||'''','NULL')||') as res';				  
		  ELSE 
		      v_consulta =  ' SELECT migracion.f_trans_tkp_empleado_tfuncionario (
		              '''||TG_OP::varchar||''',NULL,'||OLD.id_empleado||',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) as res';
		       
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