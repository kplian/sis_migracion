 
		CREATE TRIGGER tr_tts_cuenta_bancaria
  		AFTER INSERT OR UPDATE OR DELETE 
  		ON TESORO.tts_cuenta_bancaria FOR EACH ROW 
  		EXECUTE PROCEDURE migracion.f_tri_tts_cuenta_bancaria_tts_cuenta_bancaria();