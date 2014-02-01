 
		CREATE TRIGGER tr_tpr_partida_ids
  		AFTER INSERT OR UPDATE OR DELETE 
  		ON PRESTO.tpr_partida_ids FOR EACH ROW 
  		EXECUTE PROCEDURE migracion.f_tri_tpr_partida_ids_tpartida_ids();