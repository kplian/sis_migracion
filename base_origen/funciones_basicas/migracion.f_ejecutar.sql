CREATE OR REPLACE FUNCTION migracion.f_ejecutar (
  p_consulta text
)
RETURNS varchar [] AS
$body$
DECLARE
  g_registros_aux record;
  v_resp  varchar[];
BEGIN
  for g_registros_aux in execute (p_consulta) LOOP
  		v_resp= g_registros_aux.res;
  END LOOP;
  return v_resp;
  
EXCEPTION
WHEN OTHERS THEN
  v_resp[1]='FALSE';
  v_resp[2]=SQLERRM;
  v_resp[3]=SQLSTATE;                 
  RETURN v_resp;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER;