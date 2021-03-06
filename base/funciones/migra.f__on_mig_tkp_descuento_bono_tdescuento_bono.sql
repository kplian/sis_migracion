CREATE OR REPLACE FUNCTION migra.f__on_trig_tkp_descuento_bono_tdescuento_bono (
  v_operacion varchar,
  p_id_descuento_bono integer,
  p_id_funcionario integer,
  p_id_moneda integer,
  p_tipo_columna varchar,
  p_estado_reg varchar,
  p_fecha_fin date,
  p_fecha_ini date,
  p_fecha_mod timestamp,
  p_fecha_reg timestamp,
  p_id_usuario_ai integer,
  p_id_usuario_mod integer,
  p_id_usuario_reg integer,
  p_monto_total numeric,
  p_num_cuotas integer,
  p_usuario_ai varchar,
  p_valor_por_cuota numeric
)
RETURNS text AS
$body$
/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  June 6, 2014, 11:11 am
						Autor: autogenerado (JAIME RIVERA ROJAS)
						
						*/
						
						DECLARE
							v_id_tipo_columna	integer;
						BEGIN
						
							select id_tipo_columna into v_id_tipo_columna
						    from plani.ttipo_columna tc
						    where codigo = p_tipo_columna and tc.estado_reg = 'activo';
						    
						    if (v_id_tipo_columna is null) then
						    	return true;
						    end if;
						
						    if(v_operacion = 'INSERT') THEN
						    
						
						          INSERT INTO 
						            PLANI.tdescuento_bono (
						id_descuento_bono,
						id_funcionario,
						id_moneda,
						id_tipo_columna,
						estado_reg,
						fecha_fin,
						fecha_ini,
						fecha_mod,
						fecha_reg,
						id_usuario_ai,
						id_usuario_mod,
						id_usuario_reg,
						monto_total,
						num_cuotas,
						usuario_ai,
						valor_por_cuota)
				VALUES (
						p_id_descuento_bono,
						p_id_funcionario,
						p_id_moneda,
						v_id_tipo_columna,
						p_estado_reg,
						p_fecha_fin,
						p_fecha_ini,
						p_fecha_mod,
						p_fecha_reg,
						p_id_usuario_ai,
						p_id_usuario_mod,
						p_id_usuario_reg,
						p_monto_total,
						p_num_cuotas,
						p_usuario_ai,
						p_valor_por_cuota);

						       
							    ELSEIF  v_operacion = 'UPDATE' THEN
						               
						               IF  not EXISTS(select 1 
                                           from PLANI.tdescuento_bono
 
                                           where id_descuento_bono=p_id_descuento_bono) THEN
                                       
                                            raise exception 'No existe el registro que  desea modificar';
                                            
                                       END IF;
						               
						               if (p_estado_reg = 'eliminado') then
                                       		UPDATE 
                                                    PLANI.tdescuento_bono  
                                                  SET	
                                   					estado_reg='inactivo'
                                            WHERE id_descuento_bono=p_id_descuento_bono;
                                       else
                                                 UPDATE 
                                                    PLANI.tdescuento_bono  
                                                  SET						 id_funcionario=p_id_funcionario
                                   ,id_moneda=p_id_moneda
                                   ,id_tipo_columna=v_id_tipo_columna
                                   ,estado_reg=p_estado_reg
                                   ,fecha_fin=p_fecha_fin
                                   ,fecha_ini=p_fecha_ini
                                   ,fecha_mod=p_fecha_mod
                                   ,fecha_reg=p_fecha_reg
                                   ,id_usuario_ai=p_id_usuario_ai
                                   ,id_usuario_mod=p_id_usuario_mod
                                   ,id_usuario_reg=p_id_usuario_reg
                                   ,monto_total=p_monto_total
                                   ,num_cuotas=p_num_cuotas
                                   ,usuario_ai=p_usuario_ai
                                   ,valor_por_cuota=p_valor_por_cuota
                                   WHERE id_descuento_bono=p_id_descuento_bono;
								end if;
						       
						       ELSEIF  v_operacion = 'DELETE' THEN
						       
						         
						         IF  not EXISTS(select 1 
                                           from PLANI.tdescuento_bono
 
                                           where id_descuento_bono=p_id_descuento_bono) THEN
                                       
                                            raise exception 'No existe el registro que  desea eliminar';
                                            
                                END IF;
						         
						         
						         DELETE FROM 
						              PLANI.tdescuento_bono
 
						              						 WHERE id_descuento_bono=p_id_descuento_bono;

						       
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