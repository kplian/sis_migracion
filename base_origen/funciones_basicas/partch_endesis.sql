CREATE TABLE migracion.tct_comprobante (
  id_int_comprobante INTEGER NOT NULL, 
  id_clase_comprobante INTEGER, 
  id_int_comprobante_fk INTEGER, 
  id_subsistema INTEGER, 
  id_depto INTEGER, 
  id_moneda INTEGER, 
  id_periodo INTEGER, 
  nro_cbte VARCHAR(30), 
  momento VARCHAR(30), 
  glosa1 VARCHAR(1500), 
  glosa2 VARCHAR(400), 
  beneficiario VARCHAR(100), 
  tipo_cambio NUMERIC(18,2), 
  id_funcionario_firma1 INTEGER, 
  id_funcionario_firma2 INTEGER, 
  id_funcionario_firma3 INTEGER, 
  fecha DATE, 
  nro_tramite VARCHAR(70), 
  id_int_transaccion INTEGER, 
  id_cuenta INTEGER NOT NULL, 
  id_auxiliar INTEGER NOT NULL, 
  id_centro_costo INTEGER NOT NULL, 
  id_partida INTEGER, 
  id_partida_ejecucion INTEGER, 
  glosa VARCHAR(1000), 
  importe_debe NUMERIC(18,2), 
  importe_haber NUMERIC(18,2), 
  importe_recurso NUMERIC(18,2), 
  importe_gasto NUMERIC(18,2), 
  importe_debe_mb NUMERIC(18,2), 
  importe_haber_mb NUMERIC(18,2), 
  importe_recurso_mb NUMERIC(18,2), 
  importe_gasto_mb NUMERIC(18,2), 
  id_usuario_reg INTEGER, 
  codigo_clase_cbte VARCHAR(50), 
  id_uo INTEGER, 
  id_ep INTEGER
) WITHOUT OIDS;


--24/12/2013
ALTER TABLE tesoro.tts_cuenta_bancaria
  ALTER COLUMN id_cuenta DROP NOT NULL;
  
ALTER TABLE sss.tsg_persona
  ALTER COLUMN id_tipo_doc_identificacion DROP NOT NULL;
  
ALTER TABLE presto.tpr_partida_ejecucion
  DROP CONSTRAINT fk_tpr_partida_ejecucion__id_solicitud_compra RESTRICT;
  
  
ALTER TABLE presto.tpr_partida_ejecucion
  ADD COLUMN id_obligacion_pago INTEGER;  
  
  --------------- SQL ---------------

ALTER TABLE presto.tpr_partida_ejecucion
  ADD COLUMN id_int_transaccion INTEGER;
  


--08/02/2014
alter table migracion.tct_comprobante
add column momento_comprometido VARCHAR(4) DEFAULT 'no'::character varying;

alter table migracion.tct_comprobante
add column  momento_ejecutado VARCHAR(4) DEFAULT 'no'::character varying;

alter table migracion.tct_comprobante
add column  momento_pagado VARCHAR(4) DEFAULT 'no'::character varying;


CREATE TABLE migracion.tct_cbte_clase_relacion (
  id_clase_cbte INTEGER, 
  codigo_clase VARCHAR(50), 
  momento VARCHAR(30)
) WITHOUT OIDS;