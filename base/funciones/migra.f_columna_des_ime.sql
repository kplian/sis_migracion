CREATE OR REPLACE FUNCTION "migra"."f_columna_des_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Migracion
 FUNCION: 		migra.f_columna_des_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'migra.tcolumna_des'
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

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_columna_des	integer;
			    
BEGIN

    v_nombre_funcion = 'migra.f_columna_des_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'MIG_COLD_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		16-01-2013 14:09:24
	***********************************/

	if(p_transaccion='MIG_COLD_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into migra.tcolumna_des(
			estado_reg,
			id_tabla_mig,
			tipo_dato,
			id_columna_ori,
			columna,
			fecha_reg,
			id_usuario_reg,
			fecha_mod,
			id_usuario_mod
          	) values(
			'activo',
			v_parametros.id_tabla_mig,
			v_parametros.tipo_dato,
			v_parametros.id_columna_ori,
			v_parametros.columna,
			now(),
			p_id_usuario,
			null,
			null
							
			)RETURNING id_columna_des into v_id_columna_des;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Destino almacenado(a) con exito (id_columna_des'||v_id_columna_des||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_columna_des',v_id_columna_des::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'MIG_COLD_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		16-01-2013 14:09:24
	***********************************/

	elsif(p_transaccion='MIG_COLD_MOD')then

		begin
			--Sentencia de la modificacion
			update migra.tcolumna_des set
			id_tabla_mig = v_parametros.id_tabla_mig,
			tipo_dato = v_parametros.tipo_dato,
			id_columna_ori = v_parametros.id_columna_ori,
			columna = v_parametros.columna,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario
			where id_columna_des=v_parametros.id_columna_des;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Destino modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_columna_des',v_parametros.id_columna_des::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'MIG_COLD_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		16-01-2013 14:09:24
	***********************************/

	elsif(p_transaccion='MIG_COLD_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from migra.tcolumna_des
            where id_columna_des=v_parametros.id_columna_des;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Destino eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_columna_des',v_parametros.id_columna_des::varchar);
              
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
ALTER FUNCTION "migra"."f_columna_des_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
