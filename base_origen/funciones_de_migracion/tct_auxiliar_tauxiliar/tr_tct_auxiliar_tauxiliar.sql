		DROP TRIGGER tr_tct_auxiliar ON SCI.tct_auxiliar;
		CREATE TRIGGER tr_tct_auxiliar
  		AFTER INSERT OR UPDATE OR DELETE 
  		ON SCI.tct_auxiliar FOR EACH ROW 
  		EXECUTE PROCEDURE migracion.f_tri_tct_auxiliar_tauxiliar();