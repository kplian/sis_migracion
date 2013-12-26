CREATE OR REPLACE FUNCTION migra.f_migrar_parametrizacion_contable_endesis (
  p_gestion integer,
  p_tabla_endesis varchar
)
RETURNS varchar AS
$body$
/*
Autor: RCM
Fecha: 09/12/2013
Descripción: Migrar la parametrización contable de tablas de ENDESIS a PXP
*/

DECLARE

	v_cnx varchar;
    v_sql varchar;
    v_resp varchar;
    v_id_gestion integer;
    v_id_tabla_relacion_contable integer;
    v_id_tipo_relacion_contable integer;
    v_rec record;

BEGIN
	
	--1. Obtención de cadena de conexión a ENDESIS
    v_cnx = migra.f_obtener_cadena_conexion();
    
    --1.1 Apertura de la conexión
    v_resp = (SELECT dblink_connect(v_cnx));
    
    if v_resp != 'OK' then
    	raise exception 'No se pudo conectar con el servidor: No existe ninguna ruta hasta el host';
    end if;
    
    --2. Condicional por tabla
    if p_tabla_endesis = 'presto.tpr_concepto_ingas' then
        
    	--Verificación de gestión existente en ENDESIS
        v_sql = 'select a.id_gestion
                from param.tpm_gestion a
                inner join presto.tpr_parametro b
                on b.id_gestion = a.id_gestion
                where a.gestion = ' || p_gestion;
        
        select id_gestion
        into v_id_gestion
        FROM dblink(v_sql,true) as (id_gestion integer);
        
        if coalesce(v_id_gestion,0) = 0 then
            raise exception 'Gestión inexistente en Endesis - Presupuestos';
        end if;
        
        --Verificación de gestión existente en PXP
        if not exists(select 1 from param.tgestion
                    where id_gestion = v_id_gestion
                    and gestion = p_gestion) then
            raise exception 'Gestión inexistente en PXP';
        end if;
    	
    	-----------------
    	--Verifica que exista registrada la Tabla Relación Contable tconcepto_ingas
        -----------------
        select id_tabla_relacion_contable
        into v_id_tabla_relacion_contable
        from conta.ttabla_relacion_contable tr
        where tr.tabla = 'tconcepto_ingas';
        
        if v_id_tabla_relacion_contable is null then
        
        	--Creación del registro de tabla relacion contable
            insert into conta.ttabla_relacion_contable(
              id_usuario_reg,
              fecha_reg,
              estado_reg,
              tabla,
              esquema,
              tabla_id
            ) VALUES (
              1,
              now(),
              'activo',
              'tconcepto_ingas',
              'param',
              'id_concepto_ingas'
            ) returning id_tabla_relacion_contable into v_id_tabla_relacion_contable;
            
		end if;
         
        -------------   
        --Verifica que exista el tipo de relacion contable CUECOMP
        --------------
        select id_tipo_relacion_contable
        into v_id_tipo_relacion_contable
        from conta.ttipo_relacion_contable tr
        where tr.codigo_tipo_relacion = 'CUECOMP'
        and tr.id_tabla_relacion_contable = v_id_tabla_relacion_contable;
        
        if v_id_tipo_relacion_contable is null then
        
        	--Creación del tipo de relación contable
			INSERT INTO conta.ttipo_relacion_contable(
              id_usuario_reg,
              fecha_reg,
              estado_reg,
              nombre_tipo_relacion,
              codigo_tipo_relacion,
              tiene_centro_costo,
              tiene_partida,
              tiene_auxiliar,
              id_tabla_relacion_contable
            ) VALUES (
              1,
              now(),
              'activo',
              'Cuenta para realizar compras',
              'CUECOMP',
              'si-general',
              'si',
              'si',
              v_id_tabla_relacion_contable
            ) returning id_tipo_relacion_contable into v_id_tipo_relacion_contable;
        
		end if;
    
    	-------------------
		--Migración de la parametrización en Relación contable
        --------------------
        --Eliminación de los datos de la relación contable de la gestión
        delete from conta.trelacion_contable
        where id_tipo_relacion_contable = v_id_tipo_relacion_contable
        and id_gestion = v_id_gestion;
        
        --Cadena de la consulta
        v_sql = 'select
        		cta.id_presupuesto as id_centro_costo, cta.id_cuenta, cta.id_auxiliar,
                ci.id_partida,ci.id_concepto_ingas as id
        		from presto.tpr_parametro p
                inner join presto.tpr_partida par on par.id_parametro = p.id_parametro
                inner join presto.tpr_concepto_ingas ci on ci.id_partida = par.id_partida
                inner join presto.tpr_concepto_cta cta on cta.id_concepto_ingas = ci.id_concepto_ingas
                where p.id_gestion = ' ||v_id_gestion;
                
        /*v_sql = 'select
        		id_centro_costo, id_cuenta, id_auxiliar,
                id_partida,id
                from migra.ttmp_concepto_ingas'
		for v_rec in (select * from migra.ttmp_concepto_ingas) loop*/
        for v_rec in (select *
    				from dblink(v_sql,true)
                    as (id_centro_costo integer, id_cuenta integer, id_auxiliar integer, id_partida integer, id integer)) loop
                    
        	INSERT INTO conta.trelacion_contable(
              id_usuario_reg,
              fecha_reg,
              estado_reg,
              id_tipo_relacion_contable,
              id_centro_costo,
              id_cuenta,
              id_auxiliar,
              id_partida,
              id_gestion,
              id_tabla,
              defecto
            ) VALUES (
              1,
              now(),
              'activo',
              v_id_tipo_relacion_contable,
              v_rec.id_centro_costo,
              v_rec.id_cuenta,
              v_rec.id_auxiliar,
              v_rec.id_partida,
              v_id_gestion,
              v_rec.id,
              'no'
            );	
        
        end loop;
    
    elsif p_tabla_endesis = 'tesoro.tts_cuenta_bancaria' then
    
		--Verificación de gestión existente en ENDESIS
        v_sql = 'select a.id_gestion
                from param.tpm_gestion a
                inner join tesoro.tts_parametro b
                on b.id_gestion = a.id_gestion
                where a.gestion = ' || p_gestion;
        
        select id_gestion
        into v_id_gestion
        FROM dblink(v_sql,true) as (id_gestion integer);
        
        if coalesce(v_id_gestion,0) = 0 then
            raise exception 'Gestión inexistente en Endesis - Tesorería';
        end if;
        
        --Verificación de gestión existente en PXP
        if not exists(select 1 from param.tgestion
                    where id_gestion = v_id_gestion
                    and gestion = p_gestion) then
            raise exception 'Gestión inexistente en PXP';
        end if;	 
        
        -----------------
    	--Verifica que exista registrada la Tabla Relación Contable tcuenta_bancaria
        -----------------
        select id_tabla_relacion_contable
        into v_id_tabla_relacion_contable
        from conta.ttabla_relacion_contable tr
        where tr.tabla = 'tcuenta_bancaria';
        
        if v_id_tabla_relacion_contable is null then
        
        	--Creación del registro de tabla relacion contable
            insert into conta.ttabla_relacion_contable(
              id_usuario_reg,
              fecha_reg,
              estado_reg,
              tabla,
              esquema,
              tabla_id,
              fecha_mod
            ) VALUES (
              1,
              now(),
              'activo',
              'tcuenta_bancaria',
              'tes',
              'id_cuenta_bancaria',
              NULL
            ) returning id_tabla_relacion_contable into v_id_tabla_relacion_contable;
            
		end if;
         
        -------------   
        --Verifica que exista el tipo de relacion contable CUEBANCEGRE
        --------------
        select id_tipo_relacion_contable
        into v_id_tipo_relacion_contable
        from conta.ttipo_relacion_contable tr
        where tr.codigo_tipo_relacion = 'CUEBANCEGRE'
        and tr.id_tabla_relacion_contable = v_id_tabla_relacion_contable;
        
        if v_id_tipo_relacion_contable is null then
        
        	--Creación del tipo de relación contable
			INSERT INTO conta.ttipo_relacion_contable(
              id_usuario_reg,
              fecha_reg,
              estado_reg,
              nombre_tipo_relacion,
              codigo_tipo_relacion,
              tiene_centro_costo,
              tiene_partida,
              tiene_auxiliar,
              id_tabla_relacion_contable,
              fecha_mod
            ) VALUES (
              1,
              now(),
              'activo',
              'Cuentas Bancarias',
              'CUEBANCEGRE',
              'no',
              'no',
              'si',
              v_id_tabla_relacion_contable,
              NULL
            ) returning id_tipo_relacion_contable into v_id_tipo_relacion_contable;
        
		end if;
        
        -------------
        --Migración Consulta para réplica de la parametrización
        -------------
        v_sql = 'select
        		cc.id_cuenta, cc.id_auxiliar, cc.id_cuenta_bancaria
        		from tesoro.tts_parametro p
                inner join tesoro.tts_cuenta_bancaria_cuenta cc
                on cc.id_parametro = p.id_parametro
                where p.id_gestion = ' || v_id_gestion;
                
        for v_rec in (select *
    				from dblink(v_sql,true)
                    as (id_cuenta integer, id_auxiliar integer, id_cuenta_bancaria integer)) loop
        	
        	INSERT INTO conta.trelacion_contable(
              id_usuario_reg,
              fecha_reg,
              estado_reg,
              id_tipo_relacion_contable,
              id_cuenta,
              id_auxiliar,
              id_gestion,
              id_tabla,
              defecto,
              fecha_mod
            ) VALUES (
              1,
              now(),
              'activo',
              v_id_tipo_relacion_contable,
              v_rec.id_cuenta,
              v_rec.id_auxiliar,
              v_id_gestion,
              v_rec.id,
              'no',
              null
            );	 
        
        end loop;
    
    
    
    else
    	raise exception 'Migraciónde parametrización contable no implementada: ',p_tabla_endesis;
    end if;
    
    
--    raise exception 'hecho';
    return 'Migracion realizada';

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;