		DROP TRIGGER tr_tct_plantilla ON SCI.tct_plantilla;
		CREATE TRIGGER tr_tct_plantilla
  		AFTER INSERT OR UPDATE OR DELETE 
  		ON SCI.tct_plantilla FOR EACH ROW 
  		EXECUTE PROCEDURE migracion.f_tri_tct_plantilla_tplantilla();