 
		CREATE TRIGGER tr_tpm_periodo
  		AFTER INSERT OR UPDATE OR DELETE 
  		ON PARAM.tpm_periodo FOR EACH ROW 
  		EXECUTE PROCEDURE migracion.f_tri_tpm_periodo_tperiodo();