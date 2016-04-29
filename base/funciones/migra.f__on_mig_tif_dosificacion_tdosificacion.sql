CREATE OR REPLACE FUNCTION migra.f__on_trig_tif_dosificacion_tdosificacion (
  v_operacion varchar,
  p_id_dosificacion integer,
  p_id_activida_economica integer,
  p_id_sucursal integer,
  p_autoimpresor varchar,
  p_estacion varchar,
  p_estado_reg varchar,
  p_fecha_dosificacion date,
  p_fecha_inicio_emi date,
  p_fecha_limite date,
  p_fecha_mod timestamp,
  p_fecha_reg timestamp,
  p_final varchar,
  p_glosa_consumidor varchar,
  p_glosa_empresa varchar,
  p_glosa_impuestos varchar,
  p_id_lugar_pais integer,
  p_id_usuario_ai integer,
  p_id_usuario_mod integer,
  p_id_usuario_reg integer,
  p_inicial varchar,
  p_llave varchar,
  p_nombre_sisfac varchar,
  p_notificado varchar,
  p_nroaut varchar,
  p_nro_resolucion varchar,
  p_nro_siguiente integer,
  p_nro_tramite varchar,
  p_tipo varchar,
  p_tipo_autoimpresor varchar,
  p_usuario_ai varchar
)
RETURNS text AS
$body$
/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  September 2, 2015, 4:18 pm
						Autor: autogenerado (ENDESIS ROOT SISTEMA)
						
						*/
						
						DECLARE
						
						BEGIN
						
						    if(v_operacion = 'INSERT') THEN
						
						          INSERT INTO 
						            FAC.tdosificacion (
						id_dosificacion,
						id_activida_economica,
						id_sucursal,
						autoimpresor,
						estacion,
						estado_reg,
						fecha_dosificacion,
						fecha_inicio_emi,
						fecha_limite,
						fecha_mod,
						fecha_reg,
						final,
						glosa_consumidor,
						glosa_empresa,
						glosa_impuestos,
						id_lugar_pais,
						id_usuario_ai,
						id_usuario_mod,
						id_usuario_reg,
						inicial,
						llave,
						nombre_sisfac,
						notificado,
						nroaut,
						nro_resolucion,
						nro_siguiente,
						nro_tramite,
						tipo,
						tipo_autoimpresor,
						usuario_ai)
				VALUES (
						p_id_dosificacion,
						p_id_activida_economica,
						p_id_sucursal,
						p_autoimpresor,
						p_estacion,
						p_estado_reg,
						p_fecha_dosificacion,
						p_fecha_inicio_emi,
						p_fecha_limite,
						p_fecha_mod,
						p_fecha_reg,
						p_final,
						p_glosa_consumidor,
						p_glosa_empresa,
						p_glosa_impuestos,
						p_id_lugar_pais,
						p_id_usuario_ai,
						p_id_usuario_mod,
						p_id_usuario_reg,
						p_inicial,
						p_llave,
						p_nombre_sisfac,
						p_notificado,
						p_nroaut,
						p_nro_resolucion,
						p_nro_siguiente,
						p_nro_tramite,
						p_tipo,
						p_tipo_autoimpresor,
						p_usuario_ai);

                               
                                ELSEIF  v_operacion = 'UPDATE' THEN
                                       
                                       IF  not EXISTS(select 1 
                                           from FAC.tdosificacion
 
                                           						 WHERE id_dosificacion=p_id_dosificacion) THEN
                                       
                                            raise exception 'No existe el registro que  desea modificar';
                                            
                                       END IF;
						               
						               
						               UPDATE 
						                  FAC.tdosificacion  
						                SET						 id_activida_economica=p_id_activida_economica
						 ,id_sucursal=p_id_sucursal
						 ,autoimpresor=p_autoimpresor
						 ,estacion=p_estacion
						 ,estado_reg=p_estado_reg
						 ,fecha_dosificacion=p_fecha_dosificacion
						 ,fecha_inicio_emi=p_fecha_inicio_emi
						 ,fecha_limite=p_fecha_limite
						 ,fecha_mod=p_fecha_mod
						 ,fecha_reg=p_fecha_reg
						 ,final=p_final
						 ,glosa_consumidor=p_glosa_consumidor
						 ,glosa_empresa=p_glosa_empresa
						 ,glosa_impuestos=p_glosa_impuestos
						 ,id_lugar_pais=p_id_lugar_pais
						 ,id_usuario_ai=p_id_usuario_ai
						 ,id_usuario_mod=p_id_usuario_mod
						 ,id_usuario_reg=p_id_usuario_reg
						 ,inicial=p_inicial
						 ,llave=p_llave
						 ,nombre_sisfac=p_nombre_sisfac
						 ,notificado=p_notificado
						 ,nroaut=p_nroaut
						 ,nro_resolucion=p_nro_resolucion
						 --,nro_siguiente=p_nro_siguiente
						 ,nro_tramite=p_nro_tramite
						 ,tipo=p_tipo
						 ,tipo_autoimpresor=p_tipo_autoimpresor
						 ,usuario_ai=p_usuario_ai
						 WHERE id_dosificacion=p_id_dosificacion;

						       
						       ELSEIF  v_operacion = 'DELETE' THEN
						       
						         
						         IF  not EXISTS(select 1 
                                           from FAC.tdosificacion
						 WHERE id_dosificacion=p_id_dosificacion) THEN
                                       
                                            raise exception 'No existe el registro que  desea eliminar';
                                            
                                END IF;
						         
						         
						         DELETE FROM 
						              FAC.tdosificacion
 
						              						 WHERE id_dosificacion=p_id_dosificacion;

						       
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