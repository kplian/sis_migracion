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
  id_ep INTEGER,
  momento_comprometido VARCHAR(4) DEFAULT 'no'::character varying,
  momento_ejecutado VARCHAR(4) DEFAULT 'no'::character varying,
  momento_pagado VARCHAR(4) DEFAULT 'no'::character varying,
  id_cuenta_bancaria INTEGER,
  nombre_cheque VARCHAR(200),
  nro_cheque INTEGER,
  tipo VARCHAR(15),
  id_libro_bancos INTEGER,
  id_cuenta_bancaria_endesis INTEGER,
  id_orden_trabajo INTEGER
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
  



CREATE TABLE migracion.tct_cbte_clase_relacion (
  id_clase_cbte INTEGER, 
  codigo_clase VARCHAR(50), 
  momento VARCHAR(30)
) WITHOUT OIDS;


/* Data for the 'migracion.tct_cbte_clase_relacion' table  (Records 1 - 6) */

INSERT INTO migracion.tct_cbte_clase_relacion ("id_clase_cbte", "codigo_clase", "momento")
VALUES (1, E'DIARIO', E'contable');

INSERT INTO migracion.tct_cbte_clase_relacion ("id_clase_cbte", "codigo_clase", "momento")
VALUES (3, E'CAJA', E'contable');

INSERT INTO migracion.tct_cbte_clase_relacion ("id_clase_cbte", "codigo_clase", "momento")
VALUES (5, E'PAGO', E'contable');

INSERT INTO migracion.tct_cbte_clase_relacion ("id_clase_cbte", "codigo_clase", "momento")
VALUES (1, E'DIARIO', E'presupuestario');

INSERT INTO migracion.tct_cbte_clase_relacion ("id_clase_cbte", "codigo_clase", "momento")
VALUES (3, E'CAJA', E'presupuestario');

INSERT INTO migracion.tct_cbte_clase_relacion ("id_clase_cbte", "codigo_clase", "momento")
VALUES (5, E'PAGO', E'presupuestario');




--------------- SQL ---------------

ALTER TABLE sci.tct_comprobante
  DROP CONSTRAINT chk_tct_comprobante__origen RESTRICT;
  
  
 --------------- SQL ---------------

ALTER TABLE sci.tct_comprobante
  ADD CONSTRAINT tct_comprobante_chk CHECK ((((((((((((((((((((((((((((origen)::text = 'alta_activo_fijo'::text) OR ((origen)::text = 'depreciacion_activo_fijo'::text)) OR ((origen)::text = 'devengado_diario'::text)) OR ((origen)::text = 'fv_facturacion_mesual'::text)) OR ((origen)::text = 'devengado_pago'::text)) OR ((origen)::text = 'devengado_reg'::text)) OR ((origen)::text = 'duplicado'::text)) OR ((origen)::text = 'finalizacion'::text)) OR ((origen)::text = 'planilla_devengado'::text)) OR ((origen)::text = 'planilla_pago'::text)) OR ((origen)::text = 'plan_pago_anticipo'::text)) OR ((origen)::text = 'plan_pago_devengado'::text)) OR ((origen)::text = 'plan_pago_pago'::text)) OR ((origen)::text = 'rendicion'::text)) OR ((origen)::text = 'reposicion'::text)) OR ((origen)::text = 'solicitud'::text)) OR ((origen)::text = 'sucursal'::text)) OR ((origen)::text = 'kp_planilla_diario_pre'::text)) OR ((origen)::text = 'actualizacion'::text)) OR ((origen)::text = 'kp_planilla_anticipo'::text)) OR ((origen)::text = 'activo_fijo'::text)) OR ((origen)::text = 'kp_planilla_diario_costo'::text)) OR (origen IS NULL)) OR ((origen)::text = 'cierre_apertura'::text)) OR ((origen)::text = 'kp_planilla_obligacion'::text)) OR ((origen)::text = 'comprobante_apertura'::text)) OR ((origen)::text = 'pxp'::text)); 
 
 

--------------- SQL ---------------

ALTER TABLE migracion.tct_comprobante
  ALTER COLUMN beneficiario TYPE VARCHAR(500);
  
  
--------------- SQL ---------------

ALTER TABLE presto.tpr_concepto_ingas
  ADD COLUMN sw_autorizacion VARCHAR(50)[];
  
  --------------- SQL ---------------

ALTER TABLE sci.tct_comprobante
  ADD COLUMN id_depto_libro INTEGER;
  
  
  --------------- SQL ---------------

ALTER TABLE migracion.tct_comprobante
  ADD COLUMN id_depto_libro INTEGER;
