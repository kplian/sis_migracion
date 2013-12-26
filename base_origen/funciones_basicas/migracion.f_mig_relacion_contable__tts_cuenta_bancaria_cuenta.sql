CREATE OR REPLACE FUNCTION migracion.f_mig_relacion_contable__tts_cuenta_bancaria_cuenta (
  p_operacion varchar,
  p_id_cuenta_bancaria_cuenta integer,
  p_id_cuenta_bancaria integer,
  p_id_cuenta integer,
  p_id_auxiliar integer,
  p_id_presupuesto integer,
  p_id_gestion integer
)
RETURNS varchar AS
$body$
/*
Autor: RCM
Fecha: 13/12/2013
Descripción: Función para migrar la relación contable de pxp a tts_cuenta_bancaria_cuenta
*/

DECLARE

	v_id_parametro integer;
    v_respuesta varchar;

BEGIN

    if p_operacion = 'INSERT' then
    
    	--Obtención del id_parametro de tesoreria
        select par.id_parametro
        into v_id_parametro
        from param.tpm_gestion ges
        inner join tesoro.tts_parametro par
        on par.id_gestion = ges.id_gestion
        where ges.id_gestion = p_id_gestion;
    
    	--Inserción del registro
        INSERT INTO tesoro.tts_cuenta_bancaria_cuenta(
          id_cuenta_bancaria_cuenta,
          id_cuenta_bancaria,
          id_cuenta,
          id_auxiliar,
          id_parametro,
          id_usuario_reg,
          fecha_reg
        ) 
        VALUES (
          p_id_cuenta_bancaria_cuenta,
          p_id_cuenta_bancaria,
          p_id_cuenta,
          p_id_auxiliar,
          v_id_parametro,
          1,
          now()
        );
        
        --Actualiza los datos en la tabla tesoro.tts_cuenta_bancaria
        update tesoro.tts_cuenta_bancaria set
        id_cuenta = p_id_cuenta,
        id_auxiliar =  p_id_auxiliar,
        id_parametro = v_id_parametro
        where id_cuenta_bancaria = p_id_cuenta_bancaria;
        
        --Respuesta
        v_respuesta='Migración de parametrización de Concepto de Gasto de pxp a endesis realizada';
    
    elsif p_operacion = 'UPDATE' then
    
    	--Obtención del id_parametro de tesoreria
        select par.id_parametro
        into v_id_parametro
        from param.tpm_gestion ges
        inner join tesoro.tts_parametro par
        on par.id_gestion = ges.id_gestion
        where ges.id_gestion = p_id_gestion;
    
        UPDATE tesoro.tts_cuenta_bancaria_cuenta SET 
          id_cuenta_bancaria = p_id_cuenta_bancaria,
          id_cuenta = p_id_cuenta,
          id_auxiliar = p_id_auxiliar,
          id_parametro = v_id_parametro
        WHERE id_cuenta_bancaria_cuenta = p_id_cuenta_bancaria_cuenta;
        
        --Actualiza los datos en la tabla tesoro.tts_cuenta_bancaria
        update tesoro.tts_cuenta_bancaria set
        id_cuenta = p_id_cuenta,
        id_auxiliar =  p_id_auxiliar,
        id_parametro = v_id_parametro
        where id_cuenta_bancaria = p_id_cuenta_bancaria;
        
        --Respuesta
        v_respuesta='Modificación de parametrización de Concepto de Gasto de pxp a endesis realizada';
    
    else
    
    	delete from tesoro.tts_cuenta_bancaria_cuenta	
        WHERE id_cuenta_bancaria_cuenta = p_id_cuenta_bancaria_cuenta;
        
        --Respuesta
        v_respuesta='Eliminación de parametrización de Concepto de Gasto de pxp a endesis realizada';
    
    end if;

    --Respuesta
    return v_respuesta;

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER;