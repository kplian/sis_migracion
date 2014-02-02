		DROP TRIGGER tr_tpr_partida_cuenta ON PRESTO.tpr_partida_cuenta;
		CREATE TRIGGER tr_tpr_partida_cuenta
  		AFTER INSERT OR UPDATE OR DELETE 
  		ON PRESTO.tpr_partida_cuenta FOR EACH ROW 
  		EXECUTE PROCEDURE migracion.f_tri_tpr_partida_cuenta_tcuenta_partida();