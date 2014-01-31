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
    v_id_gestion	integer;
    v_desc_ingas	varchar;
    v_id_concepto_ingas integer;
    v_gestion		numeric;

BEGIN

	if p_operacion = 'INSERT' then
    	--obtener el id de la gestion para obtener el concepto en la gestion
        
        select id_gestion,pre.gestion_pres
        into v_id_gestion,v_gestion
        from presto.vpr_presupuesto pre
        where id_presupuesto = p_id_presupuesto;
        
        select desc_ingas
        into v_desc_ingas
        from presto.tpr_concepto_ingas
        where id_concepto_ingas = p_id_concepto_ingas;
        
		v_desc_ingas = trim(upper(v_desc_ingas));
        
		select ci.id_concepto_ingas into v_id_concepto_ingas
        from presto.tpr_concepto_ingas ci
        inner join presto.tpr_partida p on p.id_partida = ci.id_partida
        inner join presto.tpr_parametro par on par.id_parametro = p.id_parametro
        where par.id_gestion = v_id_gestion and trim(upper(ci.desc_ingas)) like v_desc_ingas;
        
        if (v_id_concepto_ingas is null) then
        	raise exception 'No existe el concepto: %, para la gestion: % en ENDESIS';
        end if;
        
    	----------------------------
    	--INSERCION PARAMETRIZACION
        ----------------------------
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
        v_id_concepto_ingas,
        p_id_cuenta,
        p_id_unidad_organizacional,
        p_id_auxiliar,
        p_id_presupuesto,
        current_user,
        now()
        );
        
        ------------
        --Respuesta
        ------------
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
