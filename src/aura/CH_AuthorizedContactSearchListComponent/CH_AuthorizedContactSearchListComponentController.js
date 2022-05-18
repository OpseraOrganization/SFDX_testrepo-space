({
    init: function (component, event, helper) {
        component.set('v.columns', [
            {type: 'button', typeAttributes: { 
                label: 'Add', name: 'add'
            }},
            {label: 'Contact Name', fieldName: 'Name', type: 'text', sortable: 'true'},            
            // {label: 'Account Name', fieldName: 'AccountName', type: 'text', sortable: 'true'},
            {label: 'Legal Entity Name', fieldName: 'CH_Legal_Entity_Name__c', type: 'text', sortable: 'true'},
            // {label: 'Customer Type', fieldName: 'CH_ContactType__c', type: 'text', sortable: 'true'},
            {label: 'Contact Id', fieldName: 'CH_ContactID__c', type: 'text', sortable: 'true'},            
            {label: 'Email', fieldName: 'Email', type: 'text', sortable: 'true'}
        ]);
    },
    searchContacts: function(component, event, helper) {
        helper.fetchData(component, event, helper);
    },    
    updateColumnSorting: function (component, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        component.set("v.sortedBy", fieldName);
        component.set("v.sortedDirection", sortDirection);
        helper.sortData(component, fieldName, sortDirection);
    },
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'add':
                helper.addRecord(component, row)
                break;
        }
    }
})