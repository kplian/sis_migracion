CREATE OR REPLACE FUNCTION migra.f__on_trig_tts_finalidad_cta_bancaria_tcuenta_bancaria (
  v_operacion varchar,
  p_id_cuenta_bancaria integer,
  p_id_finalidad integer,
  p_id_finalidad_old integer
)
RETURNS text AS
$body$
/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  November 30, 2013, 11:10 am
						Autor: autogenerado (ADMINISTRADOR DEL SISTEMA )
						
						*/
						
DECLARE

	v_id_cuenta_bancaria integer;
    v_id_cuenta_bancaria_pxp integer;
    v_id_finalidad		integer[];
						
BEGIN
						
	if(v_operacion = 'INSERT') THEN
						
        select cta.id_cuenta_bancaria_pxp into v_id_cuenta_bancaria_pxp
        from migra.tts_cuenta_bancaria cta
        where cta.id_cuenta_bancaria = p_id_cuenta_bancaria;
        
        if v_id_cuenta_bancaria_pxp is not null then
        	              	
            select cta.id_finalidad into v_id_finalidad 
            from tes.tcuenta_bancaria cta
            where cta.id_cuenta_bancaria=v_id_cuenta_bancaria_pxp;
            
            IF(v_id_finalidad @> ARRAY[p_id_finalidad]) THEN
            ELSE
              update tes.tcuenta_bancaria set
              id_finalidad = array_append(v_id_finalidad,p_id_finalidad) 
              where id_cuenta_bancaria = v_id_cuenta_bancaria_pxp;
            END IF;
         end if;
						       
	ELSEIF  v_operacion = 'UPDATE' THEN
    
    
     --chequear si ya existe el registro si no sacar un error
      IF  not EXISTS(select 1 
         from  MIGRA.tts_cuenta_bancaria  
         where id_cuenta_bancaria=p_id_cuenta_bancaria) THEN
                                                       
          raise exception 'No existe el registro que desea modificar';
                                                            
       END IF; 
    	
       		select cta.id_cuenta_bancaria_pxp into v_id_cuenta_bancaria_pxp
            from migra.tts_cuenta_bancaria cta
            where cta.id_cuenta_bancaria = p_id_cuenta_bancaria;
            
            if v_id_cuenta_bancaria_pxp is not null then
            	              	
                select cta.id_finalidad into v_id_finalidad 
                from tes.tcuenta_bancaria cta
                where cta.id_cuenta_bancaria=v_id_cuenta_bancaria_pxp;
                
                IF(v_id_finalidad @> ARRAY[p_id_finalidad_old]) THEN
                
                	v_id_finalidad = array_remove(v_id_finalidad,p_id_finalidad_old);
                    
                    update tes.tcuenta_bancaria set
                    id_finalidad = array_append(v_id_finalidad,p_id_finalidad) 
                    where id_cuenta_bancaria = v_id_cuenta_bancaria_pxp;                	
                END IF;
            end if;    
						       
	ELSEIF  v_operacion = 'DELETE' THEN
        					       
          --chequear si ya existe el registro si no sacar un error
      IF  not EXISTS(select 1 
         from   MIGRA.tts_cuenta_bancaria  
         where id_cuenta_bancaria=p_id_cuenta_bancaria) THEN
                                                       
          raise exception 'No existe el registro que desea modificar';
                                                            
       END IF;
          --Obtiene el id_cuenta_bancaria_pxp para realizar el delete
        select
        cb.id_cuenta_bancaria_pxp
        into v_id_cuenta_bancaria_pxp
        from migra.tts_cuenta_bancaria cb
        where id_cuenta_bancaria=p_id_cuenta_bancaria;
                
        select cta.id_finalidad into v_id_finalidad 
        from tes.tcuenta_bancaria cta
        where cta.id_cuenta_bancaria=v_id_cuenta_bancaria_pxp;
        
        IF(v_id_finalidad @> ARRAY[p_id_finalidad_old])THEN
          UPDATE tes.tcuenta_bancaria
          SET id_finalidad = array_remove(v_id_finalidad,p_id_finalidad_old)
          WHERE id_cuenta_bancaria = v_id_cuenta_bancaria_pxp;
		ELSE
          raise exception 'La cuenta bancaria no contiene esa finalidad';
        END IF;				       
	END IF;  
						  
	return 'true';
	
	END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;