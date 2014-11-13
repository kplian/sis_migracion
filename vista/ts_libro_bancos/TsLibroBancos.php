<?php
/**
*@package pXP
*@file gen-TsLibroBancos.php
*@author  (admin)
*@date 01-12-2013 09:10:17
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.TsLibroBancos=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.TsLibroBancos.superclass.constructor.call(this,config);
		this.init();
		this.grid.getTopToolbar().disable();
		this.grid.getBottomToolbar().disable();
		this.iniciarEventos();
		
		this.addButton('btnClonar',
			{
				text: 'Clonar',
				iconCls: 'bdocuments',
				disabled: false,
				handler: this.clonar,
				tooltip: '<b>Clonar</b><br/>Clonar Registro'
			}
		);
		
		this.addButton('btnCheque',
			{
				text: 'Cheque',
				iconCls: 'bprintcheck',
				disabled: false,
				handler: this.imprimirCheque,
				tooltip: '<b>Cheque</b><br/>Imprimir cheque'
			}
		);
		
		this.addButton('btnMemoramdum',
			{
				text: 'Memo',
				iconCls: 'bword',
				disabled: false,
				handler: this.memoramdum,
				tooltip: '<b>Memo</b><br/>Imprimir memoramdum de asignacion de fondo'
			}
		);
		
		this.addButton('fin_registro',
			{	text:'Siguiente',
				iconCls: 'badelante',
				disabled:true,
				handler:this.fin_registro,
				tooltip: '<b>Siguiente</b><p>Pasa al siguiente estado, si esta en borrador comprometera presupuesto</p>'
			}
		);
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_libro_bancos'
			},
			type:'Field',
			form:true 
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_cuenta_bancaria'
			},
			type:'Field',
			form:true 
		},
		{
			config:{
				name: 'fecha',
				fieldLabel: 'Fecha',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
				type:'DateField',
				filters:{pfiltro:'lban.fecha',type:'date'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'a_favor',
				fieldLabel: 'A favor de',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
				type:'TextField',
				filters:{pfiltro:'lban.a_favor',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'detalle',
				fieldLabel: 'Detalle',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:200
			},
				type:'TextArea',
				filters:{pfiltro:'lban.detalle',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},		
		{
			config:{
				name: 'observaciones',
				fieldLabel: 'Observaciones',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:25
			},
				type:'TextArea',
				filters:{pfiltro:'lban.observaciones',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},		
		{
			config:{
				name: 'nro_liquidacion',
				fieldLabel: 'Nro Liquidacion',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:20
			},
				type:'TextField',
				filters:{pfiltro:'lban.nro_liquidacion',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'nro_comprobante',
				fieldLabel: 'Nro Comprobante',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:20
			},
				type:'TextField',
				filters:{pfiltro:'lban.nro_comprobante',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name:'tipo',
				fieldLabel:'Tipo',
				allowBlank:false,
				emptyText:'Tipo...',
				typeAhead: true,
				triggerAction: 'all',
				lazyRender:true,
				mode: 'local',
				valueField: 'estilo',
				gwidth: 100,
				store:new Ext.data.ArrayStore({
                            fields: ['variable', 'valor'],
                            data : [ ['cheque','Cheque'],
									 ['deposito','Depósito'],
									 ['debito_automatico','Débito Automativo'],
									 ['transferencia_carta','Transferencia con Carta']
                                    ]
                                    }),
				valueField: 'variable',
				displayField: 'valor'
			},
			type:'ComboBox',
			id_grupo:1,
			filters:{	
					 type: 'list',
					  pfiltro:'lban.tipo',
					 options: ['Cheque','Depósito','Débito Automativo','Transferencia con Carta'],	
				},
			grid:true,
			form:true
		},
		{
			config:{
				name: 'nro_cheque',
				fieldLabel: 'Nro Cheque',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:6
			},
				type:'NumberField',
				filters:{pfiltro:'lban.nro_cheque',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'importe_deposito',
				fieldLabel: 'Importe Debe',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:1310722
			},
				type:'NumberField',
				filters:{pfiltro:'lban.importe_deposito',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'importe_cheque',
				fieldLabel: 'Importe Haber',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:1310722
			},
				type:'NumberField',
				filters:{pfiltro:'lban.importe_cheque',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name:'origen',
				fieldLabel:'Origen',
				allowBlank:false,
				emptyText:'Tipo...',
				typeAhead: true,
				triggerAction: 'all',
				lazyRender:true,
				mode: 'local',
				valueField: 'estilo',
				gwidth: 100,
				store:['CBB','SRZ','LPB','TJA','SRE','CIJ','TDD','UYU']
			},
			type:'ComboBox',
			id_grupo:1,
			filters:{	
					 type: 'list',
					  pfiltro:'lban.origen',
					 options: ['CBB','SRZ','TJA','SRE','CIJ','TDD','UYU'],	
				},
			grid:true,
			form:true
		},		
		{
			config: {
				name: 'id_libro_bancos_fk',
				fieldLabel: 'id_libro_bancos_fk',
				allowBlank: true,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_/control/Clase/Metodo',
					id: 'id_',
					root: 'datos',
					sortInfo: {
						field: 'nombre',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_', 'nombre', 'codigo'],
					remoteSort: true,
					baseParams: {par_filtro: 'movtip.nombre#movtip.codigo'}
				}),
				valueField: 'id_',
				displayField: 'nombre',
				gdisplayField: 'desc_',
				hiddenName: 'id_libro_bancos_fk',
				forceSelection: true,
				typeAhead: false,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 15,
				queryDelay: 1000,
				anchor: '100%',
				gwidth: 150,
				minChars: 2,
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['desc_']);
				}
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'movtip.nombre',type: 'string'},
			grid: true,
			form: true
		},
		{
			config:{
				name: 'estado',
				fieldLabel: 'estado',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:20
			},
				type:'TextField',
				filters:{pfiltro:'lban.estado',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'indice',
				fieldLabel: 'indice',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1310722
			},
				type:'NumberField',
				filters:{pfiltro:'lban.indice',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'estado_reg',
				fieldLabel: 'Estado Reg.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:10
			},
				type:'TextField',
				filters:{pfiltro:'lban.estado_reg',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'fecha_reg',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'lban.fecha_reg',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'usr_reg',
				fieldLabel: 'Creado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'NumberField',
				filters:{pfiltro:'usu1.cuenta',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'fecha_mod',
				fieldLabel: 'Fecha Modif.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'lban.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'usr_mod',
				fieldLabel: 'Modificado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'NumberField',
				filters:{pfiltro:'usu2.cuenta',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Depósitos',
	ActSave:'../../sis_migracion/control/TsLibroBancos/insertarTsLibroBancos',
	ActDel:'../../sis_migracion/control/TsLibroBancos/eliminarTsLibroBancos',
	ActList:'../../sis_migracion/control/TsLibroBancos/listarTsLibroBancos',
	id_store:'id_libro_bancos',
	fields: [
		{name:'id_libro_bancos', type: 'numeric'},
		{name:'id_cuenta_bancaria', type: 'numeric'},
		{name:'fecha', type: 'date',dateFormat:'Y-m-d'},
		{name:'a_favor', type: 'string'},
		{name:'nro_cheque', type: 'numeric'},
		{name:'importe_deposito', type: 'numeric'},
		{name:'nro_liquidacion', type: 'string'},
		{name:'detalle', type: 'string'},
		{name:'origen', type: 'string'},
		{name:'observaciones', type: 'string'},
		{name:'importe_cheque', type: 'numeric'},
		{name:'id_libro_bancos_fk', type: 'numeric'},
		{name:'estado', type: 'string'},
		{name:'nro_comprobante', type: 'string'},
		{name:'indice', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'tipo', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		
	],
	sortInfo:{
		field: 'fecha',
		direction: 'DESC'
	},
	bdel:true,
	bsave:false,
	bnew:true,
	bedit:true,
	
	loadValoresIniciales:function(){
		Phx.vista.TsLibroBancos.superclass.loadValoresIniciales.call(this);
		this.Cmp.id_cuenta_bancaria.setValue(this.maestro.id_cuenta_bancaria);		
	},
	
	onButtonNew:function(){
		Phx.vista.TsLibroBancos.superclass.onButtonNew.call(this); 	    
		this.cmpIdLibroBancosFk.setValue(this.maestro.id_libro_bancos);
	},
		
	clonar:function(){
		
		var data = this.getSelectedData();
		var NumSelect=this.sm.getCount();
		
		if(NumSelect != 0)
		{
			this.onButtonNew();
			
			this.cmpAFavor = this.getComponente('a_favor');
			this.cmpObservaciones = this.getComponente('observaciones');
			this.cmpDetalle = this.getComponente('detalle');		
			this.cmpNroLiquidacion = this.getComponente('nro_liquidacion');
			this.cmpIdLibroBancosFk = this.getComponente('id_libro_bancos_fk');	
			
			this.cmpTipo.setValue(data.tipo);
			this.cmpAFavor.setValue(data.a_favor);
			this.cmpObservaciones.setValue(data.observaciones);
			this.cmpDetalle.setValue(data.detalle);
			this.cmpNroLiquidacion.setValue(data.nro_liquidacion);
			this.cmpIdLibroBancosFk.setValue(data.id_libro_bancos_fk);
		}
		else
		{
			Ext.MessageBox.alert('Alerta', 'Antes debe seleccionar un item a clonar.');
		}
	},
	
	memoramdum : function(){
		var data = this.getSelectedData();
		var NumSelect=this.sm.getCount();
		
		if(NumSelect != 0)
		{		
			var data='id='+ data.id_libro_bancos;  			
			//window.open('http://172.17.45.11/ReportesEndeSis/Home/MemorandumFondosEnAvance?'+data);				
		}
		else
		{
			Ext.MessageBox.alert('Alerta', 'Antes debe seleccionar un item.');
		}
	},
	
	imprimirCheque : function(){
		var SelectionsRecord = this.getSelectedData();
		var NumSelect=this.sm.getCount();
		
		if(NumSelect!=0)
		{
			if(confirm('¿Está seguro de imprimir el cheque?'))
			{
				var data='a_favor='+SelectionsRecord.a_favor;			
				data=data+'&importe_cheque='+SelectionsRecord.importe_cheque;	
				data=data+'&fecha_cheque_literal='+SelectionsRecord.fecha_cheque_literal;	
				
				//Despliegue el mensaje de procesando				
				Phx.CP.loadingShow();
				
				Ext.Ajax.request({
					url:'../../sis_workflow/control/ProcesoWf/diagramaGanttTramite',
					params:{id_libro_bancos: SelectionsRecord.id_libro_bancos,
							estado:'impreso'},
					success:this.successImprimirCheque,
					failure: this.conexionFailure,
					timeout:this.timeout,
					scope:this
				});
				/*
				//Llamada asíncrona para ejecutar la acción posterior a la impresión del cheque
				Ext.Ajax.request({
					url:direccion+'../../../../sis_tesoreria/control/libro_bancos/ActionCambiarEstado.php',
					params:{
							//tipo:SelectionsRecord.data.tipo,
							id_libro_bancos:SelectionsRecord.data.id_libro_bancos,
							estado:'impreso'							
					},
					method:'POST',
					success: function(result, request)
					{
								window.open(direccion+'../../../../sis_tesoreria/control/libro_bancos/ActionPDFReporteCheque.php?'+data);
								//window.open(direccion+'../../../../sis_tesoreria/control/avance/reporte/ActionPDFCheque.php?'+data);
								Ext.MessageBox.hide();
								ClaseMadre_actualizar();
					},
					failure:ClaseMadre_conexionFailure,
					timeout:100000
				});*/
			}
		}
		else
		{
			Ext.MessageBox.alert('Estado', 'Antes debe seleccionar un item.');
		}
	},
	
	successImprimirCheque:function(resp){
            
		Phx.CP.loadingHide();
		var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
		if(!reg.ROOT.error){
			
			this.reload();
		   
		}else{
			
			alert('ocurrio un error durante el proceso')
		}
	},
		
	iniciarEventos:function(){
		
		this.cmpTipo = this.getComponente('tipo');		
		this.cmpNroCheque = this.getComponente('nro_cheque');
		this.cmpImporteDeposito = this.getComponente('importe_deposito');
		this.cmpImporteCheque = this.getComponente('importe_cheque');
	    this.cmpIdLibroBancosFk = this.getComponente('id_libro_bancos_fk');
		
		this.ocultarComponente(this.cmpNroCheque);
		this.ocultarComponente(this.cmpImporteDeposito);
		this.ocultarComponente(this.cmpImporteCheque);
		this.ocultarComponente(this.cmpIdLibroBancosFk);
		
		 this.cmpTipo.on('select',function(com,dat){
		 
              switch(dat.data.variable){
				case 'cheque':
					this.mostrarComponente(this.cmpNroCheque);
					this.cmpImporteDeposito.setValue(0.00);
					this.ocultarComponente(this.cmpImporteDeposito);
					this.cmpImporteCheque.setValue(0.00);
					this.mostrarComponente(this.cmpImporteCheque);
					
					//
					this.store.baseParams={m_id_cuenta_bancaria:this.maestro.id_cuenta_bancaria, m_nro_cheque:'si'};
					this.load({params:{start:0, limit:this.tam_pag}, 
					   callback : function (r) {                        
							if (r.length > 0 ) {                     
								this.scope.cmpNroCheque.setValue(r[0].data.nro_cheque + 1);
							}				
						}, scope : this
					});					
					//
					break;
				case  'deposito':
					this.ocultarComponente(this.cmpNroCheque);
					this.cmpImporteDeposito.setValue(0.00);
					this.mostrarComponente(this.cmpImporteDeposito);
					this.cmpImporteCheque.setValue(0.00);
					this.ocultarComponente(this.cmpImporteCheque);
					break;
				case  'debito_automatico':
					this.ocultarComponente(this.cmpNroCheque);
					this.cmpImporteDeposito.setValue(0.00);
					this.ocultarComponente(this.cmpImporteDeposito);
					this.cmpImporteCheque.setValue(0.00);
					this.mostrarComponente(this.cmpImporteCheque);
					break;	
				case 'transferencia_carta':
					this.ocultarComponente(this.cmpNroCheque);
					this.cmpImporteDeposito.setValue(0.00);
					this.ocultarComponente(this.cmpImporteDeposito);
					this.cmpImporteCheque.setValue(0.00);
					this.mostrarComponente(this.cmpImporteCheque);
					break;
			  }
          },this);
	},	
	
	onReloadPage:function(m){
		this.maestro=m;						
		this.store.baseParams={id_cuenta_bancaria:this.maestro.id_cuenta_bancaria};
		this.load({params:{start:0, limit:this.tam_pag}});			
	}
})
</script>
		
		