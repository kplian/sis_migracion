		DROP TRIGGER tr_tsg_persona ON SSS.tsg_persona;
		CREATE TRIGGER tr_tsg_persona
  		AFTER INSERT OR UPDATE OR DELETE 
  		ON SSS.tsg_persona FOR EACH ROW 
  		EXECUTE PROCEDURE migracion.f_tri_tsg_persona_tpersona();