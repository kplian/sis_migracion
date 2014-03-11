
CREATE TABLE migracion.tmig_migracion (
  id_migracion SERIAL, 
  verificado VARCHAR(2), 
  consulta TEXT, 
  operacion VARCHAR(15), 
  migracion VARCHAR(15), 
  fecha_reg TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL, 
  fecha_mig TIMESTAMP WITHOUT TIME ZONE, 
  CONSTRAINT tmig_migracion_pkey PRIMARY KEY(id_migracion)
) WITHOUT OIDS;


ALTER TABLE migracion.tmig_migracion
  ADD COLUMN desc_error TEXT;
  
ALTER TABLE migracion.tmig_migracion
  ADD COLUMN fecha_correo TIMESTAMP WITHOUT TIME ZONE;
  

--------------- SQL ---------------

 -- object recreation
ALTER TABLE sci.tct_comprobante
  DROP CONSTRAINT chk_tct_comprobante__origen RESTRICT;


--18-11-2013
ALTER TABLE sci.tct_comprobante
  ADD CONSTRAINT chk_tct_comprobante__origen CHECK ((((((((((((((((((((((((((((origen)::text = 'alta_activo_fijo'::text) OR ((origen)::text = 'depreciacion_activo_fijo'::text)) OR ((origen)::text = 'devengado_diario'::text)) OR ((origen)::text = 'fv_facturacion_mesual'::text)) OR ((origen)::text = 'devengado_pago'::text)) OR ((origen)::text = 'devengado_reg'::text)) OR ((origen)::text = 'duplicado'::text)) OR ((origen)::text = 'finalizacion'::text)) OR ((origen)::text = 'planilla_devengado'::text)) OR ((origen)::text = 'planilla_pago'::text)) OR ((origen)::text = 'plan_pago_anticipo'::text)) OR ((origen)::text = 'plan_pago_devengado'::text)) OR ((origen)::text = 'plan_pago_pago'::text)) OR ((origen)::text = 'rendicion'::text)) OR ((origen)::text = 'reposicion'::text)) OR ((origen)::text = 'solicitud'::text)) OR ((origen)::text = 'sucursal'::text)) OR ((origen)::text = 'kp_planilla_diario_pre'::text)) OR ((origen)::text = 'actualizacion'::text)) OR ((origen)::text = 'kp_planilla_anticipo'::text)) OR ((origen)::text = 'activo_fijo'::text)) OR ((origen)::text = 'kp_planilla_diario_costo'::text)) OR (origen IS NULL)) OR ((origen)::text = 'cierre_apertura'::text)) OR ((origen)::text = 'kp_planilla_obligacion'::text)) OR ((origen)::text = 'comprobante_apertura'::text)) OR ((origen)::text = 'comprobante_apertura'::text));
  


--------------- SQL ---------------

ALTER TABLE actif.taf_activo_fijo
  ALTER COLUMN descripcion TYPE VARCHAR(1000);
  
  
--FALTA EL ESCRIPT PARA ELIMNAR LAS FOREN KEYS DE LA TABLA DE ACTIVO FIJO PARA
-- EL PREINGERSO DE ACTIVOS  
  
