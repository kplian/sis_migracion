		DROP TRIGGER tr_tpr_concepto_cta ON PRESTO.tpr_concepto_cta;
		CREATE TRIGGER tr_tpr_concepto_cta
  		AFTER INSERT OR UPDATE OR DELETE 
  		ON PRESTO.tpr_concepto_cta FOR EACH ROW 
  		EXECUTE PROCEDURE migracion.f_tri_tpr_concepto_cta_tconcepto_cta();