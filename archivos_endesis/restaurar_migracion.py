#! /usr/bin/python
# -*- coding: utf-8 -*-
import os
import pexpect

print '********************UTILIDAD PARA RESTAURAR LA BD DE ENDESIS********************'
ip = raw_input('Ingrese Ip del servidor: ')
#print ip
nameDb = raw_input('Ingrese nombre de la base de datos: ')
#print nameDb
cuenta = raw_input('Ingrese usuario de postgres: ')
#print cuenta
password = raw_input('Ingrese contraseña de '+ cuenta + ': ')
url = os.path.dirname(__file__) + '/../../sis_migracion/base_origen'
#url esquema and path000001.sql
print url
# Primero se restaura los esquemas y las funciones
#crear esquema
command = 'psql -q -U '+ cuenta + ' -h ' + ip + ' -d ' + nameDb + ' -f ' + url + '/ESQUEMA.sql'
child = pexpect.spawn(command)
message = 'Contraseña para usuario ' + cuenta + ':'
print message
child.expect(message)
child.sendline(password)
#os.system(command)
#crear tablas del esquema migracion
command = 'psql -q -U '+ cuenta + ' -h ' + ip + ' -d ' + nameDb + ' -f ' + url + '/path00001.sql'
child = pexpect.spawn(command)
child.expect(message)
child.sendline(password)
#os.system(command)        
#crear funciones basicas
funciones_dir = url + '/funciones_basicas/'
funciones = os.listdir( funciones_dir )
for f in funciones:
    if f.endswith('.sql'):
            command = 'psql -q -U ' + cuenta + ' -h ' + ip + ' -d ' + nameDb + ' -f ' + funciones_dir + f
            child = pexpect.spawn(command)
            child.expect(message)
            child.sendline(password)
            #os.system(command)
#crear funciones de financiador
funciones_dir = url + '/funciones_de_migracion/tpm_financiador_tfinanciador/'
funciones = os.listdir( funciones_dir )
for f in funciones:
    if f.endswith('.sql'):
            command = 'psql -q -U ' + cuenta + ' -h ' + ip + ' -d ' + nameDb + ' -f ' + funciones_dir + f
            child = pexpect.spawn(command)
            child.expect(message)
            child.sendline(password)
            #os.system(command)
#crear funciones de regional
funciones_dir = url + '/funciones_de_migracion/tpm_regional_tregional/'
funciones = os.listdir( funciones_dir )
for f in funciones:
    if f.endswith('.sql'):
            command = 'psql -q -U ' + cuenta +' -h ' + ip + ' -d ' + nameDb + ' -f ' + funciones_dir + f
            child = pexpect.spawn(command)
            child.expect(message)
            child.sendline(password)
            #os.system(command)
#crear funciones de programa
funciones_dir = url + '/funciones_de_migracion/tpm_programa_tprograma/'
funciones = os.listdir( funciones_dir )
for f in funciones:
    if f.endswith('.sql'):
            command = 'psql -q -U ' + cuenta + ' -h ' + ip + ' -d ' + nameDb + ' -f ' + funciones_dir + f
            child = pexpect.spawn(command)
            child.expect(message)
            child.sendline(password)
            #os.system(command)
#crear funciones de actividad
funciones_dir = url + '/funciones_de_migracion/tpm_actividad_tactividad/'
funciones = os.listdir( funciones_dir )
for f in funciones:
    if f.endswith('.sql'):
            command = 'psql -q -U ' + cuenta + ' -h ' + ip + ' -d ' + nameDb + ' -f ' + funciones_dir + f
            child = pexpect.spawn(command)
            child.expect(message)
            child.sendline(password)
#crear funciones de proyecto
funciones_dir = url + '/funciones_de_migracion/tpm_proyecto_tproyecto/'
funciones = os.listdir( funciones_dir )
for f in funciones:
    if f.endswith('.sql'):
            command = 'psql -q -U ' + cuenta + ' -h ' + ip + ' -d ' + nameDb + ' -f ' + funciones_dir + f
            child = pexpect.spawn(command)
            child.expect(message)
            child.sendline(password)
#crear funciones de programa proyecto actividad
funciones_dir = url + '/funciones_de_migracion/tpm_programa_proyecto_actividad_tprograma_proyecto_acttividad/'
funciones = os.listdir( funciones_dir )
for f in funciones:
    if f.endswith('.sql'):
            command = 'psql -q -U ' + cuenta + ' -h ' + ip + ' -d ' + nameDb + ' -f ' + funciones_dir + f
            child = pexpect.spawn(command)
            child.expect(message)
            child.sendline(password)
#crear funciones de ep
funciones_dir = url + '/funciones_de_migracion/tpm_fina_regi_prog_proy_acti_tep/'
funciones = os.listdir( funciones_dir )
for f in funciones:
    if f.endswith('.sql'):
            command = 'psql -q -U ' + cuenta + ' -h ' + ip + ' -d ' + nameDb + ' -f ' + funciones_dir + f
            child = pexpect.spawn(command)
            child.expect(message)
            child.sendline(password)
#crear funciones de persona
funciones_dir = url + '/funciones_de_migracion/tsg_persona_tpersona/'
funciones = os.listdir( funciones_dir )
for f in funciones:
    if f.endswith('.sql'):
            command = 'psql -q -U ' + cuenta + ' -h ' + ip + ' -d ' + nameDb + ' -f ' + funciones_dir + f
            child = pexpect.spawn(command)
            child.expect(message)
            child.sendline(password)    
#crear funciones de usuario
funciones_dir = url + '/funciones_de_migracion/tsg_usuario_tusuario/'
funciones = os.listdir( funciones_dir )
for f in funciones:
    if f.endswith('.sql'):
            command = 'psql -q -U ' + cuenta + ' -h ' + ip + ' -d ' + nameDb + ' -f ' + funciones_dir + f
            child = pexpect.spawn(command)
            child.expect(message)
            child.sendline(password)
#crear funciones de funcionario
funciones_dir = url + '/funciones_de_migracion/tkp_empleado_tfuncionario/'
funciones = os.listdir( funciones_dir )
for f in funciones:
    if f.endswith('.sql'):
            command = 'psql -q -U ' + cuenta + ' -h ' + ip + ' -d ' + nameDb + ' -f ' + funciones_dir + f
            child = pexpect.spawn(command)
            child.expect(message)
            child.sendline(password)        
#crear funciones de institucion
funciones_dir = url + '/funciones_de_migracion/tpm_institucion_tinstitucion/'
funciones = os.listdir( funciones_dir )
for f in funciones:
    if f.endswith('.sql'):
            command = 'psql -q -U ' + cuenta + ' -h ' + ip + ' -d ' + nameDb + ' -f ' + funciones_dir + f
            child = pexpect.spawn(command)
            child.expect(message)
            child.sendline(password)
#crear funciones de presupuesto
funciones_dir = url + '/funciones_de_migracion/tpm_institucion_tinstitucion/'
funciones = os.listdir( funciones_dir )
for f in funciones:
    if f.endswith('.sql'):
            command = 'psql -q -U ' + cuenta + ' -h ' + ip + ' -d ' + nameDb + ' -f ' + funciones_dir + f
            child = pexpect.spawn(command)
            child.expect(message)
            child.sendline(password)
#crear funciones de concepto cuenta
funciones_dir = url + '/funciones_de_migracion/tpr_presupuesto_tcentro_costo/'
funciones = os.listdir( funciones_dir )
for f in funciones:
    if f.endswith('.sql'):
            command = 'psql -q -U ' + cuenta + ' -h ' + ip + ' -d ' + nameDb + ' -f ' + funciones_dir + f
            child = pexpect.spawn(command)
            child.expect(message)
            child.sendline(password)        
#crear funciones de concepto ingas
funciones_dir = url + '/funciones_de_migracion/tpr_concepto_ingas_tconcepto_ingas/'
funciones = os.listdir( funciones_dir )
for f in funciones:
    if f.endswith('.sql'):
            command = 'psql -q -U ' + cuenta + ' -h ' + ip + ' -d ' + nameDb + ' -f ' + funciones_dir + f
            child = pexpect.spawn(command)
            child.expect(message)
            child.sendline(password)
#crear funciones de partida
funciones_dir = url + '/funciones_de_migracion/tpr_partida_tpartida/'
funciones = os.listdir( funciones_dir )
for f in funciones:
    if f.endswith('.sql'):
            command = 'psql -q -U ' + cuenta + ' -h ' + ip + ' -d ' + nameDb + ' -f ' + funciones_dir + f
            child = pexpect.spawn(command);
            child.expect(message)
            child.sendline(password)
#crear funciones de cuenta
funciones_dir = url + '/funciones_de_migracion/tct_cuenta_tcuenta/'
funciones = os.listdir( funciones_dir )
for f in funciones:
    if f.endswith('.sql'):
            command = 'psql -q -U ' + cuenta + ' -h ' + ip + ' -d ' + nameDb + ' -f ' + funciones_dir + f
            child = pexpect.spawn(command)
            child.expect(message)
            child.sendline(password)
#crear funciones de concepto auxiliar
funciones_dir = url + '/funciones_de_migracion/tct_auxiliar_tauxiliar/'
funciones = os.listdir( funciones_dir )
for f in funciones:
    if f.endswith('.sql'):
            command = 'psql -q -U ' + cuenta + ' -h ' + ip + ' -d ' + nameDb + ' -f ' + funciones_dir + f
            child = pexpect.spawn(command)
            child.expect(message)
            child.sendline(password)
#crear funciones de orden de trabajo
funciones_dir = url + '/funciones_de_migracion/tct_orden_trabajo_torden_trabajo/'
funciones = os.listdir( funciones_dir )
for f in funciones:
    if f.endswith('.sql'):
            command = 'psql -q -U ' + cuenta + ' -h ' + ip + ' -d ' + nameDb + ' -f ' + funciones_dir + f
            child = pexpect.spawn(command)
            child.expect(message)
            child.sendline(password)

#crear funciones de unidad organizacional
funciones_dir = url + '/funciones_de_migracion/tkp_unidad_organizacional_tuo/'
funciones = os.listdir( funciones_dir )
for f in funciones:
    if f.endswith('.sql'):
            command = 'psql -q -U ' + cuenta + ' -h ' + ip + ' -d ' + nameDb + ' -f ' + funciones_dir + f
            child = pexpect.spawn(command)
            child.expect(message)
            child.sendline(password)
#crear funciones de estructura organizacional
funciones_dir = url + '/funciones_de_migracion/tkp_estructura_organizacional_testructura_uo/'
funciones = os.listdir( funciones_dir )
for f in funciones:
    if f.endswith('.sql'):
            command = 'psql -q -U ' + cuenta + ' -h ' + ip + ' -d ' + nameDb + ' -f ' + funciones_dir + f
            child = pexpect.spawn(command)
            child.expect(message)
            child.sendline(password)
#crear funciones de proveedor
funciones_dir = url + '/funciones_de_migracion/tad_proveedor_tproveedor/'
funciones = os.listdir( funciones_dir )
for f in funciones:
    if f.endswith('.sql'):
            command = 'psql -q -U ' + cuenta + ' -h ' + ip + ' -d ' + nameDb + ' -f ' + funciones_dir + f
            child = pexpect.spawn(command)
            child.expect(message)
            child.sendline(password)

#crear funciones de plantilla
funciones_dir = url + '/funciones_de_migracion/tct_plantilla_tplantilla/'
funciones = os.listdir( funciones_dir )
for f in funciones:
    if f.endswith('.sql'):
            command = 'psql -q -U ' + cuenta + ' -h ' + ip + ' -d ' + nameDb + ' -f ' + funciones_dir + f
            child = pexpect.spawn(command)
            child.expect(message)
            child.sendline(password)