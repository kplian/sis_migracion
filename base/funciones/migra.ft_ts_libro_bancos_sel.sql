CREATE OR REPLACE FUNCTION "migra"."ft_ts_libro_bancos_sel"(	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:		Migracion
 FUNCION: 		migra.ft_ts_libro_bancos_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'migra.tts_libro_bancos'
 AUTOR: 		 (admin)
 FECHA:	        01-12-2013 09:10:17
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

	v_nombre_funcion = 'migra.ft_ts_libro_bancos_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'MIG_LBAN_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		01-12-2013 09:10:17
	***********************************/

	if(p_transaccion='MIG_LBAN_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						lban.id_libro_bancos,
						lban.id_cuenta_bancaria,
						lban.fecha,
						lban.a_favor,
						lban.nro_cheque,
						lban.importe_deposito,
						lban.nro_liquidacion,
						lban.detalle,
						lban.origen,
						lban.observaciones,
						lban.importe_cheque,
						lban.id_libro_bancos_fk,
						lban.estado,
						lban.nro_comprobante,
						lban.indice,
						lban.estado_reg,
						lban.tipo,
						lban.fecha_reg,
						lban.id_usuario_reg,
						lban.fecha_mod,
						lban.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod	
						from migra.tts_libro_bancos lban
						inner join segu.tusuario usu1 on usu1.id_usuario = lban.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = lban.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'MIG_LBAN_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		01-12-2013 09:10:17
	***********************************/

	elsif(p_transaccion='MIG_LBAN_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_libro_bancos)
					    from migra.tts_libro_bancos lban
					    inner join segu.tusuario usu1 on usu1.id_usuario = lban.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = lban.id_usuario_mod
					    where ';
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;
		
		
		
	/*********************************    
 	#TRANSACCION:  'MIG_CBANESIS_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:			RCM	
 	#FECHA:			27/12/2013
	***********************************/

	elsif(p_transaccion='MIG_CBANESIS_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='SELECT * 
						FROM tesoro.f_tts_libro_bancos_sel(18, '172.17.45.12', '00:19:d1:09:22:7e',
						'TS_LBRBANSAL_SEL', NULL, 10, 0,
						'fecha desc, id_libro_bancos desc,fecha desc, id_libro_bancos desc,fecha desc, id_libro_bancos desc',
						'desc',
						'LBRBAN.id_cuenta_bancaria = ' ||v_parametros.id_cuenta_bancaria ||' AND LBRBAN.tipo = ''deposito'' AND LBRBAN.fk_libro_bancos is null',
						'%', '%', '%', '%', '%', NULL, NULL, NULL, NULL, NULL) AS (id_libro_bancos
						int4, id_cuenta_bancaria int4, fecha date, a_favor varchar, detalle text,
						observaciones text, nro_liquidacion varchar, nro_comprobante varchar,
						nro_cheque int4, tipo varchar, importe_deposito numeric, importe_cheque
						numeric, saldo numeric, origen varchar, estado varchar, usr_reg varchar,
						fecha_reg timestamp, usr_mod varchar, fecha_mod timestamp,
						fk_libro_bancos int4, fecha_cheque_literal text, emparejado varchar)';
						
			raise exception '%',v_consulta;
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

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
$BODY$
LANGUAGE 'plpgsql' VOLATILE
COST 100;
ALTER FUNCTION "migra"."ft_ts_libro_bancos_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
