--------------- SQL ---------------

CREATE OR REPLACE FUNCTION migracion.f_obtener_cadena_con_dblink (
)
RETURNS varchar AS
$body$
DECLARE

v_host varchar;
v_puerto varchar;
v_dbname varchar;
p_user varchar;
v_password varchar;
 
BEGIN

v_host='192.168.1.134';
v_puerto='5432';
v_dbname='dbadqui';
p_user='dblink';
v_password='dblink';


RETURN 'hostaddr='||v_host||' port='||v_puerto||' dbname='||v_dbname||' user='||p_user||' password='||v_password; 

 
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER;