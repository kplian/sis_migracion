<?php
/**
 *@package pXP
 *@file TsLibroBancosCheque.php
 *@author  Gonzalo Sarmiento
 *@date 01-10-2012
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.TsLibroBancosCheque = Ext.extend(Phx.gridInterfaz, {

        constructor : function(config) {
            this.maestro = config.maestro;
            Phx.vista.TsLibroBancosCheque.superclass.constructor.call(this, config);
            this.init();
			this.iniciarEventos();
            this.grid.getTopToolbar().disable();
            this.grid.getBottomToolbar().disable();            
			
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
					tooltip: '<b>Cheque</b><br/>Imprimmir cheque'
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
					handler:this.sigEstado,
					tooltip: '<b>Siguiente</b><p>Pasa al siguiente estado, si esta en borrador pasa a pendiente</p>'
				}
			);
			this.addButton('btnChequeoDocumentosWf',
				{
					text: 'Documentos',
					iconCls: 'bchecklist',
					disabled: true,
					handler: this.loadCheckDocumentosSolWf,
					tooltip: '<b>Documentos de la Solicitud</b><br/>Subir los documetos requeridos en la solicitud seleccionada.'
				}
			);
			
			this.Cmp.tipo.on('select', this.onTipoSelect, this);
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
                name: 'num_tramite',
                fieldLabel: 'Num. Tramite',
                allowBlank: true,
                anchor: '80%',
                gwidth: 150,
                maxLength:200
            },
            type:'TextField',
            filters:{pfiltro:'obpg.num_tramite',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        },
		{
            config:{
                name: 'id_depto',
                fieldLabel: 'Depto',
                allowBlank: false,
                anchor: '80%',
                origen: 'DEPTO',
                tinit: false,
                baseParams:{tipo_filtro:'DEPTO_UO',estado:'activo',codigo_subsistema:'TES'},//parametros adicionales que se le pasan al store
                gdisplayField:'nombre',
                gwidth: 100
            },
            type:'ComboRec',
            filters:{pfiltro:'dep.nombre',type:'string'},
            id_grupo:1,
            grid:false,
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
				fieldLabel: 'A Favor',
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
				maxLength:200
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
									 ['debito_automatico','Debito Automatico'],
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
					 options: ['cheque','debito_automatico','transferencia_carta']
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
				fieldLabel: 'Importe Deposito',
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
				fieldLabel: 'Importe',
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
					 options: ['CBB','SRZ','TJA','SRE','CIJ','TDD','UYU']
				},
			grid:true,
			form:true
		},	
		{
			config: {
				name: 'id_libro_bancos_fk',
				fieldLabel: 'Libro Bancos',
				allowBlank: true,
				emptyText: 'Elija una opcion',
				store: new Ext.data.JsonStore({
					url: '../../sis_/control/Clase/Metodo',
					id: 'id_',
					root: 'datos',
					sortInfo: {
						field: 'nombre',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_libro_bancos_fk', 'nombre', 'codigo'],
					remoteSort: true,
					baseParams: {par_filtro: 'movtip.nombre#movtip.codigo'}
				}),
				valueField: 'id_libro_bancos_fk',
				displayField: 'nombre',
				gdisplayField: 'nombre',
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
					return String.format('{0}', record.data['id_libro_bancos_fk']);
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
				fieldLabel: 'Estado',
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
				fieldLabel: 'Indice',
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
				fieldLabel: 'Fecha creacion',
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
        title : 'Cheques',
        ActSave:'../../sis_migracion/control/TsLibroBancos/insertarTsLibroBancos',
	ActDel:'../../sis_migracion/control/TsLibroBancos/eliminarTsLibroBancos',
	ActList:'../../sis_migracion/control/TsLibroBancos/listarTsLibroBancos',
        id_store : 'id_libro_bancos',
        fields: [
		{name:'id_libro_bancos', type: 'numeric'},
		{name:'num_tramite', type: 'string'},
		{name:'id_cuenta_bancaria', type: 'numeric'},
		{name:'fecha', type: 'date',dateFormat:'Y-m-d'},
		{name:'id_proceso_wf', type: 'numeric'},
		{name:'id_estado_wf', type: 'numeric'},
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
		{name:'id_depto', type: 'numeric'},
		{name:'nombre', type: 'string'}
	],
        sortInfo : {
            field : 'fecha',
            direction : 'DESC'
        },
        bdel : true,
        bsave : false,
		iniciarEventos:function(){
		
			this.cmpTipo = this.getComponente('tipo');		
			this.cmpNroCheque = this.getComponente('nro_cheque');
			this.cmpImporteDeposito = this.getComponente('importe_deposito');
			this.cmpImporteCheque = this.getComponente('importe_cheque');
			this.cmpIdLibroBancosFk = this.getComponente('id_libro_bancos_fk');
			
			this.ocultarComponente(this.cmpNroCheque);
			this.ocultarComponente(this.cmpImporteDeposito);
			this.ocultarComponente(this.cmpIdLibroBancosFk);
			
			 this.cmpTipo.on('select',function(com,dat){
			 
				  switch(dat.data.variable){
					case  'debito_automatico':
						this.ocultarComponente(this.cmpNroCheque);
						this.cmpImporteDeposito.setValue(0.00);
						this.ocultarComponente(this.cmpImporteDeposito);
						this.cmpImporteCheque.setValue(0.00);
						this.mostrarComponente(this.cmpImporteCheque);
						break;	
					case 'cheque':
						this.mostrarComponente(this.cmpNroCheque);
						this.cmpImporteDeposito.setValue(0.00);
						this.ocultarComponente(this.cmpImporteDeposito);
						this.cmpImporteCheque.setValue(0.00);
						this.mostrarComponente(this.cmpImporteCheque);
						this.store.baseParams={m_id_cuenta_bancaria:this.maestro.id_cuenta_bancaria, m_nro_cheque:'si'};
						//
						this.load({params:{start:0, limit:this.tam_pag}, 
						   callback : function (r) {                        
								if (r.length > 0 ) {                     
									this.scope.cmpNroCheque.setValue(parseInt(r[0].data.nro_cheque) + 1);
								}				
							}, scope : this
						});
						//
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
		
		preparaMenu:function(n){
			  var data = this.getSelectedData();
			  //var tb =this.tbar;
			  
			  Phx.vista.TsLibroBancosCheque.superclass.preparaMenu.call(this,n); 
			  if (data['estado']== 'borrador'){
				  this.getBoton('edit').enable();				  
				  this.getBoton('del').enable();    
				  this.getBoton('fin_registro').enable();				 
				  this.getBoton('btnCheque').disable();
				  this.getBoton('btnMemoramdum').disable();
				  //this.TabPanelSouth.get(1).disable();		//pestaña plan de pagos			  
			  }
			  else{				  
				  
				   if (data['estado'] == 'cobrado' || data['estado'] == 'anulado' || data['estado'] == 'reingresado'){   
					  this.getBoton('fin_registro').disable();
					}					
					else{
					  this.getBoton('fin_registro').enable();
				    }
					if (data['estado'] == 'impreso'){   
					  this.getBoton('btnCheque').enable();
					  this.getBoton('btnMemoramdum').enable();
					}					
					else{
					  this.getBoton('btnCheque').disable();
					  this.getBoton('btnMemoramdum').disable();
				    }
					this.getBoton('edit').disable();
					this.getBoton('del').disable();
			   }			  
			   
			  if(data['num_tramite'] !== ''){
				  //this.menuAdq.enable();		//Orden de Compra  , tendra libro de bancos tambien				  
				  this.getBoton('btnChequeoDocumentosWf').enable();
			  }
			  else{
				  //this.menuAdq.disable();				  
				  this.getBoton('btnChequeoDocumentosWf').disable();
			  }		  
		 },
		
		clonar:function(){
			var data = this.getSelectedData();
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
		
			var data=this.sm.getSelected().data;
			Phx.CP.loadingShow();
			Ext.Ajax.request({
				url:'../../sis_tesoreria/control/TsLibroBancos/imprimirCheque',
				params:{
					'a_favor':data.a_favor , 
					'importe_cheque' : data.importe_cheque ,
					'fecha_cheque_literal' : data.fecha_cheque_literal
				},
				success:this.successExport,
				failure: this.conexionFailure,
				timeout:this.timeout,
				scope:this
			});	
			/*
			var rec=this.sm.getSelected();
			var data='a_favor='+ rec.data.a_favor;			
			data=data+'&importe_cheque='+ rec.data.importe_cheque;	
			data=data+'&fecha_cheque_literal='+ rec.data.fecha_cheque_literal;	
						
			success: function(result, request)
			{
						window.open(direccion+'../../../../sis_tesoreria/control/libro_bancos/ActionPDFReporteCheque.php?'+data);
						//window.open(direccion+'../../../../sis_tesoreria/control/avance/reporte/ActionPDFCheque.php?'+data);
						Ext.MessageBox.hide();
						ClaseMadre_actualizar();
			},
			*/
		},
		
		sigEstado:function(){                   
		  var rec=this.sm.getSelected();
		  this.objWizard = Phx.CP.loadWindows('../../../sis_workflow/vista/estado_wf/FormEstadoWf.php',
									'Estado de Wf',
									{
										modal:true,
										width:700,
										height:450
									}, {data:{
										   id_estado_wf:rec.data.id_estado_wf,
										   id_proceso_wf:rec.data.id_proceso_wf,
										   fecha_ini:rec.data.fecha_tentativa
										  
										}}, this.idContenedor,'FormEstadoWf',
									{
										config:[{
												  event:'beforesave',
												  delegate: this.onSaveWizard												  
												}],
										
										scope:this
									 });        
				   
		 },	   
		
		onSaveWizard:function(wizard,resp){
			Phx.CP.loadingShow();
			
			Ext.Ajax.request({
				url:'../../sis_migracion/control/TsLibroBancos/siguienteEstadoLibroBancos',
				params:{
						
					id_proceso_wf_act:  resp.id_proceso_wf_act,
					id_estado_wf_act:   resp.id_estado_wf_act,
					id_tipo_estado:     resp.id_tipo_estado,
					id_funcionario_wf:  resp.id_funcionario_wf,
					id_depto_wf:        resp.id_depto_wf,
					obs:                resp.obs,
					json_procesos:      Ext.util.JSON.encode(resp.procesos)
					},
				success:this.successWizard,
				failure: this.conexionFailure,
				argument:{wizard:wizard},
				timeout:this.timeout,
				scope:this
			});
		},
		
		successWizard:function(resp){
			Phx.CP.loadingHide();
			resp.argument.wizard.panel.destroy()
			this.reload();
		 },
		 
		 loadCheckDocumentosSolWf:function() {
				var rec=this.sm.getSelected();
				rec.data.nombreVista = this.nombreVista;
				Phx.CP.loadWindows('../../../sis_workflow/vista/documento_wf/DocumentoWf.php',
						'Chequear documento del WF',
						{
							width:'90%',
							height:500
						},
						rec.data,
						this.idContenedor,
						'DocumentoWf'
			)
		},
		 
		loadValoresIniciales:function(){
			Phx.vista.TsLibroBancosCheque.superclass.loadValoresIniciales.call(this);
			this.Cmp.id_cuenta_bancaria.setValue(this.maestro.id_cuenta_bancaria);		
		},
		
		onButtonNew:function(){
			Phx.vista.TsLibroBancosCheque.superclass.onButtonNew.call(this); 	    
			this.cmpIdLibroBancosFk.setValue(this.maestro.id_libro_bancos);
		},
		
		onButtonEdit:function(){
			Phx.vista.TsLibroBancosCheque.superclass.onButtonEdit.call(this);
			var data = this.getSelectedData();
			if(data.tipo='cheque')
				this.mostrarComponente(this.cmpNroCheque);
		},
		
        onReloadPage : function(m) {
            this.maestro = m;
			this.store.baseParams={id_libro_bancos:this.maestro.id_libro_bancos, mycls:this.cls};
			this.load({params:{start:0, limit:this.tam_pag}});	
            
        }
    })
</script>