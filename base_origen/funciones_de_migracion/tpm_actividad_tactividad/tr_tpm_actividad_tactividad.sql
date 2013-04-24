 
		CREATE TRIGGER tr_tpm_actividad
  		AFTER INSERT OR UPDATE OR DELETE 
  		ON PARAM.tpm_actividad FOR EACH ROW 
  		EXECUTE PROCEDURE migracion.f_tri_tpm_actividad_tactividad();