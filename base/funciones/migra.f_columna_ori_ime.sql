CREATE OR REPLACE FUNCTION "migra"."f_columna_ori_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Migracion
 FUNCION: 		migra.f_columna_ori_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'migra.tcolumna_ori'
 AUTOR: 		 (admin)
 FECHA:	        16-01-2013 14:09:32
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
	v_id_columna_ori	integer;
			    
BEGIN

    v_nombre_funcion = 'migra.f_columna_ori_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'MIG_COLO_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		16-01-2013 14:09:32
	***********************************/

	if(p_transaccion='MIG_COLO_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into migra.tcolumna_ori(
			estado_reg,
			tipo_dato,
			columna,
			id_tabla_mig,
			fecha_reg,
			id_usuario_reg,
			fecha_mod,
			id_usuario_mod
          	) values(
			'activo',
			v_parametros.tipo_dato,
			v_parametros.columna,
			v_parametros.id_tabla_mig,
			now(),
			p_id_usuario,
			null,
			null
							
			)RETURNING id_columna_ori into v_id_columna_ori;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Origen almacenado(a) con exito (id_columna_ori'||v_id_columna_ori||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_columna_ori',v_id_columna_ori::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'MIG_COLO_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		16-01-2013 14:09:32
	***********************************/

	elsif(p_transaccion='MIG_COLO_MOD')then

		begin
			--Sentencia de la modificacion
			update migra.tcolumna_ori set
			tipo_dato = v_parametros.tipo_dato,
			columna = v_parametros.columna,
			id_tabla_mig = v_parametros.id_tabla_mig,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario
			where id_columna_ori=v_parametros.id_columna_ori;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Origen modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_columna_ori',v_parametros.id_columna_ori::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'MIG_COLO_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		16-01-2013 14:09:32
	***********************************/

	elsif(p_transaccion='MIG_COLO_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from migra.tcolumna_ori
            where id_columna_ori=v_parametros.id_columna_ori;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Origen eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_columna_ori',v_parametros.id_columna_ori::varchar);
              
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
ALTER FUNCTION "migra"."f_columna_ori_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
