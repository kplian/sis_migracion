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
#            #os.system(command)

#crear funciones de migracion
migracion_dir = url + '/funciones_de_migracion/'
directorios = os.listdir( migracion_dir )
for d in directorios:
    #crear funciones de proveedor
    funciones_dir = url + '/funciones_de_migracion/' + d
    funciones = os.listdir( funciones_dir )
    for f in funciones:
        if f.endswith('.sql'):
            command = 'psql -q -U ' + cuenta + ' -h ' + ip + ' -d ' + nameDb + ' -f ' + funciones_dir + f
            print command
            child = pexpect.spawn(command)
            child.expect(message)
            child.sendline(password)
            #os.system(command)