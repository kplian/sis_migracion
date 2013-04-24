<?php
/**
*@package pXP
*@file gen-ACTColumnaDes.php
*@author  (admin)
*@date 16-01-2013 14:09:24
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTColumnaDes extends ACTbase{    
			
	function listarColumnaDes(){
		$this->objParam->defecto('ordenacion','id_columna_des');
		
		if($this->objParam->getParametro('id_tabla_mig')!=''){
	    	$this->objParam->addFiltro("cold.id_tabla_mig = ".$this->objParam->getParametro('id_tabla_mig'));	
		}

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODColumnaDes','listarColumnaDes');
		} else{
			$this->objFunc=$this->create('MODColumnaDes');
			
			$this->res=$this->objFunc->listarColumnaDes($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarColumnaDes(){
		$this->objFunc=$this->create('MODColumnaDes');	
		if($this->objParam->insertar('id_columna_des')){
			$this->res=$this->objFunc->insertarColumnaDes($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarColumnaDes($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarColumnaDes(){
			$this->objFunc=$this->create('MODColumnaDes');	
		$this->res=$this->objFunc->eliminarColumnaDes($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>