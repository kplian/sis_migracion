CREATE OR REPLACE FUNCTION "migra"."ft_ts_libro_bancos_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Migracion
 FUNCION: 		migra.ft_ts_libro_bancos_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'migra.tts_libro_bancos'
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

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_libro_bancos	integer;
			    
BEGIN

    v_nombre_funcion = 'migra.ft_ts_libro_bancos_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'MIG_LBAN_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		01-12-2013 09:10:17
	***********************************/

	if(p_transaccion='MIG_LBAN_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into migra.tts_libro_bancos(
			id_cuenta_bancaria,
			fecha,
			a_favor,
			nro_cheque,
			importe_deposito,
			nro_liquidacion,
			detalle,
			origen,
			observaciones,
			importe_cheque,
			id_libro_bancos_fk,
			estado,
			nro_comprobante,
			indice,
			estado_reg,
			tipo,
			fecha_reg,
			id_usuario_reg,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.id_cuenta_bancaria,
			v_parametros.fecha,
			v_parametros.a_favor,
			v_parametros.nro_cheque,
			v_parametros.importe_deposito,
			v_parametros.nro_liquidacion,
			v_parametros.detalle,
			v_parametros.origen,
			v_parametros.observaciones,
			v_parametros.importe_cheque,
			v_parametros.id_libro_bancos_fk,
			v_parametros.estado,
			v_parametros.nro_comprobante,
			v_parametros.indice,
			'activo',
			v_parametros.tipo,
			now(),
			p_id_usuario,
			null,
			null
							
			)RETURNING id_libro_bancos into v_id_libro_bancos;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Depósitos almacenado(a) con exito (id_libro_bancos'||v_id_libro_bancos||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_libro_bancos',v_id_libro_bancos::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'MIG_LBAN_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		01-12-2013 09:10:17
	***********************************/

	elsif(p_transaccion='MIG_LBAN_MOD')then

		begin
			--Sentencia de la modificacion
			update migra.tts_libro_bancos set
			id_cuenta_bancaria = v_parametros.id_cuenta_bancaria,
			fecha = v_parametros.fecha,
			a_favor = v_parametros.a_favor,
			nro_cheque = v_parametros.nro_cheque,
			importe_deposito = v_parametros.importe_deposito,
			nro_liquidacion = v_parametros.nro_liquidacion,
			detalle = v_parametros.detalle,
			origen = v_parametros.origen,
			observaciones = v_parametros.observaciones,
			importe_cheque = v_parametros.importe_cheque,
			id_libro_bancos_fk = v_parametros.id_libro_bancos_fk,
			estado = v_parametros.estado,
			nro_comprobante = v_parametros.nro_comprobante,
			indice = v_parametros.indice,
			tipo = v_parametros.tipo,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario
			where id_libro_bancos=v_parametros.id_libro_bancos;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Depósitos modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_libro_bancos',v_parametros.id_libro_bancos::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'MIG_LBAN_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		01-12-2013 09:10:17
	***********************************/

	elsif(p_transaccion='MIG_LBAN_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from migra.tts_libro_bancos
            where id_libro_bancos=v_parametros.id_libro_bancos;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Depósitos eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_libro_bancos',v_parametros.id_libro_bancos::varchar);
              
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
$BODY$
LANGUAGE 'plpgsql' VOLATILE
COST 100;
ALTER FUNCTION "migra"."ft_ts_libro_bancos_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
