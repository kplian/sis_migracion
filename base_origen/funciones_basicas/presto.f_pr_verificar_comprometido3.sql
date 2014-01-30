CREATE OR REPLACE FUNCTION presto.f_pr_verificar_comprometido3 (
  inout pr_id_partida_ejecucion integer,
  out p_comprometido numeric,
  out p_ejecutado numeric,
  out p_pagado numeric,
  p_id_moneda integer
)
RETURNS record AS
$body$
DECLARE
	g_estado_com_eje numeric;
    g_registros		record;
    g_nom_sufijo integer;
    g_datos_pe	record;
    v_res		varchar;
    v_id_partida_ejecucion integer;
    v_estado			integer;
    v_estado_padre		integer;
    
BEGIN

	BEGIN
    
   -- raise exception 'WWWWWWWW';
    p_comprometido=0;
    p_ejecutado=0;
    p_pagado=0;
    
   
    
  g_nom_sufijo=nextval('presto.tpr_verifica_comprometido_seq'); 
    
    EXECUTE ('CREATE TEMPORARY TABLE tt_verificarcomprometido2_'||g_nom_sufijo||'(
              id_partida_ejecucion INTEGER NOT NULL, 
              estado_com_eje NUMERIC, 
              importe_com_eje NUMERIC, 
              id_partida_ejecucion_origen INTEGER,
              id_moneda INTEGER
            ) ON COMMIT DROP');
    
    EXECUTE ('CREATE TEMPORARY TABLE tt_ids_verificarcomprometido2_'||g_nom_sufijo||'(
              id_partida_ejecucion INTEGER NOT NULL
            ) ON COMMIT DROP');
                
    
    
    
    if(pr_id_partida_ejecucion is null)then
    	return;
    end if;
    
    select pe.fk_partida_ejecucion, padre.estado_com_eje as estado_padre,pe.estado_com_eje as estado
    into	v_id_partida_ejecucion,v_estado_padre,v_estado
    from presto.tpr_partida_ejecucion pe
    inner join presto.tpr_partida_ejecucion padre
    on pe.fk_partida_ejecucion = padre.id_partida_ejecucion
    where pe.id_partida_ejecucion = pr_id_partida_ejecucion;
    
    if (v_id_partida_ejecucion is null or v_estado_padre != v_estado) then
    	v_id_partida_ejecucion = pr_id_partida_ejecucion;
    end if;
    
    v_res = presto.f_pr_inserta_pe_hijos(v_id_partida_ejecucion,'tt_ids_verificarcomprometido2_'||g_nom_sufijo );
  	   
    EXECUTE ('insert into
        	tt_verificarcomprometido2_'||g_nom_sufijo||'
     select 
        	id_partida_ejecucion,
            estado_com_eje,
            importe_com_eje,
            fk_partida_ejecucion ,
            id_moneda
    from presto.tpr_partida_ejecucion 
    where id_partida_ejecucion in (select id_partida_ejecucion 
    								from tt_ids_verificarcomprometido2_'||g_nom_sufijo || ')');
       
    
    FOR
     g_registros in EXECUTE('SELECT  
                                sum(CASE
                                   WHEN estado_com_eje in (1,2) THEN importe_com_eje
                                  ELSE NULL
                                END) AS comprometido,
                                
                                sum(CASE
                                   WHEN estado_com_eje in (3,8) THEN importe_com_eje
                                  ELSE NULL
                                END) AS ejecutado,
                                
                                 sum(CASE
                                   WHEN estado_com_eje in (4,9) THEN importe_com_eje
                                  ELSE NULL
                                END) AS pagado
                                from tt_verificarcomprometido2_'||g_nom_sufijo||' pe 
                                WHERE id_moneda='||p_id_moneda)
     LOOP
     
        p_comprometido=g_registros.comprometido;
        p_ejecutado=g_registros.ejecutado;
        p_pagado=g_registros.pagado;
     END LOOP;
   
    return;
    END;
    
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER;