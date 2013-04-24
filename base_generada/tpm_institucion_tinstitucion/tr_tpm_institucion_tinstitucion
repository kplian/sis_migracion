 
		CREATE TRIGGER tr_tpm_institucion
  		AFTER INSERT OR UPDATE OR DELETE 
  		ON PARAM.tpm_institucion FOR EACH ROW 
  		EXECUTE PROCEDURE migracion.f_tri_tpm_institucion_tinstitucion();