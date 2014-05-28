--------------- SQL ---------------

CREATE OR REPLACE FUNCTION migra.f__on_trig_tpm_tipo_cambio_ttipo_cambio (
  v_operacion varchar,
  p_id_tipo_cambio integer,
  p_compra numeric,
  p_estado_reg varchar,
  p_fecha date,
  p_fecha_mod timestamp,
  p_fecha_reg timestamp,
  p_id_moneda integer,
  p_id_usuario_mod integer,
  p_id_usuario_reg integer,
  p_observaciones varchar,
  p_oficial numeric,
  p_venta numeric
)
RETURNS text AS
$body$
/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  March 8, 2013, 10:54 am
						Autor: autogenerado (ADMINISTRADOR DEL SISTEMA )
						
						*/
						
						DECLARE
						
						BEGIN
						
						    if(v_operacion = 'INSERT') THEN
						
						          INSERT INTO 
						            PARAM.ttipo_cambio (
						id_tipo_cambio,
						compra,
						estado_reg,
						fecha,
						fecha_mod,
						fecha_reg,
						id_moneda,
						id_usuario_mod,
						id_usuario_reg,
						observaciones,
						oficial,
						venta)
				VALUES (
						p_id_tipo_cambio,
						p_compra,
						p_estado_reg,
						p_fecha,
						p_fecha_mod,
						p_fecha_reg,
						p_id_moneda,
						p_id_usuario_mod,
						p_id_usuario_reg,
						p_observaciones,
						p_oficial,
						p_venta);

						       
							    ELSEIF  v_operacion = 'UPDATE' THEN
						               
                                       
                                       
                                 --chequear si ya existe el auxiliar si no sacar un error
                                 IF  not EXISTS(select 1 
                                   from  PARAM.ttipo_cambio 
                                   where id_tipo_cambio=p_id_tipo_cambio) THEN
                                             
                                    raise exception 'No existe el registro que desea modificar';
                                                  
                                 END IF;     
                                       
                                       
                                       UPDATE 
						                  PARAM.ttipo_cambio  
						                SET						 compra=p_compra
						 ,estado_reg=p_estado_reg
						 ,fecha=p_fecha
						 ,fecha_mod=p_fecha_mod
						 ,fecha_reg=p_fecha_reg
						 ,id_moneda=p_id_moneda
						 ,id_usuario_mod=p_id_usuario_mod
						 ,id_usuario_reg=p_id_usuario_reg
						 ,observaciones=p_observaciones
						 ,oficial=p_oficial
						 ,venta=p_venta
						 WHERE id_tipo_cambio=p_id_tipo_cambio;

						       
						       ELSEIF  v_operacion = 'DELETE' THEN
						       
						        --chequear si ya existe el auxiliar si no sacar un error
                                 IF  not EXISTS(select 1 
                                   from  PARAM.ttipo_cambio 
                                   where id_tipo_cambio=p_id_tipo_cambio) THEN
                                             
                                    raise exception 'No existe el registro que desea eliminar';
                                                  
                                 END IF;
                                 
                                 
                                 DELETE FROM 
						              PARAM.ttipo_cambio
 
						              						 WHERE id_tipo_cambio=p_id_tipo_cambio;

						       
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