CREATE OR REPLACE FUNCTION migra.f__on_trig_tkp_item_tcargo (
  v_operacion varchar,
  p_id_cargo integer,
  p_id_escala_salarial integer,
  p_id_lugar integer,
  p_id_oficina integer,
  p_id_temporal_cargo integer,
  p_id_tipo_contrato integer,
  p_id_uo integer,
  p_codigo varchar,
  p_estado_reg varchar,
  p_fecha_fin date,
  p_fecha_ini date,
  p_fecha_mod timestamp,
  p_fecha_reg timestamp,
  p_id_usuario_ai integer,
  p_id_usuario_mod integer,
  p_id_usuario_reg integer,
  p_nombre varchar,
  p_usuario_ai varchar
)
RETURNS text AS
$body$
/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  June 4, 2014, 9:29 am
						Autor: autogenerado (JAIME RIVERA ROJAS)
						
						*/
						
						DECLARE
						
						BEGIN
						
						    if(v_operacion = 'INSERT') THEN
						
						          INSERT INTO 
						            ORGA.tcargo (
						id_cargo,
						id_escala_salarial,
						id_lugar,
						id_oficina,
						id_temporal_cargo,
						id_tipo_contrato,
						id_uo,
						codigo,
						estado_reg,
						fecha_fin,
						fecha_ini,
						fecha_mod,
						fecha_reg,
						id_usuario_ai,
						id_usuario_mod,
						id_usuario_reg,
						nombre,
						usuario_ai)
				VALUES (
						p_id_cargo,
						p_id_escala_salarial,
						p_id_lugar,
						p_id_oficina,
						p_id_temporal_cargo,
						p_id_tipo_contrato,
						p_id_uo,
						p_codigo,
						p_estado_reg,
						NULL,
						now(),
						p_fecha_mod,
						p_fecha_reg,
						p_id_usuario_ai,
						p_id_usuario_mod,
						p_id_usuario_reg,
						p_nombre,
						p_usuario_ai);

						       
							    ELSEIF  v_operacion = 'UPDATE' THEN
						               
						               IF  not EXISTS(select 1 
                                           from ORGA.tcargo
 
                                           where id_cargo=p_id_cargo) THEN
                                       
                                            raise exception 'No existe el registro que  desea modificar';
                                            
                                       END IF;
						               
						               
						               UPDATE 
						                  ORGA.tcargo  
						                SET						 id_escala_salarial=p_id_escala_salarial
						 ,id_lugar=p_id_lugar
						 ,id_oficina=p_id_oficina
						 ,id_temporal_cargo=p_id_temporal_cargo
						 ,id_tipo_contrato=p_id_tipo_contrato
						 ,id_uo=p_id_uo
						 ,codigo=p_codigo
						 ,estado_reg=p_estado_reg
						 ,fecha_mod=p_fecha_mod
						 ,fecha_reg=p_fecha_reg
						 ,id_usuario_ai=p_id_usuario_ai
						 ,id_usuario_mod=p_id_usuario_mod
						 ,id_usuario_reg=p_id_usuario_reg
						 ,nombre=p_nombre
						 ,usuario_ai=p_usuario_ai
						 WHERE id_cargo=p_id_cargo;

						       
						       ELSEIF  v_operacion = 'DELETE' THEN
						       
						         
						         IF  not EXISTS(select 1 
                                           from ORGA.tcargo
 
                                           where id_cargo=p_id_cargo) THEN
                                       
                                            raise exception 'No existe el registro que  desea eliminar';
                                            
                                END IF;
						         
						         
						         DELETE FROM 
						              ORGA.tcargo
 
						              						 WHERE id_cargo=p_id_cargo;

						       
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