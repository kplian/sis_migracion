<?php
/**
*@package pXP
*@file gen-MODColumnaOri.php
*@author  (admin)
*@date 16-01-2013 14:09:32
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODColumnaOri extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarColumnaOri(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='migra.f_columna_ori_sel';
		$this->transaccion='MIG_COLO_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_columna_ori','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('tipo_dato','varchar');
		$this->captura('columna','varchar');
		$this->captura('id_tabla_mig','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('checks','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		//echo $this->getConsulta();
		$this->ejecutarConsulta();
		
		$this->getConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarColumnaOri(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='migra.f_columna_ori_ime';
		$this->transaccion='MIG_COLO_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('tipo_dato','tipo_dato','varchar');
		$this->setParametro('columna','columna','varchar');
		$this->setParametro('id_tabla_mig','id_tabla_mig','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarColumnaOri(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='migra.f_columna_ori_ime';
		$this->transaccion='MIG_COLO_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_columna_ori','id_columna_ori','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('tipo_dato','tipo_dato','varchar');
		$this->setParametro('columna','columna','varchar');
		$this->setParametro('id_tabla_mig','id_tabla_mig','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarColumnaOri(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='migra.f_columna_ori_ime';
		$this->transaccion='MIG_COLO_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_columna_ori','id_columna_ori','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>