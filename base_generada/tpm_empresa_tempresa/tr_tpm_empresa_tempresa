 
		CREATE TRIGGER tr_tpm_empresa
  		AFTER INSERT OR UPDATE OR DELETE 
  		ON PARAM.tpm_empresa FOR EACH ROW 
  		EXECUTE PROCEDURE migracion.f_tri_tpm_empresa_tempresa();