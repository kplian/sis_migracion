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


CREATE TABLE migra.tts_libro_bancos (
  id_libro_bancos SERIAL, 
  id_cuenta_bancaria INTEGER NOT NULL, 
  fecha DATE NOT NULL, 
  a_favor VARCHAR(100) NOT NULL, 
  detalle TEXT NOT NULL, 
  observaciones TEXT, 
  nro_liquidacion VARCHAR(20), 
  nro_comprobante VARCHAR(20), 
  nro_cheque INTEGER, 
  tipo VARCHAR(20) NOT NULL, 
  importe_deposito NUMERIC(20,2) NOT NULL, 
  importe_cheque NUMERIC(20,2) NOT NULL, 
  origen VARCHAR(20), 
  estado VARCHAR(20) DEFAULT 'borrador'::character varying NOT NULL, 
  id_libro_bancos_fk INTEGER, 
  indice NUMERIC(20,2), 
  CONSTRAINT tts_libro_bancos_idx UNIQUE(id_cuenta_bancaria, nro_cheque), 
  CONSTRAINT tts_libro_bancos_pkey PRIMARY KEY(id_libro_bancos)
) INHERITS (pxp.tbase)
WITHOUT OIDS;


COMMENT ON TABLE migra.tts_libro_bancos
IS 'sistema=TESORO&codigo=LBRBAN&prefijo=TS&titulo=Libro Bancos&desc=Libro Bancos';

COMMENT ON COLUMN migra.tts_libro_bancos.id_libro_bancos
IS 'nombre=id_libro_bancos&label=id_libro_bancos&grid_visible=si&grid_editable=no&disabled=no&width_grid=100&width=100%&filtro=si&defecto=&desc=id_libro_bancos';

COMMENT ON COLUMN migra.tts_libro_bancos.id_cuenta_bancaria
IS 'nombre=id_cuenta_bancaria&label=id_cuenta_bancaria&grid_visible=si&grid_editable=no&disabled=no&width_grid=100&width=100%&filtro=si&defecto=&desc=id_cuenta_bancaria';

COMMENT ON COLUMN migra.tts_libro_bancos.fecha
IS 'nombre=fecha&label=fecha&grid_visible=si&grid_editable=no&disabled=no&width_grid=100&width=100%&filtro=si&defecto=&desc=fecha';

COMMENT ON COLUMN migra.tts_libro_bancos.a_favor
IS 'nombre=a_favor&label=a_favor&grid_visible=si&grid_editable=no&disabled=no&width_grid=100&width=100%&filtro=si&defecto=&desc=a_favor';

COMMENT ON COLUMN migra.tts_libro_bancos.detalle
IS 'nombre=detalle&label=detalle&grid_visible=si&grid_editable=no&disabled=no&width_grid=100&width=100%&filtro=si&defecto=&desc=detalle';

COMMENT ON COLUMN migra.tts_libro_bancos.observaciones
IS 'nombre=observaciones&label=observaciones&grid_visible=si&grid_editable=no&disabled=no&width_grid=100&width=100%&filtro=si&defecto=&desc=observaciones';

COMMENT ON COLUMN migra.tts_libro_bancos.nro_liquidacion
IS 'nombre=nro_liquidacion&label=nro_liquidacion&grid_visible=si&grid_editable=no&disabled=no&width_grid=100&width=100%&filtro=si&defecto=&desc=nro_liquidacion';

COMMENT ON COLUMN migra.tts_libro_bancos.nro_comprobante
IS 'nombre=nro_comprobante&label=nro_comprobante&grid_visible=si&grid_editable=no&disabled=no&width_grid=100&width=100%&filtro=si&defecto=&desc=nro_comprobante';

COMMENT ON COLUMN migra.tts_libro_bancos.nro_cheque
IS 'nombre=nro_cheque&label=nro_cheque&grid_visible=si&grid_editable=no&disabled=no&width_grid=100&width=100%&filtro=si&defecto=&desc=nro_cheque';

COMMENT ON COLUMN migra.tts_libro_bancos.tipo
IS 'nombre=tipo&label=tipo&grid_visible=si&grid_editable=no&disabled=no&width_grid=100&width=100%&filtro=si&defecto=&desc=tipo

cheque
deposito';

COMMENT ON COLUMN migra.tts_libro_bancos.importe_deposito
IS 'nombre=importe_deposito&label=importe_deposito&grid_visible=si&grid_editable=no&disabled=no&width_grid=100&width=100%&filtro=si&defecto=&desc=importe_deposito';

COMMENT ON COLUMN migra.tts_libro_bancos.importe_cheque
IS 'nombre=importe_cheque&label=importe_cheque&grid_visible=si&grid_editable=no&disabled=no&width_grid=100&width=100%&filtro=si&defecto=&desc=importe_cheque';

COMMENT ON COLUMN migra.tts_libro_bancos.origen
IS 'nombre=origen&label=origen&grid_visible=si&grid_editable=no&disabled=no&width_grid=100&width=100%&filtro=si&defecto=&desc=origen';

COMMENT ON COLUMN migra.tts_libro_bancos.estado
IS 'nombre=estado&label=estado&grid_visible=si&grid_editable=no&disabled=no&width_grid=100&width=100%&filtro=si&defecto=&desc=estado';

COMMENT ON COLUMN migra.tts_libro_bancos.id_libro_bancos_fk
IS 'nombre=fk_libro_bancos&label=fk_libro_bancos&grid_visible=si&grid_editable=no&disabled=no&width_grid=100&width=100%&filtro=si&defecto=&desc=fk_libro_bancos';

/***********************************F-SCP-RCM-MIGRA-1-03/12/2013****************************************/