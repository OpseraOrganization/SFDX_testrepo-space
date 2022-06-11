({
	doInit : function(component, event, helper) {
        let objectName = component.get('v.sObjectName');
        let tableColumns = objectName === 'Contact' ? [
            {label: 'Service Contract Name', fieldName: 'ServiceContraclUrl', type: 'url', sortable: 'true', typeAttributes: {
                label: { fieldName: 'ServiceContract' }
            }},
            {label: 'Legal Entity Name', fieldName: 'AccountNameUrl', type: 'url', sortable: 'true', typeAttributes: {
                label: { fieldName: 'AccountName' }
            }},
            {label: 'Legal Entity Account Number', fieldName: 'AccountNumber', type: 'text', sortable: 'true'},
        ]:[
            {label: 'Contact Name', fieldName: 'ContactURL', type: 'url', sortable: 'true', searchable: 'true', typeAttributes: {
                label: { fieldName: 'ContactName' }
            }},
            {label: 'Legal Entity', fieldName: 'LegalEntityName', type: 'text', sortable: 'true', searchable: 'true'},
            {label: 'Email', fieldName: 'Email', type: 'email', sortable: 'true', searchable: 'true'},
            {label: 'Phone', fieldName: 'Phone', type: 'phone', sortable: 'true', searchable: 'true'},
            {label: 'Mobile', fieldName: 'MobilePhone', type: 'phone', sortable: 'true', searchable: 'true'},
            {label: 'Country', fieldName: 'Country__c', type: 'text', sortable: 'true', searchable: 'true'},
            {label: 'Contact Status', fieldName: 'Contact_Status__c', type: 'text', sortable: 'true'},
            {label: 'Created By', fieldName: 'CreatedBy', type: 'text', sortable: 'true', searchable: 'true'},
            {label: 'Created Date', fieldName: 'CreatedDate', type: 'date', sortable: 'true'},
        ];
        //
        if(objectName === 'ServiceContract') {
            component.set('v.globalActions', [{name:'report', label:'Report'}, {name:'refresh', label:'Refresh'}]);
            helper.apexAction(component, 'c.getServiceContract', {serviceContractId : component.get('v.recordId')}, true)
            .then(oServiceContract => component.set('v.contractNumber', oServiceContract.ContractNumber));
            helper.apexAction(component, 'c.getReportFromDevName', {devName : 'CH_AuthorizedContacts'}, true)
            .then(oReport => component.set('v.reportId', oReport.Id));
			helper.apexAction(component, 'c.permissionToAuthorizedContactsAccess', {recordId : component.get('v.recordId')}, true)
            .then(hasAccess => {
                if(hasAccess) {
                    tableColumns = [...tableColumns, {type: 'action', typeAttributes: {rowActions: [{label: 'Delete', name:'delete' }]}}];
                    component.set('v.tableColumns', tableColumns);
                    component.set('v.globalActions', [{name:'new', label:'New'}, {name:'report', label:'Report'}, {name:'refresh', label:'Refresh'}]);
                    component.set('v.newContactsColumns', [
                        {type: 'button', typeAttributes: { label: 'Add', name: 'add', title: 'Add as Authorized Contact', disabled: {fieldName: 'actionDisabled'}}},
                       {label: 'Contact Name', fieldName: 'ContactURL', type: 'url', sortable: 'true', searchable: 'true', typeAttributes: {
              label: { fieldName: 'Name' }   }},
                        {label: 'Legal Entity Name', fieldName: 'CH_Legal_Entity_Name__c', type: 'text', sortable: 'true', searchable: 'true'},
                        {label: 'Email', fieldName: 'Email', type: 'email', sortable: 'true', searchable: 'true'},
                        {label: 'Phone', fieldName: 'Phone', type: 'phone', sortable: 'true', searchable: 'true'},
                        {label: 'Mobile', fieldName: 'MobilePhone', type: 'phone', sortable: 'true', searchable: 'true'},
                        {label: 'Country', fieldName: 'Country__c', type: 'text', sortable: 'true', searchable: 'true'}
                    ]);  
            	} else component.set('v.tableColumns', tableColumns);   
            });
    	} else component.set('v.tableColumns', tableColumns);
        helper.getAuthorizedContacts(component, event, helper);
		helper.setTabIcon(component);
	},
	doRefresh : function(component, event, helper) {
        helper.getAuthorizedContacts(component, event, helper);
	},
    handleGlobalAction : function(component, event, helper) {
        switch(event.getParam('action')) {
            case 'new':
                component.set('v.searched', false);
        		component.set('v.newPopUpVisible', true);
                break;
            case 'refresh':
                $A.get('e.force:refreshView').fire(); 
                break;
            case 'report':
                var contractNumber = component.get('v.contractNumber');
                if(contractNumber) {
                    var navigation = $A.get("e.force:navigateToURL");
                    navigation.setParams({
                      "url": "/lightning/r/Report/" + component.get("v.reportId") + "/view?queryScope=userFolders&fv0=" + contractNumber
                    });
                    navigation.fire();
                }
                break;
            case 'viewAll':
                var event = $A.get("e.force:navigateToComponent");
                event.setParams({
                    componentDef: "c:CH_AuthorizedContacts",
                    componentAttributes:{
                        sObjectName : component.get('v.sObjectName'),
                        recordId : component.get("v.recordId"),
                        viewAll: true
                    }
                });
                event.fire();
                break;
        }
	},
    handleRowAction: function (component, event, helper) {
        switch(event.getParam('action')) {
            case 'delete':
                var oEntitlementContact = {
                    Id : event.getParam('row').Id,
                    ContactId : event.getParam('row').ContactId
                };
                helper.apexAction(component, 'c.doAuthorizedContacts', {
                    operationType : 'delete',
                    oEntitlementContact : oEntitlementContact,
                    oServiceContractId : component.get('v.recordId'),
                    withoutSharing : true,
                }, true).then(result => component.get('v.viewAll')?helper.getAuthorizedContacts(component, event, helper):$A.get('e.force:refreshView').fire());
                break;
            case 'add':
                var oEntitlementContact = {
                    ContactId : event.getParam('row').Id
                };
                helper.apexAction(component, 'c.doAuthorizedContacts', {
                    operationType : 'insert',
                    oEntitlementContact : oEntitlementContact,
                    oServiceContractId : component.get('v.recordId'),
                    withoutSharing : true,
                }, true).then(result => component.get('v.viewAll')?helper.getAuthorizedContacts(component, event, helper):$A.get('e.force:refreshView').fire());
                break;
        }
    },
    closePopUp : function(component, event, helper) {
        component.set('v.newPopUpVisible', false);
    },
    searchNewContacts : function(component, event, helper) {
        if(event.keyCode === 13 || !event.keyCode)
        	helper.searchContacts(component);
    }
})