 
		CREATE TRIGGER tr_tkp_historico_asignacion
  		AFTER INSERT OR UPDATE OR DELETE 
  		ON KARD.tkp_historico_asignacion FOR EACH ROW 
  		EXECUTE PROCEDURE migracion.f_tri_tkp_historico_asignacion_tuo_funcionario();