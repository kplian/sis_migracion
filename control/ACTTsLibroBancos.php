<?php
/**
*@package pXP
*@file gen-ACTTsLibroBancos.php
*@author  (admin)
*@date 01-12-2013 09:10:17
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

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
				
	function insertarTsLibroBancos(){
		$this->objFunc=$this->create('MODTsLibroBancos');	
		if($this->objParam->insertar('id_libro_bancos')){
			$this->res=$this->objFunc->insertarTsLibroBancos($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarTsLibroBancos($this->objParam);
		}
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
		
		$idSolicitud = $this->objParam->getParametro('id_solicitud');
		$id_proceso_wf= $this->objParam->getParametro('id_proceso_wf');
		$estado = $this->objParam->getParametro('estado');
		
		$nombreArchivo= 'HTMLReporteCheque.php';
		
		header("location: HTMLReporteCheque.php");
		
		if(!$create_file){
					$mensajeExito = new Mensaje();
					$mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
													'Se generó con éxito el reporte: '.$nombreArchivo,'control');
					$mensajeExito->setArchivoGenerado($nombreArchivo);
					$this->res = $mensajeExito;
					$this->res->imprimirRespuesta($this->res->generarJson());
		}
		else{
					
			return dirname(__FILE__).'/../../reportes_generados/'.$nombreArchivo;  
			
		}
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
			
}

?>