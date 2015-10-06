--------------- SQL ---------------

CREATE OR REPLACE FUNCTION presto.f_i_pr_gestionarpresupuesto_array (
  pr_id_presupuesto integer [],
  pr_id_partida integer [],
  pr_id_moneda integer [],
  pr_monto_total numeric [],
  pr_fecha date [],
  pr_id_partida_ejecucion integer [],
  pr_sw_momento numeric [],
  pr_id_item integer [],
  pr_id_servicio integer [],
  pr_id_concepto_ingas integer [],
  pr_columna_relacion varchar [],
  pr_fk_llave integer [],
  pr_id_int_comprobante integer
)
RETURNS numeric [] AS
$body$
/*
    
    Nombre: f_i_pr_gestionarpresupuesto_array
    Descripción: Llamada a la funcion de gestionar  presupuesto segun array
    Autor: Rensi Arteaga Coapri
    Fecha:  24/06/2013
    
    
*/   

DECLARE



v_i  integer;

v_size integer;  --tamano del array

v_cont integer;  --controla la posiscion de la respuesta en el array de retorno

v_resp numeric[];
v_rescom numeric[];


v_id_cuenta_doc  integer;
v_id_devengado   integer;
v_id_solicitud_compra  integer;
v_id_cuenta_doc_rendicion  integer;  
v_id_comprobante  integer;

 v_columna_relacion  varchar;
 v_fk_llave  integer;
 
 --gvc 29-07-2014
 g_id_partida_ejecucion_devengado integer;
 g_id_partida_ejecucion_comprometido  integer;
 g_estado_com_eje	numeric;
 
BEGIN

--determinar el comprobante correspondiente al intermediario

IF pr_id_int_comprobante is NOT NULL THEN

  select 
  c.id_comprobante
  into
  v_id_comprobante
  from sci.tct_comprobante c
  where c.id_int_comprobante = pr_id_int_comprobante;

END IF;

  

-- 0) determinar el tamanho del array


 v_size = array_upper(pr_sw_momento, 1);
 -- 1)recorre las posiciones del array 
 
 --  raise  exception 'xxx   ERROR ENDESIS %, %, %, %, %',pr_sw_momento, v_size, pr_fk_llave, pr_id_moneda, pr_monto_total ;
 
FOR v_i IN 1..v_size LOOP
 
 -- 1.1)  llamara la funcion de ejecucion
 
           v_id_cuenta_doc =NULL;
           v_id_devengado  =NULL;
           v_id_solicitud_compra  =NULL;
           v_id_cuenta_doc_rendicion  =NULL;
           v_columna_relacion  =NULL;
           v_fk_llave  =NULL;
 
 
          IF( pr_columna_relacion is not NULL ) THEN 
 
             IF pr_columna_relacion[v_i]= 'id_cuenta_doc' THEN 
             
                v_id_cuenta_doc = pr_fk_llave[v_i];
             
             ELSIF pr_columna_relacion[v_i] = 'id_devengado' THEN 
             
                v_id_devengado = pr_fk_llave[v_i];
             
             ELSEIF pr_columna_relacion[v_i] = 'id_solicitud_compra' THEN 
             
                v_id_solicitud_compra = pr_fk_llave[v_i];
             
             ELSEIF pr_columna_relacion[v_i] = 'id_cuenta_doc_rendicion' THEN 
             
                v_id_cuenta_doc_rendicion = pr_fk_llave[v_i];
             
             
             
             ELSE 
             
               v_columna_relacion  =pr_columna_relacion[v_i];
               v_fk_llave   = pr_fk_llave[v_i];
            
             END IF;
          
          
          END IF;
 
 
      --  raise exception 'ante de la segunda  %',pr_fecha[v_i]::date;
   
 	--obtenemos el estado_com_eje del id_partida_ejecucion origen
    select pe.estado_com_eje
    into g_estado_com_eje
    from presto.tpr_partida_ejecucion pe
    where pe.id_partida_ejecucion = pr_id_partida_ejecucion[v_i];
       
    
    --raise exception ' ...  %, %', pr_id_moneda[v_i], pr_monto_total[v_i];
     -------------------------------------------------
     --  Si no tenemos un comprometido y necesitamos  devengar
     --------------------------------------------------
     IF   pr_id_partida_ejecucion[v_i] is NULL and pr_sw_momento[v_i] in (3, 4)   THEN
       
             -- COMPROMETER
             v_rescom:= presto.f_i_pr_gestionarpresupuesto(
                                                      pr_id_presupuesto[v_i],
                                                      pr_id_partida[v_i],
                                                      pr_id_moneda[v_i],
                                                      pr_monto_total[v_i],
                                                      -- NULL,
                                                      --now()::date,
                                                      pr_fecha[v_i]::date,
                                                      NULL,
                                                      1,    --MOMENTO COMPROMETIDO
                                                      pr_id_item[v_i],
                                                      pr_id_servicio[v_i],
                                                      pr_id_concepto_ingas[v_i],
                                                      v_id_cuenta_doc,
                                                      v_id_devengado,
                                                      v_id_solicitud_compra,
                                                      v_id_cuenta_doc_rendicion,                   --id_cuenta_doc_rendicion
                                                      v_id_comprobante,
                                                      v_columna_relacion,
                                                      v_fk_llave
                                            );
            -- DEVENGAR
            
            g_id_partida_ejecucion_comprometido = v_rescom[1];
            
            v_rescom:=presto.f_i_pr_gestionarpresupuesto(
                                                      pr_id_presupuesto[v_i],
                                                      pr_id_partida[v_i],
                                                      pr_id_moneda[v_i],
                                                      pr_monto_total[v_i],
                                                     -- NULL,
                                                       --now()::date,
                                                      pr_fecha[v_i]::date,
                                                      g_id_partida_ejecucion_comprometido, --pr_id_partida_ejecucion[v_i],
                                                      3,  --MOMENTO DEVENGAR
                                                      pr_id_item[v_i],
                                                      pr_id_servicio[v_i],
                                                      pr_id_concepto_ingas[v_i],
                                                      v_id_cuenta_doc,
                                                      v_id_devengado,
                                                      v_id_solicitud_compra,
                                                      v_id_cuenta_doc_rendicion,                   --id_cuenta_doc_rendicion
                                                      v_id_comprobante,
                                                      v_columna_relacion,
                                                      v_fk_llave
                                            );
                                            
               --   PAGAR ....  solo si el momento es 4                           
               IF  pr_sw_momento[v_i] = 4   THEN  
               
                           g_id_partida_ejecucion_devengado = v_rescom[1];                                
     
                           --registramos el pagado
                           v_rescom:=presto.f_i_pr_gestionarpresupuesto(
                                                      pr_id_presupuesto[v_i],
                                                      pr_id_partida[v_i],
                                                      pr_id_moneda[v_i],
                                                      pr_monto_total[v_i],
                                                     -- NULL,
                                                       --now()::date,
                                                      pr_fecha[v_i]::date,
                                                      g_id_partida_ejecucion_devengado, --pr_id_partida_ejecucion[v_i],
                                                      4, --momento PAGADO
                                                      pr_id_item[v_i],
                                                      pr_id_servicio[v_i],
                                                      pr_id_concepto_ingas[v_i],
                                                      v_id_cuenta_doc,
                                                      v_id_devengado,
                                                      v_id_solicitud_compra,
                                                      v_id_cuenta_doc_rendicion,                   --id_cuenta_doc_rendicion
                                                      v_id_comprobante,
                                                      v_columna_relacion,
                                                      v_fk_llave
                                            );
        
               END IF;                       
     -----------------------------------------------------
     -- SI tenemos un comprometido y necesitamos PAGAR
     -------------------------------------------------------
 	 ELSEIF(g_estado_com_eje = 1 and pr_sw_momento[v_i] = 4 )then
       
           raise notice '>>>>>>  paso %',v_i;
           --registramos el devengado
           v_rescom:=presto.f_i_pr_gestionarpresupuesto(
                                                      pr_id_presupuesto[v_i],
                                                      pr_id_partida[v_i],
                                                      pr_id_moneda[v_i],
                                                      pr_monto_total[v_i],
                                                      -- NULL,
                                                      --now()::date,
                                                      pr_fecha[v_i]::date,
                                                      pr_id_partida_ejecucion[v_i],
                                                      pr_sw_momento[v_i] - 1::numeric,     --3, --pr_sw_momento[v_i],  --DEVENGADO
                                                      pr_id_item[v_i],
                                                      pr_id_servicio[v_i],
                                                      pr_id_concepto_ingas[v_i],
                                                      v_id_cuenta_doc,
                                                      v_id_devengado,
                                                      v_id_solicitud_compra,
                                                      v_id_cuenta_doc_rendicion,                   --id_cuenta_doc_rendicion
                                                      v_id_comprobante,
                                                      v_columna_relacion,
                                                      v_fk_llave
                                            );
                                            
           --obtenemos el id_partida_ejecucion del devengado      
           g_id_partida_ejecucion_devengado = v_rescom[1];                           
                                            
           raise notice '>>>>>>  paso %',v_i;
           
           --registramos el pagado
           v_rescom:=presto.f_i_pr_gestionarpresupuesto(
                                                      pr_id_presupuesto[v_i],
                                                      pr_id_partida[v_i],
                                                      pr_id_moneda[v_i],
                                                      pr_monto_total[v_i],
                                                     -- NULL,
                                                       --now()::date,
                                                      pr_fecha[v_i]::date,
                                                      g_id_partida_ejecucion_devengado, --pr_id_partida_ejecucion[v_i],
                                                      pr_sw_momento[v_i],
                                                      pr_id_item[v_i],
                                                      pr_id_servicio[v_i],
                                                      pr_id_concepto_ingas[v_i],
                                                      v_id_cuenta_doc,
                                                      v_id_devengado,
                                                      v_id_solicitud_compra,
                                                      v_id_cuenta_doc_rendicion,                   --id_cuenta_doc_rendicion
                                                      v_id_comprobante,
                                                      v_columna_relacion,
                                                      v_fk_llave
                                            );
      else                                      
      
      		raise notice '>>>>>>  paso %',v_i;
       		v_rescom:=presto.f_i_pr_gestionarpresupuesto(
                                                  pr_id_presupuesto[v_i],
                                                  pr_id_partida[v_i],
                                                  pr_id_moneda[v_i],
                                                  pr_monto_total[v_i],
                                                 -- NULL,
                                                   --now()::date,
                                                  pr_fecha[v_i]::date,
                                                  pr_id_partida_ejecucion[v_i],
                                                  pr_sw_momento[v_i],
                                                  pr_id_item[v_i],
                                                  pr_id_servicio[v_i],
                                                  pr_id_concepto_ingas[v_i],
                                                  v_id_cuenta_doc,
                                                  v_id_devengado,
                                                  v_id_solicitud_compra,
                                                  v_id_cuenta_doc_rendicion,                   --id_cuenta_doc_rendicion
                                                  v_id_comprobante,
                                                  v_columna_relacion,
                                                  v_fk_llave
                                        );                                      
                                            
      end if;
 
 
    -- 1.2)  almacena resultado en el array de respuesta

   v_resp[v_i]=v_rescom[1];

  END LOOP;

  -- 2) retorna el resultado  
   
  RETURN v_resp;   
         

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;