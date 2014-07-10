<?php
/**
*@package pXP
*@file gen-ACTTablaMig.php
*@author  (admin)
*@date 14-01-2013 18:19:52
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTTablaMig extends ACTbase{
	
	private $NameTablaOri;
	private $NameTablaDes;
	private $EsquemaOri;
	private $EsquemaDes;
	private $ruta;
	private $ColumnasOri;
	private $ColumnasDes;
	private $id_tabla_mig;
	   
			
	function listarTablaMig(){
		$this->objParam->defecto('ordenacion','id_tabla_mig');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODTablaMig','listarTablaMig');
		} else{
			$this->objFunc=$this->create('MODTablaMig');
			
			$this->res=$this->objFunc->listarTablaMig($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	function listarSubsistemaOri(){
		$this->objParam->defecto('ordenacion','id_subsistema');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODTablaMig','listarSubsistemaOri');
		} else{
			$this->objFunc=$this->create('MODTablaMig');
			
			$this->res=$this->objFunc->listarSubsistemaOri($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function listarTablaOri(){		
		if($this->objParam->getParametro('esquema')!=''){
			$this->objParam->addFiltro("n.nspname=''".strtolower($this->objParam->getParametro('esquema'))."''");
		}
		$this->objFunc=$this->create('MODTablaMig');		
		$this->res=$this->objFunc->listarTablaOri();
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarTablaMig(){
		$this->objFunc=$this->create('MODTablaMig');	
		if($this->objParam->insertar('id_tabla_mig')){
			$this->res=$this->objFunc->insertarTablaMig($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarTablaMig($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarTablaMig(){
			$this->objFunc=$this->create('MODTablaMig');	
		$this->res=$this->objFunc->eliminarTablaMig($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	
	function GenerarCodigoMig(){
		/////////////////////////////
		//Obtiene valores de las tablas
		////////////////////////////
		 $this->id_tabla_mig = $this->objParam->getParametro('id_tabla_mig');
		
		
		$this->objParam->addParametroConsulta('ordenacion','id_tabla_mig');
		$this->objParam->addParametroConsulta('dir_ordenacion','asc');
		$this->objParam->addParametroConsulta('puntero','0');
		$this->objParam->addParametroConsulta('cantidad','1');
		$this->objParam->addFiltro("id_tabla_mig=".$this->id_tabla_mig);
	    //obtener datos de las tablas origen y destino
		
		$this->objFunc=$this->create('MODTablaMig');
		$res=$this->objFunc->listarTablaMig($this->objParam);
		
		$arreglo=$res->getDatos();
		
		$this->iniciarVariables($arreglo[0]);
		
		
		///////////////////////////////////
		//Prepara consulta columnas origen
		///////////////////////////////////
		$this->objParam = new CTParametro('{}',null,null,null);
		$this->objParam->addParametroConsulta('ordenacion','checks desc, columna asc');
		$this->objParam->addParametroConsulta('dir_ordenacion','');
		$this->objParam->addParametroConsulta('puntero','0');
		$this->objParam->addParametroConsulta('cantidad','100');//  BUG  ----> OJO  UN ERROR NO CAPTURA EL PARAMETRO DE ESTE OBJETO SI NO DEL ANTERIOR  
		$this->objParam->addFiltro("colo.id_tabla_mig=".$this->id_tabla_mig);
		//Obtiene los datos de la columna
		$this->objFunc=$this->create('MODColumnaOri');
		$res=$this->objFunc->listarColumnaOri($this->objParam);
		
		//$res->imprimirRespuesta($res->generarJson());
		
		
		$this->ColumnasOri=$res->getDatos();
		
		///////////////////////////////////
		//Prepara consulta columnas destino
		///////////////////////////////////
		$this->objParam = new CTParametro('{}',null,null,null);
		$this->objParam->addParametroConsulta('ordenacion','checks desc, columna asc');
		$this->objParam->addParametroConsulta('dir_ordenacion','');
		$this->objParam->addParametroConsulta('puntero','0');
		$this->objParam->addParametroConsulta('cantidad','100');//  BUG  ----> OJO  UN ERROR NO CAPTURA EL PARAMETRO DE ESTE OBJETO SI NO DEL ANTERIOR  
		$this->objParam->addFiltro("cold.id_tabla_mig=".$this->id_tabla_mig);
		//Obtiene los datos de la columna
		$this->objFunc=$this->create('MODColumnaDes');
		$res=$this->objFunc->listarColumnaDes($this->objParam);
		
		//$res->imprimirRespuesta($res->generarJson());
		
		
		$this->ColumnasDes=$res->getDatos();
		
		//var_dump($this->ColumnasOri);
		$this->ruta = $this->crearDirectorio();
		
		//generar  triguer
		$this->generarTriguer($this->ruta);
		
		//generar funcion triguer
		$this->generarFuncionTriguer($this->ruta);
		
		//generar funcion de tranformacion origen
		$this->generarFuncionTransformacion($this->ruta);
		
		//generar funcion de insercion destino
		$this->generarFuncionInsercionDestino($this->ruta);
		
		//genera funcion de migracion inicial
		$this->generarFuncionDeMigracionInicial($this->ruta);
		
		
		//Respuesta
		echo "{success:true,resp:'Archivos generados', registros_ori:".sizeof($this->ColumnasOri).", registros_des:".sizeof($this->ColumnasDes)."}";
		exit;
	}
	
	private function generarTriguer($ruta){
				
		$texto_archivo=" 
		CREATE TRIGGER tr_".$this->NameTablaOri."
  		AFTER INSERT OR UPDATE OR DELETE 
  		ON ".$this->EsquemaOri.".".$this->NameTablaOri." FOR EACH ROW 
  		EXECUTE PROCEDURE migracion.f_tri_".$this->NameTablaOri."_".$this->NameTablaDes."();";
		//genera archivo fisicamente	
		$this->guardarArchivo($ruta."/tr_".$this->NameTablaOri."_".$this->NameTablaDes, $texto_archivo);	
		
	}
	
	private function generarFuncionTriguer($ruta){
				
		$texto_archivo="
		CREATE OR REPLACE FUNCTION migracion.f_tri_".$this->NameTablaOri."_".$this->NameTablaDes." ()
		RETURNS trigger AS
		\$BODY$\n\n".
		"DECLARE
		 
		g_registros record;
		v_consulta varchar;
		v_res_cone  varchar;
		v_cadena_cnx varchar;
		v_cadena_con varchar;
		resp boolean;
		
		BEGIN
		   IF(TG_OP = 'INSERT' or  TG_OP ='UPDATE' ) THEN
		   
			 v_consulta =  'SELECT migracion.f_trans_".$this->NameTablaOri."_".$this->NameTablaDes." (
                  '''||TG_OP::varchar||'''";
				  
			foreach ($this->ColumnasOri as $data){
			     if($data['tipo_dato']=='varchar'  ||$data['tipo_dato']=='text'||$data['tipo_dato']=='date'||$data['tipo_dato']=='timestamp'||$data['tipo_dato']=='time')
				{
					$texto_archivo=$texto_archivo.",'||COALESCE(''''||NEW.".$data['columna']."::varchar||'''','NULL')||'";
				}
		        //elseif($data['tipo_dato']=='int4'  ||$data['tipo_dato']=='integer'||$data['tipo_dato']=='numeric'||$data['tipo_dato']=='bigint')
				 else
				{
					$texto_archivo=$texto_archivo.",'||COALESCE(NEW.".$data['columna']."::varchar,'NULL')||'";
				}
			
			}	  
				  
							  
  $texto_archivo=$texto_archivo.") as res';				  
		  ELSE 
		      v_consulta =  ' SELECT migracion.f_trans_".$this->NameTablaOri."_".$this->NameTablaDes." (
		              '''||TG_OP::varchar||'''";
		              
		         foreach ($this->ColumnasOri as $data){
		         		if($data[checks]=='PK')
						{
							$texto_archivo=$texto_archivo.",'||OLD.".$data['columna']."||'";
							
						}
						else
						{
							$texto_archivo=$texto_archivo.",NULL";	
							
						}			
		         				
		         			
		         		
		         	
		         }     
		              
		       $texto_archivo=$texto_archivo.       ") as res';
		       
		   END IF;
		   --------------------------------------
		   -- PARA PROBAR SI FUNCIONA LA FUNCION DE TRANFROMACION, HABILITAR EXECUTE
		   ------------------------------------------
		     --EXECUTE (v_consulta);
		   
		   
		    INSERT INTO 
		                      migracion.tmig_migracion
		                    (
		                      verificado,
		                      consulta,
		                      operacion
		                    ) 
		                    VALUES (
		                      'no',
		                       v_consulta,
		                       TG_OP::varchar
		                       
		                    );
		
		  RETURN NULL;
		
		END;
		\$BODY$".
		"LANGUAGE 'plpgsql'
		VOLATILE
		CALLED ON NULL INPUT
		SECURITY INVOKER;";
		
		//genera archivo fisicamente	
		$this->guardarArchivo($ruta."/migracion.f_tri_".$this->NameTablaOri."_".$this->NameTablaDes, $texto_archivo);
		
	}


    //generar funcion de tranformacion
    private function generarFuncionTransformacion($ruta){
    $texto_archivo="CREATE OR REPLACE FUNCTION migracion.f_trans_".$this->NameTablaOri."_".$this->NameTablaDes." (
			  v_operacion varchar";
			  
			  foreach ($this->ColumnasOri as $data)
			  {
			  	$texto_archivo=$texto_archivo.",p_".$data['columna']." ".$data['tipo_dato'];	
			  }
			  
			 $texto_archivo=$texto_archivo. ")
			RETURNS varchar [] AS
			\$BODY$\n\n".
			"DECLARE
			 
			g_registros record;
			v_consulta varchar;
			v_res_cone  varchar;
			v_cadena_cnx varchar;
			v_cadena_con varchar;
			resp boolean;
			v_resp varchar;
			v_respuesta varchar[];
			
			g_registros_resp record;\n";
			
			 foreach ($this->ColumnasDes as $data)
			  {
			  	$texto_archivo=$texto_archivo."			v_".$data['columna']." ".$data['tipo_dato'].";\n";	
			  }
			
			$texto_archivo=$texto_archivo."BEGIN
			
			
			          --funcion para obtener cadena de conexion
			          v_cadena_cnx =  migracion.f_obtener_cadena_con_dblink();
			          
			          
			           ---------------------------------------
			           --previamente se tranforman los datos  (descomentar)
			           ---------------------------------------\n
			           /*
			           ";
				    
			    foreach ($this->ColumnasDes as $data)
			    {
			    	if($data['tipo_dato']=='varchar' || $data['tipo_dato'] =='text'){
			    		 $texto_archivo=$texto_archivo."\t\t\tv_".$data['columna']."=convert(p_".$data['desc_columna_ori']."::".$data['tipo_dato'].", 'LATIN1', 'UTF8');\n";	
			     
			    	}
					else
					{
			  	       $texto_archivo=$texto_archivo."\t\t\tv_".$data['columna']."=p_".$data['desc_columna_ori']."::".$data['tipo_dato'].";\n";	
			        }
			    }
			    
			    $texto_archivo=$texto_archivo." */   
			    --cadena para la llamada a la funcion de insercion en la base de datos destino
			      
			        
			          v_consulta = 'select migra.f__on_trig_".$this->NameTablaOri."_".$this->NameTablaDes." (
			               '''||v_operacion::varchar||'''";
						   
			   foreach ($this->ColumnasDes as $data)
			   {
			  	 if($data['tipo_dato']=='varchar'  ||$data['tipo_dato']=='text'||$data['tipo_dato']=='date'||$data['tipo_dato']=='timestamp'||$data['tipo_dato']=='time')
				  {
				 	$texto_archivo=$texto_archivo.",'||COALESCE(''''||v_".$data['columna']."::varchar||'''','NULL')||'";
				  }
				  else
				  {
				 	$texto_archivo=$texto_archivo.",'||COALESCE(v_".$data['columna']."::varchar,'NULL')||'";
				  }
			   }		   
						   
				$texto_archivo=$texto_archivo.")';
			          --probar la conexion con dblink
			          
					   --probar la conexion con dblink
			          v_resp =  (SELECT dblink_connect(v_cadena_cnx));
			            
			             IF(v_resp!='OK') THEN
			            
			             	--modificar bandera de fallo  
			                 raise exception 'FALLA CONEXION A LA BASE DE DATOS CON DBLINK';
			                 
			             ELSE
					  
			         
			               PERFORM * FROM dblink(v_consulta,true) AS ( xx varchar);
			                v_res_cone=(select dblink_disconnect());
			             END IF;
			            
			            v_respuesta[1]='TRUE';
                       
			           RETURN v_respuesta;
			EXCEPTION
			   WHEN others THEN
			   
			    v_res_cone=(select dblink_disconnect());
			     v_respuesta[1]='FALSE';
                 v_respuesta[2]=SQLERRM;
                 v_respuesta[3]=SQLSTATE;
                 v_respuesta[4]=v_consulta;
                 
    
                 
                 RETURN v_respuesta;
			
			END;
			\$BODY$\n\n".
			"LANGUAGE 'plpgsql'
			VOLATILE
			CALLED ON NULL INPUT
			SECURITY INVOKER;";
    	
		//genera archivo fisicamente	
		$this->guardarArchivo($ruta."/migracion.f_trans_".$this->NameTablaOri."_".$this->NameTablaDes, $texto_archivo);
		
		
	}	
	
	 private function generarFuncionInsercionDestino($ruta){
	 	
		$texto_archivo="CREATE OR REPLACE FUNCTION migra.f__on_trig_".$this->NameTablaOri."_".$this->NameTablaDes." (
						  v_operacion varchar";
			  foreach ($this->ColumnasDes as $data)
			  {
			  	$texto_archivo=$texto_archivo.",p_".$data['columna']." ".$data['tipo_dato'];	
			  }
			  
			 $texto_archivo=$texto_archivo. ")
						RETURNS text AS
						\$BODY$\n\n".
						"/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  ".  date("F j, Y, g:i a") ."
						Autor: autogenerado (".$_SESSION["_NOM_USUARIO"].")
						
						*/
						
						DECLARE
						
						BEGIN
						
						    if(v_operacion = 'INSERT') THEN
						
						          INSERT INTO 
						            ".$this->EsquemaDes.".".$this->NameTablaDes." (\n";
						            
			 $filas_des = sizeof($this->ColumnasDes);	
			 $cont = 0;	
			 $valores="";
			 
			 foreach ($this->ColumnasDes as $data)
			  {
			  	 $cont++;
			  	if($cont<$filas_des)
			  	{
			  		$texto_archivo=$texto_archivo."\t\t\t\t\t\t".$data['columna'].",\n";
					$valores=$valores."\t\t\t\t\t\tp_".$data['columna'].",\n";	
			    }
				else{
					$texto_archivo=$texto_archivo."\t\t\t\t\t\t".$data['columna'].")\n";
					$valores=$valores."\t\t\t\t\t\tp_".$data['columna'].");\n";		
				}
			  }
			  
			 $texto_validacion = "\t\t\t\tVALUES (\n".$valores."
                               
                                ELSEIF  v_operacion = 'UPDATE' THEN
                                       
                                       IF  not EXISTS(select 1 
                                           from ".$this->EsquemaDes.".".$this->NameTablaDes."\n 
                                           "; 
                                        
                                        
			  
			 $texto_temp=") THEN
                                       
                                            raise exception 'No existe el registro que  desea modificar';
                                            
                                       END IF;
						               
						               
						               UPDATE 
						                  ".$this->EsquemaDes.".".$this->NameTablaDes."  
						                SET"; 
			  
			  
			 $filas_des = sizeof($this->ColumnasDes);	
			 $cont = 0;	
			 $valores="";
			 $sw_ini=0;
			 
			 foreach ($this->ColumnasDes as $data)
			  {
			  	   $cont++;
			  	   
			  		if($data[checks]!='PK' &&  ($cont==1 || $sw_ini==0)){
			  			$texto_temp=$texto_temp."\t\t\t\t\t\t ". $data['columna']."=p_".$data['columna']."\n";	
			  		    $sw_ini=1;
					}
					elseif($data[checks]!='PK' && $sw_ini=1 ){
						$texto_temp=$texto_temp."\t\t\t\t\t\t ,". $data['columna']."=p_".$data['columna']."\n";	
			  		}
					elseif($data[checks]=='PK'){
							
			  			$valores="\t\t\t\t\t\t WHERE ". $data['columna']."=p_".$data['columna'].";\n";
			  			$valores_temp="\t\t\t\t\t\t WHERE ". $data['columna']."=p_".$data['columna']."";
			  			
			  		}
			}
			
			$texto_archivo=$texto_archivo.$texto_validacion.$valores_temp;
			
			$texto_archivo=$texto_archivo.$texto_temp.$valores."
						       
						       ELSEIF  v_operacion = 'DELETE' THEN
						       
						         
						         IF  not EXISTS(select 1 
                                           from ".$this->EsquemaDes.".".$this->NameTablaDes."\n".$valores_temp.") THEN
                                       
                                            raise exception 'No existe el registro que  desea eliminar';
                                            
                                END IF;
						         
						         
						         DELETE FROM 
						              ".$this->EsquemaDes.".".$this->NameTablaDes."\n 
						              ".$valores."
						       
						       END IF;  
						  
						 return 'true';
						
						-- statements;
						--EXCEPTION
						--WHEN exception_name THEN
						--  statements;
						END;
						\$BODY$\n\n".
						"
						LANGUAGE 'plpgsql'
						VOLATILE
						CALLED ON NULL INPUT
						SECURITY INVOKER
						COST 100;";
			
			//genera archivo fisicamente	
		$this->guardarArchivo($ruta."/migra.f__on_mig_".$this->NameTablaOri."_".$this->NameTablaDes, $texto_archivo);
		
		
	 }

    private function generarFuncionDeMigracionInicial($ruta){
         $texto_archivo="CREATE OR REPLACE FUNCTION migracion.f_mig_ini_".$this->NameTablaOri."_".$this->NameTablaDes."()
						RETURNS boolean AS
						\$BODY$\n\n"."
						DECLARE
						 
						g_registros record;
						v_consulta varchar;
						v_res_cone varchar;
						v_cadena_cnx varchar;
						v_resp varchar;
						
						v_cadena_resp varchar[];
						
						BEGIN
						     --funcion para obtener cadena de conexion
							 v_cadena_cnx =  migracion.f_obtener_cadena_con_dblink();
									          
						  
						    --quirta llaves foraneas en el destino
						     v_resp =  (SELECT dblink_connect(v_cadena_cnx));
									            
						     IF(v_resp!='OK') THEN
									            
						        --modificar bandera de fallo  
						         raise exception 'FALLA CONEXION A LA BASE DE DATOS CON DBLINK';
									                 
						     ELSE
						       v_consulta = 'select pxp.f_add_remove_foraneas(''".$this->NameTablaDes."'',''".$this->EsquemaDes."'',''eliminar'')';                   
						       raise notice '%',v_consulta;
						       PERFORM * FROM dblink(v_consulta,true) AS ( xx varchar);
						        v_res_cone=(select dblink_disconnect());
						     END IF;
						
						
						   --consulta los registro de la tabla origen
						    FOR g_registros in (
						        SELECT \n";
						        
			 $filas_des = sizeof($this->ColumnasOri);	
			 $cont = 0;	
			 
			 foreach ($this->ColumnasOri as $data)
			  {
			  	 $cont++;
			  	if($cont<$filas_des)
			  	{
			  		$texto_archivo=$texto_archivo."\t\t\t\t\t\t".$data['columna'].",\n";
				}
				else{
					$texto_archivo=$texto_archivo."\t\t\t\t\t\t".$data['columna']."\n";
				}
			  }
						        
				$texto_archivo=$texto_archivo."FROM 
						          ".$this->EsquemaOri.".".$this->NameTablaOri.") LOOP
						        
						        -- inserta en el destino
						      
						            v_cadena_resp = migracion.f_trans_".$this->NameTablaOri."_".$this->NameTablaDes."(
						            'INSERT'";
				  
						foreach ($this->ColumnasOri as $data){
						     $texto_archivo=$texto_archivo.",g_registros.".$data['columna']."\n\t\t\t\t\t";
						}	  
				  
							  
  					$texto_archivo=$texto_archivo.");	
					            IF v_cadena_resp[1] = 'FALSE' THEN
					              RAISE NOTICE 'ERROR ->>>  (%),(%) - %   ', v_cadena_resp[3], v_cadena_resp[2], v_cadena_resp[4];
					            END IF; 	
						 END LOOP;
						
						     --reconstruye llaves foraneas
						     v_resp =  (SELECT dblink_connect(v_cadena_cnx));
									            
						     IF(v_resp!='OK') THEN
									            
						        --modificar bandera de fallo  
						         raise exception 'FALLA CONEXION A LA BASE DE DATOS CON DBLINK';
									                 
						     ELSE
						       v_consulta = 'select pxp.f_add_remove_foraneas(''".$this->NameTablaDes."'',''".$this->EsquemaDes."'',''insertar'')';                   
						       raise notice '%',v_consulta;
						       PERFORM * FROM dblink(v_consulta,true) AS ( xx varchar);
						        v_res_cone=(select dblink_disconnect());
						     END IF;
						
						RETURN TRUE;
						END;
						\$BODY$\n\n"."
						LANGUAGE 'plpgsql'
						VOLATILE
						CALLED ON NULL INPUT
						SECURITY INVOKER;";	
    		
    	//genera archivo fisicamente	
		$this->guardarArchivo($ruta."/migracion.f_mig_ini_".$this->NameTablaOri."_".$this->NameTablaDes, $texto_archivo);
		
    }	
	
	private function guardarArchivo($pNombreArchivo, $pTexto){
		$arch=fopen($pNombreArchivo,"w+");
		fwrite($arch,$pTexto);
		fclose($arch);
	}
	
	private function crearDirectorio(){
		$this->ruta= dirname(__FILE__).'/../base_generada/'.$this->NameTablaOri.'_'.$this->NameTablaDes;
		if(!file_exists($this->ruta)){
			mkdir($this->ruta);
		}
		return $this->ruta;
		
	}
	
	private  function iniciarVariables($arreglo){
		
		$this->NameTablaOri=$arreglo['tabla_ori'];
		$this->NameTablaDes=$arreglo['tabla_des'];
		$this->EsquemaOri=$arreglo['codigo_sis_ori'];
		$this->EsquemaDes=$arreglo['desc_subsistema_des'];
		
		
	}
	
			
}

?>