CREATE OR REPLACE FUNCTION migra.f__on_trig_tsg_persona_tpersona (
  v_operacion varchar,
  p_id_persona integer,
  p_apellido_materno varchar,
  p_apellido_paterno varchar,
  p_celular1 varchar,
  p_celular2 varchar,
  p_ci varchar,
  p_correo varchar,
  p_direccion varchar,
  p_estado_reg varchar,
  p_extension varchar,
  p_fecha_mod timestamp,
  p_fecha_nacimiento date,
  p_fecha_reg timestamp,
  p_genero varchar,
  p_id_usuario_mod integer,
  p_id_usuario_reg integer,
  p_nombre varchar,
  p_num_documento integer,
  p_telefono1 varchar,
  p_telefono2 varchar
)
RETURNS text AS
$body$
/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  February 7, 2013, 3:35 pm
						Autor: autogenerado (ADMINISTRADOR DEL SISTEMA )
						
						*/
						
						DECLARE
                        
                        	v_cadena_cnx varchar;
						
						BEGIN
                        
                        	v_cadena_cnx = migra.f_obtener_cadena_conexion();
                            
                            
						
						    if(v_operacion = 'INSERT') THEN
						
						          INSERT INTO 
						            SEGU.tpersona (
						id_persona,
						apellido_materno,
						apellido_paterno,
						celular1,
						celular2,
						ci,
						correo,
						direccion,
						estado_reg,
						extension,
						fecha_mod,
						fecha_nacimiento,
						fecha_reg,
						genero,
						id_usuario_mod,
						id_usuario_reg,
						nombre,
						num_documento,
						telefono1,
						telefono2)
				VALUES (
						p_id_persona,
						p_apellido_materno,
						p_apellido_paterno,
						p_celular1,
						p_celular2,
						p_ci,
						p_correo,
						p_direccion,
						p_estado_reg,
						p_extension,
						p_fecha_mod,
						p_fecha_nacimiento,
						p_fecha_reg,
						p_genero,
						p_id_usuario_mod,
						p_id_usuario_reg,
						p_nombre,
						p_num_documento,
						p_telefono1,
						p_telefono2);
                      
                       /* update segu.tpersona set 
                            foto=(
                                    select foto 
                                    --from dblink('host=192.168.1.108 dbname=dbendesis user=postgres password=postgres','select foto_persona from sss.tsg_persona where id_persona='||p_id_persona)
                                    from dblink(v_cadena_cnx,'select foto_persona from sss.tsg_persona where id_persona='||p_id_persona)
                                    as (foto bytea))
                             where id_persona=p_id_persona;*/

						       
							    ELSEIF  v_operacion = 'UPDATE' THEN
                                
                                
                                /*raise exception '%,%,%,%,%,%,%,%,%,%,%,%,%,%,%,%,%,%,%',p_apellido_materno
						 ,p_apellido_paterno
						 ,p_celular1
						 ,p_celular2
						 ,p_ci
						 ,p_correo
						 ,p_direccion
						 ,p_estado_reg
						 ,p_extension
						 ,p_fecha_mod
						 ,p_fecha_nacimiento
						 ,p_fecha_reg
						 ,p_genero
						 ,p_id_usuario_mod
						 ,p_id_usuario_reg
						 ,p_nombre
						 ,p_num_documento
						 ,p_telefono1
						 ,p_telefono2;*/
                                

						               UPDATE 
						                  SEGU.tpersona  
						                SET						 
                                        apellido_materno=p_apellido_materno
						 ,apellido_paterno=p_apellido_paterno
						 ,celular1=p_celular1
						 ,celular2=p_celular2
						 ,ci=p_ci
						 ,correo=p_correo
						 ,direccion=p_direccion
						 ,estado_reg=p_estado_reg
						 ,extension=p_extension
						 ,fecha_mod=p_fecha_mod
						 ,fecha_nacimiento=p_fecha_nacimiento
						 ,fecha_reg=p_fecha_reg
						 ,genero=p_genero
						 ,id_usuario_mod=p_id_usuario_mod
						 ,id_usuario_reg=p_id_usuario_reg
						 ,nombre=p_nombre
						 ,num_documento=p_num_documento
						 ,telefono1=p_telefono1
						 ,telefono2=p_telefono2
						 WHERE id_persona=p_id_persona;
                         
                      

						 /*update segu.tpersona set 
                            foto=(
                                    select foto 
                                    --from dblink('host=192.168.1.108 dbname=dbendesis user=postgres password=postgres','select foto_persona from sss.tsg_persona where id_persona='||p_id_persona)
                                    from dblink(v_cadena_cnx,'select foto_persona from sss.tsg_persona where id_persona='||p_id_persona)
                                    as (foto bytea))
                             where id_persona=p_id_persona;*/
      
                         
						       ELSEIF  v_operacion = 'DELETE' THEN
						       
						         DELETE FROM 
						              SEGU.tpersona
 
						              						 WHERE id_persona=p_id_persona;

						       
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