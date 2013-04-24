
CREATE TABLE migracion.tmig_migracion (
  id_migracion SERIAL, 
  verificado VARCHAR(2), 
  consulta TEXT, 
  operacion VARCHAR(15), 
  migracion VARCHAR(15), 
  fecha_reg TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL, 
  fecha_mig TIMESTAMP WITHOUT TIME ZONE, 
  CONSTRAINT tmig_migracion_pkey PRIMARY KEY(id_migracion)
) WITHOUT OIDS;


ALTER TABLE migracion.tmig_migracion
  ADD COLUMN desc_error TEXT;
  
ALTER TABLE migracion.tmig_migracion
  ADD COLUMN fecha_correo TIMESTAMP WITHOUT TIME ZONE;