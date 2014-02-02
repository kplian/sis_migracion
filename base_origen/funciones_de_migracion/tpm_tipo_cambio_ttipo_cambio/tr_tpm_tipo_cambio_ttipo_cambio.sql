		DROP TRIGGER tr_tpm_tipo_cambio ON PARAM.tpm_tipo_cambio;
		CREATE TRIGGER tr_tpm_tipo_cambio
  		AFTER INSERT OR UPDATE OR DELETE 
  		ON PARAM.tpm_tipo_cambio FOR EACH ROW 
  		EXECUTE PROCEDURE migracion.f_tri_tpm_tipo_cambio_ttipo_cambio();