		DROP TRIGGER  tr_tts_libro_bancos ON TESORO.tts_libro_bancos;
		CREATE TRIGGER tr_tts_libro_bancos
  		AFTER INSERT OR UPDATE OR DELETE 
  		ON TESORO.tts_libro_bancos FOR EACH ROW 
  		EXECUTE PROCEDURE migracion.f_tri_tts_libro_bancos_tts_libro_bancos();