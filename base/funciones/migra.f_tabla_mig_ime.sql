--------------- SQL ---------------

CREATE OR REPLACE FUNCTION migra.f_tabla_mig_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Migracion
 FUNCION: 		migra.f_tabla_mig_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'migra.ttabla_mig'
 AUTOR: 		 (admin)
 FECHA:	        14-01-2013 18:19:52
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_tabla_mig	integer;
    cadena_con varchar;
    v_res_cone varchar;
    v_consulta varchar;
    g_registros record;
			    
BEGIN

    v_nombre_funcion = 'migra.f_tabla_mig_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'MIG_TAM_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		14-01-2013 18:19:52
	***********************************/

	if(p_transaccion='MIG_TAM_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into migra.ttabla_mig(
			estado_reg,
			alias_des,
			id_subsistema_ori,
			obs,
			id_subsistema_des,
			alias_ori,
			tabla_ori,
			tabla_des,
			fecha_reg,
			id_usuario_reg,
			fecha_mod,
			id_usuario_mod,
            codigo_sis_ori
          	) values(
			'activo',
			v_parametros.alias_des,
			v_parametros.id_subsistema_ori,
			v_parametros.obs,
			v_parametros.id_subsistema_des,
			v_parametros.alias_ori,
			v_parametros.tabla_ori,
			v_parametros.tabla_des,
			now(),
			p_id_usuario,
			null,
			null,
            v_parametros.codigo_sis_ori
							
			)RETURNING id_tabla_mig into v_id_tabla_mig;
            
            
            
           -- Registro de las colummas para la tabla destino
                insert into migra.tcolumna_des(
                  id_usuario_reg,
                  estado_reg, 
                  columna, 
                  tipo_dato,
                  id_tabla_mig,
                  checks
                  )
                select
                p_id_usuario, 
                'activo', 
                columna, 
                tipo_dato,
                v_id_tabla_mig,
                checks 
                from gen.f_obtener_datos_tabla_sel(p_id_usuario,v_parametros.tabla_des,'GEN_COLUMN_SEL') as (
                columna varchar,descripcion varchar,tipo_dato varchar,longitud text,
                nulo varchar,checks varchar, valor_defecto varchar, grid_ancho INTEGER,
                grid_mostrar varchar, form_ancho_porcen integer, orden smallint, grupo smallint);
            
            
            
            --  INSERCION DE COLUMNAS EN ORIGEN
            
            
             cadena_con = 'hostaddr='||v_parametros.ip||' port=5432 dbname='||v_parametros.base||' user='||v_parametros.usuario||' password='||v_parametros.pass; 
    		 v_res_cone=( select dblink_connect(cadena_con));
            
            
            v_consulta:='select
                          columna, 
                          tipo_dato,
                          checks 
                          from migracion.f_obtener_datos_tabla_sel(1,'''||v_parametros.tabla_ori||''',''GEN_COLUMN_SEL'') as (
                          columna varchar,descripcion varchar,tipo_dato varchar,longitud text,
                          nulo varchar,checks varchar, valor_defecto varchar, grid_ancho INTEGER,
                          grid_mostrar varchar, form_ancho_porcen integer, orden smallint, grupo smallint)';
          
			--Devuelve la respuesta
            
            
            FOR g_registros in ( SELECT * FROM  dblink(v_consulta ,true) as (columna varchar, tipo_dato varchar, checks varchar )) LOOP
                 
                     INSERT  into  migra.tcolumna_ori
                  (
                    id_usuario_reg,
                    fecha_reg,
                    estado_reg,
                    columna,
                    tipo_dato,
                    id_tabla_mig,
                    checks
                  ) 
                  VALUES (
                    p_id_usuario,
                    now(),
                    'activo',
                    g_registros.columna,
                    g_registros.tipo_dato,
                    v_id_tabla_mig,
                    g_registros.checks
                  );
            
            END LOOP;
            
               
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Migracion almacenado(a) con exito (id_tabla_mig'||v_id_tabla_mig||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tabla_mig',v_id_tabla_mig::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'MIG_TAM_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		14-01-2013 18:19:52
	***********************************/

	elsif(p_transaccion='MIG_TAM_MOD')then

		begin
			--Sentencia de la modificacion
			update migra.ttabla_mig set
			alias_des = v_parametros.alias_des,
			id_subsistema_ori=v_parametros.id_subsistema_ori,
			obs = v_parametros.obs,
			id_subsistema_des=v_parametros.id_subsistema_des,
			alias_ori=v_parametros.alias_ori,
			tabla_ori=v_parametros.tabla_ori,
			tabla_des=v_parametros.tabla_des,
			fecha_mod=now(),
			id_usuario_mod=p_id_usuario,
            codigo_sis_ori=v_parametros.codigo_sis_ori
			where id_tabla_mig=v_parametros.id_tabla_mig;
            
            -----------
            
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Migracion modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tabla_mig',v_parametros.id_tabla_mig::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'MIG_TAM_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		14-01-2013 18:19:52
	***********************************/

	elsif(p_transaccion='MIG_TAM_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from migra.ttabla_mig
            where id_tabla_mig=v_parametros.id_tabla_mig;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Migracion eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tabla_mig',v_parametros.id_tabla_mig::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
         
	else
     
    	raise exception 'Transaccion inexistente: %',p_transaccion;

	end if;

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