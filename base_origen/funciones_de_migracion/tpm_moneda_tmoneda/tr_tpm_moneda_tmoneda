 
		CREATE TRIGGER tr_tpm_moneda
  		AFTER INSERT OR UPDATE OR DELETE 
  		ON PARAM.tpm_moneda FOR EACH ROW 
  		EXECUTE PROCEDURE migracion.f_tri_tpm_moneda_tmoneda();