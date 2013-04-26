 
		CREATE TRIGGER tr_tsg_usuario_asignacion
  		AFTER INSERT OR UPDATE OR DELETE 
  		ON SSS.tsg_usuario_asignacion FOR EACH ROW 
  		EXECUTE PROCEDURE migracion.f_tri_tsg_usuario_asignacion_tusuario_grupo_ep();