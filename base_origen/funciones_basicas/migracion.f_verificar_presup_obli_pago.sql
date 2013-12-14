CREATE OR REPLACE FUNCTION migracion.f_pxp_verificar_presup (
  pa_id_partida integer [],
  pa_id_presupuesto integer [],
  pa_id_moneda integer [],
  pa_importe numeric []
)
RETURNS SETOF record AS
$body$
/*
Autor: RCM
Fecha: 15/12/2013
Descripción: Función que devuelve la disponiilidad presupuestaria de ENDESIS para PXP a partir de id_partida, id_presupuesto, moneda e importe
de pxp
*/

DECLARE

	v_size integer;
    v_sql varchar;
    v_rec record;

BEGIN

	--Creación de tabla temporal para realizar la verificación
    v_sql = 'create temp table tt_pxp_verificacion_dispo(
    		id_partida integer,
            id_presupuesto integer,
            id_moneda integer,
            importe numeric
    		) on commit drop';
            
    execute(v_sql);

	v_size = array_upper(pa_id_partida, 1);
    
    --Inserta los datos en la tabla temporal
    for i in 1..v_size loop
    
    	v_sql = 'insert into tt_pxp_verificacion_dispo(
        		id_partida, id_presupuesto,id_moneda,importe
                ) values('||
                pa_id_partida[i]||','||
                pa_id_presupuesto[i]||','||
                pa_id_moneda[i]||','||
                pa_importe[i]||')';
                
        execute(v_sql);
    end loop;

    --DEfine la consulta para la verificación de disponibilidad
    v_sql = 'select
    		id_partida,
            id_presupuesto,
            id_moneda,
            importe,
            f_iif(((presto."f_i_ad_verificarPresupuestoPartida"(
								id_presupuesto,
								id_partida,
								id_moneda,
								importe))[1]=CAST(1 as numeric)),''Disponible''::varchar, ''NO DISPONIBLE''::varchar) as disponibilidad
    		from tt_pxp_verificacion_dispo';
            
	for v_rec in execute(v_sql) loop
    	return next v_rec;
    end loop;

    return;

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER;