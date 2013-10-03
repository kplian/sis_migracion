--------------- SQL ---------------

CREATE OR REPLACE FUNCTION migra.f__on_trig_tpr_concepto_ingas_tconcepto_ingas (
  v_operacion varchar,
  p_id_concepto_ingas integer,
  p_desc_ingas varchar,
  p_estado_reg varchar,
  p_fecha_mod timestamp,
  p_fecha_reg timestamp,
  p_id_item integer,
  p_id_oec integer,
  p_id_servicio integer,
  p_id_usuario_mod integer,
  p_id_usuario_reg integer,
  p_sw_tesoro integer,
  p_tipo varchar,
  p_id_partida integer
)
RETURNS text AS
$body$
/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  February 18, 2013, 4:15 pm
						Autor: autogenerado (ADMINISTRADOR DEL SISTEMA )
						
						*/
						
						DECLARE
						
						BEGIN
						
						    if(v_operacion = 'INSERT') THEN
						
						          INSERT INTO 
						            param.tconcepto_ingas (
						id_concepto_ingas,
						desc_ingas,
						estado_reg,
						fecha_mod,
						fecha_reg,
						id_oec,
						id_usuario_mod,
						id_usuario_reg,
						sw_tes,
						tipo)
				VALUES (
						p_id_concepto_ingas,
						p_desc_ingas,
						p_estado_reg,
						p_fecha_mod,
						p_fecha_reg,
						p_id_oec,
						p_id_usuario_mod,
						p_id_usuario_reg,
						p_sw_tesoro,
						p_tipo);
				--insercion a la tabla tconcepto_partida                        
                INSERT INTO pre.tconcepto_partida(
                        id_concepto_partida,
                        id_concepto_ingas,                        
                        id_partida,
                        fecha_reg,
                        id_usuario_reg)
                VALUES(
                        p_id_concepto_ingas,
                        p_id_concepto_ingas,
                        p_id_partida,
                        p_fecha_reg,
                        p_id_usuario_reg);
						       
		ELSEIF  v_operacion = 'UPDATE' THEN
                  
        
                    UPDATE 
                      param.tconcepto_ingas  
                    SET						 desc_ingas=p_desc_ingas
                   ,estado_reg=p_estado_reg
                   ,fecha_mod=p_fecha_mod
                   ,fecha_reg=p_fecha_reg
                   ,id_oec=p_id_oec
                   ,id_usuario_mod=p_id_usuario_mod
                   ,id_usuario_reg=p_id_usuario_reg
                   ,sw_tes=p_sw_tesoro
                   ,tipo=p_tipo
                   WHERE id_concepto_ingas=p_id_concepto_ingas;
                         
				--actualizacion de la tabla tconcepto_partida
                
                
                 IF EXISTS( SELECT 1 FROM  pre.tconcepto_partida cp
                             WHERE cp.id_partida = p_id_partida
                                  and cp.id_concepto_ingas = p_id_concepto_ingas) THEN
                         
                  ELSE   
                  
                       INSERT INTO pre.tconcepto_partida(
                            id_concepto_partida,
                            id_concepto_ingas,                        
                            id_partida,
                            fecha_reg,
                            id_usuario_reg)
                       VALUES(
                            p_id_concepto_ingas,
                            p_id_concepto_ingas,
                            p_id_partida,
                            p_fecha_reg,
                            p_id_usuario_reg);      
                                  
                  END IF;                
                
               
                        
                
				
					
                	       ELSEIF  v_operacion = 'DELETE' THEN
                           
                           
                                 DELETE FROM 
						              pre.tconcepto_partida
                                  WHERE id_concepto_ingas=p_id_concepto_ingas;
                               
						       
						         DELETE FROM 
						              param.tconcepto_ingas
                                  WHERE id_concepto_ingas=p_id_concepto_ingas;

						       
						       END IF;  
						  
						 return 'true';
						
						-- statements;
						--EXCEPTION
						--WHEN exception_name THEN
						--  statements;
						END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;