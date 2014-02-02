		DROP TRIGGER tr_tkp_estructura_organizacional ON KARD.tkp_estructura_organizacional;
		CREATE TRIGGER tr_tkp_estructura_organizacional
  		AFTER INSERT OR UPDATE OR DELETE 
  		ON KARD.tkp_estructura_organizacional FOR EACH ROW 
  		EXECUTE PROCEDURE migracion.f_tri_tkp_estructura_organizacional_testructura_uo();