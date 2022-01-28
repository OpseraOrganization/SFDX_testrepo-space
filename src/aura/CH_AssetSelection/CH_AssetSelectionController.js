({
	doInit : function(component, event, helper) {
		// Set Table Asset Columns
        var tableStructure = component.get('v.tableColumns');
        component.set('v.tableColumns', (tableStructure && tableStructure.length != 0) ? tableStructure :[
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
            {label: 'Country', fieldName: 'CH_CountryISOName__c', sortable: 'true', searchable: 'true', type: 'text'},
            {label: 'Product Description', fieldName: 'ProductDescription', searchable: 'true', type: 'hidden'}  
        ]);
        //Get Assets
        helper.getAssets(component, component.get('v.contact'), component.get('v.account'), component.get('v.netElemAsset'));
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
    }
})