CREATE OR REPLACE FUNCTION migracion.f_mig_relacion_contable__tpr_concepto_cta (
  p_operacion varchar,
  p_id_concepto_cta integer,
  p_id_concepto_ingas integer,
  p_id_cuenta integer,
  p_id_unidad_organizacional integer,
  p_id_auxiliar integer,
  p_id_presupuesto integer
)
RETURNS varchar AS
$body$
/*
Autor: RCM
Fecha: 13/12/2013
Descripción: Función para migrar la relación contable de pxp a tpr_concepto_cta
*/

DECLARE

	v_respuesta varchar;

BEGIN

	if p_operacion = 'INSERT' then
    
    	--Inserción del registro
        INSERT INTO presto.tpr_concepto_cta (
        id_concepto_cta,
        id_concepto_ingas,
        id_cuenta,
        id_unidad_organizacional,
        id_auxiliar,
        id_presupuesto,
        usuario_reg,
        fecha_reg
        ) VALUES (
        p_id_concepto_cta,
        p_id_concepto_ingas,
        p_id_cuenta,
        p_id_unidad_organizacional,
        p_id_auxiliar,
        p_id_presupuesto,
        current_user,
        now()
        );
        
        --Respuesta
        v_respuesta= 'Migración de parametrización de Cuenta Bancaria de pxp a endesis realizada';
    
    elsif p_operacion = 'UPDATE' then
    
        update presto.tpr_concepto_cta set 
          id_concepto_ingas = p_id_concepto_ingas,
          id_cuenta = p_id_cuenta,
          id_unidad_organizacional = p_id_unidad_organizacional,
          id_auxiliar = p_id_auxiliar,
          id_presupuesto = p_id_presupuesto
        where id_concepto_cta = p_id_concepto_cta;
        
        --Respuesta
        v_respuesta= 'Modificación de parametrización de Cuenta Bancaria de pxp a endesis realizada';
        
    else
    	delete from presto.tpr_concepto_cta 
        where id_concepto_cta = p_id_concepto_cta;
        
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