 
		CREATE TRIGGER tr_tpm_programa
  		AFTER INSERT OR UPDATE OR DELETE 
  		ON PARAM.tpm_programa FOR EACH ROW 
  		EXECUTE PROCEDURE migracion.f_tri_tpm_programa_tprograma();