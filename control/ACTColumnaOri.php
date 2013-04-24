<?php
/**
*@package pXP
*@file gen-ACTColumnaOri.php
*@author  (admin)
*@date 16-01-2013 14:09:32
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTColumnaOri extends ACTbase{    
			
	function listarColumnaOri(){
		$this->objParam->defecto('ordenacion','id_columna_ori');
        if($this->objParam->getParametro('id_tabla_mig')!=''){
	    	$this->objParam->addFiltro("colo.id_tabla_mig = ".$this->objParam->getParametro('id_tabla_mig'));	
		}
		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODColumnaOri','listarColumnaOri');
		} else{
			$this->objFunc=$this->create('MODColumnaOri');
			
			$this->res=$this->objFunc->listarColumnaOri($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarColumnaOri(){
		$this->objFunc=$this->create('MODColumnaOri');	
		if($this->objParam->insertar('id_columna_ori')){
			$this->res=$this->objFunc->insertarColumnaOri($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarColumnaOri($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarColumnaOri(){
			$this->objFunc=$this->create('MODColumnaOri');	
		$this->res=$this->objFunc->eliminarColumnaOri($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>