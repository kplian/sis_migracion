/***********************************I-SCP-RAC-MIGRA-1-01/01/2013****************************************/
    
CREATE TABLE migra.ttabla_mig (
  id_tabla_mig SERIAL, 
  id_subsistema_ori INTEGER, 
  id_subsistema_des INTEGER, 
  tabla_ori VARCHAR(255) NOT NULL, 
  tabla_des VARCHAR(255) NOT NULL, 
  alias_ori VARCHAR(5) NOT NULL, 
  alias_des VARCHAR(5) NOT NULL,
  obs VARCHAR(500),  
  CONSTRAINT ttabla_mig_pkey PRIMARY KEY(id_tabla_mig)
) INHERITS (pxp.tbase)
WITHOUT OIDS;


CREATE TABLE migra.tcolumna_ori (
  id_columna_ori SERIAL, 
  columna VARCHAR(150), 
  tipo_dato VARCHAR(30), 
  CONSTRAINT tcolumna_ori_pkey PRIMARY KEY(id_columna_ori)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

CREATE TABLE migra.tcolumna_des (
  id_columna_des SERIAL, 
  columna VARCHAR(150), 
  tipo_dato VARCHAR(80), 
  id_columna_ori INTEGER, 
  CONSTRAINT tcolumna_des_pkey PRIMARY KEY(id_columna_des)
) INHERITS (pxp.tbase)
WITHOUT OIDS; 

ALTER TABLE migra.ttabla_mig
  ADD COLUMN codigo_sis_ori VARCHAR(200); 
  
--------------- SQL ---------------

ALTER TABLE migra.tcolumna_des
  ADD COLUMN id_tabla_mig INTEGER;
  
  --------------- SQL ---------------

ALTER TABLE migra.tcolumna_ori
  ADD COLUMN id_tabla_mig INTEGER;  
  
  
ALTER TABLE migra.tcolumna_des
  ADD COLUMN checks VARCHAR(4);
  
ALTER TABLE migra.tcolumna_ori
  ADD COLUMN checks VARCHAR(4);
  
 
     

/***********************************F-SCP-RAC-MIGRA-1-01/01/2013****************************************/




/***********************************I-SCP-RAC-MIGRA-1-18/11/2013****************************************/

--------------- SQL ---------------
/*
CREATE TABLE migra.tdepto_to_depto_endesis (
  id_depto_to_depto_endesis SERIAL, 
  id_depto_pxp INTEGER, 
  id_depto_endesis INTEGER, 
  PRIMARY KEY(id_depto_to_depto_endesis)
) WITHOUT OIDS;*/



/***********************************F-SCP-RAC-MIGRA-1-18/11/2013****************************************/


/***********************************I-SCP-RCM-MIGRA-1-03/12/2013****************************************/
CREATE TABLE migra.tts_cuenta_bancaria (
  id_cuenta_bancaria integer, 
  id_institucion INTEGER NOT NULL, 
  id_cuenta INTEGER NOT NULL, 
  nro_cuenta_banco VARCHAR(30) NOT NULL, 
  nro_cheque INTEGER NOT NULL, 
  estado_cuenta NUMERIC(1,0) NOT NULL, 
  id_auxiliar INTEGER, 
  id_parametro INTEGER, 
  id_gestion INTEGER,
  id_cuenta_bancaria_pxp INTEGER,
  CONSTRAINT ts_cuenta_bancaria_pkey PRIMARY KEY(id_cuenta_bancaria)
) WITHOUT OIDS;


/***********************************F-SCP-RCM-MIGRA-1-03/12/2013****************************************/


/***********************************I-SCP-RAC-MIGRA-1-03/02/2014****************************************/


CREATE TABLE migra.tdepto_to_depto_endesis (
  id_depto_to_depto_endesis SERIAL, 
  id_depto_pxp INTEGER, 
  id_depto_endesis INTEGER, 
  CONSTRAINT tdepto_to_depto_endesis_pkey PRIMARY KEY(id_depto_to_depto_endesis)
) WITHOUT OIDS;

/***********************************F-SCP-RAC-MIGRA-1-03/02/2014****************************************/



/***********************************I-SCP-RAC-MIGRA-2-03/02/2014****************************************/

ALTER TABLE migra.tts_cuenta_bancaria
  ADD COLUMN centro VARCHAR(4) DEFAULT 'si' NOT NULL;

COMMENT ON COLUMN migra.tts_cuenta_bancaria.centro
IS 'Identifica si es de la regional central o no. Viene por la integracionde cuenta bancaria endesis';

/***********************************F-SCP-RAC-MIGRA-2-03/02/2014****************************************/

/***********************************I-SCP-JRR-MIGRA-0-14/02/2014****************************************/

CREATE TABLE migra.tconcepto_ids (
  id_concepto_ingas INTEGER, 
  id_concepto_ingas_pxp INTEGER, 
  id_gestion INTEGER, 
  desc_ingas VARCHAR
) WITHOUT OIDS;

/***********************************F-SCP-JRR-MIGRA-0-14/02/2014****************************************/


/***********************************I-SCP-JRR-MIGRA-0-21/10/2014****************************************/
CREATE SEQUENCE orga.tescala_salarial_migracion_seq
  INCREMENT 1 MINVALUE 1
  MAXVALUE 9223372036854775807 START 10100
  CACHE 1;
/***********************************F-SCP-JRR-MIGRA-0-21/10/2014****************************************/



/***********************************I-SCP-GSS-MIGRA-0-02/09/2015****************************************/

CREATE TABLE migra.tcbte_central (
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
  beneficiario VARCHAR(500),
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
  id_orden_trabajo INTEGER,
  id_depto_libro INTEGER,
  id_depto_conta_pxp INTEGER
) 
WITH (oids = false);


/***********************************F-SCP-GSS-MIGRA-0-02/09/2015****************************************/




