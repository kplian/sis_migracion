 
		CREATE TRIGGER tr_tsg_asignacion_estructura_tpm_frppa
  		AFTER INSERT OR UPDATE OR DELETE 
  		ON SSS.tsg_asignacion_estructura_tpm_frppa FOR EACH ROW 
  		EXECUTE PROCEDURE migracion.f_tri_tsg_asignacion_estructura_tpm_frppa_tgrupo_ep();