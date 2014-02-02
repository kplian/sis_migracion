		DROP TRIGGER tr_tpr_presupuesto ON PRESTO.tpr_presupuesto;
		CREATE TRIGGER tr_tpr_presupuesto
  		AFTER INSERT OR UPDATE OR DELETE 
  		ON PRESTO.tpr_presupuesto FOR EACH ROW 
  		EXECUTE PROCEDURE migracion.f_tri_tpr_presupuesto_tcentro_costo();