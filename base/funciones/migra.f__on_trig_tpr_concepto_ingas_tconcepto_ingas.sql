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
  p_id_partida integer,
  p_activo_fijo varchar,
  p_almacenable varchar
)
RETURNS text AS
$body$
/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  February 18, 2013, 4:15 pm
						Autor: autogenerado (ADMINISTRADOR DEL SISTEMA )
						
						*/
						
						DECLARE
                        
                        
                        v_id_concepto_ingas integer;
                        v_desc_ingas varchar;
                        v_tipo varchar;
                        v_id_gestion 	integer;
                        v_id_concepto_ingas_pxp	integer;
                        
                  /*
                  
                  0)  isnerta en ENDESIS
                  
                     verifiquemos que el nombre del concepto no este repetido
                     
                     0.1)  si el concepto existe,  solo insertamoas la nueva relacion con la partida presupuestaria
                     
                     0.2) si el concepto no existe insertamos nuevo concepto y partida
                     
                     
                     
                  
                  1) si es MODIFICACION
                  
                     TODO BLOQUEAR LA MODIFICACION
                      
 				 2)  si es eliminacion 
                   
                    2.1)  BUSCAMOS AL DESCRIPCION Y ELIMINAMOS LA RELACION CON LA APRTIDA  
                    
                  
                  */      
                        
						
						BEGIN
                        
                        
                         select 
                               p.tipo
                              into
                               v_tipo
                              from 
                              pre.tpartida p  
                              where p.id_partida = p_id_partida;
                              
                          v_desc_ingas =   trim (both  E'\t\n\r ' from upper(p_desc_ingas));
                              
                        SELECT 
                          ci.id_concepto_ingas
                        into
                          v_id_concepto_ingas
                        FROM param.tconcepto_ingas ci
                        WHERE  trim(upper(ci.desc_ingas)) = v_desc_ingas;    
						
						    if(v_operacion = 'INSERT') THEN
                            
                              if(v_id_concepto_ingas is NULL)THEN                              		
  									
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
                                          tipo,
                                          activo_fijo,
                                          almacenable,
                                          movimiento)
                                  VALUES (
                                          p_id_concepto_ingas,
                                          v_desc_ingas,
                                          p_estado_reg,
                                          p_fecha_mod,
                                          p_fecha_reg,
                                          p_id_oec,
                                          p_id_usuario_mod,
                                          p_id_usuario_reg,
                                          p_sw_tesoro,
                                          p_tipo,
                                          p_activo_fijo,
                                          p_almacenable,
                                          v_tipo) RETURNING id_concepto_ingas into v_id_concepto_ingas;
                                    
                                                    
                             
                             END IF;
                             select id_gestion into v_id_gestion
                             from pre.tpartida
                             where id_partida =  p_id_partida;
                             
                            INSERT INTO migra.tconcepto_ids(
                                  
                                    id_concepto_ingas,                        
                                    id_concepto_ingas_pxp,
                                    desc_ingas,
                                    id_gestion)
                            VALUES(
                                   
                                    p_id_concepto_ingas,
                                    v_id_concepto_ingas,
                                    p_desc_ingas,
                                    v_id_gestion);  
                                                                      
                            --insercion a la tabla tconcepto_partida                        
                            INSERT INTO pre.tconcepto_partida(
                                  
                                    id_concepto_ingas,                        
                                    id_partida,
                                    fecha_reg,
                                    id_usuario_reg)
                            VALUES(
                                   
                                    v_id_concepto_ingas,
                                    p_id_partida,
                                    p_fecha_reg,
                                    p_id_usuario_reg);
						       
		ELSEIF  v_operacion = 'UPDATE' THEN
        			
        
                     --chequear si ya existe el auxiliar si no sacar un error
                     IF  not EXISTS(select 1 
                       from  migra.tconcepto_ids
                       where id_concepto_ingas = p_id_concepto_ingas) THEN
                                             
                        raise exception 'No existe el registro que desea modificar';
                                                  
                     END IF;
                    
                    
                    select id_concepto_ingas_pxp
                    into v_id_concepto_ingas_pxp
                    from migra.tconcepto_ids
                    where id_concepto_ingas = p_id_concepto_ingas;
                    --raise exception '%',v_id_concepto_ingas;   
                    
                    update migra.tconcepto_ids 
                    set desc_ingas = p_desc_ingas
                    where id_concepto_ingas = p_id_concepto_ingas;       
                    UPDATE 
                      param.tconcepto_ingas  
                    SET						 
                    estado_reg=p_estado_reg
        			,desc_ingas = v_desc_ingas
                   ,fecha_mod=p_fecha_mod
                   ,fecha_reg=p_fecha_reg
                   ,id_oec=p_id_oec
                   ,id_usuario_mod=p_id_usuario_mod
                   ,id_usuario_reg=p_id_usuario_reg
                   ,sw_tes=p_sw_tesoro
                   ,tipo=p_tipo
                   ,activo_fijo=p_activo_fijo
                   ,almacenable=p_almacenable,
                    movimiento = v_tipo
                   WHERE id_concepto_ingas=v_id_concepto_ingas_pxp;
                         
				--actualizacion de la tabla tconcepto_partida
               
                
                 IF EXISTS( SELECT 1 FROM  pre.tconcepto_partida cp
                             WHERE cp.id_partida = p_id_partida
                                  and cp.id_concepto_ingas = v_id_concepto_ingas_pxp) THEN
                         
                  ELSE   
                  
                       INSERT INTO pre.tconcepto_partida(
                          
                            id_concepto_ingas,                        
                            id_partida,
                            fecha_reg,
                            id_usuario_reg)
                       VALUES(
                          
                            v_id_concepto_ingas_pxp,
                            p_id_partida,
                            p_fecha_reg,
                            p_id_usuario_reg);      
                                  
                  END IF;                
                
               
				
					
                	       ELSEIF  v_operacion = 'DELETE' THEN
                            	
                               --chequear si ya existe el auxiliar si no sacar un error
                               IF  not EXISTS(select 1 
                                 from  migra.tconcepto_ids
                                 where id_concepto_ingas = p_id_concepto_ingas) THEN
                                                       
                                  raise exception 'No existe el registro que desea eliminar';
                                                            
                               END IF;
                           
                           
                           
                                 select id_concepto_ingas_pxp
                                into v_id_concepto_ingas
                                from migra.tconcepto_ids
                                where id_concepto_ingas = p_id_concepto_ingas;
                                 
                                 DELETE FROM 
						              pre.tconcepto_partida
                                  WHERE 
                                        id_concepto_ingas=v_id_concepto_ingas
                                  AND  id_partida = p_id_partida;
                                  
                                  DELETE FROM 
						              migra.tconcepto_ids
                                  WHERE 
                                        id_concepto_ingas=p_id_concepto_ingas;
                               
						       
                                IF (not exists(select 1 from pre.tconcepto_partida  cp where cp.id_concepto_ingas = v_id_concepto_ingas)) THEN
                           
                                   update
                                        param.tconcepto_ingas
                                        set estado_reg = 'inactivo'
                                    WHERE id_concepto_ingas=v_id_concepto_ingas;
                                  
                                END IF;  

						       
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