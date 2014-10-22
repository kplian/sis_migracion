CREATE OR REPLACE FUNCTION migra.f__on_trig_tkp_escala_salarial2_tescala_salarial (
  v_operacion varchar,
  p_id_escala_salarial integer,
  p_id_categoria_salarial integer,
  p_aprobado varchar,
  p_codigo varchar,
  p_estado_reg varchar,
  p_fecha_fin date,
  p_fecha_ini date,
  p_fecha_mod timestamp,
  p_fecha_reg timestamp,
  p_haber_basico numeric,
  p_id_usuario_ai integer,
  p_id_usuario_mod integer,
  p_id_usuario_reg integer,
  p_nombre varchar,
  p_nro_casos integer,
  p_usuario_ai varchar
)
RETURNS text AS
$body$
/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  June 3, 2014, 3:53 pm
						Autor: autogenerado (JAIME RIVERA ROJAS)
						
						*/
						
						DECLARE
							v_reg_old 		record;
							v_secuencia		integer;
						BEGIN
						
						    if(v_operacion = 'INSERT') THEN
						
						          INSERT INTO 
						            ORGA.tescala_salarial (
						id_escala_salarial,
						id_categoria_salarial,
						aprobado,
						codigo,
						estado_reg,
						fecha_fin,
						fecha_ini,
						fecha_mod,
						fecha_reg,
						haber_basico,
						id_usuario_ai,
						id_usuario_mod,
						id_usuario_reg,
						nombre,
						nro_casos,
						usuario_ai)
				VALUES (
						p_id_escala_salarial,
						p_id_categoria_salarial,
						p_aprobado,
						p_codigo,
						p_estado_reg,
						p_fecha_fin,
						p_fecha_ini,
						p_fecha_mod,
						p_fecha_reg,
						p_haber_basico,
						p_id_usuario_ai,
						p_id_usuario_mod,
						p_id_usuario_reg,
						p_nombre,
						p_nro_casos,
						p_usuario_ai);

						       
							    ELSEIF  v_operacion = 'UPDATE' THEN
						               
						               IF  not EXISTS(select 1 
                                           from ORGA.tescala_salarial
 
                                           where id_escala_salarial=p_id_escala_salarial) THEN
                                       
                                            raise exception 'No existe el registro que  desea modificar';
                                            
                                       END IF;
                                       
                                       select * into v_reg_old 
                                        from orga.tescala_salarial
                                        where id_escala_salarial = p_id_escala_salarial;
						              if (v_reg_old.haber_basico != p_haber_basico) then
                                          if (p_fecha_ini is null) then
                                              raise exception 'Si cambia el haber básico, debe definir la fecha desde la que se aplicará el cambio';
                                          end if;
                                          select nextval('orga.tescala_salarial_migracion_seq') into v_secuencia;
                                          insert into orga.tescala_salarial (id_escala_salarial,
                                                  aprobado , 			haber_basico,			nombre,
                                                  nro_casos,			codigo,					id_categoria_salarial,
                                                  fecha_ini,			fecha_fin,				estado_reg,id_escala_padre) 
                                          values (v_secuencia ,v_reg_old.aprobado ,v_reg_old.haber_basico,	v_reg_old.nombre,
                                                  v_reg_old.nro_casos,v_reg_old.codigo,		v_reg_old.id_categoria_salarial,
                                                  v_reg_old.fecha_ini,(p_fecha_ini - interval '1 day'), 'inactivo',p_id_escala_salarial);
                                      end if;
                                      --Sentencia de la modificacion
                                      update orga.tescala_salarial set
                                      aprobado = p_aprobado,
                                      haber_basico = p_haber_basico,
                                      nombre = p_nombre,
                                      nro_casos = p_nro_casos,
                                      id_usuario_mod = p_id_usuario_mod,
                                      fecha_mod = now()
                                      where id_escala_salarial=p_id_escala_salarial;
                          			
                                      if (p_fecha_ini is not null and v_reg_old.haber_basico != p_haber_basico) then
                                          update orga.tescala_salarial set
                                          fecha_ini = p_fecha_ini
                                          where id_escala_salarial=p_id_escala_salarial;
                                      end if; 			               
						               

						       
						       ELSEIF  v_operacion = 'DELETE' THEN
						       
						         
						         IF  not EXISTS(select 1 
                                           from ORGA.tescala_salarial
 
                                           where id_escala_salarial=p_id_escala_salarial) THEN
                                       
                                            raise exception 'No existe el registro que  desea eliminar';
                                            
                                END IF;
						         
						         
						         DELETE FROM 
						              ORGA.tescala_salarial
 
						              						 WHERE id_escala_salarial=p_id_escala_salarial;

						       
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