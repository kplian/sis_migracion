--------------- SQL ---------------

CREATE OR REPLACE FUNCTION migra.f__on_trig_tpm_fina_regi_prog_proy_acti_tep (
  v_operacion varchar,
  p_id_ep integer,
  p_estado_reg varchar,
  p_fecha_mod timestamp,
  p_fecha_reg timestamp,
  p_id_financiador integer,
  p_id_prog_pory_acti integer,
  p_id_regional integer,
  p_id_usuario_mod integer,
  p_id_usuario_reg integer,
  p_sw_presto integer
)
RETURNS text AS
$body$
/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  February 5, 2013, 4:41 pm
						Autor: autogenerado (ADMINISTRADOR DEL SISTEMA )
						
						*/
						
						DECLARE
						
						BEGIN
						
						    if(v_operacion = 'INSERT') THEN
						
						          INSERT INTO 
						            PARAM.tep (
						id_ep,
						estado_reg,
						fecha_mod,
						fecha_reg,
						id_financiador,
						id_prog_pory_acti,
						id_regional,
						id_usuario_mod,
						id_usuario_reg,
						sw_presto)
				VALUES (
						p_id_ep,
						p_estado_reg,
						p_fecha_mod,
						p_fecha_reg,
						p_id_financiador,
						p_id_prog_pory_acti,
						p_id_regional,
						p_id_usuario_mod,
						p_id_usuario_reg,
						p_sw_presto);

						       
							    ELSEIF  v_operacion = 'UPDATE' THEN
						               
                                       --chequear si ya existe el auxiliar si no sacar un error
                                 IF  not EXISTS(select 1 
                                   from  PARAM.tep 
                                   where id_ep=p_id_ep) THEN
                                             
                                    raise exception 'No existe el registro que desea modificar';
                                                  
                                 END IF; 
                                       
                                       
                                       
                                       UPDATE 
						                  PARAM.tep  
						                SET						 estado_reg=p_estado_reg
						 ,fecha_mod=p_fecha_mod
						 ,fecha_reg=p_fecha_reg
						 ,id_financiador=p_id_financiador
						 ,id_prog_pory_acti=p_id_prog_pory_acti
						 ,id_regional=p_id_regional
						 ,id_usuario_mod=p_id_usuario_mod
						 ,id_usuario_reg=p_id_usuario_reg
						 ,sw_presto=p_sw_presto
						 WHERE id_ep=p_id_ep;

						       
						       ELSEIF  v_operacion = 'DELETE' THEN
						       
						         --chequear si ya existe el auxiliar si no sacar un error
                                 IF  not EXISTS(select 1 
                                   from  PARAM.tep 
                                   where id_ep=p_id_ep) THEN
                                             
                                    raise exception 'No existe el registro que desea eliminar';
                                                  
                                 END IF;
                                 
                                 DELETE FROM 
						              PARAM.tep
                                 WHERE id_ep=p_id_ep;

						       
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