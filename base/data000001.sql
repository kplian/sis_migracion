/***********************************I-DAT-RAC-MIGRA-0-31/12/2012*****************************************/


INSERT INTO segu.tsubsistema ("codigo", "nombre", "fecha_reg", "prefijo", "estado_reg", "nombre_carpeta", "id_subsis_orig")
VALUES (E'MIGRA', E'Migracion', E'2013-01-14', E'MIG', E'activo', E'migracion', NULL);


----------------------------------
--COPY LINES TO data.sql FILE  
---------------------------------

select pxp.f_insert_tgui ('MIGRACION', '', 'MIGRA', 'si', NULL, '', 1, '', '', 'MIGRA');
select pxp.f_insert_tgui ('Generador', 'Generada Scrip de Migracion', 'TAM', 'si', 1, 'sis_migracion/vista/tabla_mig/TablaMig.php', 2, '', 'TablaMig', 'MIGRA');
select pxp.f_insert_tfuncion ('migra.f_tabla_mig_ime', 'Funcion para tabla     ', 'MIGRA');
select pxp.f_insert_tfuncion ('migra.f_tabla_mig_sel', 'Funcion para tabla     ', 'MIGRA');
select pxp.f_insert_tfuncion ('migra.f_tabla_mig_ori_sel', 'Funcion para tabla     ', 'MIGRA');
select pxp.f_insert_tfuncion ('migra.f_columna_ori_ime', 'Funcion para tabla     ', 'MIGRA');
select pxp.f_insert_tfuncion ('migra.f_columna_ori_sel', 'Funcion para tabla     ', 'MIGRA');
select pxp.f_insert_tfuncion ('migra.f_columna_des_ime', 'Funcion para tabla     ', 'MIGRA');
select pxp.f_insert_tfuncion ('migra.f_gestion_regla', 'Funcion para tabla     ', 'MIGRA');
select pxp.f_insert_tfuncion ('migra.f_columna_des_sel', 'Funcion para tabla     ', 'MIGRA');
select pxp.f_insert_tfuncion ('migra.f__on_trig_tpm_gestion_tgestion', 'Funcion para tabla     ', 'MIGRA');
select pxp.f_insert_tprocedimiento ('MIG_TAM_ELI', 'Eliminacion de registros', 'si', '', '', 'migra.f_tabla_mig_ime');
select pxp.f_insert_tprocedimiento ('MIG_TAM_MOD', 'Modificacion de registros', 'si', '', '', 'migra.f_tabla_mig_ime');
select pxp.f_insert_tprocedimiento ('MIG_TAM_INS', 'Insercion de registros', 'si', '', '', 'migra.f_tabla_mig_ime');
select pxp.f_insert_tprocedimiento ('MIG_TAM_CONT', 'Conteo de registros', 'si', '', '', 'migra.f_tabla_mig_sel');
select pxp.f_insert_tprocedimiento ('MIG_TAM_SEL', 'Consulta de datos', 'si', '', '', 'migra.f_tabla_mig_sel');
select pxp.f_insert_tprocedimiento ('MIG_TABORI_CONT', 'Conteo de registros', 'si', '', '', 'migra.f_tabla_mig_ori_sel');
select pxp.f_insert_tprocedimiento ('MIG_TABORI_SEL', 'Consulta de datos', 'si', '', '', 'migra.f_tabla_mig_ori_sel');
select pxp.f_insert_tprocedimiento ('MIG_SISORI_CONT', 'Conteo de registros', 'si', '', '', 'migra.f_tabla_mig_ori_sel');
select pxp.f_insert_tprocedimiento ('MIG_SISORI_SEL', 'Consulta de datos', 'si', '', '', 'migra.f_tabla_mig_ori_sel');
select pxp.f_insert_tprocedimiento ('MIG_COLO_ELI', 'Eliminacion de registros', 'si', '', '', 'migra.f_columna_ori_ime');
select pxp.f_insert_tprocedimiento ('MIG_COLO_MOD', 'Modificacion de registros', 'si', '', '', 'migra.f_columna_ori_ime');
select pxp.f_insert_tprocedimiento ('MIG_COLO_INS', 'Insercion de registros', 'si', '', '', 'migra.f_columna_ori_ime');
select pxp.f_insert_tprocedimiento ('MIG_COLO_CONT', 'Conteo de registros', 'si', '', '', 'migra.f_columna_ori_sel');
select pxp.f_insert_tprocedimiento ('MIG_COLO_SEL', 'Consulta de datos', 'si', '', '', 'migra.f_columna_ori_sel');
select pxp.f_insert_tprocedimiento ('MIG_COLD_ELI', 'Eliminacion de registros', 'si', '', '', 'migra.f_columna_des_ime');
select pxp.f_insert_tprocedimiento ('MIG_COLD_MOD', 'Modificacion de registros', 'si', '', '', 'migra.f_columna_des_ime');
select pxp.f_insert_tprocedimiento ('MIG_COLD_INS', 'Insercion de registros', 'si', '', '', 'migra.f_columna_des_ime');
select pxp.f_insert_tprocedimiento ('MIG_COLD_CONT', 'Conteo de registros', 'si', '', '', 'migra.f_columna_des_sel');
select pxp.f_insert_tprocedimiento ('MIG_COLD_SEL', 'Consulta de datos', 'si', '', '', 'migra.f_columna_des_sel');
----------------------------------
--COPY LINES TO dependencies.sql FILE 
---------------------------------

select pxp.f_insert_testructura_gui ('MIGRA', 'SISTEMA');
select pxp.f_insert_testructura_gui ('TAM', 'MIGRA');
   
/***********************************F-DAT-RAC-MIGRA-0-31/12/2012*****************************************/
