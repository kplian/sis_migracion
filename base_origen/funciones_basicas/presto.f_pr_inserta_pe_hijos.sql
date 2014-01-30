CREATE OR REPLACE FUNCTION presto.f_pr_inserta_pe_hijos (
  p_id_pe integer,
  p_tabla varchar
)
RETURNS varchar AS
$body$
DECLARE
  	v_registros			record;
    v_res		varchar;
BEGIN
/**
 * 
 *  Author: JRR KPLIAN
 *  28/01/2014
 *
 */

	EXECUTE ('insert into ' || 
        	p_tabla || ' values (' || p_id_pe|| ')');
    for v_registros in (	select id_partida_ejecucion 
    						from presto.tpr_partida_ejecucion pe
                            where pe.fk_partida_ejecucion = p_id_pe)loop
		v_res = presto.f_pr_inserta_pe_hijos(v_registros.id_partida_ejecucion,p_tabla);
    end loop;
    return 'exito';
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER;