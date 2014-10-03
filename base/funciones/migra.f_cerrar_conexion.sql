CREATE OR REPLACE FUNCTION migra.f_cerrar_conexion (
  p_nombre_conexion varchar,
  p_tipo varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Presupuestos
 FUNCION: 		migra.f_cerrar_conexion
 DESCRIPCION:   Funcion que recupera los datos de conexion al servidor remoto
 AUTOR: 		Gonzalo Sarmiento Sejas
 FECHA:	        13-03-2013
 COMENTARIOS:	
***************************************************************************/
DECLARE

v_host varchar;
v_puerto varchar;
v_dbname varchar;
p_user varchar;
v_password varchar;
v_sincronizar varchar; 
v_resp varchar;
v_nombre_funcion varchar;
v_cadena		varchar;
v_sql 			varchar;
 
BEGIN


 v_nombre_funcion =  'migra.f_cerrar_conexion';
  
  v_sincronizar=pxp.f_get_variable_global('sincronizar');

   IF v_sincronizar = 'false'  or p_nombre_conexion is null THEN
     
     return 'exito';
     
   ELSE
   	if(p_tipo = 'exito') then
      v_sql := 'commit;';
      perform dblink_exec(p_nombre_conexion, v_sql, true);
    ELSE
    	v_sql := 'rollback;';
        perform dblink_exec(p_nombre_conexion, v_sql, false);
    end if;   
    perform dblink_disconnect(p_nombre_conexion);
   	return 'exito'; 
   END IF;
    
   
EXCEPTION
					
	WHEN OTHERS THEN
			v_resp='';
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
			v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
			v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
			raise exception '%',v_resp;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;