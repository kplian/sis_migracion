CREATE OR REPLACE FUNCTION migra.f__on_trig_tct_comprobante_libro_bancos_tcomprobante_libro_banc (
  v_operacion varchar,
  p_id_comprobante_libro_bancos integer,
  p_id_int_comprobante integer,
  p_id_libro_bancos_cheque integer,
  p_id_libro_bancos_deposito integer,
  p_estado_reg varchar,
  p_fecha_mod timestamp,
  p_fecha_reg timestamp,
  p_id_usuario_mod integer,
  p_id_usuario_reg integer,
  p_tipo varchar
)
RETURNS text AS
$body$
/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  October 23, 2014, 6:18 pm
						Autor: autogenerado (GONZALO JOSE SARMIENTO SEJAS)
						
						*/
						
						DECLARE
						
						BEGIN
						
						    if(v_operacion = 'INSERT') THEN
						
						          INSERT INTO 
						            CONTA.tcomprobante_libro_bancos (
						id_comprobante_libro_bancos,
						id_int_comprobante,
						id_libro_bancos_cheque,
						id_libro_bancos_deposito,
						estado_reg,
						fecha_mod,
						fecha_reg,
						id_usuario_mod,
						id_usuario_reg,
						tipo)
				VALUES (
						p_id_comprobante_libro_bancos,
						p_id_int_comprobante,
						p_id_libro_bancos_cheque,
						p_id_libro_bancos_deposito,
						p_estado_reg,
						p_fecha_mod,
						p_fecha_reg,
						p_id_usuario_mod,
						p_id_usuario_reg,
						p_tipo);

                               
                                ELSEIF  v_operacion = 'UPDATE' THEN
                                       
                                       IF  not EXISTS(select 1 
                                           from CONTA.tcomprobante_libro_bancos
 
                                           						 WHERE id_comprobante_libro_bancos=p_id_comprobante_libro_bancos) THEN
                                       
                                            raise exception 'No existe el registro que  desea modificar';
                                            
                                       END IF;
						               
						               
						               UPDATE 
						                  CONTA.tcomprobante_libro_bancos  
						                SET						 id_int_comprobante=p_id_int_comprobante
						 ,id_libro_bancos_cheque=p_id_libro_bancos_cheque
						 ,id_libro_bancos_deposito=p_id_libro_bancos_deposito
						 ,estado_reg=p_estado_reg
						 ,fecha_mod=p_fecha_mod
						 ,fecha_reg=p_fecha_reg
						 ,id_usuario_mod=p_id_usuario_mod
						 ,id_usuario_reg=p_id_usuario_reg
						 ,tipo=p_tipo
						 WHERE id_comprobante_libro_bancos=p_id_comprobante_libro_bancos;

						       
						       ELSEIF  v_operacion = 'DELETE' THEN
						       
						         
						         IF  not EXISTS(select 1 
                                           from CONTA.tcomprobante_libro_bancos
						 WHERE id_comprobante_libro_bancos=p_id_comprobante_libro_bancos) THEN
                                       
                                            raise exception 'No existe el registro que  desea eliminar';
                                            
                                END IF;
						         
						         
						         DELETE FROM 
						              CONTA.tcomprobante_libro_bancos
 
						              						 WHERE id_comprobante_libro_bancos=p_id_comprobante_libro_bancos;

						       
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