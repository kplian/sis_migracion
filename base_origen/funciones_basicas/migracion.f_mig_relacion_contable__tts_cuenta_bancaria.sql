CREATE OR REPLACE FUNCTION migracion.f_mig_relacion_contable__tts_cuenta_bancaria (
  p_operacion varchar,
  p_id_relacion_contable integer,
  p_id_cuenta_bancaria integer,
  p_id_cuenta integer,
  p_id_auxiliar integer,
  p_id_centro_costo integer,
  p_id_gestion integer,
  p_nro_cuenta_banco varchar
)
RETURNS varchar AS
$body$
/*
Autor: RCM
Fecha: 23/12/2013
Descripción: Función para migrar la cuenta bancaria
*/

DECLARE

	v_respuesta varchar;
	v_id_parametro integer;

BEGIN

	--Obtener parametro de tesoreria
    select id_parametro
    into v_id_parametro
    from tesoro.tts_parametro pa
    where pa.id_gestion = p_id_gestion;

	if p_operacion = 'INSERT' then
		
		--Verifica si ya existe registrado esa cuenta en este parametro
		if exists(select 1 from tesoro.tts_cuenta_bancaria
				where nro_cuenta_banco = p_nro_cuenta_banco
				and id_parametro = v_id_parametro) then

			--Actualiza el registro
			UPDATE tesoro.tts_cuenta_bancaria SET
			id_cuenta = p_id_cuenta,
			id_auxiliar = p_id_auxiliar
			WHERE nro_cuenta_banco = p_nro_cuenta_banco
			and id_parametro = v_id_parametro;
			
		else
		
			--Obtiene la institucion de la cuenta bancaria de otras gestiones
			select id_institucion
			into v_id_institucion
			from tesoro.tts_cuenta_bancaria
			where nro_cuenta_banco = p_nro_cuenta_banco
			order by id_cuenta_bancaria desc limit 1;
			
			if v_id_institucion is null then
				raise exception 'Error al migrar cuenta a Endesis, no existe la cuenta bancaria';
			end if;
			
		
			--Inserción del registro
	        INSERT INTO 
			tesoro.tts_cuenta_bancaria
			(
			  id_cuenta_bancaria,
			  id_institucion,
			  id_cuenta,
			  nro_cuenta_banco,
			  nro_cheque,
			  estado_cuenta,
			  id_auxiliar,
			  id_parametro
			) values(
			  p_id_cuenta_bancaria,
			  v_id_institucion,
			  p_id_cuenta,
			  p_nro_cuenta_banco,
			  0,
			  1,
			  p_id_auxiliar,
			  v_id_parametro
			);
			
		end if;

        --Respuesta
        v_respuesta= 'Migración de parametrización de Cuenta Bancaria de pxp a endesis realizada';
    
    elsif p_operacion = 'UPDATE' then
    	
    	--Actualiza el registro
		update tesoro.tts_cuenta_bancaria set
		id_cuenta = p_id_cuenta,
		id_auxiliar = p_id_auxiliar
		WHERE nro_cuenta_banco = p_nro_cuenta_banco
		and id_parametro = v_id_parametro;
        
        --Respuesta
        v_respuesta= 'Modificación de parametrización de Cuenta Bancaria de pxp a endesis realizada';
        
    else
    	--Eliminación: solo se pone en null la cuenta y el auxiliar contable
    
    	update tesoro.tts_cuenta_bancaria set
    	id_cuenta = null,
    	id_auxiliar = null 
        where nro_cuenta_banco = p_nro_cuenta_banco
		and id_parametro = v_id_parametro;
        
        --Respuesta
        v_respuesta= 'Eliminación de parametrización de Cuenta Bancaria de pxp a endesis realizada';
    
    end if;

	
	return v_respuesta;

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER;