 
		CREATE TRIGGER tr_tpr_partida
  		AFTER INSERT OR UPDATE OR DELETE 
  		ON PRESTO.tpr_partida FOR EACH ROW 
  		EXECUTE PROCEDURE migracion.f_tri_tpr_partida_tpartida();