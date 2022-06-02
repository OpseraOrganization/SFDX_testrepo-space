({
    doInit : function(component, event, helper) {
		// Set NEA Table Columns
        var tableStructure = component.get('v.tableColumns');
        component.set('v.tableColumns', (tableStructure && tableStructure.length != 0) ? tableStructure : [
            {label: 'Network Element ID', fieldName: 'CH_NetworkElementID__c', sortable: 'true', searchable: 'true', type: 'text'},
            {label: 'Asset Name', fieldName: 'URL', sortable: 'true', searchable: 'true', type: 'url', typeAttributes: {
                label: { fieldName: 'Name' }
            }},
            {label: 'Product', fieldName: 'ProductURL', sortable: 'true', searchable: 'true', type: 'url', typeAttributes: {
                label: { fieldName: 'ProductName' }
            }},
            {label: 'Solution', fieldName: 'SolutionURL', sortable: 'true', searchable: 'true', type: 'url', typeAttributes: {
                label: { fieldName: 'SolutionName' }
            }},
            {label: 'Product Variant', fieldName: 'VariantURL', sortable: 'true', searchable: 'true', type: 'url', typeAttributes: {
                label: { fieldName: 'VariantName' }
            }},
            {label: 'Product Release', fieldName: 'ReleaseURL', sortable: 'true', searchable: 'true', type: 'url', typeAttributes: {
                label: { fieldName: 'ReleaseName' }
            }},
            {label: 'Address', fieldName: 'Address', sortable: 'true', searchable: 'true', type: 'text'},
            {label: 'Lab', fieldName: 'CH_LabEnvironment__c', sortable: 'true', type: 'boolean'},        
            {label: 'Country', fieldName: 'CH_CountryISOName__c', searchable: 'true', type: 'hidden'}
        ]);
        //Get Network Element Assets
        helper.getNetworkElementAssets(component, component.get('v.account'), component.get('v.asset'), component.get('v.entitlement'), component.get('v.product'));
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
    preSelect : function(component, event, helper) {
        const params = event.getParam('arguments');
        helper.getNetworkElementAssets(component, component.get('v.account'), null, null, null, params.target, params.callback);
    },
})