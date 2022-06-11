({
	doInit : function(component, event, helper) {
        let globalActions = component.get('v.type') === 'Complete' ? [{name:'refresh', label:'Refresh'}] : [];
        let tableColumns = [];
        let objectName = component.get('v.sObjectName');
        switch(objectName) {
            case 'ServiceContract':
            	tableColumns = [
                    {label: 'Contract Name', fieldName: 'ContractURL', type: 'url', sortable: 'true', searchable: 'true', typeAttributes: {
                        label: { fieldName: 'ContractName' }
                    }},
                    {label: 'Account', fieldName: 'AccountName', type: 'text', sortable: 'true', searchable: 'true'},
                    
                    {label: 'Line Item Number', fieldName: 'LineItemURL', type: 'url', sortable: 'true', searchable: 'true', typeAttributes: {
                        label: { fieldName: 'LineItemNumber' }
                    }},
                    {label: 'Covered Product (Asset Name)', fieldName: 'AssetURL', type: 'url', sortable: 'true', searchable: 'true', typeAttributes: {
                        label: { fieldName: 'AssetName' }
                    }},
                    {label: 'Entitlement Name', fieldName: 'EntitlementURL', type: 'url', sortable: 'true', searchable: 'true', typeAttributes: {
                        label: { fieldName: 'EntitlementName' }
                    }},
                    {label: 'End Date', fieldName: 'EndDate', type: 'text', sortable: 'true', searchable: 'true'},
                    {label: 'Status', fieldName: 'Status', type: 'text', sortable: 'true', searchable: 'true'},
                    {label: 'External Status', fieldName: 'ExternalStatus', type: 'text', sortable: 'true', searchable: 'true'},
                    
                ];
                component.set('v.targetObjectName', 'Contract Line Item');
                break;
            case 'ContractLineItem':
            	tableColumns = [
                    {label: 'Contract Name', fieldName: 'ContractURL', type: 'url', sortable: 'true', searchable: 'true', typeAttributes: {
                        label: { fieldName: 'ContractName' }
                    }},
                    {label: 'Contract Number', fieldName: 'ContractNumber', type: 'text', sortable: 'true', searchable: 'true'},
                    {label: 'Account Name', fieldName: 'AccountURL', type: 'url', sortable: 'true', searchable: 'true', typeAttributes: {
                        label: { fieldName: 'AccountName' }
                    }},
                    {label: 'End Date', fieldName: 'EndDate', type: 'text', sortable: 'true', searchable: 'true'},
                    {label: 'Paid to End Date', fieldName: 'PaidtoEndDate', type: 'text', sortable: 'true', searchable: 'true'},
                    {label: 'Start Date', fieldName: 'StartDate', type: 'text', sortable: 'true', searchable: 'true'}
                ];
                component.set('v.targetObjectName', 'Vendor Contract');
                break;
            default:
            	console.error(objectName + ' is not compatible');
                break;
        }
        if(objectName === 'ServiceContract') {
            helper.apexAction(component, "c.permissionToChangeVendorContract", { 
                recordId : component.get("v.recordId")
            }, true).then(hasAccess => {
                if(hasAccess) {
                    tableColumns = [...tableColumns, {type: 'action', typeAttributes: { rowActions: [{name: 'unlink', label:'Unlink'}]}}];
                    globalActions = [...globalActions, {name:'link', label:'Link'}];
                    component.set('v.cliColumns', [
                        {label: 'Account', fieldName: 'ServiceAccountName', type: 'text', sortable: 'true', searchable: 'true'},
                         {label: 'Service Name', fieldName: 'ServiceName', type: 'text', sortable: 'true', searchable: 'true'},
                         {label: 'Line Item Number', fieldName: 'LineItemNumber', type: 'text', sortable: 'true', searchable: 'true'},
                         {label: 'Asset', fieldName: 'AssetName', type: 'text', sortable: 'true', searchable: 'true'},
                         {label: 'Service Offering', fieldName: 'CH_ServiceOffering__c', type: 'text', sortable: 'true', searchable: 'true'},
                         {label: 'End Date', fieldName: 'EndDate', type: 'date', sortable: 'true', searchable: 'true'},
                         {label: 'CARES Line Item', fieldName: 'CH_CARES_LineItem__c', type: 'text', sortable: 'true', searchable: 'true'},
                         {label: 'Service External Status', fieldName: 'ServiceExternalStatus', type: 'text', sortable: 'true', searchable: 'true'},
                         {label: 'External Status', fieldName: 'NCP_External_Status__c', type: 'text', sortable: 'true', searchable: 'true'}
                    ]);
                    helper.apexAction(component, "c.getCareContractRecordTypeId", null, true)
                    .then(recordTypeId => component.set("v.careContractRecordTypeId", recordTypeId));
                }
                component.set('v.tableColumns', tableColumns);
                component.set('v.globalActions', globalActions);
            });
        } else {
            component.set('v.tableColumns', tableColumns);
            component.set('v.globalActions', globalActions);
        }
    	helper.getCoveredVendorContracts(component, helper, objectName);
		helper.setTabIcon(component);
	},
	refresh : function(component, event, helper) {
    	helper.getCoveredVendorContracts(component, helper, component.get('v.sObjectName'));
	},
    handleGlobalAction : function(component, event, helper) {
        switch(event.getParam('action')) {
            case 'link':
        		component.set('v.visiblePopUp', 'Link');
                break;
            case 'refresh':
                $A.get('e.force:refreshView').fire(); 
                break;
            case 'clearSelection':
                component.find("cliTable").setSelectedRows(new Array());
                break;
            case 'saveLink':
                helper.incrementActionCounter(component);
                var cli = component.find("cliTable").getSelectedRows();
                var oCLIIdList = [];
                for (let i = 0; i < cli.length; i++) {
                    oCLIIdList = [...oCLIIdList, cli[i].Id];
                }
                helper.apexAction(component, "c.createCoveredVendorContracts", {
                    oVendorContractId: component.get("v.recordId"),
                    oContractLineItemIdList: oCLIIdList
                }, true).then(result => {
                    helper.decrementActionCounter(component);
                    if (result === '' || result === 'duplicated') {
                        if (result === '') {
                            helper.showToast('success', 'Success', 'The contract line items have been linked successfully.');
                    		$A.get('e.force:refreshView').fire(); 
                        } else {
                            helper.showToast('warning', 'Warning', 'The selected contract line items where already linked.');
                        }
                        helper.search(component, helper);
                    } else helper.showToast('error', 'Error', result);
                });
                break;
            case 'viewAll':
                var event = $A.get("e.force:navigateToComponent");
                event.setParams({
                    componentDef: "c:CH_CoveredVendorContract",
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
            case 'unlink':
        		component.set('v.visiblePopUp', 'Unlink');
                component.set('v.unlinkId', event.getParam('row').Id);
                break;
        }
    },
    handleSectionToggle : function(component, event, helper) {
        var openSections = event.getParam('openSections');
        component.set('v.sectionName', openSections.length != 0 ? openSections[0] : '');
    },
    search : function(component, event, helper) {
        if(event.keyCode === 13 || !event.keyCode) {
        	helper.search(component, helper);
    	}
    },
    closePopUp : function(component, event, helper) {
        component.set('v.activeSectionName', 'Search');
        component.set('v.cliList', []);
        component.set('v.searched', false);
        component.set('v.visiblePopUp', '');
        component.set('v.unlinkId', null);
    },
    unlink : function(component, event, helper) {
        helper.incrementActionCounter(component);
        helper.apexAction(component, "c.removeCoveredVendorContracts", {
            sObjectId : component.get('v.unlinkId')
        }, true).then(result => {
            helper.decrementActionCounter(component);
            if(result) {
                helper.showToast('success', 'Success', 'The contract line item has been unlinked successfully.');
                $A.get('e.force:refreshView').fire();
                component.set('v.visiblePopUp', '');
                component.set('v.unlinkId', null);
            } else helper.showToast('error', 'Error', 'Error while unlinking the contract line items.');
    	});
    },
})