<?php
/**
*@package pXP
*@file gen-TablaMig.php
*@author  (admin)
*@date 14-01-2013 18:19:52
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.TablaMig=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.initButtons=[this.cmbIp,this.cmbBase,this.cmbUser,this.cmbPass];
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.TablaMig.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:50}});
		
		
		
		this.getComponente('id_subsistema_des').on('select',this.onSubsistemaSelect, this)
		this.getComponente('id_subsistema_ori').on('select',this.onSubsistemaOriSelect, this)
		
		
		this.cmbIp.on('change',this.setFiltroDblink, this);
		this.cmbBase.on('change',this.setFiltroDblink, this);
		this.cmbUser.on('change',this.setFiltroDblink, this);
		this.cmbPass.on('change',this.setFiltroDblink, this);
		this.setValorDefecto();
		
		
		this.addButton('gen_cod',{text:'Generar Codigo',iconCls: 'blist',disabled:false,handler:this.GenerarCodigo,tooltip: '<b>Generar Código</b><br/>Genera automáicamente los archivos de Base de datos, Modelo, Control y Vista'});
	
				
		
		
	},
	
	
	
	GenerarCodigo:function(){
		var data=this.sm.getSelected().data;
			Phx.CP.loadingShow();
			Ext.Ajax.request({
				// form:this.form.getForm().getEl(),
				url:'../../sis_migracion/control/TablaMig/GenerarCodigoMig',
				params:{'id_tabla_mig':data.id_tabla_mig},
				success:this.successSinc,
				failure: this.conexionFailure,
				timeout:this.timeout,
				scope:this
			});
			
	},
	successSinc:function(){
		Phx.CP.loadingHide();
		Ext.MessageBox.alert('Estado','Archivos generados!');
	},
	agregarArgsExtraSubmit: function(){
		//Inicializa el objeto de los argumentos extra
		this.argumentExtraSubmit={};
        this.argumentExtraSubmit.ip= this.cmbIp.getValue();
		this.argumentExtraSubmit.base= this.cmbBase.getValue();
		this.argumentExtraSubmit.usuario= this.cmbUser.getValue();
		this.argumentExtraSubmit.pass= this.cmbPass.getValue();
		
	},
	setValorDefecto:function(){
		this.cmbIp.setValue('192.168.1.32');
		this.cmbBase.setValue('dbendesis');
		this.cmbUser.setValue('dblink2');
		this.cmbPass.setValue('pass');
		this.setFiltroDblink();
	},
	
	setFiltroDblink:function(){
		
		var  cmbSubOri= this.getComponente('id_subsistema_ori')
		cmbSubOri.store.baseParams.ip= this.cmbIp.getValue();
		cmbSubOri.store.baseParams.base= this.cmbBase.getValue();
		cmbSubOri.store.baseParams.usuario= this.cmbUser.getValue();
		cmbSubOri.store.baseParams.pass= this.cmbPass.getValue();
		cmbSubOri.reset();
        cmbSubOri.modificado=true;
        
        var  cmbTabOri= this.getComponente('tabla_ori')
		cmbTabOri.store.baseParams.ip= this.cmbIp.getValue();
		cmbTabOri.store.baseParams.base= this.cmbBase.getValue();
		cmbTabOri.store.baseParams.usuario= this.cmbUser.getValue();
		cmbTabOri.store.baseParams.pass= this.cmbPass.getValue();
		cmbTabOri.reset();
        cmbTabOri.modificado=true;
		
	},
	onSubsistemaSelect:function(c,r,i)
	{
		var cmbTablaDes=  this.getComponente('tabla_des');
		cmbTablaDes.store.baseParams.esquema=r.data.codigo;
        cmbTablaDes.reset();
        cmbTablaDes.modificado=true;
	
	},
	onSubsistemaOriSelect:function(c,r,i)
	{
		var cmbTablaOri=  this.getComponente('tabla_ori');
		
		console.log('ORIGEN',r.data.codigo)
		cmbTablaOri.store.baseParams.esquema=r.data.nombre_corto;
        cmbTablaOri.reset();
        cmbTablaOri.modificado=true;
        
        this.getComponente('codigo_sis_ori').setValue(r.data.nombre_corto);
	
	},
	cmbIp:new Ext.form.TextField({
				//name: 'tabla_ori',
				emptyText: 'IP',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:255
			}),
	cmbBase:new Ext.form.TextField({
				//name: 'tabla_ori',
				emptyText: 'Base',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:255
			}),		
	cmbUser:new Ext.form.TextField({
				//name: 'tabla_ori',
				emptyText: 'User',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:255
			}),
	cmbPass:new Ext.form.TextField({
				//name: 'tabla_ori',
				emptyText: 'Pass',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:255
			}),				
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_tabla_mig'
			},
			type:'Field',
			form:true 
		},{
			config:{
				name: 'id_subsistema_ori',
				fieldLabel: 'Sistema Ori.',
				allowBlank:false,
				emptyText:'Subsistema...',
				store:new Ext.data.JsonStore({

				url: '../../sis_migracion/control/TablaMig/listarSubsistemaOri',
				id: 'id_subsistema',
				root: 'datos',
				sortInfo:{
					field: 'nombre_corto',
					direction: 'ASC'
				},
				totalProperty: 'total',
				fields: ['id_subsistema','nombre_corto','nombre_largo'],
				// turn on remote sorting
				remoteSort: true,
				baseParams:{par_filtro:'nombre_corto'}
			}),
				valueField: 'id_subsistema',
				displayField: 'nombre_corto',
				gdisplayField:'codigo_sis_ori',
				hiddenName: 'id_subsistema_ori',
				forceSelection:true,
				typeAhead: true,
    			triggerAction: 'all',
    			lazyRender:true,
				mode:'remote',
				pageSize:50,
				queryDelay:500,
				width:210,
				gwidth:220,
				minChars:2,
				minListWidth:'100%',
				renderer:function (value, p, record){return String.format('{0}', record.data['codigo_sis_ori']);}
	      },
			type:'ComboBox',
			id_grupo:0,
			filters:{	
		        pfiltro:'codigo_sis_ori',
				type:'string'
			},
			
			grid:true,
			form:true
	},
	{
			config:{
				name: 'codigo_sis_ori',
				labelSeparator:'',
				inputType:'hidden',
			
			},
			type:'Field',
			grid:false,
			form:true
		},
	 
		{
			config:{
				name:'tabla_ori',
				fieldLabel: 'Tabla Ori.',
				allowBlank:false,
				emptyText:'Tabla...',
				store:new Ext.data.JsonStore({
                        url: '../../sis_migracion/control/TablaMig/listarTablaOri',
						id: 'oid_tabla',
						root: 'datos',
						sortInfo:{
							field: 'nombre',
							direction: 'ASC'
						},
						totalProperty: 'total',
						fields: ['oid_tabla','nombre'],
						// turn on remote sorting
						remoteSort: true,
						baseParams:{par_filtro:'c.relname'}}),
				valueField: 'nombre',
				displayField: 'nombre',
				gdisplayField:'tabla_ori',
				hiddenName: 'tabla_ori',
				forceSelection:true,
				typeAhead: false,
    			triggerAction: 'all',
    			lazyRender:true,
				mode:'remote',
				pageSize:50,
				queryDelay:500,
				width:210,
				gwidth:220,
				minChars:2,
				minListWidth:'100%'
			},
			type:'ComboBox',
			filters:{pfiltro:'tam.tabla_ori',type:'string'},
			grid:true,
			form:true
		},
		
		{
			config:{
				name: 'alias_ori',
				fieldLabel: 'Alis Ori.',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:5
			},
			type:'TextField',
			filters:{pfiltro:'tam.alias_ori',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'id_subsistema_des',
				fieldLabel: 'Sistema Des.',
				allowBlank:false,
				emptyText:'Subsistema...',
				store:new Ext.data.JsonStore({
 						url: '../../sis_seguridad/control/Subsistema/listarSubsistema',
						id: 'id_subsistema',
						root: 'datos',
						sortInfo:{
							field: 'nombre',
							direction: 'ASC'
						},
						totalProperty: 'total',
						fields: ['id_subsistema','nombre','codigo'],
						// turn on remote sorting
						remoteSort: true,
						baseParams:{par_filtro:'nombre'}
				}),
				valueField: 'id_subsistema',
				displayField: 'codigo',
				gdisplayField:'desc_subsistema_des',
				hiddenName: 'id_subsistema_des',
				forceSelection:true,
				typeAhead: true,
    			triggerAction: 'all',
    			lazyRender:true,
				mode:'remote',
				pageSize:50,
				queryDelay:500,
				width:210,
				gwidth:220,
				minChars:2,
				minListWidth:'100%',	
				renderer:function (value, p, record){return String.format('{0}', record.data['desc_subsistema_des']);}
	       			
			},
			type:'ComboBox',
			id_grupo:0,
			filters:{	
		        pfiltro:'sud.nombre',
				type:'string'
			},
			
			grid:true,
			form:true
	},
	
		
		{
			config:{
				name:'tabla_des',
				fieldLabel: 'Tabla Des.',
				allowBlank:false,
				emptyText:'Tabla...',
				store:new Ext.data.JsonStore({
                        url: '../../sis_generador/control/Tabla/listarTablaCombo',
						id: 'oid_tabla',
						root: 'datos',
						sortInfo:{
							field: 'nombre',
							direction: 'ASC'
						},
						totalProperty: 'total',
						fields: ['oid_tabla','nombre'],
						// turn on remote sorting
						remoteSort: true,
						baseParams:{par_filtro:'c.relname'}}),
				valueField: 'nombre',
				displayField: 'nombre',
				gdisplayField:'tabla_des',
				hiddenName: 'tabla_des',
				forceSelection:true,
				typeAhead: false,
    			triggerAction: 'all',
    			lazyRender:true,
				mode:'remote',
				pageSize:50,
				queryDelay:500,
				width:210,
				gwidth:220,
				minChars:2,
				minListWidth:'100%'
			},
			type:'ComboBox',
			filters:{pfiltro:'tam.tabla_des',type:'string'},
			grid:true,
			form:true
		},
		{
			config:{
				name: 'alias_des',
				fieldLabel: 'Alias Des.',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:5
			},
			type:'TextField',
			filters:{pfiltro:'tam.alias_des',type:'string'},
			grid:true,
			form:true
		},
		{
			config:{
				name: 'obs',
				fieldLabel: 'Observaciones',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:500
			},
			type:'TextArea',
			filters:{pfiltro:'tam.obs',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
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
			filters:{pfiltro:'tam.estado_reg',type:'string'},
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
			filters:{pfiltro:'tam.fecha_reg',type:'date'},
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
			filters:{pfiltro:'tam.fecha_mod',type:'date'},
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
	
	title:'Migracion',
	ActSave:'../../sis_migracion/control/TablaMig/insertarTablaMig',
	ActDel:'../../sis_migracion/control/TablaMig/eliminarTablaMig',
	ActList:'../../sis_migracion/control/TablaMig/listarTablaMig',
	id_store:'id_tabla_mig',
	fields: [
		{name:'id_tabla_mig', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'alias_des', type: 'string'},
		{name:'id_subsistema_ori', type: 'numeric'},
		{name:'obs', type: 'string'},
		{name:'id_subsistema_des', type: 'numeric'},
		{name:'alias_ori', type: 'string'},
		{name:'tabla_ori', type: 'string'},
		{name:'tabla_des', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},'desc_subsistema_des','codigo_sis_ori'
		
	],
	tabsouth:[
	      {
		  url:'../../../sis_migracion/vista/columna_ori/ColumnaOri.php',
		  title:'Origen', 
		  //width:'50%',
		  height:'50%',
		  cls:'ColumnaOri'
		 },
	     {
		  url:'../../../sis_migracion/vista/columna_des/ColumnaDes.php',
		  title:'Destino', 
		  height:'50%',
		  cls:'ColumnaDes'
		 },
	
	   ],
	sortInfo:{
		field: 'id_tabla_mig',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true
	}
)
</script>
		
		