CREATE OR REPLACE FUNCTION migracion.f_sincronizacion (
)
RETURNS boolean AS
$body$
DECLARE

g_registros record;
g_registros_aux record;

v_resp  varchar[];
  
BEGIN
 
   IF  EXISTS(select 1 FROM 
                migracion.tmig_migracion 
              WHERE  migracion = 'falla')  THEN
   
   
    raise exception 'Existe una falla que debe ser resuelta';
   END IF;


      FOR g_registros in (
              SELECT 
                id_migracion,
                verificado,
                consulta,
                operacion,
                migracion,
                fecha_reg,
                fecha_mig
              FROM 
                migracion.tmig_migracion 
              WHERE  migracion is NULL) LOOP
          
        	
        	v_resp = migracion.f_ejecutar(g_registros.consulta);
        
            IF v_resp[1]= 'TRUE' THEN
            
                  DELETE FROM 
                    migracion.tmig_migracion 
                  WHERE 
                    id_migracion = g_registros.id_migracion;
           ELSE
                           
                UPDATE 
                  migracion.tmig_migracion  
                SET 
                  migracion = 'falla',
                  fecha_mig = now(),
                  desc_error = v_resp[3]||'-'||v_resp[2]
                 
                WHERE 
                  id_migracion = g_registros.id_migracion;
                  
                EXIT;
           END IF;  
           
        	
        END LOOP;


		RETURN TRUE;



END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER;