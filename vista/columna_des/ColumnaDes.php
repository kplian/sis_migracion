<?php
/**
*@package pXP
*@file gen-ColumnaDes.php
*@author  (admin)
*@date 16-01-2013 14:09:24
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ColumnaDes=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.ColumnaDes.superclass.constructor.call(this,config);
		
		this.init();
		
		var dataPadre = Phx.CP.getPagina(this.idContenedorPadre).getSelectedData()
		if(dataPadre){
			this.onEnablePanel(this, dataPadre);
		}
		else
		{
			this.bloquearMenus();
		}
		
		
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_columna_des'
			},
			type:'Field',
			form:true 
		},
		{
			config:{
				name: 'id_tabla_mig',
				labelSeparator:'',
				inputType:'hidden'
			},
			type:'Field',
			form:true 
		},
		{
			config:{
				name: 'columna',
				fieldLabel: 'columna',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:150
			},
			type:'TextField',
			filters:{pfiltro:'cold.columna',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'tipo_dato',
				fieldLabel: 'tipo_dato',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:80
			},
			type:'TextField',
			filters:{pfiltro:'cold.tipo_dato',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				
				name: 'id_columna_ori',
				fieldLabel: 'Col. Ori.',
				allowBlank: false,
				emptyText:'Coumna Origen...',
				store:new Ext.data.JsonStore(
				{
					url: '../../sis_migracion/control/ColumnaOri/listarColumnaOri',
					id: 'id_columna_ori',
					root: 'datos',
					sortInfo:{
						field: 'id_columna_ori',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_columna_ori','columna','tipo_dato'],
					// turn on remote sorting
					remoteSort: true,
					baseParams:{par_filtro:'columna'}
				}),
				valueField: 'id_columna_ori',
				displayField: 'columna',
				gdisplayField:'desc_columna_ori',
				hiddenName: 'id_columna_ori',
				groupable:true,//rpueba rac
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
				renderer:function (value, p, record){return String.format('{0}', record.data['desc_columna_ori']);}
			},
			type:'ComboBox',
			filters:{pfiltro:'co.columna',type:'string'},
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
			filters:{pfiltro:'cold.estado_reg',type:'string'},
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
			filters:{pfiltro:'cold.fecha_reg',type:'date'},
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
			filters:{pfiltro:'cold.fecha_mod',type:'date'},
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
	
	title:'Destino',
	ActSave:'../../sis_migracion/control/ColumnaDes/insertarColumnaDes',
	ActDel:'../../sis_migracion/control/ColumnaDes/eliminarColumnaDes',
	ActList:'../../sis_migracion/control/ColumnaDes/listarColumnaDes',
	id_store:'id_columna_des',
	fields: [
		{name:'id_columna_des', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_tabla_mig', type: 'numeric'},
		{name:'tipo_dato', type: 'string'},
		{name:'id_columna_ori', type: 'numeric'},
		{name:'columna', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},'desc_columna_ori'
		
	],
	sortInfo:{
		field: 'id_columna_des',
		direction: 'ASC'
	},
	onReloadPage:function(m)
	{
		this.maestro=m;						
		this.store.baseParams={id_tabla_mig:this.maestro.id_tabla_mig};
		this.load({params:{start:0, limit:50}});			
	},
	loadValoresIniciales:function()
	{
		Phx.vista.ColumnaOri.superclass.loadValoresIniciales.call(this);
		this.getComponente('id_tabla_mig').setValue(this.maestro.id_tabla_mig);		
	},
	bdel:true,
	bsave:true
	}
)
</script>
		
		