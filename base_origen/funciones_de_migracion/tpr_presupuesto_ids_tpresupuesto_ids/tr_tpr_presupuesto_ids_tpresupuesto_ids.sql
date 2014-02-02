		DROP TRIGGER tr_tpr_presupuesto_ids ON PRESTO.tpr_presupuesto_ids;
		CREATE TRIGGER tr_tpr_presupuesto_ids
  		AFTER INSERT OR UPDATE OR DELETE 
  		ON PRESTO.tpr_presupuesto_ids FOR EACH ROW 
  		EXECUTE PROCEDURE migracion.f_tri_tpr_presupuesto_ids_tpresupuesto_ids();