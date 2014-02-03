CREATE OR REPLACE FUNCTION migra.f__on_trig_tts_libro_bancos_tts_libro_bancos (
  v_operacion varchar,
  p_nro_cuenta varchar,
  p_id_libro_bancos integer,
  p_a_favor varchar,
  p_detalle text,
  p_estado varchar,
  p_estado_reg varchar,
  p_fecha date,
  p_fecha_mod timestamp,
  p_fecha_reg timestamp,
  p_id_libro_bancos_fk integer,
  p_id_usuario_mod integer,
  p_id_usuario_reg integer,
  p_importe_cheque numeric,
  p_importe_deposito numeric,
  p_indice numeric,
  p_nro_cheque integer,
  p_nro_comprobante varchar,
  p_nro_liquidacion varchar,
  p_observaciones text,
  p_origen varchar,
  p_tipo varchar
)
RETURNS text AS
$body$
/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  November 30, 2013, 11:48 pm
						Autor: autogenerado (ADMINISTRADOR DEL SISTEMA )
						
						*/
						
DECLARE

	v_id_cuenta_bancaria_pxp integer;
	v_tipo_mov varchar;
	v_id_cuenta_bancaria integer;
						
BEGIN
						
	if(v_operacion = 'INSERT') THEN
	
				--Verifica el id_cuenta_bancaria a asociar
									
					select cb.id_cuenta_bancaria
					into v_id_cuenta_bancaria
					from tes.tcuenta_bancaria cb
					where cb.nro_cuenta = p_nro_cuenta and cb.estado_reg = 'activo';
										
						INSERT INTO 
						MIGRA.tts_libro_bancos (
						id_cuenta_bancaria,
						id_libro_bancos,
						a_favor,
						detalle,
						estado,
						estado_reg,
						fecha,
						fecha_mod,
						fecha_reg,
						id_libro_bancos_fk,
						id_usuario_mod,
						id_usuario_reg,
						importe_cheque,
						importe_deposito,
						indice,
						nro_cheque,
						nro_comprobante,
						nro_liquidacion,
						observaciones,
						origen,
						tipo)
				VALUES (
						v_id_cuenta_bancaria,
						p_id_libro_bancos,
						p_a_favor,
						p_detalle,
						p_estado,
						p_estado_reg,
						p_fecha,
						p_fecha_mod,
						p_fecha_reg,
						p_id_libro_bancos_fk,
						p_id_usuario_mod,
						p_id_usuario_reg,
						p_importe_cheque,
						p_importe_deposito,
						p_indice,
						p_nro_cheque,
						p_nro_comprobante,
						p_nro_liquidacion,
						p_observaciones,
						p_origen,
						p_tipo);
						
				-------------------------------------------
				--Inserción en tabla tes.tcuenta_bancaria_mov
		        -------------------------------------------
		        
		        v_tipo_mov = 'egreso';
                if p_tipo = 'cheque' then
                    v_tipo_mov = 'egreso';
                elsif p_tipo = 'deposito' then
                    v_tipo_mov = 'ingreso';
                end if;
		        	
                --Registro del deposito
                INSERT INTO tes.tcuenta_bancaria_mov(
                      id_usuario_reg,
                      fecha_reg,
                      estado_reg,
                      id_cuenta_bancaria_mov,
                      id_cuenta_bancaria,
                      tipo_mov,
                      tipo,
                      descripcion,
                      nro_doc_tipo,
                      id_cuenta_bancaria_mov_fk,
                      importe,
                      estado,
                      observaciones
                    ) VALUES (
                      1,
                      now(),
                      'activo',
                      p_id_libro_bancos,
                      v_id_cuenta_bancaria,
                      v_tipo_mov,
                      'cheque',
                      p_detalle,
                      p_nro_cheque,
                      p_id_libro_bancos_fk,
                      coalesce(p_importe_cheque,p_importe_deposito)::numeric,
                      p_estado,
                      p_observaciones
                    );
                    

                
		ELSEIF  v_operacion = 'UPDATE' THEN
						  select cb.id_cuenta_bancaria
                          into v_id_cuenta_bancaria
                          from tes.tcuenta_bancaria cb
                          where cb.nro_cuenta = p_nro_cuenta and cb.estado_reg = 'activo';
                          
                                       
						  UPDATE MIGRA.tts_libro_bancos SET
						  id_cuenta_bancaria=v_id_cuenta_bancaria
						 ,a_favor=p_a_favor
						 ,detalle=p_detalle
						 ,estado=p_estado
						 ,estado_reg=p_estado_reg
						 ,fecha=p_fecha
						 ,fecha_mod=p_fecha_mod
						 ,fecha_reg=p_fecha_reg
						 ,id_libro_bancos_fk=p_id_libro_bancos_fk
						 ,id_usuario_mod=p_id_usuario_mod
						 ,id_usuario_reg=p_id_usuario_reg
						 ,importe_cheque=p_importe_cheque
						 ,importe_deposito=p_importe_deposito
						 ,indice=p_indice
						 ,nro_cheque=p_nro_cheque
						 ,nro_comprobante=p_nro_comprobante
						 ,nro_liquidacion=p_nro_liquidacion
						 ,observaciones=p_observaciones
						 ,origen=p_origen
						 ,tipo=p_tipo
						 WHERE id_libro_bancos=p_id_libro_bancos;
						 
                        v_tipo_mov = 'egreso';
						if p_tipo = 'cheque' then
			        		v_tipo_mov = 'egreso';
			        	end if;
			        	if p_tipo = 'deposito' then
			        		v_tipo_mov = 'ingreso';
			        	end if;
						 
						UPDATE tes.tcuenta_bancaria_mov SET 
						id_usuario_mod = 1,
						fecha_mod = now(),
						estado_reg = p_estado,
						tipo_mov = v_tipo_mov,
						descripcion = p_detalle,
                        id_cuenta_bancaria_mov_fk=p_id_libro_bancos_fk,
						nro_doc_tipo = p_nro_cheque,
						importe = coalesce(p_importe_cheque,p_importe_deposito)::numeric,
						estado = p_estado,
						observaciones = p_observaciones
						WHERE id_cuenta_bancaria_mov = p_id_libro_bancos;
						       
		ELSEIF  v_operacion = 'DELETE' THEN
						       
						         DELETE FROM 
						         MIGRA.tts_libro_bancos
						         WHERE id_libro_bancos=p_id_libro_bancos;
						         
						         DELETE FROM 
						         tes.tcuenta_bancaria_mov
						         WHERE id_cuenta_bancaria_mov=p_id_libro_bancos;

						       
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