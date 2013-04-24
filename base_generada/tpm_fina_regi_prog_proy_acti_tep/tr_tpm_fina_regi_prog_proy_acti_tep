 
		CREATE TRIGGER tr_tpm_fina_regi_prog_proy_acti
  		AFTER INSERT OR UPDATE OR DELETE 
  		ON PARAM.tpm_fina_regi_prog_proy_acti FOR EACH ROW 
  		EXECUTE PROCEDURE migracion.f_tri_tpm_fina_regi_prog_proy_acti_tep();