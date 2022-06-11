({
	doInit : function(component, event, helper) {
        let globalActions = component.get('v.type') === 'Complete' ? [{name:'refresh', label:'Refresh'}] : [];
        let tableColumns = [
            {label: 'Network Element ID', fieldName: 'CH_NetworkElementID__c', type: 'text', sortable: 'true', searchable: 'true'},
            {label: 'Asset Name', fieldName: 'URL', type: 'url', sortable: 'true', searchable: 'true', typeAttributes: {
                label: { fieldName: 'Name' },tooltip : { fieldName: 'assetDetails' }, title : {fieldName: 'assetDetails'}
            }},
            {label: 'Address Details', fieldName: 'AddressDetails', type: 'text', sortable: 'true', searchable: 'true'},
            {label: 'Site Name', fieldName: 'CH_SiteName__c', type: 'text', sortable: 'true', searchable: 'true'},
            {label: 'Lab', fieldName: 'CH_LabEnvironment__c', type: 'Boolean', sortable: 'true', searchable: 'true',
             "cellAttributes": {
                 "iconName": { "fieldName": "LabEnvironment_chk" },
                 "iconPosition": "left"
             }},
            {label: 'Solution', fieldName: 'Solution', type: 'text', sortable: 'true', searchable: 'true'},
            {label: 'Product Variant', fieldName: 'ProductVariant', type: 'text', sortable: 'true', searchable: 'true'},
            {label: 'Product Release', fieldName: 'ProductRelease', type: 'text', sortable: 'true', searchable: 'true'}
        ];
 		component.set('v.neaColumns', tableColumns);
        tableColumns.splice(2, 0, {label: 'Link Status', fieldName: 'CH_Status__c', type: 'text', sortable: 'true', searchable: 'true', values : ['Active', 'Inactive']});
        tableColumns.splice(5, 0, {label: 'Product', fieldName: 'Product', type: 'text', sortable: 'true', searchable: 'true'});
        tableColumns = [...tableColumns, {label: 'NEA Status', fieldName: 'Status', type: 'text', sortable: 'true', searchable: 'true', values : ['Active', 'Inactive']}];
        helper.apexAction(component, "c.permissionToChangeNetworkElmentAssets", null, true).then(hasAccess => {
            if(hasAccess) {
 				helper.getNEAAvailableForLinking(component);
                globalActions = [...globalActions, {name:'link', label:'Link'}];
                if(component.get('v.viewAll')) {
           			globalActions = [...globalActions, {name:'unlink', label:'Unlink'}];
                } else {
                    tableColumns = [...tableColumns, {type: 'action', typeAttributes: { rowActions: [{name: 'unlink', label:'Unlink'}]}}];
                }
        	}
            component.set('v.globalActions', globalActions);
            component.set('v.tableColumns', tableColumns);
        });
 		helper.getCoveredNetworkElementAssets(component);
		helper.setTabIcon(component);
	},
    handleGlobalAction : function(component, event, helper) {
        switch(event.getParam('action')) {
            case 'link':
                var selected = component.find("cNEATable").getSelectedRows();
                if(selected.length > 0) {
                    var linkList = [];
        		    for(let i = 0; i < selected.length; i++) {
                        if(selected[i].CH_Status__c === 'Inactive' && selected[i].Status === 'Active') {
                            linkList = [...linkList, {
                                Id : selected[i].Id,
                                CH_ContractLineItem__c : selected[i].CH_ContractLineItem__c,
                                CH_NetworkElementAsset__c : selected[i].CH_NetworkElementAsset__c
                            }];
                        }
                       else return helper.showToast('error', 'Error', 'One or more of the selected Network Element Assets are already linked Or Status of NEA Status is inactive.');
                    }
                    helper.apexAction(component, 'c.linkCoveredNetworkElementAssets', {
                        oCoveredNetworkElementAssetList : linkList
                    }, true).then(result => {
                        component.set('v.visiblePopUp', '');
                        (result ? $A.get('e.force:refreshView').fire() : helper.showToast('error', 'Error', "Something went wrong"));
                    });
                }
                else component.set('v.visiblePopUp', 'Link');
                break;
            case 'unlink':
                var selected = component.find("cNEATable").getSelectedRows();
                if(selected.length > 0) {
                    var unlinkList = [];
        		    for(let i = 0; i < selected.length; i++) {
                        if(selected[i].CH_Status__c === 'Active') {
                            unlinkList = [...unlinkList, {
                                Id : selected[i].Id,
                                CH_ContractLineItem__c : selected[i].CH_ContractLineItem__c,
                                CH_NetworkElementAsset__c : selected[i].CH_NetworkElementAsset__c
                            }];
                        }
                        //Ref: NOKIASC-36332 Replaced Error Message With Custom Label
                        else return helper.showToast('error', 'Error', $A.get("$Label.c.CH_One_Or_More_Selected_NEA_Already_Unlinked"));
                    }
                    component.set('v.visiblePopUp', 'Unlink');
                    component.set('v.unlinkList', unlinkList);
                }
                else helper.showToast('info', 'Info', 'No Linked Network Element Asset selected.');
                break;
            case 'refresh':
                $A.get('e.force:refreshView').fire(); 
                break;
            case 'clearSelection':
                component.find("cNEATable").setSelectedRows(new Array());
                break;
            case 'viewAll':
                var event = $A.get("e.force:navigateToComponent");
                event.setParams({
                    componentDef: "c:CH_CoveredNetworkElementAsset",
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
                let row = event.getParam('row');
                if(row.CH_Status__c === 'Active') {
                    component.set('v.visiblePopUp', 'Unlink');
                    component.set('v.unlinkList', [{
                        Id : row.Id,
                        CH_ContractLineItem__c : row.CH_ContractLineItem__c,
                        CH_NetworkElementAsset__c : row.CH_NetworkElementAsset__c
                    }]);
                }
               //Ref: NOKIASC-36332 Replaced Error Message With Custom Label
                else helper.showToast('error', 'Error', $A.get("$Label.c.CH_NEA_Already_Unlinked"));
                break;
        }
    },
    closePopUp : function(component, event, helper) {
        component.set('v.visiblePopUp', '');
        component.set('v.unlinkList', null);
    },
    link : function(component, event, helper) {
        var linkList = component.find("linkNEATable").getSelectedRows().map(function(cur) {
            return {
                Id : cur.Id,
                CH_ContractLineItem__c : cur.CH_ContractLineItem__c,
                CH_NetworkElementAsset__c : cur.CH_NetworkElementAsset__c
            }
        });
        helper.apexAction(component, 'c.linkCoveredNetworkElementAssets', {
            oCoveredNetworkElementAssetList : linkList
        }, true).then(result => {
            component.set('v.visiblePopUp', '');
            component.find("cNEATable").setSelectedRows(new Array());
            //Ref: NOKIASC-36332 Replaced Error Message With Custom Label
            (result ? $A.get('e.force:refreshView').fire() : helper.showToast('error', 'Error', $A.get("$Label.c.CH_Something_Went_Wrong")));
        });
    },
    unlink : function(component, event, helper) {
        let unlinkList = component.get('v.unlinkList');
        helper.apexAction(component, 'c.unlinkCoveredNetworkElementAssets', {
            oCoveredNetworkElementAssetList : unlinkList
        }, true).then(result => {
            component.set('v.visiblePopUp', '');
            component.set('v.unlinkList', null);
            component.find("cNEATable").setSelectedRows(new Array());
            //Ref: NOKIASC-36332 Replaced Error Message With Custom Label
            (result ? $A.get('e.force:refreshView').fire() : helper.showToast('error', 'Error', $A.get("$Label.c.CH_Something_Went_Wrong")));
        });
    },
})