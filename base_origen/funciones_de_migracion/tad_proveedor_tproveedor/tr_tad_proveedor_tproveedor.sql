 
		CREATE TRIGGER tr_tad_proveedor
  		AFTER INSERT OR UPDATE OR DELETE 
  		ON COMPRO.tad_proveedor FOR EACH ROW 
  		EXECUTE PROCEDURE migracion.f_tri_tad_proveedor_tproveedor();