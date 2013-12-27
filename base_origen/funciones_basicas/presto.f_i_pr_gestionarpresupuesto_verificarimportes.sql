--------------- SQL ---------------

CREATE OR REPLACE FUNCTION presto.f_i_pr_gestionarpresupuesto_verificarimportes (
  pr_id_partida_presupuesto integer,
  pr_id_partida_ejecucion integer,
  pr_importe_presupuesto numeric,
  pr_id_moneda integer,
  pr_estado_com_eje numeric
)
RETURNS numeric AS
$body$
/*

    Nombre: f_i_pr_gestionarpresupuesto_verificarimportes
    Descripción: verifica la integridad de datos
    Autor: Julio Guarachi Lopez
    Fecha: 26/10/2009


    Historial de modificaciones
    -----
    Modificado:
    Fecha:
    descripcion:
    -----
	PARAMETROS DE ENTRADA
	pr_id_presupuesto integer (Presupuesto a gestionar),
    pr_fecha_compro date (fecha de historico),

    ----------------
    */

DECLARE
g_importe_presupuestado NUMERIC;
g_importe_comprometido NUMERIC;
g_importe_transpaso_reformulacion_incremento NUMERIC;
g_importe_comprometido_revertido NUMERIC;
g_importe_ejecutado NUMERIC;
g_importe_ejecutado_revertido NUMERIC;
g_importe_pagado NUMERIC;
g_importe_pagado_revertido NUMERIC;
g_saldo NUMERIC;
g_resul  varchar;
g_estado_com_eje NUMERIC;
g_fecha_com_eje  date;
g_id_moneda  INTEGER;
g_momento_presupuestario VARCHAR;
g_id_partida_presupuesto INTEGER;
g_presupuesto_partida text;
g_tipo_pres NUMERIC;
g_tipo_partida NUMERIC;

BEGIN
  g_resul='FALSE';

  SELECT CASE	
  			WHEN pr_estado_com_eje=1
  			THEN 'Comprometido'
  			WHEN pr_estado_com_eje=2
  			THEN 'Comprometido Revertido'
   			WHEN pr_estado_com_eje=3
  			THEN 'Ejecutado'  				
  			WHEN pr_estado_com_eje=4
  			THEN 'Pagado o Ingresado'
  			WHEN pr_estado_com_eje=5
  			THEN 'Traspaso'
  			WHEN pr_estado_com_eje=6
  			THEN 'Reformulaciones'
  			WHEN pr_estado_com_eje=7
  			THEN 'Incrementos'
  			WHEN pr_estado_com_eje=8
  			THEN 'Ejecutado Revertido'
  			WHEN pr_estado_com_eje=9
  			THEN 'Pagado o Ingresado Revertido'
            ELSE 'ninguno'
            END
  INTO g_momento_presupuestario;
  
  -- verifica el momento presupuestario
  IF g_momento_presupuestario = 'ninguno' THEN
         raise exception '%','No existe el momento presupuestario (f_i_pr_gestionarpresupuesto_verificarimportes)';
  END IF;
  
  -- verifica los parametros de entrada
 if (pr_id_partida_ejecucion IS NULL and  pr_id_partida_presupuesto IS NULL ) or (pr_id_partida_ejecucion IS NOT NULL and  pr_id_partida_presupuesto IS NOT NULL) THEN
		 raise exception '%','Los valores de pr_id_partida_ejecucion y pr_id_partida_presupuesto estan nulos o ambos estan con valor (f_i_pr_gestionarpresupuesto_verificarimportes)';
 END IF;
 
  -- recupuera la partida presupuesto
  g_id_partida_presupuesto=  pr_id_partida_presupuesto;
  IF g_id_partida_presupuesto  is null THEN
	  SELECT id_partida_presupuesto
	  INTO g_id_partida_presupuesto
	  FROM presto.tpr_partida_ejecucion
	  WHERE id_partida_ejecucion=pr_id_partida_ejecucion;
  END IF;
  
  	--recupera el presupuesto
	SELECT 'en el presupuesto: '||                            	
  			COALESCE(pre.desc_presupuesto,'')||'('||pre.id_presupuesto||'); en la partida: '||
            COALESCE( par.codigo_partida,'')||' - '||COALESCE( par.nombre_partida,'')||'('||par.id_partida||')' ,PRE.tipo_press,par.tipo_partida
    INTO g_presupuesto_partida, g_tipo_pres ,g_tipo_partida
	FROM presto.tpr_partida_presupuesto parpre
		INNER JOIN presto.vpr_presupuesto pre on  parpre.id_presupuesto=pre.id_presupuesto
		INNER JOIN presto.tpr_partida par on parpre.id_partida=par.id_partida
	WHERE id_partida_presupuesto=g_id_partida_presupuesto;
	--verificar las reversiones tengan importe negativo

	--  IF  pr_estado_com_eje in (2,8,9) and pr_importe_presupuesto>0 THEN
  IF  pr_estado_com_eje in (8,9) and pr_importe_presupuesto>0 THEN
 		 raise exception '%','El importe presupuesto '||g_momento_presupuestario||' tiene que ser negativo (f_i_pr_gestionarpresupuesto_verificarimportes)';
  END IF;
  
  IF  pr_estado_com_eje in (1,3,4) and pr_importe_presupuesto<0 THEN
	--	raise exception '%','El importe presupuesto '||g_momento_presupuestario||' tiene que ser positivo (f_i_pr_gestionarpresupuesto_verificarimportes)';
  END IF;
  
	---presupuesto de gasto o inversion
	--VERIFIACION EN NIVEL 1  gasto o inversion
	-- Presupuestado,1 : Comprometido	,		5 : Transpaso,	6 : Reformulaciones,	7 : Incrementos
	--2: comprometido revertido
	--presupuestado >=    Comprometido +- Transpaso +-Reformulaciones+Incrementos
   IF pr_estado_com_eje in (1,5,6,7) and pr_id_partida_ejecucion is null and pr_id_partida_presupuesto is not null and g_tipo_pres in (2,3,5,6)THEN
        IF   g_resul='TRUE' THEN
            raise exception '%', 'Ya entro a otra opcion; momento presupuesto: '||g_momento_presupuestario||'; tipo presupuesto '||g_tipo_pres||'(f_i_pr_gestionarpresupuesto_verificarimportes)'  ;
        END IF;
   		raise notice '*************JRR******   id_partida_presupuesto: %, importe: %',pr_id_partida_presupuesto,pr_importe_presupuesto;

	    --recupera el importe presupuestado
        SELECT pardet.total
        INTO g_importe_presupuestado
		FROM presto.tpr_partida_detalle pardet
		WHERE  pardet.id_partida_presupuesto=pr_id_partida_presupuesto and pardet.id_moneda=pr_id_moneda;
        g_importe_presupuestado=COALESCE(g_importe_presupuestado, 0.00);
        
        --verificacion del importe presupestado
        --IF g_importe_presupuestado is null or g_importe_presupuestado <=0   THEN
        --	raise exception '%','(f_i_pr_gestionarpresupuesto_verificarimportes) No existe importe presupuestado';
        --END IF;
        --recupera el importe Comprometido= comprometido - comprometido_revertido
        SELECT   COALESCE (sum (importe_com_eje ),0.00)
        INTO   g_importe_comprometido
		FROM presto.tpr_partida_ejecucion
		WHERE id_partida_presupuesto=pr_id_partida_presupuesto AND estado_com_eje in (1,2) AND id_moneda=pr_id_moneda;
        
        --recupera el importe Transpaso //en negativo imcremetan la disposicion y en positivo disminuyen la disponibilidad
		--recupera el importe Reformulaciones  //en negativo imcremetan la disposicion y en positivo disminuyen la disponibilidad
        --recupera el importe Incrementos //en negativo imcremetan la disposicion y en positivo disminuyen la disponibilidad
        SELECT   -1*(COALESCE (sum (importe_com_eje ),0.00))
        INTO g_importe_transpaso_reformulacion_incremento
		FROM presto.tpr_partida_ejecucion
		WHERE id_partida_presupuesto=pr_id_partida_presupuesto AND estado_com_eje in (5,6,7) AND id_moneda=pr_id_moneda;
		
        --saldo =  Presupuestado-  Comprometido +- Transpaso +- Reformulaciones+ Incrementos
        g_saldo= g_importe_presupuestado-g_importe_comprometido+ g_importe_transpaso_reformulacion_incremento;
        
        --verifica que el saldo sea mayor al importe que se quiere comprometer
        --RAC , BOA  24/12/2013
        --para salver problemas de redondedo
       -- raise exception 'xxxxxxx';
        
        IF pr_importe_presupuesto > g_saldo + 0.01  THEN
        
          /*if g_id_partida_presupuesto != 10716  then
          raise exception 'presupuesto:%  saldo:%    g_pres: %   compr: %',pr_importe_presupuesto,g_saldo, g_importe_presupuestado,g_importe_comprometido;
          end if;*/
          
          --RCM: salto de la validación
          --if g_id_partida_presupuesto != 12089  then --10716, 9359
		  raise exception '%' ,'* No tiene saldo suficiente para continuar. El importe '||g_momento_presupuestario||' es: '||abs(pr_importe_presupuesto)||' y el saldo es: '||g_saldo||' '||g_presupuesto_partida||'('||coalesce(g_id_partida_presupuesto, 0)||') (f_i_pr_gestionarpresupuesto_verificarimportes)';
          --end if;
        END IF;
        --raise exception 'llega ' ;
        g_resul='TRUE';
   END IF;
   
--VERIFIACION EN NIVEL 2  gasto o inversion
-- 1 : Comprometido		2 : Comprometido Revertido	3 : Ejecutado	
-- 8 : ejecutado_revertido
--comprometido >= comprometido revertido + (ejecutado - ejecutado revertido)
   IF pr_estado_com_eje in (2,3) and pr_id_partida_ejecucion is not null and pr_id_partida_presupuesto is null and g_tipo_pres in (2,3,5,6) THEN
   			IF   g_resul='TRUE' THEN
    			raise exception '%', '(f_i_pr_gestionarpresupuesto_verificarimportes) ya entro a otra opcion; momento presupuesto: '||g_momento_presupuestario||'; tipo presupuesto '||g_tipo_pres;
		    END IF;

	--verificamos el estado de la partida ejecucion que venga de  un comprometido	
		SELECT estado_com_eje , fecha_com_eje , id_moneda , importe_com_eje
    	INTO g_estado_com_eje , g_fecha_com_eje , g_id_moneda, g_importe_comprometido
	    FROM presto.tpr_partida_ejecucion
	    WHERE  id_partida_ejecucion =pr_id_partida_ejecucion;

        	--verifica que el id_partida_ejecucion sea del un comprometido
		    IF g_estado_com_eje !=1 THEN
        		 raise exception '%, pr_id_partida_ejecucion:%',' (f_i_pr_gestionarpresupuesto_verificarimportes) El estado tiene que ser comprometido, para poder ejecutar o reveertir el comprometido', pr_id_partida_ejecucion;
	    	END IF;
            --verifica que la moneda de comprometido se la misma del comprometido revertido o ejecutado
	       /* if g_id_moneda!=pr_id_moneda THEN
			raise exception '%',' (f_i_pr_gestionarpresupuesto_verificarimportes) la moneda del comprometido es: '||(SELECT simbolo
																	FROM param.tpm_moneda
																	WHERE id_moneda=g_id_moneda)||' y la moneda del '||g_momento_presupuestario||' es: '||(	SELECT simbolo
																																					FROM param.tpm_moneda
																																					WHERE id_moneda=pr_id_moneda);
            END IF;*/

            --recupera el importe comprometido revertido
        	    SELECT coalesce(   sum(-1*importe_com_eje),0.00)
    	        INTO   g_importe_comprometido_revertido
				FROM presto.tpr_partida_ejecucion
				WHERE  fk_partida_ejecucion=pr_id_partida_ejecucion and id_moneda=g_id_moneda	
                and  estado_com_eje in (2) ;
      
                
             --recupera el importe ejecutado
        	    SELECT coalesce( abs( sum(importe_com_eje)),0.00)
    	        INTO   g_importe_ejecutado
				FROM presto.tpr_partida_ejecucion
				WHERE  fk_partida_ejecucion=pr_id_partida_ejecucion and id_moneda=g_id_moneda	and  estado_com_eje in (3);
              --recupera importe ejecutado revertido
	          	SELECT coalesce(abs( sum(ejerev.importe_com_eje)),0.00)
                INTO   g_importe_ejecutado_revertido
				FROM presto.tpr_partida_ejecucion eje
					INNER JOIN presto.tpr_partida_ejecucion ejerev on eje.id_partida_ejecucion =ejerev.fk_partida_ejecucion and  eje.id_moneda =ejerev.id_moneda
				WHERE  eje.fk_partida_ejecucion=pr_id_partida_ejecucion and  eje.estado_com_eje in (3) and ejerev.estado_com_eje in (8);
                --calcula el saldo
                g_saldo = g_importe_comprometido- g_importe_comprometido_revertido  - (g_importe_ejecutado - g_importe_ejecutado_revertido);
                IF  (abs( pr_importe_presupuesto)> g_saldo  and pr_importe_presupuesto<0 and g_saldo>=0)
                	or (abs( pr_importe_presupuesto)> g_saldo  and pr_estado_com_eje=3 and g_saldo>=0)  THEN
					  raise exception '%' ,' (f_i_pr_gestionarpresupuesto_verificarimportes) No ** tiene saldo suficiente Importe '||g_momento_presupuestario||'  : '||abs(pr_importe_presupuesto)||'; y el saldo  es:'||g_saldo||'; '||g_presupuesto_partida||'('||coalesce(g_id_partida_presupuesto, 0)||') PE:'||pr_id_partida_ejecucion;
                END IF;
		        g_resul='TRUE';

   END IF;

   --VERIFIACION EN NIVEL 3 gasto o inversion
-- 3 : Ejecutado, 8 : Ejecuctado Revertido,	4 : pagado
-- 9 : Pagado Revertido
--Ejecutado >= Ejecuctado Revertido + (pagado - Pagado Revertido)
   IF pr_estado_com_eje in (8,4) and pr_id_partida_ejecucion is not null and pr_id_partida_presupuesto is null   THEN
   			IF   g_resul='TRUE' THEN
    			raise exception '%', '(f_i_pr_gestionarpresupuesto_verificarimportes) ya entro a otra opcion; momento presupuesto: '||g_momento_presupuestario||'; tipo presupuesto '||g_tipo_pres;
		    END IF;

            SELECT estado_com_eje , fecha_com_eje , id_moneda , importe_com_eje
    	  	INTO g_estado_com_eje , g_fecha_com_eje , g_id_moneda, g_importe_ejecutado
	    	FROM presto.tpr_partida_ejecucion
	   		 WHERE  id_partida_ejecucion =pr_id_partida_ejecucion;

        	--verifica que el id_partida_ejecucion sea del un comprometido
		    IF g_estado_com_eje !=3 THEN
        		 raise exception '%','(f_i_pr_gestionarpresupuesto_verificarimportes) El estado tiene que ser ejecutado, para poder pagar o reveertir el ejecutado';
	    	END IF;
            --verifica que la moneda de comprometid se la misma del comprometido revertido o ejecutado
	        if g_id_moneda!=pr_id_moneda THEN
			/*raise exception '%','(f_i_pr_gestionarpresupuesto_verificarimportes) La moneda del ejecutado es: '||(SELECT simbolo
																	FROM param.tpm_moneda
																	WHERE id_moneda=g_id_moneda)||' y la moneda del '||g_momento_presupuestario||' es: '||(	SELECT simbolo
																																					FROM param.tpm_moneda
																																					WHERE id_moneda=pr_id_moneda);*/
            END IF;

            --recupera el importe ejecutado revertido
        	    SELECT coalesce( abs( sum(importe_com_eje)),0.00)
    	        INTO   g_importe_ejecutado_revertido
				FROM presto.tpr_partida_ejecucion
				WHERE  fk_partida_ejecucion=pr_id_partida_ejecucion and id_moneda=g_id_moneda	and  estado_com_eje in (8);
             --recupera el importe pagado
        	    SELECT coalesce( abs( sum(importe_com_eje)),0.00)
    	        INTO   g_importe_pagado
				FROM presto.tpr_partida_ejecucion
				WHERE  fk_partida_ejecucion=pr_id_partida_ejecucion and id_moneda=g_id_moneda	and  estado_com_eje in (4);
              --recupera importe pagado revertido
	          	SELECT coalesce(abs( sum(pagrev.importe_com_eje)),0.00)
                INTO   g_importe_pagado_revertido
				FROM presto.tpr_partida_ejecucion pag
					INNER JOIN presto.tpr_partida_ejecucion pagrev on pag.id_partida_ejecucion =pagrev.fk_partida_ejecucion and  pag.id_moneda =pagrev.id_moneda
				WHERE  pag.fk_partida_ejecucion=pr_id_partida_ejecucion and  pag.estado_com_eje in (4) and pagrev.estado_com_eje in (9);
                --calcula el saldo
                g_saldo = g_importe_ejecutado- coalesce(g_importe_ejecutado_revertido,0)  - (coalesce(g_importe_pagado,0) - coalesce(g_importe_pagado_revertido,0));
                if g_saldo <0 and pr_importe_presupuesto>0 THEN    
               
		                raise exception  '(f_i_pr_gestionarpresupuesto_verificarimportes) El saldo no puedo ser negativo:%;   g_importe_ejecutado: %; g_importe_ejecutado_revertido: % g_importe_pagado: %; g_importe_pagado_revertido: %;); ',g_saldo,  g_importe_ejecutado, g_importe_ejecutado_revertido ,g_importe_pagado , g_importe_pagado_revertido;
                END IF;
               -- raise exception 'cc%',pr_id_partida_ejecucion;      
                 -- raise exception 'g_importe_ejecutado%,g_importe_ejecutado_revertido%, g_importe_pagado%, g_importe_pagado_revertido% ',g_importe_ejecutado,g_importe_ejecutado_revertido, g_importe_pagado , g_importe_pagado_revertido;

               --verifica que el saldo sea mayor al importe que se quiere comprometer
              --RAC , BOA  24/12/2013
              --para salver problemas de redondedo
            
                IF  abs( round(pr_importe_presupuesto,2))> (g_saldo + 0.01) and pr_importe_presupuesto>0 THEN
				 raise exception '%' ,'(f_i_pr_gestionarpresupuesto_verificarimportes) pagado --**** No tiene saldo suficiente Importe '||g_momento_presupuestario||'  : '||abs(pr_importe_presupuesto)||'; y el saldo  es:'||g_saldo||'; '||g_presupuesto_partida||'('||coalesce(g_id_partida_presupuesto, 0)||')';
                END IF;

		        g_resul='TRUE';
   END IF;

      --VERIFIACION EN NIVEL 4 gasto o inversion
-- 4 : pagado,9 : Pagado Revertido
--pagado >= Pagado Revertido
   IF pr_estado_com_eje in (9) and pr_id_partida_ejecucion is not null and pr_id_partida_presupuesto is null   THEN
   			IF   g_resul='TRUE' THEN
    			raise exception '%', '(f_i_pr_gestionarpresupuesto_verificarimportes) ya entro a otra opcion; momento presupuesto: '||g_momento_presupuestario||'; tipo presupuesto '||g_tipo_pres;
		    END IF;
            SELECT estado_com_eje , fecha_com_eje , id_moneda , importe_com_eje
    	  	INTO g_estado_com_eje , g_fecha_com_eje , g_id_moneda, g_importe_pagado
	    	FROM presto.tpr_partida_ejecucion
	   		 WHERE  id_partida_ejecucion =pr_id_partida_ejecucion;
        	--verifica que el id_partida_ejecucion sea del un pago
		    IF g_estado_com_eje !=4 THEN
        		 raise exception '%','(f_i_pr_gestionarpresupuesto_verificarimportes) El estado tiene que ser pagado, para poder revertir el pagado';
	    	END IF;
            --verifica que la moneda de comprometid se la misma del comprometido revertido o ejecutado
	        /*if g_id_moneda!=pr_id_moneda THEN
			raise exception '%','(f_i_pr_gestionarpresupuesto_verificarimportes) la moneda del ejecutado es: '||(SELECT simbolo
																	FROM param.tpm_moneda
																	WHERE id_moneda=g_id_moneda)||' y la moneda del '||g_momento_presupuestario||' es: '||(	SELECT simbolo
																																					FROM param.tpm_moneda
																																					WHERE id_moneda=pr_id_moneda);
            END IF;*/

                --recupera el importe pagado revertido
	          	SELECT coalesce(abs( sum(pagrev.importe_com_eje)),0.00)
                INTO   g_importe_pagado_revertido
				FROM presto.tpr_partida_ejecucion pag
					INNER JOIN presto.tpr_partida_ejecucion pagrev on pag.id_partida_ejecucion =pagrev.fk_partida_ejecucion and  pag.id_moneda =pagrev.id_moneda
				WHERE  pag.id_partida_ejecucion=pr_id_partida_ejecucion and  pag.estado_com_eje in (4) and pagrev.estado_com_eje in (9);
                --calcula el saldo
                g_saldo = g_importe_pagado - g_importe_pagado_revertido;

                if g_saldo < 0.00 THEN
		                raise exception '(f_i_pr_gestionarpresupuesto_verificarimportes) El saldo no puedo ser negativo :%;g_importe_pagado: %; g_importe_pagado_revertido: %;', g_saldo, g_importe_pagado, g_importe_pagado_revertido;
                END IF;


                IF  abs( pr_importe_presupuesto)> g_saldo  THEN
					  raise exception '%' ,'(f_i_pr_gestionarpresupuesto_verificarimportes) No tiene saldo suficiente Importe '||g_momento_presupuestario||'  : '||abs(pr_importe_presupuesto)||'; y el saldo  es:'||g_saldo||'; '||g_presupuesto_partida||'('||coalesce(g_id_partida_presupuesto, 0)||')';
                END IF;
		        g_resul='TRUE';
   END IF;
---------Presupueso de recurso
--VERIFIACION EN NIVEL 1  recurso
-- Presupuestado,1 : ejecutado	,		5 : Transpaso,	6 : Reformulaciones,	7 : Incrementos
--2: ejecutado revertido
--presupuestado >=    ejecutado +- Transpaso +-Reformulaciones+Incrementos
--RCM cambio
   IF pr_estado_com_eje in (3,5,6,7) and pr_id_partida_ejecucion is null and pr_id_partida_presupuesto is not null and g_tipo_pres in (1,4)THEN
    	IF   g_resul='TRUE' THEN
    		raise exception '%', '(f_i_pr_gestionarpresupuesto_verificarimportes) ya entro a otra opcion; momento presupuesto: '||g_momento_presupuestario||'; tipo presupuesto '||g_tipo_pres;
	    END IF;

	    --recupera el importe presupuestado
        SELECT pardet.total
        INTO g_importe_presupuestado
		FROM presto.tpr_partida_detalle pardet
		WHERE  pardet.id_partida_presupuesto=pr_id_partida_presupuesto and pardet.id_moneda=pr_id_moneda;
        --verificacion del importe presupestado
        IF g_importe_presupuestado is null or g_importe_presupuestado <=0 and g_tipo_partida not in (1)  THEN
        	raise exception '%;,g_importe_presupuestado:%;pr_id_moneda:%;pr_id_partida_presupuesto:%; g_tipo_partida:%;','(f_i_pr_gestionarpresupuesto_verificarimportes) No existe importe presupuestado',g_importe_presupuestado,pr_id_moneda,pr_id_partida_presupuesto,g_tipo_partida;
        END IF;
        --recupera el importe ejecutado y el ejecutado revertido
        SELECT   COALESCE (sum (importe_com_eje ),0.00)
        INTO   g_importe_ejecutado
		FROM presto.tpr_partida_ejecucion
		WHERE id_partida_presupuesto=pr_id_partida_presupuesto AND estado_com_eje in (3,8) AND id_moneda=pr_id_moneda;
        --recupera el importe Transpaso //en negativo imcremetan la disposicion y en positivo disminuyen la disponibilidad
		--recupera el importe Reformulaciones  //en negativo imcremetan la disposicion y en positivo disminuyen la disponibilidad
        --recupera el importe Incrementos //en negativo imcremetan la disposicion y en positivo disminuyen la disponibilidad
        SELECT   -1*(COALESCE (sum (importe_com_eje ),0.00))
        INTO g_importe_transpaso_reformulacion_incremento
		FROM presto.tpr_partida_ejecucion
		WHERE id_partida_presupuesto=pr_id_partida_presupuesto AND estado_com_eje in (5,6,7) AND id_moneda=pr_id_moneda;
		--saldo =  Presupuestado-  Comprometido +- Transpaso +- Reformulaciones+ Incrementos
        g_saldo= g_importe_presupuestado-g_importe_ejecutado+ g_importe_transpaso_reformulacion_incremento;
        --verifica que el saldo sea mayor al importe que se quiere comprometer
        --comentado por que se pueden sobregirar la ejecucion presupuestaria de recurso
        --IF pr_importe_presupuesto> g_saldo THEN
		--   raise exception '%' ,'(f_i_pr_gestionarpresupuesto_verificarimportes) No tiene saldo suficiente Importe '||g_momento_presupuestario||'  : '||abs(pr_importe_presupuesto)||'; y el saldo  es:'||g_saldo||'; '||g_presupuesto_partida||'('||coalesce(g_id_partida_presupuesto, 0)||')';
        --END IF;
        g_resul='TRUE';
   END IF;
    -----------------------------

    IF   g_resul='FALSE' THEN
    			raise exception '%', '(f_i_pr_gestionarpresupuesto_verificarimportes) No entro a ninguna opcion; momento presupuesto : '||g_momento_presupuestario||'; tipo presupuesto '||g_tipo_pres||';  pr_id_partida_ejecucion: '||coalesce(pr_id_partida_ejecucion ,0)||'; pr_id_partida_presupuesto: '||coalesce(g_id_partida_presupuesto,0);
    END IF;
      g_saldo=g_saldo - pr_importe_presupuesto;
	 RETURN g_saldo;

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER;