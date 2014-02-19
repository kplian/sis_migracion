
   
/***********************************I-DEP-RAC-MIGRA-0-31/12/2012*****************************************/
ALTER TABLE migra.tconcepto_ids
  ADD CONSTRAINT tconcepto_ids_fk FOREIGN KEY (id_concepto_ingas_pxp)
    REFERENCES param.tconcepto_ingas(id_concepto_ingas)
    MATCH FULL
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

/***********************************F-DEP-RAC-MIGRA-0-31/12/2013*****************************************/
