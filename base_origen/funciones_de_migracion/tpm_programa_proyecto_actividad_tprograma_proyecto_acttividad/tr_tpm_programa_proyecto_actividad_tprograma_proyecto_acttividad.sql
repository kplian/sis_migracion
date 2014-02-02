DROP TRIGGER  tr_tpm_programa_proyecto_actividad on PARAM.tpm_programa_proyecto_actividad
		CREATE TRIGGER tr_tpm_programa_proyecto_actividad
  		AFTER INSERT OR UPDATE OR DELETE 
  		ON PARAM.tpm_programa_proyecto_actividad FOR EACH ROW 
  		EXECUTE PROCEDURE migracion.f_tri_tpm_programa_proyecto_actividad_tprograma_proyecto_acttividad();