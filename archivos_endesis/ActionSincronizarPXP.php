<?php
/*
**********************************************************
Nombre de archivo:	    ActionSincronizarPXP.php
Proposito:				Permite sincronizar
Tabla:					
Parametros:				

Valores de Retorno:    	
Fecha de Creacion:		07/02/2013
Version:				1.0.0
Autor:					Rensi Arteaga Copari
**********************************************************
*/

include("../../lib/lib_general/cls_correo.php");

function Sincronizar($db){
	
	$rows    = 0;        // Number of rows
	$qid    = 0;        // Query result resource
	
	// See PostgreSQL developer manual (www.postgresql.org) for system table spec.
	// Get catalog data from system tables.
	$sql = 'SELECT * FROM migracion.f_sincronizacion()';
	$qid = pg_Exec($db, $sql);

	// Check error
	if (!is_resource($qid)) {
		print('Error en la Sincronizacion');
		return null;
	}

	$rows = pg_NumRows($qid);
	// Store meta data
	for ($i = 0; $i < $rows; $i++) {
		$res      = pg_Result($qid,$i,0);        // Field Name
	}
	
	echo 'Sincronizacion terminada ('.$res.')  - '.date("m-d-Y H:i:s").'<BR>';
    return $res;
}



function enviarCorreo($consulta,$error,$operacion,$hora_mig){
	$correo = new cls_correo();
	
	$origen='rensi@kplian.com';
	$destino='rensi_4rn@hotmail.com';
	$tema='MIGACION: error en la migracion ENDESIS -> PXP]';
	$mensaje_cab='Error al realizar '.$operacion;
	$titulo='ERROR  de migracion a las :'.$hora_mig;
	
	$mensaje='La consulta: <br>'.$consulta.'<br>'.'El error registrao es: <BR>'.$error.'<Br>';
	
	echo $mensaje;
	
	$var_cor = $correo ->EnviarCorreodeMigracionFlujo($origen,$destino,$tema,$mensaje,$titulo,$mensaje_cab);
	
	echo "correo enviado .... $var_cor<BR>";
	
}

function listarErrores($db,$date_ini)
{

	$query="SELECT 
			  id_migracion,
			  verificado,
			  consulta,
			  operacion,
			  migracion,
			  fecha_reg,
			  fecha_mig,
			  desc_error
			FROM 
			  migracion.tmig_migracion  m
			WHERE  m.migracion = 'falla' 
			and   (fecha_correo  <= '$date_ini' 
			or  fecha_correo  is NULL);";
	
	echo $query;
	
	echo "<BR>FECHA  ---> ".date("Y/m/d H:i:s")."<BR>";
	
	$query_upd="\nUPDATE 
	          migracion.tmig_migracion set 
	          fecha_correo = '".date("Y/m/d H:i:s")."'
	          WHERE
			     id_migracion = ";
	
	
	$salida=array();

	if($result = pg_query($db,$query))
	{
		while ($row = pg_fetch_array($result))
		{
		
		    $consulta = $query_upd.$row["id_migracion"].';';	
		
		
			echo $consulta;
			pg_query($db,$consulta);
			//enviarCorreo($row['consulta'],$row['desc_error'],$row['operacion'],$row['fecha_mig']);
			
		}
		
		//Libera la memoria
		pg_FreeResult($result);
	}
	else 
	{
		print('Error al ejecutar funcion. '.pg_last_error($db));
	}
	return $salida;
}



function restar($h1,$h2)
{
	$h2h = date('H', strtotime($h2));
	$h2m = date('i', strtotime($h2));
	$h2s = date('s', strtotime($h2));
	$hora2 =$h2h." hour ". $h2m ." min ".$h2s ." second";
	 
	$horas_sumadas= $h1." - ". $hora2;
	$text=date('Y/m/d H:i:s', strtotime($horas_sumadas)) ;
	return $text;
 
}


  //PARA calular el envio de correos por consulta fallida cada 5 horas
  //hasta que alimien el registro
  //para no llenar la casilla de correo del administrador
    $hora_actual = date("H:i:s");
	$date = date("Y/m/d H:i:s");
	$hora_dif = date('5:00:00');
	
	$date_filtro= restar($hora_actual,$hora_dif);
	
	
	echo "<BR>".$date_filtro." ---  ".$date."<BR>";
	
	

	//// Test code ////
	$dbName     = 'dbendesis';    // Change this to your db name
	$dbUser        = 'dblink2';    // Change this to your db user name
	$pass = 'pass';
	$db = pg_connect("host=192.168.1.32 dbname=".$dbName.' user='.$dbUser." password='".$pass."' port=5432");

Sincronizar($db);
listarErrores($db,$date_filtro);
//			enviarCorreoDir();
	
