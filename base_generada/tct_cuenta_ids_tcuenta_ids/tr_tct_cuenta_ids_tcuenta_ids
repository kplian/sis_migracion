 
		CREATE TRIGGER tr_tct_cuenta_ids
  		AFTER INSERT OR UPDATE OR DELETE 
  		ON SCI.tct_cuenta_ids FOR EACH ROW 
  		EXECUTE PROCEDURE migracion.f_tri_tct_cuenta_ids_tcuenta_ids();