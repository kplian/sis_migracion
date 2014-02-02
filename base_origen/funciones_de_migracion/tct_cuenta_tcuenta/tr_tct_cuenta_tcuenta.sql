		DROP TRIGGER tr_tct_cuenta ON SCI.tct_cuenta;
		CREATE TRIGGER tr_tct_cuenta
  		AFTER INSERT OR UPDATE OR DELETE 
  		ON SCI.tct_cuenta FOR EACH ROW 
  		EXECUTE PROCEDURE migracion.f_tri_tct_cuenta_tcuenta();