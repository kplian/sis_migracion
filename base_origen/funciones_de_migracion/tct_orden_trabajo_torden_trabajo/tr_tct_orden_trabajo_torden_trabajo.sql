 
		CREATE TRIGGER tr_tct_orden_trabajo
  		AFTER INSERT OR UPDATE OR DELETE 
  		ON SCI.tct_orden_trabajo FOR EACH ROW 
  		EXECUTE PROCEDURE migracion.f_tri_tct_orden_trabajo_torden_trabajo();