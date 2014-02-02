		DROP TRIGGER tr_tsg_asignacion_estructura ON SSS.tsg_asignacion_estructura;
		CREATE TRIGGER tr_tsg_asignacion_estructura
  		AFTER INSERT OR UPDATE OR DELETE 
  		ON SSS.tsg_asignacion_estructura FOR EACH ROW 
  		EXECUTE PROCEDURE migracion.f_tri_tsg_asignacion_estructura_tgrupo();