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
			$this->objParam->addFiltro("id_cuenta_bancaria_pxp = ".$this->objParam->getParametro('id_cuenta_bancaria'));	
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
						
	function eliminarTsLibroBancos(){
			$this->objFunc=$this->create('MODTsLibroBancos');	
		$this->res=$this->objFunc->eliminarTsLibroBancos($this->objParam);
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
			
}

?>