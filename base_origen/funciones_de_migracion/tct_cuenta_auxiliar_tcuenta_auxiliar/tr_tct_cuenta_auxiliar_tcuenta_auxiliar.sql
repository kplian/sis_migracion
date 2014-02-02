		DROP TRIGGER tr_tct_cuenta_auxiliar ON SCI.tct_cuenta_auxiliar;
		CREATE TRIGGER tr_tct_cuenta_auxiliar
  		AFTER INSERT OR UPDATE OR DELETE 
  		ON SCI.tct_cuenta_auxiliar FOR EACH ROW 
  		EXECUTE PROCEDURE migracion.f_tri_tct_cuenta_auxiliar_tcuenta_auxiliar();