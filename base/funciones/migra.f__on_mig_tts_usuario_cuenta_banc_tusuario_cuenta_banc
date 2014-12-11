CREATE OR REPLACE FUNCTION migra.f__on_trig_tts_usuario_cuenta_banc_tusuario_cuenta_banc (
  v_operacion varchar,
  p_id_usuario_cuenta_banc integer,
  p_estado varchar,
  p_estado_reg varchar,
  p_fecha_mod timestamp,
  p_fecha_reg timestamp,
  p_id_cuenta_bancaria integer,
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_id_usuario_mod integer,
  p_id_usuario_reg integer,
  p_tipo_permiso varchar,
  p_usuario_ai varchar
)
RETURNS text AS
$body$
/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  November 26, 2014, 8:22 pm
						Autor: autogenerado (GONZALO JOSE SARMIENTO SEJAS)
						
						*/
						
						DECLARE
						v_id_cuenta_bancaria_pxp		integer;	
						BEGIN
						
						    if(v_operacion = 'INSERT') THEN
						
                        select cta.id_cuenta_bancaria_pxp into v_id_cuenta_bancaria_pxp
                        from migra.tts_cuenta_bancaria cta
                        where cta.id_cuenta_bancaria=p_id_cuenta_bancaria;
                        
						          INSERT INTO 
						            TES.tusuario_cuenta_banc (
						id_usuario_cuenta_banc,
						estado_reg,
						fecha_mod,
						fecha_reg,
						id_cuenta_bancaria,
						id_usuario,
						id_usuario_ai,
						id_usuario_mod,
						id_usuario_reg,
						tipo_permiso,
						usuario_ai)
				VALUES (
						p_id_usuario_cuenta_banc,
						p_estado,
						p_fecha_mod,
						p_fecha_reg,
						v_id_cuenta_bancaria_pxp,
						p_id_usuario,
						p_id_usuario_ai,
						p_id_usuario_mod,
						p_id_usuario_reg,
						p_tipo_permiso,
						p_usuario_ai);

                               
                                ELSEIF  v_operacion = 'UPDATE' THEN
                                       
                                       IF  not EXISTS(select 1 
                                           from TES.tusuario_cuenta_banc
 
                                           						 WHERE id_usuario_cuenta_banc=p_id_usuario_cuenta_banc) THEN
                                       
                                            raise exception 'No existe el registro que  desea modificar';
                                            
                                       END IF;
						               
						               select cta.id_cuenta_bancaria_pxp into v_id_cuenta_bancaria_pxp
				                       from migra.tts_cuenta_bancaria cta
                				       where cta.id_cuenta_bancaria=p_id_cuenta_bancaria;
                                       
						               UPDATE 
						                  TES.tusuario_cuenta_banc  
						                SET		estado_reg=p_estado
						 ,fecha_mod=p_fecha_mod
						 ,fecha_reg=p_fecha_reg
						 ,id_cuenta_bancaria=v_id_cuenta_bancaria_pxp
						 ,id_usuario=p_id_usuario
						 ,id_usuario_ai=p_id_usuario_ai
						 ,id_usuario_mod=p_id_usuario_mod
						 ,id_usuario_reg=p_id_usuario_reg
						 ,tipo_permiso=p_tipo_permiso
						 ,usuario_ai=p_usuario_ai
						 WHERE id_usuario_cuenta_banc=p_id_usuario_cuenta_banc;

						       
						       ELSEIF  v_operacion = 'DELETE' THEN
						       
						         
						         IF  not EXISTS(select 1 
                                           from TES.tusuario_cuenta_banc
						 WHERE id_usuario_cuenta_banc=p_id_usuario_cuenta_banc) THEN
                                       
                                            raise exception 'No existe el registro que  desea eliminar';
                                            
                                END IF;
						         
						         
						         DELETE FROM 
						              TES.tusuario_cuenta_banc
 
						              						 WHERE id_usuario_cuenta_banc=p_id_usuario_cuenta_banc;

						       
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