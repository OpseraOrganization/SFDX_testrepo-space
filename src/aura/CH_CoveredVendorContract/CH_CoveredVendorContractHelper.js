({
    getCoveredVendorContracts : function(component, helper, objectName) {
        helper.apexAction(component, 'c.getCoveredVendorContracts', {
            sObjectType : objectName,
            sObjectId : component.get('v.recordId')
        }, true).then(results => {
            component.set('v.coveredVendorContracts', results.map(function(cur) {
            	let object = {};
           		switch(objectName) {
            		case 'ServiceContract':
                        var cli = cur.CH_ContractLineItem__r;
                        object = {
                            Id : cur.Id,
                            AccountName : cli.CH_Account__c,
                            ContractURL : '/one/one.app?#/sObject/' +cli.ServiceContractId + '/view',
           					ContractName : cli.ServiceContract ? cli.ServiceContract.Name : '',
                            LineItemURL : '/one/one.app?#/sObject/' +cli.Id + '/view',
                            LineItemNumber : cli.LineItemNumber,
                            AssetURL : '/one/one.app?#/sObject/' +cli.AssetId + '/view',
            				AssetName : cli.Asset ? cli.Asset.Name : '',
                            EntitlementURL : '/one/one.app?#/sObject/' +cli.CH_Entitlement__c + '/view',
                            EntitlementName : cli.CH_Entitlement__r ? cli.CH_Entitlement__r.Name : '',
                            EndDate : cli.EndDate,
                            ExternalStatus : cli.NCP_External_Status__c,
                            Status : cli.Status,
                        };
                      	break;
            		case 'ContractLineItem':
                        var vendor = cur.CH_VendorContract__r;
                        object = {
                            Id : cur.Id,
                            ContractNumber : vendor.ContractNumber,
                            AccountURL : '/one/one.app?#/sObject/' +vendor.AccountId + '/view',
                      		AccountName : vendor.Account ? vendor.Account.Name : '',
                            ContractURL : '/one/one.app?#/sObject/' +vendor.Id + '/view',
                            ContractName : vendor.Name,
                            EndDate : vendor.EndDate,
                            PaidtoEndDate : vendor.CH_PaidToEndDate__c,
                            StartDate : vendor.StartDate,
                        };
                      	break;
    			}
            	return object;
        	}));
        });
    },
    search: function(component, helper) {
        helper.incrementActionCounter(component);
        let args = {
            oVendorContractId : component.get("v.recordId"),
            oAccountId : component.find("AccountId").get("v.value"),
            sServiceAgreement : component.find("ServiceAgreement").get("v.value"),
            sCaresLineItem : component.find("CaresLineItem").get("v.value"),
            sCDBNumber : component.find("CDBContract").get("v.value"),
            sContractNumber : component.find("ContractNumber").get("v.value"),
            sLineItemNumber : component.find("LineItemNumber").get("v.value"),
            sProductName : component.find("ProductName").get("v.value"),
            sStatus : component.find("Status").get("v.value"),
            sExternalStatus : component.find("ExternalStatus").get("v.value"),
        };
        //
        helper.apexAction(component, "c.searchContractLineItem", args, true).then(results => {
            helper.decrementActionCounter(component);
            for(let i = 0; i < results.length; i++) {
                results[i].ServiceAccountName = (results[i].ServiceContract && results[i].ServiceContract.Account ? results[i].ServiceContract.Account.Name : "");
                results[i].ServiceName = (results[i].ServiceContract ? results[i].ServiceContract.Name : "");
                results[i].AssetName = (results[i].Asset ? results[i].Asset.Name : "");
                results[i].ServiceExternalStatus = (results[i].ServiceContract ? results[i].ServiceContract.NCP_External_Status__c : "");
       		}
            let table = component.find("cliTable");
    		(table?table.setSelectedRows(new Array()):null);
            component.set('v.cliList', results);
            component.set('v.searched', true);
            component.set('v.activeSectionName', '');
    	});
    },
    // Tab
    setTabIcon : function(component) {
        if(component.get('v.viewAll')) {
            let targetObjectName = "Linked " + component.get("v.targetObjectName") + "s";
            var workspaceAPI = component.find("Workspace");
            workspaceAPI.getEnclosingTabId().then(function(response) {
                workspaceAPI.setTabLabel({
                    tabId: response,
                    label: targetObjectName,
                    title: targetObjectName
                });
                workspaceAPI.setTabIcon({
                    tabId: response,
                    icon: "standard:contract_line_item",
                    iconAlt: targetObjectName
                });
                workspaceAPI.focusTab({
                    tabId : response
                }); 
            });
        }
    },
    //
    apexAction: function(component, method, params, handleError) {
        let helper = this, action = component.get(method);
        helper.incrementActionCounter(component);
        return new Promise(function(resolve, reject) { 
        	if(params) action.setParams(params);
        	action.setCallback(helper, function(response) {
                let state = response.getState();
                helper.decrementActionCounter(component);
                if (state === "SUCCESS") {
                    resolve(response.getReturnValue());
                } else {
                    if(handleError) {
                        var error = response.getError();
                        var message =  error && error[0] && error[0].message ? error[0].message : "Something went wrong";
                        helper.showToast('error', 'Error', message);
                    }
                    else reject(response.getError());
                }
            });
            $A.enqueueAction(action);
        });
    },
    // Generic Toast Message
    showToast: function(sType, title, message) {
        $A.get("e.force:showToast").setParams({
            "title": title,
            "message": message,
            "type": sType
        }).fire();
    },
    // Loading Framework
    isLoading: function(component) {
        return component.get("v.showSpinner");
    },
    incrementActionCounter: function(component) {
        var counter = component.get("v.actionCounter") + 1;
        if (counter === 1) {
            component.set("v.showSpinner", true);
        }
        component.set("v.actionCounter", counter);
    },
    decrementActionCounter: function(component) {
        var counter = component.get("v.actionCounter") - 1;
        if (counter === 0) {
            component.set("v.showSpinner", false);
        }
        component.set("v.actionCounter", counter);
    }
})