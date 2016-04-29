CREATE OR REPLACE FUNCTION migra.f__on_trig_tsg_lugar_tlugar (
  v_operacion varchar,
  p_id_lugar integer,
  p_id_lugar_fk integer,
  p_codigo varchar,
  p_codigo_largo varchar,
  p_estado_reg varchar,
  p_fecha_mod timestamp,
  p_fecha_reg timestamp,
  p_id_usuario_mod integer,
  p_id_usuario_reg integer,
  p_nombre varchar,
  p_sw_impuesto varchar,
  p_sw_municipio varchar,
  p_tipo varchar,
  p_es_regional varchar
)
RETURNS text AS
$body$
/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  June 7, 2013, 4:01 pm
						Autor: autogenerado (ADMINISTRADOR DEL SISTEMA )
						
						*/
						
						DECLARE
						
						v_codigos 			record;
                        v_codigo_largo		varchar;
                        v_tamanio			int4;
						
						BEGIN
						
						    if(v_operacion = 'INSERT') THEN
						
						          INSERT INTO 
						            PARAM.tlugar (
						id_lugar,
						id_lugar_fk,
						codigo,
						codigo_largo,
						estado_reg,
						fecha_mod,
						fecha_reg,
						id_usuario_mod,
						id_usuario_reg,
						nombre,
						sw_impuesto,
						sw_municipio,
						tipo,
                        es_regional)
				VALUES (
						p_id_lugar,
						p_id_lugar_fk,
						p_codigo,
						p_codigo_largo,
						p_estado_reg,
						p_fecha_mod,
						p_fecha_reg,
						p_id_usuario_mod,
						p_id_usuario_reg,
						p_nombre,
						p_sw_impuesto,
						p_sw_municipio,
						p_tipo,
                        p_es_regional);
						
						create temp table codigos(
                        	  id_lugar int4,
                              id_lugar_fk int4,
                              codigo varchar
                        ) on commit drop;

						insert into codigos(
						WITH RECURSIVE otro(id_lugar, id_lugar_fk, codigo)AS(		
                        SELECT l.id_lugar, l.id_lugar_fk, l.codigo
                            FROM param.tlugar l
                            WHERE l.id_lugar=p_id_lugar and l.id_lugar_fk!=p_id_lugar
                        UNION ALL 
                            SELECT l.id_lugar, l.id_lugar_fk, l.codigo
                            FROM param.tlugar l, otro o
                            WHERE l.id_lugar=o.id_lugar_fk
                        )select * from otro order by id_lugar ASC);
                        
                        select count(id_lugar) into v_tamanio from codigos;
                        if (v_tamanio!=0) then
                            FOR v_codigos in select * from codigos                        
                            LOOP
                                v_codigo_largo:=pxp.concatvarchar(v_codigo_largo,v_codigos.codigo);
                            END LOOP;                       
                    		
                            UPDATE PARAM.tlugar SET 
                             codigo_largo=v_codigo_largo
                             WHERE id_lugar=p_id_lugar;						

						end if;						       
							    ELSEIF  v_operacion = 'UPDATE' THEN
						              
                                 --chequear si ya existe el registro si no sacar un error
                              
                        
                              IF  not EXISTS(select 1 
                                 from  PARAM.tlugar  
                                 where id_lugar=p_id_lugar) THEN
                                                       
                                  raise exception 'No existe el registro que desea modificar';
                                                            
                               END IF; 
                                
                                
                                
                                 UPDATE 
						                  PARAM.tlugar  
						                SET	  id_lugar_fk=p_id_lugar_fk
                                             ,codigo=p_codigo
                                             ,codigo_largo=p_codigo_largo
                                             ,estado_reg=p_estado_reg
                                             ,fecha_mod=p_fecha_mod
                                             ,fecha_reg=p_fecha_reg
                                             ,id_usuario_mod=p_id_usuario_mod
                                             ,id_usuario_reg=p_id_usuario_reg
                                             ,nombre=p_nombre
                                             ,sw_impuesto=p_sw_impuesto
                                             ,sw_municipio=p_sw_municipio
                                             ,tipo=p_tipo
                                             ,es_regional = p_es_regional
                                             WHERE id_lugar=p_id_lugar;
                         
                         create temp table codigos(
                        	  id_lugar int4,
                              id_lugar_fk int4,
                              codigo varchar
                        ) on commit drop;

						insert into codigos(
						WITH RECURSIVE otro(id_lugar, id_lugar_fk, codigo)AS(		
                        SELECT l.id_lugar, l.id_lugar_fk, l.codigo
                            FROM param.tlugar l
                            WHERE l.id_lugar=p_id_lugar and l.id_lugar_fk!=p_id_lugar
                        UNION ALL 
                            SELECT l.id_lugar, l.id_lugar_fk, l.codigo
                            FROM param.tlugar l, otro o
                            WHERE l.id_lugar=o.id_lugar_fk
                        )select * from otro order by id_lugar ASC);
                        
                        select count(id_lugar) into v_tamanio from codigos;
                        if (v_tamanio!=0) then
                            FOR v_codigos in select * from codigos                        
                            LOOP
                                v_codigo_largo:=pxp.concatvarchar(v_codigo_largo,v_codigos.codigo);
                            END LOOP;                       
                    		
                            UPDATE PARAM.tlugar SET 
                             codigo_largo=v_codigo_largo
                             WHERE id_lugar=p_id_lugar;						

						end if;	

						       
						       ELSEIF  v_operacion = 'DELETE' THEN
						       
						           --chequear si ya existe el registro si no sacar un error
                              
                        
                              IF  not EXISTS(select 1 
                                 from  PARAM.tlugar  
                                 where id_lugar=p_id_lugar) THEN
                                                       
                                  raise exception 'No existe el registro que desea eliminar';
                                                            
                               END IF;
                                 
                                 
                                 DELETE FROM 
						              PARAM.tlugar
 
						              						 WHERE id_lugar=p_id_lugar;

						       
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