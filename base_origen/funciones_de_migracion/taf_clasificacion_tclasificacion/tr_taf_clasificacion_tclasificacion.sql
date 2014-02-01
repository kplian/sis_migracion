 
		CREATE TRIGGER tr_taf_clasificacion
  		AFTER INSERT OR UPDATE OR DELETE 
  		ON ACTIF.taf_clasificacion FOR EACH ROW 
  		EXECUTE PROCEDURE migracion.f_tri_taf_clasificacion_tclasificacion();