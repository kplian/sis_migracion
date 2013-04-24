--------------- SQL ---------------

CREATE OR REPLACE FUNCTION migra.f_tabla_mig_ori_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS SETOF record AS
$body$
/**************************************************************************
 SISTEMA:		Migracion
 FUNCION: 		migra.f_tabla_mig_ori_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'migra.ttabla_mig'
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

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
    g_registros record;
    v_res_cone varchar;
    cadena_con varchar;
			    
BEGIN

	v_nombre_funcion = 'migra.f_tabla_mig_ori_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'MIG_SISORI_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		14-01-2013 18:19:52
	***********************************/

	if(p_transaccion='MIG_SISORI_SEL')then
     				
    	begin
        
            cadena_con = 'hostaddr='||v_parametros.ip||' port=5432 dbname='||v_parametros.base||' user='||v_parametros.usuario||' password='||v_parametros.pass; 
    		 v_res_cone=( select dblink_connect(cadena_con));
            --Sentencia de la consulta
			v_consulta:='select
						   sub.id_subsistema,
                           sub.nombre_corto,
                           sub.nombre_largo
                        from sss.tsg_subsistema sub   
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
            
            
            FOR g_registros in ( SELECT * FROM  dblink(v_consulta ,true) as (id_subsistema integer, nombre_corto varchar,nombre_largo varchar )) LOOP
           
              RETURN NEXT g_registros;
           END LOOP;
              raise notice 'PASA el FOR';
         
            
			 v_res_cone=(select dblink_disconnect());
             
						
		end;

	/*********************************    
 	#TRANSACCION:  'MIG_SISORI_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		14-01-2013 18:19:52
	***********************************/

	elsif(p_transaccion='MIG_SISORI_CONT')then

		begin
         
            cadena_con = 'hostaddr='||v_parametros.ip||' port=5432 dbname='||v_parametros.base||' user='||v_parametros.usuario||' password='||v_parametros.pass; 
    	
        
            v_res_cone=( select dblink_connect(cadena_con));
            --Sentencia de la consulta
			v_consulta:='select
            	            COUNT(sub.id_subsistema) AS total
                        from sss.tsg_subsistema sub    
				        where  ';
			
          
            
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
           -- v_consulta:=v_consulta||' GROUP BY id_subsistema,nombre_corto';
			
			--Devuelve la respuesta
            
            raise notice '%',v_consulta;
            
            
            FOR g_registros in (  SELECT * FROM dblink(v_consulta ,true) as (total bigint)) LOOP
          
            
                 RETURN NEXT g_registros;
            END LOOP;
            raise notice 'PASA el FOR';
             v_res_cone=(select dblink_disconnect());

		end;
	/*********************************    
 	#TRANSACCION:  'MIG_TABORI_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		14-01-2013 18:19:52
	***********************************/

	elseif(p_transaccion='MIG_TABORI_SEL')then
     				
    	begin
        
            cadena_con = 'hostaddr='||v_parametros.ip||' port=5432 dbname='||v_parametros.base||' user='||v_parametros.usuario||' password='||v_parametros.pass; 
    		 v_res_cone=( select dblink_connect(cadena_con));
            
            
            v_consulta:='SELECT n.oid::integer as oid_esquema,
                                n.nspname::varchar AS nombre_esquema,
                                c.oid::integer as oid_tabla ,
                                c.relname::varchar as nombre

                        FROM pg_namespace n
                        INNER JOIN pg_class c ON c.relnamespace = n.oid
                        where n.nspname not like ''pg_%'' and
                            n.nspname not like ''information_schema'' and c.relkind=''r'' and ';
            v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||' order by c.relname limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
            
			--Devuelve la respuesta
            
            
            FOR g_registros in ( SELECT * FROM  dblink(v_consulta ,true) as (id_subsistema integer, nombre_corto varchar,oid_talbla integer ,nombre varchar )) LOOP
           
              RETURN NEXT g_registros;
           END LOOP;
              raise notice 'PASA el FOR';
         
            
			 v_res_cone=(select dblink_disconnect());
             
						
		end;

	/*********************************    
 	#TRANSACCION:  'MIG_TABORI_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		14-01-2013 18:19:52
	***********************************/

	elsif(p_transaccion='MIG_TABORI_CONT')then

		begin
         
            cadena_con = 'hostaddr='||v_parametros.ip||' port=5432 dbname='||v_parametros.base||' user='||v_parametros.usuario||' password='||v_parametros.pass; 
    	
        
            v_res_cone=( select dblink_connect(cadena_con));
            --Sentencia de la consulta
			v_consulta:='select count(c.oid)
            			FROM pg_namespace n
                        INNER JOIN pg_class c ON c.relnamespace = n.oid
                        where n.nspname not like ''pg_%'' and
                            n.nspname not like ''information_schema'' and c.relkind=''r'' and ';
            v_consulta:=v_consulta||v_parametros.filtro;
           -- v_consulta:=v_consulta||' GROUP BY id_subsistema,nombre_corto';
			
			--Devuelve la respuesta
            
            raise notice '%',v_consulta;
            
            
            FOR g_registros in (  SELECT * FROM dblink(v_consulta ,true) as (total bigint)) LOOP
          
            
                 RETURN NEXT g_registros;
            END LOOP;
            raise notice 'PASA el FOR';
             v_res_cone=(select dblink_disconnect());

		end;				
	else
					     
		raise exception 'Transaccion inexistente';
					         
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
COST 100 ROWS 1000;