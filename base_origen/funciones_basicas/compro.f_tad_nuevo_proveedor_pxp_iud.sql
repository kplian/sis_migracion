CREATE OR REPLACE FUNCTION compro.f_tad_nuevo_proveedor_pxp_iud (
  p_accion varchar,
  p_id_proveedor integer,
  p_id_persona integer,
  p_codigo varchar,
  p_numero_sigma varchar,
  p_tipo varchar,
  p_id_institucion integer,
  p_doc_id integer,
  p_nombre_institucion varchar,
  p_direccion_institucion varchar,
  p_casilla integer,
  p_telefono1_institucion integer,
  p_telefono2_institucion integer,
  p_celular1_institucion integer,
  p_celular2_institucion integer,
  p_fax integer,
  p_email1_institucion varchar,
  p_email2_institucion varchar,
  p_pag_web varchar,
  p_observaciones varchar,
  p_codigo_banco varchar,
  p_codigo_institucion varchar,
  p_nit varchar,
  p_id_lugar integer,
  p_register varchar,
  p_nombre varchar,
  p_apellido_paterno varchar,
  p_apellido_materno varchar,
  p_ci integer,
  p_correo varchar,
  p_celular1 integer,
  p_celular2 integer,
  p_telefono1 integer,
  p_telefono2 integer,
  p_genero varchar,
  p_fecha_nacimiento date,
  p_direccion varchar
)
RETURNS varchar AS
$body$
DECLARE
	g_id_institucion		integer;
    g_id_persona			integer;
    g_id_proveedor			integer;
    v_codigo				varchar;
    v_resp					varchar;
BEGIN
	if (p_accion = 'insert') then
    	
        if p_register = 'before_registered' then
            g_id_proveedor:=(select nextval('compro.tad_proveedor_id_proveedor_seq'));
            
             v_codigo:=('PROV'||f_llenar_ceros(g_id_proveedor::numeric,4))::varchar;
                 INSERT INTO compro.tad_proveedor(
                      id_proveedor,
                      id_institucion,
                      id_persona,
                      codigo,
                      observaciones,
                      id_lugar
                      )
                 VALUES (
                      g_id_proveedor,
                      p_id_institucion,
                      p_id_persona,
                      v_codigo,
                      p_observaciones,
                      p_id_lugar
                      );
          else
                if (p_tipo = 'persona')then
                    if(exists (select 1 from sss.tsg_persona per where trim(upper(per.apellido_paterno)) like trim(upper(p_apellido_paterno)) and trim(upper(per.apellido_materno)) like trim(upper(p_apellido_materno)) and (trim(upper(per.nombre)) like trim(upper(p_nombre))||'%' or trim(upper(p_nombre)) like trim(upper(per.nombre))||'%' )))then
                         raise exception 'Ya existe una persona con el mismo nombre. Si el proveedor no existe puede ser creado desde la vista Proveedores';
                    end if;
                    
                    g_id_persona:=(select nextval('sss.tsg_persona_id_persona_seq'));
                     --obtengo el id_persona siguiente
                    INSERT INTO sss.tsg_persona(
                           id_persona,
                           apellido_paterno,
                           apellido_materno,
                           nombre,
                           doc_id,
                           telefono1,
                           telefono2,
                           celular1,
                           celular2,
                           email1,
                           --id_tipo_doc_identificacion,
                           direccion,
                           genero,
                           fecha_nacimiento)
                    VALUES (
                           g_id_persona,
                           p_apellido_paterno,
                           p_apellido_materno,
                           p_nombre,
                           p_ci,
                           p_telefono1,
                           p_telefono1,
                           p_celular1,
                           p_celular2,
                           p_correo,		      
                           --ad_id_tipo_doc_identificacion,
                           p_direccion,
                           p_genero,
                           p_fecha_nacimiento);
                else
                     if(exists (select 1 from param.tpm_institucion where trim(upper(nombre)) like trim(upper(p_nombre_institucion))))then
                               raise exception 'Ya existe una institución con el mismo nombre. Si el proveedor no existe puede ser creado desde la vista Proveedores';
                     end if;

                     --Si es empresa
                     g_id_institucion:=(select nextval('param.tpm_institucion_id_institucion_seq'));

                     --obtengo el id_institucion siguiente
                     INSERT INTO param.tpm_institucion(
                            id_institucion,
                            doc_id,
                            nombre,
                            casilla,
                            telefono1,
                            telefono2,
                            celular1,
                            celular2,
                            fax,
                            email1,
                            email2,
                            pag_web,
                            --id_tipo_doc_institucion,
                            direccion)
                      VALUES (
                            g_id_institucion,
                            p_doc_id,
                            p_nombre_institucion,
                            p_casilla,
                            p_telefono1_institucion,
                            p_telefono2_institucion,
                            p_celular1_institucion,
                            p_celular2_institucion,
                            p_fax,
                            p_email1_institucion,
                            p_email2_institucion,
                            p_pag_web,
                            --ad_id_tipo_doc_institucion,
                            p_direccion_institucion);
                end if;
                     --inserto en  institucion

                 g_id_proveedor:=(select nextval('compro.tad_proveedor_id_proveedor_seq'));
                 v_codigo:=('PROV'||f_llenar_ceros(g_id_proveedor::numeric,4))::varchar;
                     INSERT INTO compro.tad_proveedor(
                          id_proveedor,
                          id_institucion,
                          id_persona,
                          codigo,
                          observaciones,
                          id_lugar
                          )
                     VALUES (
                          g_id_proveedor,
                          g_id_institucion,
                          g_id_persona,
                          v_codigo,
                          p_observaciones,
                          p_id_lugar
                          );
            end if;
        elsif (p_accion = 'update') then
        	if (p_id_institucion is not null) then
            	UPDATE 
                  param.tpm_institucion  
                SET 
                  doc_id = p_doc_id,
                  nombre = p_nombre_institucion,
                  casilla = p_casilla,
                  telefono1 = p_telefono1_institucion,
                  telefono2 = p_telefono2_institucion,
                  celular1 = p_celular1_institucion,
                  celular2 = p_celular2_institucion,
                  fax = p_fax,
                  email1 = p_email1_institucion,
                  email2 = p_email2_institucion,
                  pag_web = p_pag_web,
                  direccion = p_direccion_institucion,
                  codigo = p_codigo_institucion               
                WHERE 
                  id_institucion = p_id_institucion;
            elsif (p_id_persona is not null) then
            
            	UPDATE sss.tsg_persona set                           
                           apellido_paterno = p_apellido_paterno,
                           apellido_materno = p_apellido_materno,
                           nombre = p_nombre,
                           doc_id = p_ci,
                           telefono1 = p_telefono1,
                           telefono2 = p_telefono2,
                           celular1 = p_celular1,
                           celular2 = p_celular2,
                           email1 = p_correo,
                           --id_tipo_doc_identificacion,
                           direccion = p_direccion,
                           genero = p_genero,
                           fecha_nacimiento = p_fecha_nacimiento
                WHERE 
                  id_persona = p_id_persona;                    
            end if;
            
        	update compro.tad_proveedor set
            	id_institucion = p_id_institucion,
                id_persona = p_id_persona,
                codigo = p_codigo,
                id_lugar = p_id_lugar
            where id_proveedor = p_id_proveedor;
            
        elsif (p_accion = 'delete') then
        	delete from compro.tad_proveedor
            where id_proveedor = p_id_proveedor;
                       
        end if;
--        raise exception 'llega';
        
        return 'exito';
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER;