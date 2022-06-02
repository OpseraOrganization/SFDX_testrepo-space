({
	getCoveredNetworkElementAssets : function(component) {
        this.apexAction(component, 'c.getCoveredNetworkElementAssets', {
            sObjectId : component.get('v.recordId'),
            active : false
        }, true).then(results => {
            component.set('v.coveredNEAs', results.map(function(cur) {
            	let object = cur.CH_NetworkElementAsset__r;
            	object.Id = cur.Id;
            	object.CH_ContractLineItem__c = cur.CH_ContractLineItem__c;
            	object.CH_NetworkElementAsset__c = cur.CH_NetworkElementAsset__c;
            	object.CH_Status__c = cur.CH_Status__c;
            	/*object.URL = '/one/one.app?#/sObject/' + object.Id + '/view';*/
				object.URL = '/one/one.app?#/sObject/' + cur.CH_NetworkElementAsset__c + '/view';
            	object.AddressDetails = object.Address__r ? object.Address__r.CH_AddressDetails__c : '';
            	object.Product = object.Product2 ? object.Product2.Name : '';
            	object.Solution = object.CH_Solution__r ? object.CH_Solution__r.Name : '';
            	object.ProductVariant = object.CH_ProductVariant__r ? object.CH_ProductVariant__r.Name : '';
            	object.ProductRelease = object.CH_ProductRelease__r ? object.CH_ProductRelease__r.Name : '';
            	return object;
        	}));
        });
	},
	getNEAAvailableForLinking : function(component) {
        this.apexAction(component, 'c.getCoveredNetworkElementAssetsAvailableForLinking', {
            sObjectId : component.get('v.recordId')
        }, true).then(results => {
            component.set('v.oCNEAList', results);
            component.set('v.linkNEAList', results.map(function(cur) {
            	let tableTitle = 'Network Element Assets: ';
				let object = cur.CH_NetworkElementAsset__r;
            	object.Id = cur.Id;
            	object.CH_ContractLineItem__c = cur.CH_ContractLineItem__c;
            	object.CH_NetworkElementAsset__c = cur.CH_NetworkElementAsset__c;
            	object.CH_Status__c = cur.CH_Status__c;
            	object.assetDetails = (object.CH_SWBuild__r?('SW Build: "' +object.CH_SWBuild__r.Name+'"'):'SW Build: ""')+(object.CH_SWComponent__r?(', SW Component: "' +object.CH_SWComponent__r.Name+'"'):', SW Component: ""')+(object.CH_SWModule__r?(', SW Module: "' +object.CH_SWModule__r.Name+'"'):', SW Module: ""')+(object.CH_SWRelease__r?(', SW Release: "' +object.CH_SWRelease__r.Name+'"'):', SW Release: ""')+(object.CH_NetworkManagementSystemID__c?(', Network Management System ID: "' +object.CH_NetworkManagementSystemID__c+'"'):', Network Management System ID: ""');
            	/*object.URL = '/one/one.app?#/sObject/' + object.Id + '/view';*/
				object.URL = '/one/one.app?#/sObject/' + cur.CH_NetworkElementAsset__c + '/view';
            	object.AddressDetails = object.Address__r ? object.Address__r.CH_AddressDetails__c : '';
            	object.Product = object.Product2 ? object.Product2.Name : '';
            	tableTitle += object.Product;
            	component.set('v.tableTitle',tableTitle);
            	object.Solution = object.CH_Solution__r ? object.CH_Solution__r.Name : '';
            	object.ProductVariant = object.CH_ProductVariant__r ? object.CH_ProductVariant__r.Name : '';
            	object.ProductRelease = object.CH_ProductRelease__r ? object.CH_ProductRelease__r.Name : '';
            	return object;
        	}));
        });
	},
    // Tab
    setTabIcon : function(component) {
        if(component.get('v.viewAll')) {
            var workspaceAPI = component.find("Workspace");
            workspaceAPI.getEnclosingTabId().then(function(response) {
                workspaceAPI.setTabLabel({
                    tabId: response,
                    label: "Linked Network Element Assets",
                    title: "Linked Network Element Assets"
                });
                workspaceAPI.setTabIcon({
                    tabId: response,
                    icon: "standard:asset_object",
                    iconAlt: "Linked Network Element Assets"
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
                        resolve(null);
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