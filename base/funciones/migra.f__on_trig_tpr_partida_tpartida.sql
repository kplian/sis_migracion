--------------- SQL ---------------

CREATE OR REPLACE FUNCTION migra.f__on_trig_tpr_partida_tpartida (
  v_operacion varchar,
  p_id_partida integer,
  p_id_partida_fk integer,
  p_cod_ascii varchar,
  p_cod_excel varchar,
  p_codigo varchar,
  p_cod_trans varchar,
  p_descripcion varchar,
  p_ent_trf varchar,
  p_estado_reg varchar,
  p_fecha_mod timestamp,
  p_fecha_reg timestamp,
  p_id_gestion integer,
  p_id_parametros integer,
  p_id_usuario_mod integer,
  p_id_usuario_reg integer,
  p_nivel_partida integer,
  p_nombre_partida varchar,
  p_sw_movimiento varchar,
  p_sw_transaccional varchar,
  p_tipo varchar
)
RETURNS text AS
$body$
/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  February 19, 2013, 11:53 am
						Autor: autogenerado (ADMINISTRADOR DEL SISTEMA )
						
						*/
						
						DECLARE
						
						BEGIN
						
						    if(v_operacion = 'INSERT') THEN
						
						          INSERT INTO 
						            PRE.tpartida (
						id_partida,
						id_partida_fk,
						cod_ascii,
						cod_excel,
						codigo,
						cod_trans,
						descripcion,
						ent_trf,
						estado_reg,
						fecha_mod,
						fecha_reg,
						id_gestion,
						id_parametros,
						id_usuario_mod,
						id_usuario_reg,
						nivel_partida,
						nombre_partida,
						sw_movimiento,
						sw_transaccional,
						tipo)
				VALUES (
						p_id_partida,
						p_id_partida_fk,
						p_cod_ascii,
						p_cod_excel,
						p_codigo,
						p_cod_trans,
						p_descripcion,
						p_ent_trf,
						p_estado_reg,
						p_fecha_mod,
						p_fecha_reg,
						p_id_gestion,
						p_id_parametros,
						p_id_usuario_mod,
						p_id_usuario_reg,
						p_nivel_partida,
						p_nombre_partida,
						p_sw_movimiento,
						p_sw_transaccional,
						p_tipo);

						       
							    ELSEIF  v_operacion = 'UPDATE' THEN
						               
                                     --chequear si ya existe el registro si no sacar un error
                               IF  not EXISTS(select 1 
                                 from  PRE.tpartida
                                 where id_partida=p_id_partida) THEN
                                                       
                                  raise exception 'No existe el registro que desea modificar';
                                                            
                               END IF;    
                                       
                                       
                                       
                                       
                                       UPDATE 
						                  PRE.tpartida  
						                SET						 id_partida_fk=p_id_partida_fk
						 ,cod_ascii=p_cod_ascii
						 ,cod_excel=p_cod_excel
						 ,codigo=p_codigo
						 ,cod_trans=p_cod_trans
						 ,descripcion=p_descripcion
						 ,ent_trf=p_ent_trf
						 ,estado_reg=p_estado_reg
						 ,fecha_mod=p_fecha_mod
						 ,fecha_reg=p_fecha_reg
						 ,id_gestion=p_id_gestion
						 ,id_parametros=p_id_parametros
						 ,id_usuario_mod=p_id_usuario_mod
						 ,id_usuario_reg=p_id_usuario_reg
						 ,nivel_partida=p_nivel_partida
						 ,nombre_partida=p_nombre_partida
						 ,sw_movimiento=p_sw_movimiento
						 ,sw_transaccional=p_sw_transaccional
						 ,tipo=p_tipo
						 WHERE id_partida=p_id_partida;

						       
						       ELSEIF  v_operacion = 'DELETE' THEN
						       
						             --chequear si ya existe el registro si no sacar un error
                               IF  not EXISTS(select 1 
                                 from  PRE.tpartida
                                 where id_partida=p_id_partida) THEN
                                                       
                                  raise exception 'No existe el registro que desea eliminar';
                                                            
                               END IF;
                               
                               
                               
                                DELETE FROM 
						              PRE.tpartida
 
						              						 WHERE id_partida=p_id_partida;

						       
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