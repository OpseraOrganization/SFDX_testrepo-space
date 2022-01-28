({
	init : function(component, event, helper) {
        helper.setTabIcon(component);
        component.set('v.columns', [
            {label: 'Contract Name', fieldName: 'ContractURL', sortable: 'true', type: 'url', typeAttributes: {
                label: { fieldName: 'ContractName' }
            }},
            {label: 'Contract Project', fieldName: 'ContractProject', sortable: 'true', type: 'text'},
            {label: 'Line Item Number', fieldName: 'LineItemURL', sortable: 'true', type: 'url', typeAttributes: {
                label: { fieldName: 'LineItemNumber' }
            }},
            {label: 'Covered Product', fieldName: 'AssetName', sortable: 'true', type: 'text'},
            {label: 'Service Offering', fieldName: 'CH_ServiceOffering__c', sortable: 'true', type: 'text'},
            {label: 'Start Date', fieldName: 'StartDate', sortable: 'true', type: 'date-local', 
             	typeAttributes: { year: 'numeric', month: 'short', day: '2-digit' }
            },
            {label: 'End Date', fieldName: 'EndDate', sortable: 'true', type: 'date-local'},
            {label: 'Contract Status', fieldName: 'ContractExtStatus', sortable: 'true', type: 'text'},
            {label: 'Line Item Status', fieldName: 'NCP_External_Status__c', sortable: 'true', type: 'text'}
        ]);
        var reportTypeOptions = [
            { label: 'Search Service Contracts', value: 'ReportType-A', selected: true },
            { label: 'Search Service Contracts + Ignore AC Check', value: 'ReportType-B', selected: false },
            { label: 'Search Recently Expired Service Contracts + Ignore AC Check', value: 'ReportType-C', selected: false },
        ];
            component.set("v.options", reportTypeOptions);
            component.set("v.selectedValue", reportTypeOptions[0].value);
        helper.getEntitlementReport(component, event);
	},
    onChange: function (component, event, helper) {
        helper.getEntitlementReport(component, event);
    },
    // Client-side controller called by the onsort event handler
    sortColumn: function (cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
    }
})