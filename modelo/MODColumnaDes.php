<?php
/**
*@package pXP
*@file gen-MODColumnaDes.php
*@author  (admin)
*@date 16-01-2013 14:09:24
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODColumnaDes extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarColumnaDes(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='migra.f_columna_des_sel';
		$this->transaccion='MIG_COLD_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_columna_des','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_tabla_mig','int4');
		$this->captura('tipo_dato','varchar');
		$this->captura('id_columna_ori','int4');
		$this->captura('columna','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_columna_ori','varchar');
		$this->captura('checks','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarColumnaDes(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='migra.f_columna_des_ime';
		$this->transaccion='MIG_COLD_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_tabla_mig','id_tabla_mig','int4');
		$this->setParametro('tipo_dato','tipo_dato','varchar');
		$this->setParametro('id_columna_ori','id_columna_ori','int4');
		$this->setParametro('columna','columna','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarColumnaDes(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='migra.f_columna_des_ime';
		$this->transaccion='MIG_COLD_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_columna_des','id_columna_des','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_tabla_mig','id_tabla_mig','int4');
		$this->setParametro('tipo_dato','tipo_dato','varchar');
		$this->setParametro('id_columna_ori','id_columna_ori','int4');
		$this->setParametro('columna','columna','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarColumnaDes(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='migra.f_columna_des_ime';
		$this->transaccion='MIG_COLD_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_columna_des','id_columna_des','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>