<?php
class cls_correo
{
	
/*
**********************************************************
Nombre de la funci�n:	EnviarCorreoAdjunto($origen,$destino,$nom_archivo,$dir_archivo,$asunto,$mensaje)
Prop�sito:				Se utiliza para crear enviar un mail con un archivo adjunto
						
						
Par�metros:				$origen	--> quien es envia el mensaje
						$destino  --> para quien es el mensage
						$nom_archivo  --> nombre del archivo adjunto
						$dir_archivo  --> dir donde se encuentra el archivo 
						$asunto  --> asunto del mensaje
						$mensaje  --> el mensaje pra enviar por mail
Valores de Retorno:		1 	-->	exito en el envio
						0	--> error
Autor					Rensi Arteaga Copari rensi@pi.umsa.bo
**********************************************************
*/


function EnviarCorreoAdjunto($origen,$destino,$nom_archivo,$dir_archivo,$asunto,$mensaje)
{

		$file = fopen($dir_archivo+"/"+nom_archivo, "r");
		$contenido = fread($file, filesize($dir_archivo+"/"+nom_archivo));
		$encoded_attach = chunk_split(base64_encode($contenido));
		fclose($file);
		
		$nombref=$nom_archivo;
		if($asuton=="")
		{
			$asunto="Archivo adjunto";
		}
		$email=$destino;
	
		//$mensaje="Email enviado por cortesia de Dise�o y Programaci�n";
	
		$cabeceras = "From: lotito <$origen>\n";
		$cabeceras .= "Reply-To: $email\n";
		$cabeceras .= "MIME-version: 1.0\n";
		$cabeceras .= "Content-type: multipart/mixed; ";
		$cabeceras .= "boundary=\"Message-Boundary\"\n";
		$cabeceras .= "Content-transfer-encoding: 7BIT\n";
		$cabeceras .= "X-attachments: $nombref";
		
		$body_top = "--Message-Boundary\n";
		$body_top .= "Content-type: text/plain; charset=US-ASCII\n";
		$body_top .= "Content-transfer-encoding: 7BIT\n";
		$body_top .= "Content-description: Mail message body\n\n";
	
		$cuerpo = $body_top.$mensaje;
	
		//$nombref="fichero.bin";
		$cuerpo .= "\n\n--Message-Boundary\n";
		$cuerpo .= "Content-type: Binary; name=\"$nombref\"\n";
		$cuerpo .= "Content-Transfer-Encoding: BASE64\n";
		$cuerpo .= "Content-disposition: attachment; filename=\"$nombref\"\n\n";
		$cuerpo .= "$encoded_attach\n";
		$cuerpo .= "--Message-Boundary--\n";

		$exito=mail($email,$asunto,$cuerpo,$cabeceras);
		return $exito;
	
	}
	
	/*
**********************************************************
Nombre de la funci�n:	EnviarCorreoConfirmacion($origen,$destino,$nombre,$id)
Prop�sito:				Se utiliza para crear enviar un mail con un archivo adjunto
						
						
Par�metros:				$origen	--> quien es envia el mensaje
						$destino  --> para quien es el mensage
						$nombre  --> pra mostra en el mensaje
						$id  --> clave cliente
						
Valores de Retorno:		1 	-->	exito en el envio
						0	--> error
Autor					Rensi Arteaga Copari rensi@pi.umsa.bo
**********************************************************
*/
function EnviarCorreoConfirmacion($origen,$destino,$nombre,$id)
{
	
	////
	$id = $id *199;
	$host  = $_SERVER['HTTP_HOST'];
    $uri  = rtrim(dirname($_SERVER['PHP_SELF']), '/\\');
    $extra = "../../control/cliente/ActionConfirmaCliente.php?id=$id&nom=$nombre";
    $extra2 = "../../control/cliente/ActionBajaCliente.php?id=$id&nom=$nombre";
    $url= "http://$host$uri/$extra";
    $url2= "http://$host$uri/$extra2";
	///

		$destinatario = $destino;
		$asunto = "Confirmaci�n Loto Millonario";
		$cuerpo = "
		<html>
		<head>
 		<title>LOTO MILLONARIO</title>
		</head>
		<body>
		<h1>Hola $nombre!  </h1>

		 Te enviamos este mensaje para que puedas  confirmar tu suscripci&oacute;n a nuestra p&aacute;gina web y as&iacute; poder recibir nuestros  boletines semanalmente con todas las novedades de LOTO MILLONARIO.</p>
		<p>Si est&aacute;s de acuerdo <a href='$url'>pulsa aqu&iacute;.</a></p>
		<p>&nbsp;</p>
		<p>&nbsp;</p>
		<p>&nbsp;</p>
		<p>&nbsp;</p>
		<p>&nbsp;</p>
		<p>&nbsp;</p>
		<p>-------------------------------------------<br />
  		Este mensaje no es <em>spam, </em>en caso de no querer  recibir esta informaci&oacute;n o alguna relacionada a nuestro producto <a href='$url2'>pulsa  aqu&iacute;.</a></p>
		<p>
		</body>
		</html>
		";	
		//para el env�o en formato HTML
		$headers  = "MIME-Version: 1.0\r\n";
		$headers .= "Content-type: text/html; charset=iso-8859-1\r\n";

		//direcci�n del remitente
		$headers .= "From:lotomillonario <lotomillonario@loto.com.bo>\r\n";
		
		//direcci�n de respuesta, si queremos que sea distinta que la del remitente
		//$headers .= "Reply-To: rensi_4rn@hotmail.combo\r\n";

		//direcciones que recibi�n copia
		//$headers .= "Cc: rensi4rn@gmail.com\r\n";

		//direcciones que recibir�n copia oculta
		//$headers .= "Bcc: rensi4rn@yahoo.com.fr,vsp@jtc.com.bo\r\n";

		$exito= mail($destinatario,$asunto,$cuerpo,$headers);

		return $exito;
	
	}
	
	
	
		/*
**********************************************************
Nombre de la funci�n:	EnviarCorreoConfirmacion($origen,$destino,$nombre,$id)
Prop�sito:				Se utiliza para crear enviar un mail con un archivo adjunto
						
						
Par�metros:				$origen	--> quien es envia el mensaje
						$destino  --> para quien es el mensage
						$nombre  --> pra mostra en el mensaje
						$id  --> clave cliente
						
Valores de Retorno:		1 	-->	exito en el envio
						0	--> error
Autor					Rensi Arteaga Copari rensi@pi.umsa.bo
**********************************************************
*/
function EnviarBoletin($origen,$destino,$nombre,$id)
{    ////recuperacion de variables
  session_start();
  $id = $id *199;
  
  ///premios extra///
  $extras = array();
  $extras = $_SESSION["extras"];
  ///////////////////////////////////
  $contenido=$_SESSION["contenido"];
  $com=$_SESSION["combinaciones"];
  $id_figura=$_SESSION["id_figura"];
  $fig = $_SESSION["figura_sorteada"];
  $nro_sorteo=$_SESSION["sorteo"];
  $color=$_SESSION["color"];
  $raiz = "imagenes/contenido/";


  $figcg= $_SESSION['figcg']; //aciertos cantidad ganadores
  $cg13 = $_SESSION['cg13']; //aciertos cantidad ganadores
  $cg140 = $_SESSION['cg140']; //aciertos cantidad ganadores
  $cg141 = $_SESSION['cg141']; //aciertos cantidad ganadores
  $cg15 = $_SESSION['cg15']; //aciertos cantidad ganadores
  
  //premio neto
  $figpn = $_SESSION['figpn'];
  $pn13 = $_SESSION['pn13']; // aciertos premio neto
  $pn140 = $_SESSION['pn140']; //aciertos premio neto
  $pn141 = $_SESSION['pn141']; //aciertos premio neto
  $pn15 = $_SESSION['pn15']; //aciertos premio neto
  
  
  //totales por categoria
  $figtc = $_SESSION['figtc'];//figura total categoria
  $tc13 = $_SESSION['tc13'];// 13 aciertos premio total categoria
  $tc140 = $_SESSION['tc140'];//14 aciertos sin fig premio total categoria
  $tc141 = $_SESSION['tc141'];//14 aciertos mas fig premio total categoria
  $tc15 = $_SESSION['tc15']; //15 aciertos premio total categoria
  $numganadores = $_SESSION['numganadores'];//numero de ganadores
  $monto = $_SESSION['monto'];//monto total ganado
  
  //totales
  $totalpn =  $_SESSION['totalpn'];
  $totaltc = $_SESSION['totaltc'];
  $totalcg = $_SESSION['totalcg'];//numero de ganadores
  $fechasorteo = $_SESSION['fechasorteo'];
  $boletin = $_SESSION['boletin'] ;
	///////////////////////////////////
	
	////
	$host  = $_SERVER['HTTP_HOST'];
    $uri  = rtrim(dirname($_SERVER['PHP_SELF']), '/\\');
    $extra = "../../control/cliente/ActionBajaCliente.php?id=$id&nom=$nombre";
    $url= "http://$host$uri/$extra";
    //$url2= "http://$host$uri/../..";
    $url2= "http://www.loto.com.bo/control/cliente/../..";
	///

		$destinatario = $destino;
		$asunto = "Boletin de Resultados";
		$cuerpo = "
		<html>
		<head>
 		<title>Loto Millonario .::. Resultados</title>
   		<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>
 		<style type='text/css'>
		<!-- 
		.contenido{
		width:758px;
		background-color:#F5F5F5;
		}
		.texto_normal{
		font-family:Arial, Helvetica, sans-serif;
		font-size:12px;
		color:#454545;
		padding:10px 25px 25px 25px;
		}
		.texto_normal a{
		text-decoration:none;
		color:#B51168;
		}
		.texto_normal a:hover{
		text-decoration:underline;
		color:#0096FF;
		}
		.ganador_monto{
		font-family:Helvetica;
		font-size:25px;
		font-weight:bold;
		color:#FFFFFF;
		background-color:#454545;
		}
		.ganador_datos{
		font-family:Helvetica;
		font-size:10px;
		font-weight:bold;
		color:#FFFFFF;
		background-color:#454545;
		text-align:right;
		}
		.ganador_datos a{
		color:#FFFFFF;
		}
		.ganador_datos a:hover{
		color:#66FF66;
		}
		.subtitulo_principal{
		font-family:Arial, Helvetica, sans-serif;
		font-weight:bold;
		font-size:14px;
		color:#B51168;
		text-align:left;
		vertical-align:bottom;
		padding:10px 0px 0px 20px;
		}
		.titulo_principal{
		font-family:Arial, Helvetica, sans-serif;
		font-weight:bold;
		font-size:14px;
		color:#ffffff;
		}
		.subtitulo{
		font-family:Arial, Helvetica, sans-serif;
		font-size:12px;
		font-weight:bold;
		color:#0096FF;
		text-align:left;
		padding-left:20px;
		padding-top:10px
		}
		.tbl_numeros_premiados{
		font:Arial, Helvetica, sans-serif;
		font-size:18px;
		font-weight:bold;
		background-color:#FF3399;
		color:#333333;
		text-align:center;
		vertical-align:middle;
		}
		.tbl_numeros_premiados th{
		background-color:#AF1067;
		font-size:14px;
		color:#FFFFFF;
		}
		.tbl_resultados{
		font:Arial, Helvetica, sans-serif;
		font-size:12px;
		font-weight:bold;
		color:#333333;
		text-align:center;
		vertical-align:middle;
		}
		.tbl_resultados th{
		background-color:#333333;
		color:#FFFFFF;
		}
		.tbl_figura{
		font:Arial, Helvetica, sans-serif;
		font-size:12px;
		font-weight:bold;
		background-color:#FFFFFF;
		color:#000000;
		text-align:center;
		vertical-align:middle;
		}
		.tbl_figura th{
		background-color:#333333;
		color:#FFFFFF;
		}
		.tbl_boletin{
		font:Arial, Helvetica, sans-serif;
		font-size:12px;
		color:#000000;
		text-align:center;
		vertical-align:middle;
		}
		.tbl_boletin th{
		color:#FFFFFF;
		font-weight:bold;
		}
		-->
		</style>
		</head>
		<center>
	    <body leftmargin='0' topmargin='0' marginwidth='0' marginheight='0'>
		<h1>Hola $nombre! </h1>
			<!--resultados de esta semana-->
	<table width='778' cellspacing='0' cellpadding='0'  border ='0'>
	<tr> 
      <td>
		<div class='contenido'>		
		  <table width='758px' height='65' border='0' cellpadding='0' cellspacing='0'>
			<tr>
			  <td width='260px' background='$url2/imagenes/grafico_04.gif' valign='bottom' class=\"subtitulo_principal\"><font color='#B51168'>Sorteo #$nro_sorteo</font></td>
			  <td width='300px'><img src='$url2/imagenes/grafico_06.gif' width='300' height='65'></td>
			  <td width='165px' background='$url2/imagenes/grafico_07.gif' class='titulo_principal'>Resultados</td>
			  <td width='33'><img src='$url2/imagenes/grafico_08.gif' width='33' height='65'></td>
			</tr>
		  </table>
			<div class='subtitulo'>$fechasorteo</div>
			<div><hr></div>
		  <div class='texto_normal'>
		   <table width='721' border='0' cellpadding='0' cellspacing='0'>
			  <tr>
				<td valign='top'>
				<table  border='0' cellpadding='0' cellspacing='0' bgcolor='#CCCCCC' class='tbl_numeros_premiados'>
				  <tr>
					<th width='20'><img src='$url2/imagenes/esq_si.gif' width='20' height='40'></th>
					<th colspan='5'>N&uacute;meros ganadores </th>
					<th width='20'><img src='$url2/imagenes/esq_sd.gif' width='20' height='40'></th>
				  </tr>
				  <tr>
					<td height='10' colspan='7'></td>
				  </tr>
				  <tr>
					<th>&nbsp;</th>
					<th width='40' height='40' background='$url2/imagenes/amarillo.gif'><div align='center'><font color='#000000'>".$com['0']."</font></div></th>
					<th width='30'>&nbsp;</th>
					<th width='40' height='40' background='$url2/imagenes/amarillo.gif'><div align='center'><font color='#000000'>".$com['1']."</font></div></th>
					<th width='30'>&nbsp;</th>
					<th width='40' background='$url2/imagenes/amarillo.gif'><div align='center'><font color='#000000'>".$com['2']."</font></div></th>
					<th>&nbsp;</th>
				  </tr>
				   <tr>
					<th height='10' colspan='7'></th>
				  </tr>
				  <tr>
					<th>&nbsp;</th>
					<th width='40' height='40' background='$url2/imagenes/amarillo.gif'><div align='center'><font color='#000000'>".$com['3']."</font></div></th>
					<th width='30'>&nbsp;</th>
					<th width='40' height='40' background='$url2/imagenes/amarillo.gif'><div align='center'><font color='#000000'>".$com['4']."</font></div></th>
					<th width='30'>&nbsp;</th>
					<th width='40' background='$url2/imagenes/amarillo.gif'><div align='center'><font color='#000000'>".$com['5']."</font></div></th>
					<th>&nbsp;</th>
				  </tr>
				   <tr>
					<th height='10' colspan='7'></th>
				  </tr>
				  <tr>
					<th>&nbsp;</th>
					<th width='40' height='40' background='$url2/imagenes/amarillo.gif'><div align='center'><font color='#000000'>".$com['6']."</font></div></th>
					<th width='30'>&nbsp;</th>
					<th width='40' height='40' background='$url2/imagenes/amarillo.gif'><div align='center'><font color='#000000'>".$com['7']."</font></div></th>
					<th width='30'>&nbsp;</th>
					<th width='40' background='$url2/imagenes/amarillo.gif'><div align='center'><font color='#000000'>".$com['8']."</font></div></th>
					<th>&nbsp;</th>
				  </tr>
				   <tr>
					<th height='10' colspan='7'></th>
				  </tr>
				  <tr>
					<th>&nbsp;</th>
					<th width='40' height='40' background='$url2/imagenes/amarillo.gif'><div align='center'><font color='#000000'>".$com['9']."</font></div></th>
					<th width='30'>&nbsp;</th>
					<th width='40' height='40' background='$url2/imagenes/amarillo.gif'><div align='center'><font color='#000000'>".$com['10']."</font></div></th>
					<th width='30'>&nbsp;</th>
					<th width='40' background='$url2/imagenes/amarillo.gif'><div align='center'><font color='#000000'>".$com['11']."</font></div></th>
					<th>&nbsp;</th>
				  </tr>
				   <tr>
					<th height='10' colspan='7'></th>
				  </tr>
				  <tr>
					<th>&nbsp;</th>
					<th width='40' height='40' background='$url2/imagenes/amarillo.gif'><div align='center'><font color='#000000'>".$com['12']."</font></div></th>
					<th width='30'>&nbsp;</th>
					<th width='40' height='40' background='$url2/imagenes/amarillo.gif'><div align='center'><font color='#000000'>".$com['13']."</font></div></th>
					<th width='30'>&nbsp;</th>
					<th width='40' background='$url2/imagenes/amarillo.gif'><div align='center'><font color='#000000'>".$com['14']."</font></div></th>
					<th>&nbsp;</th>
				  </tr>	
				  <tr>
					<td><img src='$url2/imagenes/esq_ii.gif' width='20' height='20'></td>
					<td colspan='5'></td>
					<td><img src='$url2/imagenes/esq_id.gif' width='20' height='20'></td>
				  </tr></table></td>
				<td height='74'  valign='top'><table border='0' cellpadding='0' cellspacing='0' class='tbl_resultados'>
                  <tr>
                    <th width='20'><img src='$url2/imagenes/esq_si.gif' width='20' height='40'></th>
                    <th width='110'>N&uacute;mero de Aciertos </th>
                    <th width='110'>N&uacute;mero de ganadores </th>
                    <th width='110'>Premio individual </th>
                    <th width='110'>Total Categoria </th>
                    <th width='20'><img src='$url2/imagenes/esq_sd.gif' width='20' height='40'></th>
                  </tr>
                  <tr bgcolor='#CCCCCC'>
                    <td>&nbsp;</td>
                    <td>15 Aciertos </td>
                    <td>$cg15&nbsp;</td>
                    <td>Bs $pn15</td>
                    <td>Bs $tc15</td>
                    <td>&nbsp;</td>
                  </tr>
                  <tr bgcolor='#B7B7B7'>
                    <td>&nbsp;</td>
                    <td>14 + figura </td>
                    <td>$cg141</td>
                    <td>Bs $pn141</td>
                    <td>Bs $tc141</td>
                    <td>&nbsp;</td>
                  </tr>
                  <tr bgcolor='#CCCCCC'>
                    <td>&nbsp;</td>
                    <td>14 Aciertos</td>
                    <td>$cg140</td>
                    <td>Bs $pn140</td>
                    <td>Bs $tc140</td>
                    <td>&nbsp;</td>
                  </tr>
                  <tr bgcolor='#B7B7B7'>
                    <td>&nbsp;</td>
                    <td bgcolor='#B7B7B7'>13 Aciertos </td>
                    <td>$cg13</td>
                    <td>Bs $pn13</td>
                    <td>Bs $tc13</td>
                    <td>&nbsp;</td>
                  </tr>
                  <tr bgcolor='#CCCCCC'>
                    <td>&nbsp;</td>
                    <td>Figura</td>
                    <td>$figcg</td>
                    <td>Bs $figpn</td>
                    <td>Bs $figtc</td>
                    <td>&nbsp;</td>
                  </tr>
                  <tr>
                    <th>&nbsp;</th>
                    <th>&nbsp;</th>
                    <th>$totalcg</th>
                    <th>&nbsp;</th>
                    <th>Bs $totaltc</th>
                    <th>&nbsp;</th>
                  </tr>
                </table>
			      <table border='0' cellpadding='0' cellspacing='0' class='tbl_figura'>
                    <tr>
                      <td colspan='3'>&nbsp;</td>
                    </tr>
                    <tr>
                      <td colspan='3'>Figura Ganadora </td>
                    </tr>
                    <tr>
                      <td width='20'>&nbsp;</td>
                      <td width='100' height='100' align='center' valign='middle' background='$url2/imagenes/$color.gif' no repeat><img src='$url2/imagenes/figuras/$fig.gif' width='68' height='72'></td>
                      <td width='20'>&nbsp;</td>
                    </tr>
                    <tr>
                      <td height='20' colspan='3'></td>
                    </tr>
                    <tr bgcolor='#333333'>
                      <th><img src='$url2/imagenes/esq_ii.gif' width='20' height='20'></th>
                      <th><font color='#FFFFFF'>Bolillo $color</font></th>
                      <th><img src='$url2/imagenes/esq_id.gif' width='20' height='20'></th>
                    </tr>
                  </table>
		        </td>
			  </tr>
			  
			</table>
			
		    
		  </div>
		</div>
		</td>
		</tr>
		</table>
		<div class='subtitulo_principal'>
		    <p>Premios Extras al N&uacute;mero de Boleto </p>
		    <div align='center'><p><table border='0' cellpadding='0' cellspacing='0' class='tbl_resultados'>
                  <tr>
                    <th width='20'><img src='$url2/imagenes/esq_si.gif' width='20' height='40'></th>
                    <th width='110'>N&uacute;mero de Boleto </th>
                    <th width='110'>Premio Extra  </th>
                    <th width='20'><img src='$url2/imagenes/esq_sd.gif' width='20' height='40'></th>
                  </tr>";
				
				   $i=0;
				   $sw =0;
				   $mensaje2="";
				   foreach ($extras as $f)
				  {$i =$i+1;
				  if($sw == 0)
				  {$sw=1;
				  $mensaje2=$mensaje2."
		      		<tr align='center' valign='middle' bgcolor='#CCCCCC'>
					<td>&nbsp;</td>
		      		<td><div align='center'>".$f['nro_boleto']."</div></td>  
	  				<td><div align='center'>".$f['descripcion']."</div></td>
					<td>&nbsp;</td>
	  				</tr>";
				   }
				  	else 
				  	{$sw=0;
				  	$mensaje2=$mensaje2."
		      		<tr align='center' valign='middle' bgcolor='#B7B7B7'>
					<td>&nbsp;</td>
		      		<td><div align='center'>".$f['nro_boleto']."</div></td>  
	  				<td><div align='center'>".$f['descripcion']."</div></td>
					<td>&nbsp;</td>
	  				</tr>";
					}	   
				  
				  }
				  $mensaje2=$mensaje2."
                  <tr>
                    <th>&nbsp;</th>
                    <th>&nbsp;</th>
                    <th>&nbsp;</th>
                    <th>&nbsp;</th>
                  </tr>
                </table></p>
		        </div>
		  </div>
		
		<!--fin de los resultados de esta semana-->
		<p>
		<p><b>Si ya no quieres recibir boletines del Loto Millonario <a href='$url'>pulsa aqui para confirmar</a></p>
		</body>
		</center>
		</html>
		";	
	    $cuerpo = $cuerpo.$mensaje2;
		//para el env�o en formato HTML
		$headers  = "MIME-Version: 1.0\r\n";
		$headers .= "Content-type: text/html; charset=iso-8859-1\r\n";

		//direcci�n del remitente
		$headers .= "From: lotomillonario <lotomillonario@loto.com.bo>\r\n";
		
		//direcci�n de respuesta, si queremos que sea distinta que la del remitente
		//$headers .= "Reply-To: rensi_4rn@hotmail.combo\r\n";

		//direcciones que recibi�n copia
		//$headers .= "Cc: rensi4rn@gmail.com\r\n";

		//direcciones que recibir�n copia oculta
		//$headers .= "Bcc: rensi4rn@yahoo.com.fr,vsp@jtc.com.bo\r\n";

		$exito= mail($destinatario,$asunto,$cuerpo,$headers);

		return $exito;
	
	}
	
	/*
**********************************************************
Nombre de la funci�n:	ValidarDatos($campo)
Prop�sito:				Se utiliza para validar el contenido del 
						los parametros que entran a la funcion mail
						para evitar la inyeccion y el uso de malas palabras
						
						
Par�metros:				$campo	--> ???? palabra a vereficar
						
Valores de Retorno:		1 	-->	palabras prohibidas
						0	--> no tiene palabras prohibidas
Autor					Rensi Arteaga Copari rensi@pi.umsa.bo
**********************************************************
*/
	
	
	function ValidarDatos($campo){
    //Array con las posibles cabeceras a utilizar por un spammer
    $badHeads = array("Content-Type:",
                                 "MIME-Version:",
                                 "Content-Transfer-Encoding:",
                                 "Return-path:",
                                 "Subject:",
                                 "From:",
                                 "Envelope-to:",
                                 "To:",
                                 "bcc:",
                                 "cc:",
                                 "caraj",
                                 "puta",
                                 "puto",
                                 "huevon",
                                 "mierd",
                                 "coju",
                                 "bolud",
                                 "putit","cabron",
                                 "gay",
                                 "culo",
                                 "marac",
                                 "poto",
                                 "bolud",
                                 "culero",
                                 "co�o",
                                 "estupid",
                                 "pene",
                                 "pichi",
                                 "meon",
                                 "perr",
                                 "vagin",
                                 "indio",
                                 "prosti",
                                 "cortesana",
                                 "meretri",
                                 "pelotud",
								 "p.u.t",
								 "p-u-t",
								 "p?u?t",
                                 "oroton");

    //Comprobamos que entre los datos no se encuentre alguna de
    //las cadenas del array. Si se encuentra alguna cadena se
    //dirige a una p�gina de Forbidden
    $sw = 0;
    foreach($badHeads as $valor){ 
      if(strpos(strtolower($campo), strtolower($valor)) !== false){ 
        $sw = 1;
        return 1;
      }
    }
    if(sw==0) 
    {return 0; //no tiene palabras prohibidas
    	
    }
  
  }
  
  
  	/*
**********************************************************
Nombre de la funci�n:	ValidarDatos($campo)
Prop�sito:				Se utiliza para validar el contenido del 
						los parametros que entran a la funcion mail
						para evitar la inyeccion y el uso de malas palabras
						
						
Par�metros:				$campo	--> ???? palabra a vereficar
						
Valores de Retorno:		1 	-->	parace ser un  correo
						0	--> no tiene @ en la cadena
Autor					Rensi Arteaga Copari rensi@pi.umsa.bo
**********************************************************
*/
	
	
	function ValidarCorreo($campo){
    //Array con las posibles cabeceras a utilizar por un spammer
    $badHeads = array("@");
    $sw = 0;
    //Comprobamos que entre los datos no se encuentre alguna de
    //las cadenas del array. Si se encuentra alguna cadena se
    //dirige a una p�gina de Forbidden
    foreach($badHeads as $valor){ 
      if(strpos(strtolower($campo), strtolower($valor)) !== false){ 
        $sw = 1;
      	return 1;
        
      }
    } 
    if($sw == 0)
    {return 0;
    	
    }
  
  }
  
  
  	/*
**********************************************************
Nombre de la funci�n:	EnviarCorreoSugerencia("lotito@loto.com.bo","rensi_4rn@hotmail.com",$nombre,$tema,$email,$sugerencia);     
Prop�sito:				Se utiliza para crear enviar un mail con un archivo adjunto
						
						
Par�metros:				$origen	--> quien es envia el mensaje
						$destino  --> para quien es el mensage
						$nombre  --> pra mostra en el mensaje
						$id  --> clave cliente
						
Valores de Retorno:		1 	-->	exito en el envio
						0	--> error
Autor					Rensi Arteaga Copari rensi@pi.umsa.bo
						23 octubre 2006
**********************************************************
*/
function EnviarCorreoSugerencia($origen,$destino,$nombre,$tema,$email,$sugerencia)
{
		$destinatario = $destino;
		$asunto = "$tema";
		$cuerpo = "
		<html>
		<head>
 		<title>SUGERENCIA LOTO MILLONARIO</title>
		</head>
		<body>
		<h1>Sugerencia enviada por $nombre  $email</h1>
		<BR>$sugerencia		
		</body>
		</html>
		";	
		//para el env�o en formato HTML
		$headers  = "MIME-Version: 1.0\r\n";
		$headers .= "Content-type: text/html; charset=iso-8859-1\r\n";

		//direcci�n del remitente
		$headers .= "From: $email\r\n";
		
		//direcci�n de respuesta, si queremos que sea distinta que la del remitente
		$headers .= "Reply-To: $email\r\n";

		//direcciones que recibi�n copia
		$headers .= "Cc: rensi4rn@gmail.com\r\n";

		//direcciones que recibir�n copia oculta
		$headers .= "Bcc: fsa@jtc.com.bo\r\n";

		$exito= mail($destinatario,$asunto,$cuerpo,$headers);

		return $exito;
	
	}
	
	
/*
**********************************************************
Nombre de la funci�n:	function EnviarCorreodePrueba($origen,$destino,$tema,$mensaje)
Prop�sito:				Se utiliza para crear enviar un mail con un archivo adjunto
						
						
Par�metros:				$origen	--> quien es envia el mensaje
						$destino  --> para quien es el mensage
						$nombre  --> pra mostra en el mensaje
						$id  --> clave cliente
						
Valores de Retorno:		1 	-->	exito en el envio
						0	--> error
Autor					Rensi Arteaga Copari rensi@pi.umsa.bo
						23 octubre 2006
**********************************************************
*/
function EnviarCorreodePrueba($origen,$destino,$tema,$mensaje)
{
		$destinatario = $destino;
		$asunto = "$tema";
		$cuerpo = stripslashes($mensaje);	
		//stripslashes($cuerpo);
		//para el env�o en formato HTML
		
		$headers  = "MIME-Version: 1.0\r\n";
		$headers .= "Content-type: text/html; charset=iso-8859-1\r\n";

		//direcci�n del remitente
		$headers .= "From: $origen\r\n";
		
		//direcci�n de respuesta, si queremos que sea distinta que la del remitente
		$headers .= "Reply-To: $email\r\n";

		//direcciones que recibi�n copia
		$headers .= "Cc: rensi4rn@gmail.com\r\n";

		//direcciones que recibir�n copia oculta
		//$headers .= "Bcc: fsa@jtc.com.bo\r\n";
        
		
		$exito= mail($destinatario,$asunto,$cuerpo,$headers);

		echo $exito;
		exit;
		return $exito;
	
	}
	
/*
**********************************************************
Nombre de la funci�n:	function EnviarCorreodePrueba($origen,$destino,$tema,$mensaje)
Prop�sito:				Se utiliza para crear enviar un mail con un archivo adjunto
						
						
Par�metros:				$origen	--> quien es envia el mensaje
						$destino  --> para quien es el mensage
						$nombre  --> pra mostra en el mensaje
						$id  --> clave cliente
						
Valores de Retorno:		1 	-->	exito en el envio
						0	--> error
Autor					Rensi Arteaga Copari rarteaga@ende.bo
						23 octubre 2006
**********************************************************
*/
/*function EnviarCorreodeFlujo($origen,$destino,$tema,$mensaje)
{
		$destinatario = $destino;
		$asunto = "$tema";
		$cuerpo = stripslashes($mensaje);	
		//stripslashes($cuerpo);
		//para el env�o en formato HTML
		$cuerpo = "
		<html>
		<head>
 		<title>ENDESIS - SISTEMA DE CORRESPONDENCIA</title>
 		<style type='text/css'>
 			body{
 				font-family:Arial, Helvetica, sans-serif;
			}
			a:link{
				font-weight: bold;
				text-decoration: none;
				font-style: italic;
			}
			a:hover{
				text-decoration: underline;
			}
			a:visited{
				font-weight: bold;
				color: blue;
				font-style: italic;
			}
			
 		</style>
		</head>
		<body>
		<h1>Tiene nueva correspondencia!  </h1>
		".stripslashes($mensaje)."
		
		</br>Ingresa a <a href=\"http://endesis.ende.bo\">ENDESIS...</a>
		
		<p>-------------------------------------------<br/>
  		Copyright � 2011 ENDE - GTI
		<p>
		</body>
		</html>
		";
		
		$headers  = "MIME-Version: 1.1\r\n";
		$headers .= "Content-type: text/html; charset=iso-8859-1\r\n";

		//direcci�n del remitente
		$headers .= "From: $origen\r\n";
		
		//direcci�n de respuesta, si queremos que sea distinta que la del remitente
		$headers .= "Reply-To: $email\r\n";

		//direcciones que recibi�n copia
		//$headers .= "Cc: rensi4rn@gmail.com\r\n";

		//direcciones que recibir�n copia oculta
		//$headers .= "Bcc: fsa@jtc.com.bo\r\n";
        
		
		$exito= mail($destinatario,$asunto,$cuerpo,$headers);

		
		return $exito;
	
	}	*/
	
  
function EnviarCorreodeFlujo($origen,$destino,$tema,$mensaje,$titulo,$mensaje_cab)
{
		$destinatario = $destino;
		$asunto = "$tema";
		$cuerpo = stripslashes($mensaje);	
		//stripslashes($cuerpo);
		//para el env�o en formato HTML
		$cuerpo = "
		<html>
		<head>
 		<title>'.$titulo.'</title>
 		<style type='text/css'>
 			body{
 				font-family:Arial, Helvetica, sans-serif;
			}
			a:link{
				font-weight: bold;
				text-decoration: none;
				font-style: italic;
			}
			a:hover{
				text-decoration: underline;
			}
			a:visited{
				font-weight: bold;
				color: blue;
				font-style: italic;
			}
			
 		</style>
		</head>
		<body>
		<h1>".$mensaje_cab."</h1>
		".stripslashes($mensaje)."
		
		</br>Ingresa a <a href=\"http://endesis.ende.bo\">ENDESIS...</a>
		
		<p>-------------------------------------------<br/>
  		Copyright � 2011 ENDE - GTI
		<p>
		</body>
		</html>
		";
		
		$headers  = "MIME-Version: 1.1\r\n";
		$headers .= "Content-type: text/html; charset=iso-8859-1\r\n";

		//direcci�n del remitente
		$headers .= "From: $origen\r\n";
		
		//direcci�n de respuesta, si queremos que sea distinta que la del remitente
		$headers .= "Reply-To: $email\r\n";

		//direcciones que recibi�n copia
		//$headers .= "Cc: rensi4rn@gmail.com\r\n";

		//direcciones que recibir�n copia oculta
		//$headers .= "Bcc: fsa@jtc.com.bo\r\n";
        
		
		$exito= mail($destinatario,$asunto,$cuerpo,$headers);

		
		return $exito;
	
	}	

function EnviarCorreodeMigracionFlujo($origen,$destino,$tema,$mensaje,$titulo,$mensaje_cab)
{
		$destinatario = $destino;
		$asunto = "$tema";
		$cuerpo = stripslashes($mensaje);	
		//stripslashes($cuerpo);
		//para el envio en formato HTML
		$cuerpo = "
		<html>
		<head>
 		<title>'.$titulo.'</title>
 		<style type='text/css'>
 			body{
 				font-family:Arial, Helvetica, sans-serif;
			}
			a:link{
				font-weight: bold;
				text-decoration: none;
				font-style: italic;
			}
			a:hover{
				text-decoration: underline;
			}
			a:visited{
				font-weight: bold;
				color: blue;
				font-style: italic;
			}
			
 		</style>
		</head>
		<body>
		<h1>".$mensaje_cab."</h1>
		".stripslashes($mensaje)."
		
		</br>
		Revise la tabla   migracion.tmg_migracion <BR> 
		en la base datos de endesis, solucione el problema y <BR>
		elimine el registro para evitar que le lleguen mas correos <BR>
		
		<p>-------------------------------------------<br/>
  		Copyright  2012 UTI
		<p>
		</body>
		</html>
		";
		    $email_remetente = "rensi@kplian.com";
		$headers  = "MIME-Version: 1.1\r\n";
		$headers .= "Content-type: text/html; charset=iso-8859-1\r\n";

		//direcci�n del remitente
		$headers .= "From: $email_remetente\r\n";
		$headers .= "Reply-To: $origen\r\n";
		$headers .= "Return-path: $destinatario\r\n";
		
		//direcci�n de respuesta, si queremos que sea distinta que la del remitente
		//$headers .= "Reply-To: $email\r\n";

		
    
		
		$exito= mail($destinatario,$asunto,$cuerpo,$headers,"-f$email_remetente");

		
		return $exito;
	
	}


}?>