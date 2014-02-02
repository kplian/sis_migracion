		DROP TRIGGER tr_tpm_regional ON PARAM.tpm_regional;
		CREATE TRIGGER tr_tpm_regional
  		AFTER INSERT OR UPDATE OR DELETE 
  		ON PARAM.tpm_regional FOR EACH ROW 
  		EXECUTE PROCEDURE migracion.f_tri_tpm_regional_tregional();