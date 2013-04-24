 
		CREATE TRIGGER tr_tkp_empleado
  		AFTER INSERT OR UPDATE OR DELETE 
  		ON KARD.tkp_empleado FOR EACH ROW 
  		EXECUTE PROCEDURE migracion.f_tri_tkp_empleado_tfuncionario();