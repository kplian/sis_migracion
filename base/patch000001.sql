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

CREATE TABLE migra.tdepto_to_depto_endesis (
  id_depto_to_depto_endesis SERIAL, 
  id_depto_pxp INTEGER, 
  id_depto_endesis INTEGER, 
  PRIMARY KEY(id_depto_to_depto_endesis)
) WITHOUT OIDS;



/***********************************F-SCP-RAC-MIGRA-1-18/11/2013****************************************/






