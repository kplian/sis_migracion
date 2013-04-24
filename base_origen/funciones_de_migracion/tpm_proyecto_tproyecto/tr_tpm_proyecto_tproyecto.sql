 
		CREATE TRIGGER tr_tpm_proyecto
  		AFTER INSERT OR UPDATE OR DELETE 
  		ON PARAM.tpm_proyecto FOR EACH ROW 
  		EXECUTE PROCEDURE migracion.f_tri_tpm_proyecto_tproyecto();