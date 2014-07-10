CREATE OR REPLACE FUNCTION migra.f__on_trig_tkp_empleado_cuenta_bancaria_tfuncionario_cuenta_bancaria (
						  v_operacion varchar,p_id_funcionario_cuenta_bancaria int4,p_id_funcionario int4,p_id_institucion int4,p_estado_reg varchar,p_fecha_fin date,p_fecha_ini date,p_fecha_mod timestamp,p_fecha_reg timestamp,p_id_usuario_ai int4,p_id_usuario_mod int4,p_id_usuario_reg int4,p_nro_cuenta varchar,p_usuario_ai varchar)
						RETURNS text AS
						$BODY$

/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  July 10, 2014, 5:27 pm
						Autor: autogenerado (JAIME RIVERA ROJAS)
						
						*/
						
						DECLARE
						
						BEGIN
						
						    if(v_operacion = 'INSERT') THEN
						
						          INSERT INTO 
						            ORGA.tfuncionario_cuenta_bancaria (
						id_funcionario_cuenta_bancaria,
						id_funcionario,
						id_institucion,
						estado_reg,
						fecha_fin,
						fecha_ini,
						fecha_mod,
						fecha_reg,
						id_usuario_ai,
						id_usuario_mod,
						id_usuario_reg,
						nro_cuenta,
						usuario_ai)
				VALUES (
						p_id_funcionario_cuenta_bancaria,
						p_id_funcionario,
						p_id_institucion,
						p_estado_reg,
						p_fecha_fin,
						p_fecha_ini,
						p_fecha_mod,
						p_fecha_reg,
						p_id_usuario_ai,
						p_id_usuario_mod,
						p_id_usuario_reg,
						p_nro_cuenta,
						p_usuario_ai);

                               
                                ELSEIF  v_operacion = 'UPDATE' THEN
                                       
                                       IF  not EXISTS(select 1 
                                           from ORGA.tfuncionario_cuenta_bancaria
 
                                           						 WHERE id_funcionario_cuenta_bancaria=p_id_funcionario_cuenta_bancaria) THEN
                                       
                                            raise exception 'No existe el registro que  desea modificar';
                                            
                                       END IF;
						               
						               
						               UPDATE 
						                  ORGA.tfuncionario_cuenta_bancaria  
						                SET						 id_funcionario=p_id_funcionario
						 ,id_institucion=p_id_institucion
						 ,estado_reg=p_estado_reg
						 ,fecha_fin=p_fecha_fin
						 ,fecha_ini=p_fecha_ini
						 ,fecha_mod=p_fecha_mod
						 ,fecha_reg=p_fecha_reg
						 ,id_usuario_ai=p_id_usuario_ai
						 ,id_usuario_mod=p_id_usuario_mod
						 ,id_usuario_reg=p_id_usuario_reg
						 ,nro_cuenta=p_nro_cuenta
						 ,usuario_ai=p_usuario_ai
						 WHERE id_funcionario_cuenta_bancaria=p_id_funcionario_cuenta_bancaria;

						       
						       ELSEIF  v_operacion = 'DELETE' THEN
						       
						         
						         IF  not EXISTS(select 1 
                                           from ORGA.tfuncionario_cuenta_bancaria
						 WHERE id_funcionario_cuenta_bancaria=p_id_funcionario_cuenta_bancaria) THEN
                                       
                                            raise exception 'No existe el registro que  desea eliminar';
                                            
                                END IF;
						         
						         
						         DELETE FROM 
						              ORGA.tfuncionario_cuenta_bancaria
 
						              						 WHERE id_funcionario_cuenta_bancaria=p_id_funcionario_cuenta_bancaria;

						       
						       END IF;  
						  
						 return 'true';
						
						-- statements;
						--EXCEPTION
						--WHEN exception_name THEN
						--  statements;
						END;
						$BODY$


						LANGUAGE 'plpgsql'
						VOLATILE
						CALLED ON NULL INPUT
						SECURITY INVOKER
						COST 100;