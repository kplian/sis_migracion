		DROP TRIGGER tr_tpm_financiador ON PARAM.tpm_financiador;
		CREATE TRIGGER tr_tpm_financiador
  		AFTER INSERT OR UPDATE OR DELETE 
  		ON PARAM.tpm_financiador FOR EACH ROW 
  		EXECUTE PROCEDURE migracion.f_tri_tpm_financiador_tfinanciador();