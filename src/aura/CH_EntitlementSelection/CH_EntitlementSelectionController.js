({
	doInit : function(component, event, helper) {
        // Set Entitlement displayed fields
        var tableStructure = component.get('v.tableColumns');
        if(!tableStructure || tableStructure.length == 0) {
            tableStructure = [
                {label: 'Entitlement Name', fieldName: 'EntitlementURL', sortable: 'true', searchable: 'true', type: 'url', typeAttributes: {
                    label: { fieldName: 'Name' }
                }},
                {label: 'Contract Name', fieldName: 'ContractURL', sortable: 'true', searchable: 'true', type: 'url', typeAttributes: {
                    label: { fieldName: 'ContractName' }
                }},
                {label: 'Contract Line Item Number', fieldName: 'LineItemURL', sortable: 'true', searchable: 'true', type: 'url', typeAttributes: {
                    label: { fieldName: 'LineItemNumber' }
                }},
                {label: 'Project', fieldName: 'ProjectName', sortable: 'true', searchable: 'true', type: 'text'},  
                {label: 'Business Hour', fieldName: 'BusinessHour', sortable: 'true', searchable: 'true', type: 'text'}
            ];
            if(component.get('v.showScripts')) { 
                tableStructure = [...tableStructure, {
                	label: 'Script', fieldName: 'HasScript', type: 'boolean', sortable: 'true', cellAttributes: { 
                        iconName: { fieldName: 'action:script' },
                        iconPosition: 'right'
                	}
            	}];
        	} 
            tableStructure = [...tableStructure, {label: 'NEA Count', fieldName: 'NEACount', sortable: 'true', searchable: 'true', type: 'number'}];
        }
        component.set('v.tableColumns', tableStructure);
        // Reset entitlementScriptVerified flag to false before we get new list        
        component.set('v.entitlementScriptVerified', false);
        //Get Entitlements
        helper.getEntitlements(component, component.get('v.account'), component.get('v.contact'), component.get('v.asset'), component.get('v.netElemAsset'));
	},
    handleSelection : function(component, event, helper) {
        helper.select(component, event.getParam('selectedRows')[0]);
    },
    handleGlobalAction : function(component, event, helper) {
        var action = event.getParam('action');
        switch(action) {
            case 'clearSelection':
                helper.reset(component);
                break;
            default:
                helper.emit(component, action, null);
                break;
        }
    },
    resetSelection : function(component, event, helper) {
        helper.reset(component);
    },
    emitScriptVerification: function(component, event, helper) {
    	helper.emit(component, 'scriptVerification', component.get("v.entitlementScriptVerified"));
    },
})