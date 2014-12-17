<?php
/**
*@package pXP
*@file gen-ACTTsLibroBancos.php
*@author  (admin)
*@date 01-12-2013 09:10:17
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/
include_once(dirname(__FILE__).'/../../lib/lib_general/funciones.inc.php');
require_once(dirname(__FILE__).'/../../pxp/pxpReport/ReportWriter.php');
require_once(dirname(__FILE__).'/../../sis_tesoreria/reportes/RLibroBancos.php');
require_once(dirname(__FILE__).'/../../pxp/pxpReport/DataSource.php');


class ACTTsLibroBancos extends ACTbase{    
			
	function listarTsLibroBancos(){
		$this->objParam->defecto('ordenacion','id_libro_bancos');
		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_cuenta_bancaria')!=''){
			$this->objParam->addFiltro("id_cuenta_bancaria = ".$this->objParam->getParametro('id_cuenta_bancaria'));	
		}
		
		if($this->objParam->getParametro('mycls')=='TsLibroBancosDeposito'){
			$this->objParam->addFiltro("id_libro_bancos_fk is null");	
			$this->objParam->addFiltro("tipo=''deposito''");
		}
		if($this->objParam->getParametro('mycls')=='TsLibroBancosCheque'){
			$this->objParam->addFiltro("id_libro_bancos_fk = ".$this->objParam->getParametro('id_libro_bancos'));
			$this->objParam->addFiltro("tipo in (''cheque'',''debito_automatico'',''transferencia_carta'')");
		}
		if($this->objParam->getParametro('mycls')=='TsLibroBancosDepositoExtra'){
			$this->objParam->addFiltro("id_libro_bancos_fk = ".$this->objParam->getParametro('id_libro_bancos'));
			$this->objParam->addFiltro("tipo=''deposito''");
		}
		
		if($this->objParam->getParametro('m_nro_cheque')!=''){
			$this->objParam->addFiltro("nro_cheque= (Select max (lb.nro_cheque)
													From tes.tts_libro_bancos lb 
													Where lb.id_cuenta_bancaria=".$this->objParam->getParametro('m_id_cuenta_bancaria').") ");	
		}		
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODTsLibroBancos','listarTsLibroBancos');
		} else{
			$this->objFunc=$this->create('MODTsLibroBancos');
			
			$this->res=$this->objFunc->listarTsLibroBancos($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function listarTsLibroBancosDepositosConSaldo(){
		$this->objParam->defecto('ordenacion','fecha');
		$this->objParam->defecto('dir_ordenacion','desc');
		
		$this->objFunc=$this->create('MODTsLibroBancos');
		$this->res=$this->objFunc->listarTsLibroBancosDepositosConSaldo($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarTsLibroBancos(){
		$this->objFunc=$this->create('MODTsLibroBancos');	
		if($this->objParam->insertar('id_libro_bancos')){
			$this->res=$this->objFunc->insertarTsLibroBancos($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarTsLibroBancos($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function anteriorEstadoLibroBancos(){
        $this->objFunc=$this->create('MODTsLibroBancos');  
        $this->res=$this->objFunc->anteriorEstadoLibroBancos($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
	
	function siguienteEstadoLibroBancos(){
		$this->objFunc=$this->create('MODTsLibroBancos');
		$this->res=$this->objFunc->siguienteEstadoLibroBancos($this->objParam);					
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function eliminarTsLibroBancos(){
			$this->objFunc=$this->create('MODTsLibroBancos');	
		$this->res=$this->objFunc->eliminarTsLibroBancos($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function imprimirCheque(){
		
		$fecha_cheque_literal = $this->objParam->getParametro('fecha_cheque_literal');
		$importe_cheque =$this->objParam->getParametro('importe_cheque');;	
		$a_favor = $this->objParam->getParametro('a_favor');
		$nombre_lugar = 'Cochabamba';
		
		$fichero= 'HTMLReporteCheque.php';
		$fichero_salida = dirname(__FILE__).'/../../reportes_generados/'.$fichero;
		
		$fp=fopen($fichero_salida,w);
		
		$funciones = new funciones();
		
		$contenido = "<body onLoad='window.print();'>";
		$contenido = $contenido. "<table border=0 style='line-height: 10px;'>";
		$contenido = $contenido. "<td colspan='10'; style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td colspan='26'; style='text-align: left; width:25px; font-size:8pt'>".$nombre_lugar.", ".$fecha_cheque_literal."</td><tr>";
		$contenido = $contenido. "<td colspan='28'; style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td colspan='3'; style='text-align: left; width:35px; font-size:8pt'>".number_format($importe_cheque,2)."</td><tr>";
		$contenido = $contenido. "<td colspan='33'; style='text-align: left; width:35px; font-size:8pt'></td><tr>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td colspan='31'; style='text-align: left; width:35px; font-size:8pt'>".$a_favor."</td><tr>";
		$contenido = $contenido. "<td colspan='33'; style='text-align: left; width:35px; font-size:8pt'></td><tr>";
		$contenido = $contenido. "<td colspan='33'; style='text-align: left; width:35px; font-size:8pt'></td><tr>";
		$contenido = $contenido. "<td colspan='33'; style='text-align: left; width:35px; font-size:8pt'></td><tr>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td colspan='31'; style='text-align: left; width:35px; font-size:8pt'>".$funciones->num2letrasCheque($importe_cheque).'-----'."</td><tr>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'></td>";
		$contenido = $contenido. "<td style='text-align: left; width:35px; font-size:8pt'></td><td style='text-align: left; width:35px; font-size:8pt'></td><tr>";
		$contenido = $contenido. '</body>';

		fwrite($fp, $contenido);
		fclose($fp);
			
		$mensajeExito = new Mensaje();
		$mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
										'Se generó con éxito el reporte: '.$fichero,'control');
		$mensajeExito->setArchivoGenerado($fichero);
		$this->res = $mensajeExito;
		$this->res->imprimirRespuesta($this->res->generarJson());
	  }
	
	function listarDepositosENDESIS(){
		$this->objParam->defecto('ordenacion','id_libro_bancos');
		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_cuenta_bancaria')!=''){
			$this->objParam->addFiltro("id_cuenta_bancaria = ".$this->objParam->getParametro('id_cuenta_bancaria'));	
		}
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODTsLibroBancos','listarDepositosENDESIS');
		} else{
			$this->objFunc=$this->create('MODTsLibroBancos');
			$this->res=$this->objFunc->listarDepositosENDESIS($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function reporteLibroBancos(){
		$dataSource = new DataSource();
		
		$nro_cuenta = $this->objParam->getParametro('nro_cuenta');
		$fecha_ini = $this->objParam->getParametro('fecha_ini');
		$fecha_fin = $this->objParam->getParametro('fecha_fin');
		$tipo = $this->objParam->getParametro('tipo');
		$estado = $this->objParam->getParametro('estado');
		$finalidad = $this->objParam->getParametro('finalidad');
		
		$this->objParam->addParametroConsulta('ordenacion','id_libro_bancos');
        $this->objParam->addParametroConsulta('dir_ordenacion','ASC');
        $this->objParam->addParametroConsulta('cantidad',1000);
        $this->objParam->addParametroConsulta('puntero',0);
		
		$dataSource->putParameter('nro_cuenta', $nro_cuenta);
		$dataSource->putParameter('fecha_ini', $fecha_ini);
		$dataSource->putParameter('fecha_fin', $fecha_fin);
		$dataSource->putParameter('tipo', $tipo);
		$dataSource->putParameter('estado', $estado);
		$dataSource->putParameter('finalidad', $finalidad);		
		
		$this->objFunc=$this->create('MODTsLibroBancos');
		$resultLibroBancos = $this->objFunc->reporteLibroBancos($this->objParam);
				
		if($resultLibroBancos->getTipo()=='EXITO'){
						
			$datosLibroBancos = $resultLibroBancos->getDatos();
			
			$dataSource->setDataSet($datosLibroBancos);    
			
			$nombreArchivo = 'LibroBancos.pdf';
			$reporte = new RLibroBancos();
			
			$reporte->setDataSource($dataSource);	
			$reportWriter = new ReportWriter($reporte, dirname(__FILE__).'/../../reportes_generados/'.$nombreArchivo);
			$reportWriter->writeReport(ReportWriter::PDF);
	
			$mensajeExito = new Mensaje();
			$mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
			'Se generó con éxito el reporte: '.$nombreArchivo,'control');
			$mensajeExito->setArchivoGenerado($nombreArchivo);
			$this->res = $mensajeExito;
			$this->res->imprimirRespuesta($this->res->generarJson());
		}
		else{			 
			 $resultLibroBancos->imprimirRespuesta($resultLibroBancos->generarJson());			
		}
	}
			
}

?>