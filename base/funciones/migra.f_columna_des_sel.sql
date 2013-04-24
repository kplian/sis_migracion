--------------- SQL ---------------

CREATE OR REPLACE FUNCTION migra.f_columna_des_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Migracion
 FUNCION: 		migra.f_columna_des_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'migra.tcolumna_des'
 AUTOR: 		 (admin)
 FECHA:	        16-01-2013 14:09:24
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
			    
BEGIN

	v_nombre_funcion = 'migra.f_columna_des_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'MIG_COLD_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		16-01-2013 14:09:24
	***********************************/

	if(p_transaccion='MIG_COLD_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						cold.id_columna_des,
						cold.estado_reg,
						cold.id_tabla_mig,
						cold.tipo_dato,
						cold.id_columna_ori,
						cold.columna,
						cold.fecha_reg,
						cold.id_usuario_reg,
						cold.fecha_mod,
						cold.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod ,
                        co.columna as desc_columna_ori,
                        cold.checks
						from migra.tcolumna_des cold
                        left join migra.tcolumna_ori co on  co.id_columna_ori = cold.id_columna_ori
						inner join segu.tusuario usu1 on usu1.id_usuario = cold.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = cold.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'MIG_COLD_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		16-01-2013 14:09:24
	***********************************/

	elsif(p_transaccion='MIG_COLD_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_columna_des)
					    from migra.tcolumna_des cold
					    left join migra.tcolumna_ori co on  co.id_columna_ori = cold.id_columna_ori
						inner join segu.tusuario usu1 on usu1.id_usuario = cold.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = cold.id_usuario_mod
					    where ';
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

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
COST 100;