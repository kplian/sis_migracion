		DROP TRIGGER tr_tpr_concepto_ingas ON PRESTO.tpr_concepto_ingas;
		CREATE TRIGGER tr_tpr_concepto_ingas
  		AFTER INSERT OR UPDATE OR DELETE 
  		ON PRESTO.tpr_concepto_ingas FOR EACH ROW 
  		EXECUTE PROCEDURE migracion.f_tri_tpr_concepto_ingas_tconcepto_ingas();