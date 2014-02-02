		DROP TRIGGER tr_tkp_unidad_organizacional ON KARD.tkp_unidad_organizacional;
		CREATE TRIGGER tr_tkp_unidad_organizacional
  		AFTER INSERT OR UPDATE OR DELETE 
  		ON KARD.tkp_unidad_organizacional FOR EACH ROW 
  		EXECUTE PROCEDURE migracion.f_tri_tkp_unidad_organizacional_tuo();