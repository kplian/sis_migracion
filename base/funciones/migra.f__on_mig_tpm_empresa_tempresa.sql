--------------- SQL ---------------

CREATE OR REPLACE FUNCTION migra.f__on_trig_tpm_empresa_tempresa (
  v_operacion varchar,
  p_id_empresa integer,
  p_codigo varchar,
  p_estado_reg varchar,
  p_fecha_mod timestamp,
  p_fecha_reg timestamp,
  p_id_usuario_mod integer,
  p_id_usuario_reg integer,
  p_logo varchar,
  p_nit varchar,
  p_nombre varchar
)
RETURNS text AS
$body$
/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  February 5, 2013, 3:14 pm
						Autor: autogenerado (ADMINISTRADOR DEL SISTEMA )
						
						*/
						
						DECLARE
						
						BEGIN
						
						    if(v_operacion = 'INSERT') THEN
						
						          INSERT INTO 
						            PARAM.tempresa (
						id_empresa,
						codigo,
						estado_reg,
						fecha_mod,
						fecha_reg,
						id_usuario_mod,
						id_usuario_reg,
						logo,
						nit,
						nombre)
				VALUES (
						p_id_empresa,
						p_codigo,
						p_estado_reg,
						p_fecha_mod,
						p_fecha_reg,
						p_id_usuario_mod,
						p_id_usuario_reg,
						p_logo,
						p_nit,
						p_nombre);

						       
							    ELSEIF  v_operacion = 'UPDATE' THEN
						               
                                  --chequear si ya existe el auxiliar si no sacar un error
                                 IF  not EXISTS(select 1 
                                   from  PARAM.tempresa 
                                   where id_empresa=p_id_empresa) THEN
                                             
                                    raise exception 'No existe el registro que desea modificar';
                                                  
                                 END IF;
                                       
                                       
                                       
                                       UPDATE 
						                  PARAM.tempresa  
						                SET						 codigo=p_codigo
						 ,estado_reg=p_estado_reg
						 ,fecha_mod=p_fecha_mod
						 ,fecha_reg=p_fecha_reg
						 ,id_usuario_mod=p_id_usuario_mod
						 ,id_usuario_reg=p_id_usuario_reg
						 ,logo=p_logo
						 ,nit=p_nit
						 ,nombre=p_nombre
						 WHERE id_empresa=p_id_empresa;

						       
						       ELSEIF  v_operacion = 'DELETE' THEN
						       
						         
                                  --chequear si ya existe el auxiliar si no sacar un error
                                 IF  not EXISTS(select 1 
                                   from  PARAM.tempresa 
                                   where id_empresa=p_id_empresa) THEN
                                             
                                    raise exception 'No existe el registro que desea eliminar';
                                                  
                                 END IF;
                                 
                                 DELETE FROM 
						              PARAM.tempresa
 
						              						 WHERE id_empresa=p_id_empresa;

						       
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