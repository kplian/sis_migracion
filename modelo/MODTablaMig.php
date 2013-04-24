<?php
/**
*@package pXP
*@file gen-MODTablaMig.php
*@author  (admin)
*@date 14-01-2013 18:19:52
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODTablaMig extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarTablaMig(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='migra.f_tabla_mig_sel';
		$this->transaccion='MIG_TAM_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_tabla_mig','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('alias_des','varchar');
		$this->captura('id_subsistema_ori','int4');
		$this->captura('obs','varchar');
		$this->captura('id_subsistema_des','int4');
		$this->captura('alias_ori','varchar');
		$this->captura('tabla_ori','varchar');
		$this->captura('tabla_des','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_subsistema_des','varchar');
		$this->captura('codigo_sis_ori','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}

     function listarSubsistemaOri(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='migra.f_tabla_mig_ori_sel';
		$this->transaccion='MIG_SISORI_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		$this->setTipoRetorno('record');
		$this->setParametro('ip','ip','varchar');
		$this->setParametro('base','base','varchar');
		$this->setParametro('usuario','usuario','varchar');
		$this->setParametro('pass','pass','varchar');  
				
		//Definicion de la lista del resultado del query
		$this->captura('id_subsistema','int4');
		$this->captura('nombre_corto','varchar');
		$this->captura('nombre_largo','varchar');
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
	 
	 function listarTablaOri(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='migra.f_tabla_mig_ori_sel';// nombre procedimiento almacenado
		$this->transaccion='MIG_TABORI_SEL';//nombre de la transaccion
		$this->tipo_procedimiento='SEL';//tipo de transaccion
	    $this->setTipoRetorno('record');
		$this->setParametro('ip','ip','varchar');
		$this->setParametro('base','base','varchar');
		$this->setParametro('usuario','usuario','varchar');
		$this->setParametro('pass','pass','varchar');  
		//Definicion de la lista del resultado del query
	
		$this->captura('oid_esquema','integer');
		$this->captura('nombre_esquema','varchar');
		$this->captura('oid_tabla','integer');
		$this->captura('nombre','varchar');
				
		//Ejecuta la funcion
		$this->armarConsulta();
		/*echo $this->consulta;
		exit();*/
		$this->ejecutarConsulta();

		return $this->respuesta;
	}
    
			
	function insertarTablaMig(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='migra.f_tabla_mig_ime';
		$this->transaccion='MIG_TAM_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('alias_des','alias_des','varchar');
		$this->setParametro('id_subsistema_ori','id_subsistema_ori','int4');
		$this->setParametro('obs','obs','varchar');
		$this->setParametro('id_subsistema_des','id_subsistema_des','int4');
		$this->setParametro('alias_ori','alias_ori','varchar');
		$this->setParametro('tabla_ori','tabla_ori','varchar');
		$this->setParametro('tabla_des','tabla_des','varchar');
		$this->setParametro('codigo_sis_ori','codigo_sis_ori','varchar');
		//----------------dato apra conexion dblink---------------
		$this->setParametro('ip','ip','varchar');
		$this->setParametro('base','base','varchar');
		$this->setParametro('usuario','usuario','varchar');
		$this->setParametro('pass','pass','varchar');  

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarTablaMig(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='migra.f_tabla_mig_ime';
		$this->transaccion='MIG_TAM_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tabla_mig','id_tabla_mig','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('alias_des','alias_des','varchar');
		$this->setParametro('id_subsistema_ori','id_subsistema_ori','int4');
		$this->setParametro('obs','obs','varchar');
		$this->setParametro('id_subsistema_des','id_subsistema_des','int4');
		$this->setParametro('alias_ori','alias_ori','varchar');
		$this->setParametro('tabla_ori','tabla_ori','varchar');
		$this->setParametro('tabla_des','tabla_des','varchar');
		$this->setParametro('codigo_sis_ori','codigo_sis_ori','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarTablaMig(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='migra.f_tabla_mig_ime';
		$this->transaccion='MIG_TAM_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tabla_mig','id_tabla_mig','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>