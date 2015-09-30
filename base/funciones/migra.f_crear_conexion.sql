--------------- SQL ---------------

CREATE OR REPLACE FUNCTION migra.f_crear_conexion (
  p_id_depto_lb integer = NULL::integer,
  p_tabla varchar = NULL::character varying,
  p_codigo_estacion varchar = NULL::character varying
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Presupuestos
 FUNCION: 		migra.f_crear_conexion
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
v_sincronizar_central varchar; 
v_resp varchar;
v_nombre_funcion varchar;
v_cadena		varchar;
v_nombre_con	varchar;
v_instancia		record;
v_consulta		varchar;
BEGIN

 
 v_nombre_funcion =  'migra.f_crear_conexion';
 v_sincronizar  = pxp.f_get_variable_global('sincronizar');
 v_sincronizar_central  = pxp.f_get_variable_global('sincronizar_central');
 
     IF(p_id_depto_lb is not null)THEN
        
        
        IF p_tabla is null THEN
          raise exception 'si especifica libro de bancos tiene tambien que especificar la tabla de donde salen los datos';
        END IF;
        
        v_consulta = 'select t.host, t.puerto, t.dbname, t.usuario, t.password from ' || p_tabla || ' t where id_depto_lb='|| p_id_depto_lb || '';
        
        execute v_consulta into v_instancia;
        
        
        IF v_instancia is NULL THEN
          raise exception 'no se encontro registro de conexión para la estación de id libro de bancos = % ',  p_id_depto_lb;
        END IF;
        
        v_host = v_instancia.host;
        v_puerto = v_instancia.puerto;
        v_dbname = v_instancia.dbname;
        p_user = v_instancia.usuario;
        v_password = v_instancia.password;
        --v_sincronizar = v_instancia.sincroniza;
     
     ELSIF p_codigo_estacion is not NULL  THEN
     
        IF p_tabla is null THEN
          raise exception 'si especifica el codigo de estacion tiene tambien que especificar la tabla de donde salen los datos';
        END IF;
      
        v_consulta = 'select t.host, t.puerto, t.dbname, t.usuario, t.password from ' || p_tabla || ' t where  lower(codigo)='||  lower(p_codigo_estacion) || '';
        
        execute v_consulta into v_instancia;
        
        
        IF v_instancia is NULL THEN
          raise exception 'no se encontro registro de conexión para la estación de código = % ',  p_codigo_estacion;
        END IF;
        
        v_host = v_instancia.host;
        v_puerto = v_instancia.puerto;
        v_dbname = v_instancia.dbname;
        p_user = v_instancia.usuario;
        v_password = v_instancia.password;
     
     
     ELSE
        v_host=pxp.f_get_variable_global('sincroniza_ip');
        v_puerto=pxp.f_get_variable_global('sincroniza_puerto');  
        v_dbname=pxp.f_get_variable_global('sincronizar_base');
        p_user=pxp.f_get_variable_global('sincronizar_user');
        v_password=pxp.f_get_variable_global('sincronizar_password');
        v_sincronizar=pxp.f_get_variable_global('sincronizar');
        
        if (v_sincronizar != 'true' and v_sincronizar_central != 'true') then
        	raise exception 'No esta habilitada ninguna opcion de sincronizacion para la base  de datos';
        end if;
        
     END IF;

       

      v_cadena = 'hostaddr='||v_host||' port='||v_puerto||' dbname='||v_dbname||' user='||p_user||' password='||v_password;
       
      --raise exception '%', v_cadena;
      select trunc(random()*100000)::varchar into v_nombre_con;
      v_nombre_con = 'pg_' || v_nombre_con;
      perform dblink_connect(v_nombre_con, v_cadena);
      perform dblink_exec(v_nombre_con, 'begin;', true);
      return v_nombre_con;  
 
   
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