<?php
/**
*@package pXP
*@file gen-MODTsLibroBancos.php
*@author  (admin)
*@date 01-12-2013 09:10:17
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODTsLibroBancos extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarTsLibroBancos(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='migra.ft_ts_libro_bancos_sel';
		$this->transaccion='MIG_LBAN_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_libro_bancos','int4');
		$this->captura('id_cuenta_bancaria','int4');
		$this->captura('fecha','date');
		$this->captura('a_favor','varchar');
		$this->captura('nro_cheque','int4');
		$this->captura('importe_deposito','numeric');
		$this->captura('nro_liquidacion','varchar');
		$this->captura('detalle','text');
		$this->captura('origen','varchar');
		$this->captura('observaciones','text');
		$this->captura('importe_cheque','numeric');
		$this->captura('id_libro_bancos_fk','int4');
		$this->captura('estado','varchar');
		$this->captura('nro_comprobante','varchar');
		$this->captura('indice','numeric');
		$this->captura('estado_reg','varchar');
		$this->captura('tipo','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarTsLibroBancos(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='migra.ft_ts_libro_bancos_ime';
		$this->transaccion='MIG_LBAN_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cuenta_bancaria','id_cuenta_bancaria','int4');
		$this->setParametro('fecha','fecha','date');
		$this->setParametro('a_favor','a_favor','varchar');
		$this->setParametro('nro_cheque','nro_cheque','int4');
		$this->setParametro('importe_deposito','importe_deposito','numeric');
		$this->setParametro('nro_liquidacion','nro_liquidacion','varchar');
		$this->setParametro('detalle','detalle','text');
		$this->setParametro('origen','origen','varchar');
		$this->setParametro('observaciones','observaciones','text');
		$this->setParametro('importe_cheque','importe_cheque','numeric');
		$this->setParametro('id_libro_bancos_fk','id_libro_bancos_fk','int4');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('nro_comprobante','nro_comprobante','varchar');
		$this->setParametro('indice','indice','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('tipo','tipo','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarTsLibroBancos(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='migra.ft_ts_libro_bancos_ime';
		$this->transaccion='MIG_LBAN_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_libro_bancos','id_libro_bancos','int4');
		$this->setParametro('id_cuenta_bancaria','id_cuenta_bancaria','int4');
		$this->setParametro('fecha','fecha','date');
		$this->setParametro('a_favor','a_favor','varchar');
		$this->setParametro('nro_cheque','nro_cheque','int4');
		$this->setParametro('importe_deposito','importe_deposito','numeric');
		$this->setParametro('nro_liquidacion','nro_liquidacion','varchar');
		$this->setParametro('detalle','detalle','text');
		$this->setParametro('origen','origen','varchar');
		$this->setParametro('observaciones','observaciones','text');
		$this->setParametro('importe_cheque','importe_cheque','numeric');
		$this->setParametro('id_libro_bancos_fk','id_libro_bancos_fk','int4');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('nro_comprobante','nro_comprobante','varchar');
		$this->setParametro('indice','indice','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('tipo','tipo','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarTsLibroBancos(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='migra.ft_ts_libro_bancos_ime';
		$this->transaccion='MIG_LBAN_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_libro_bancos','id_libro_bancos','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>