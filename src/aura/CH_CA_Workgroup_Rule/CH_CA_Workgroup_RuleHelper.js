({
    // Close the current tab that was created for editing or creating a workgroup member
    closeConsoleTAB: function(component) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
        });  
    },
    //Cloning the workgroup rule
    cloneWorkgroupRule : function(component, event, helper) {
        component.set("v.isClone",false);
        component.set("v.isCloned", true);
    },
    getWGRuleDetails: function(component,event,helper,wgId){
		var action = component.get("c.getWGRuleDetails");
        action.setParams({
                wgId : wgId,
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS" && component.isValid()) {
                    
                   var resp=response.getReturnValue();
                    
                    component.find("name").set("v.value",resp.Name);
                    component.find("workgroup").set("v.value",resp.CH_Workgroup__c);
                    component.find("orderNumber").set("v.value",resp.CH_OrderNumber__c);
                    component.find("active").set("v.value",resp.CH_Active__c);
                    component.find("serviceType").set("v.value",resp.CH_ServiceType__c);
                    component.find("contractType").set("v.value",resp.CH_Contract_Type__c);
                   // component.find("mySelect").set("v.value",resp.Name);
                    component.find("workGroupType").set("v.value",resp.CH_Workgroup_Type__c);
                    component.find("severity").set("v.value",resp.CH_Severity__c);
                    component.find("outage").set("v.value",resp.CH_Outage__c);
                    component.find("levelOfSupport").set("v.value",resp.CH_LevelOfSupport__c);
                    component.find("customerGroup").set("v.value",resp.CH_Customer_Group__c);
                    component.find("account").set("v.value",resp.CH_Account__c);
                    component.find("serviceContract").set("v.value",resp.CH_ServiceContract__c);
                    component.find("region").set("v.value",resp.CH_Region1__c);
                    component.find("country").set("v.value",resp.CH_Country1__c);
                    component.find("productGroup").set("v.value",resp.CH_Product_Group__c);
                    component.find("product").set("v.value",resp.CH_Product__c);
                    component.find("solution").set("v.value",resp.CH_Solution__c);
                    component.find("productRelease").set("v.value",resp.CH_ProductRelease__c);
                    component.find("productVariant").set("v.value",resp.CH_ProductVariant__c);
                    component.find("productModule").set("v.value",resp.CH_Product_Module__c);
                    
                }
                });
        
        $A.enqueueAction(action);
    },
    openSubTab : function(component, lightningComp, caseId, title) {
        
        var workspaceAPI = component.find("workspace");
        
        workspaceAPI.getEnclosingTabId()
        .then(function(tabId) {
            return workspaceAPI.openSubtab({
                parentTabId: tabId,
                recordId: caseId,
                pageReference: {
                    "type": "standard__component",
                    "attributes": {
                       "componentName": lightningComp
                       //"objectApiName": 'CH_Workgroup_Rule__c',
                       // "actionName": "new"
                    },
                    "state": {
                        "uid": "1",
                        "c__cloneRecordId": caseId,
                        "c__edit":"True",
                        "c__recordTypeId":component.get("v.recordTypeId")
                       
                    }
                },
                focus: true
                //url: url
            });
        })
        //.then(function(){
        //    return workspaceAPI.getFocusedTabInfo();
        //})   
        .then(function(response) {
            var focusedTabId = response;
            workspaceAPI.setTabLabel({
                tabId: focusedTabId,
                label: title
            });
        })
        .catch(function(error) {
            console.log(error);
        });
    },
})