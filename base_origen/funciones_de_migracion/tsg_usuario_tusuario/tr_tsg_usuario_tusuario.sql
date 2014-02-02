		DROP TRIGGER tr_tsg_usuario ON SSS.tsg_usuario;
		CREATE TRIGGER tr_tsg_usuario
  		AFTER INSERT OR UPDATE OR DELETE 
  		ON SSS.tsg_usuario FOR EACH ROW 
  		EXECUTE PROCEDURE migracion.f_tri_tsg_usuario_tusuario();