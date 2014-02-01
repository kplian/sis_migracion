 
		CREATE TRIGGER tr_tpm_gestion
  		AFTER INSERT OR UPDATE OR DELETE 
  		ON PARAM.tpm_gestion FOR EACH ROW 
  		EXECUTE PROCEDURE migracion.f_tri_tpm_gestion_tgestion();