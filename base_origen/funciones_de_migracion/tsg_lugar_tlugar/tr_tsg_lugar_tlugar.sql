		DROP TRIGGER tr_tsg_lugar ON SSS.tsg_lugar;
		CREATE TRIGGER tr_tsg_lugar
  		AFTER INSERT OR UPDATE OR DELETE 
  		ON SSS.tsg_lugar FOR EACH ROW 
  		EXECUTE PROCEDURE migracion.f_tri_tsg_lugar_tlugar();