({
    
    doInit : function(component, event, helper) {
        
        if(component.get("v.initialLoad")){  
            var recordId = component.get("v.recordId");
            var action = component.get("c.accessCheck");
            action.setParams({ caseId : recordId });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set("v.edit",response.getReturnValue());
                    var action = component.get("c.fetchODRrecords");
                    action.setParams({ caseId : recordId });
                    action.setCallback(this, function(response) {
                        var state = response.getState();
                        if (state === "SUCCESS") {
                            component.set("v.isODRexist",response.getReturnValue());
                            
                        }
                    });
                    $A.enqueueAction(action);
                }
            });
            $A.enqueueAction(action);
            component.set("v.initialLoad",false);
        }
    },
    
    handleOnload: function(component, event, helper) {  
        component.set("v.initialLoad",true);
        var onRefreshView = component.get('c.doInit');
        
        $A.enqueueAction(onRefreshView);
    },
    
    
    handleSuccess : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The record has been updated successfully.",
            "type": "success"
        });
        toastEvent.fire();
        component.set("v.errorlogo", false);
    },
    update : function(component,event,helper) {
        component.find("recordEditForm").submit();
        $A.get('e.force:refreshView').fire();
    },
    /* NOKIASC-31257 As per this US Commenting Delete ODR Functionality Start-
    launchDeleteODR : function (component,event,helper) {
        component.set("v.deleteODR",true)
        var flow = component.find("ODRDeletion");
        var inputVariables = [
            { name : "recordId", type : "String", value: component.get("v.recordId") }
        ];
        flow.startFlow("CH_Delte_ODR",inputVariables);
    },
    NOKIASC-31257 As per this US Commenting Delete ODR Functionality End */
    launchCreateODR : function (component,event,helper) {
        
        
        var caseId = component.get("v.recordId");
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId()
        .then(function(tabId) {
            return workspaceAPI.openSubtab({
                parentTabId: tabId,
                recordId: caseId,
                pageReference: {
                    "type": "standard__component",
                    "attributes": {
                        "componentName": "c__CH_CaseField_CreateODR"
                    },
                    "state": {
                        "uid": "1",
                        "c__recordId": caseId
                    }
                },
                focus: true
            });
        })
        .then(function(response) {
            var focusedTabId = response;
            workspaceAPI.setTabLabel({
                tabId: focusedTabId,
                label: "Create ODR"
            });
        })
        .catch(function(error) {
            console.log(error);
        }); 
    },
    launchCheckODR : function (component,event,helper) {
        debugger;
        component.set("v.checkODRFinish", true);
        component.set("v.checkODR",true);
        var flow = component.find("ODRCheck");
        var inputVariables = [
            { name : "recordId", type : "String", value: component.get("v.recordId") }
        ];
        flow.startFlow("CH_CheckODRCoverage",inputVariables);
    },
    /*NOKIASC-31257 As per this US Commenting Delete ODR Functionality 
     
    handleDeleteODR : function (component,event,helper) {
        
        if(event.getParam("status") === "FINISHED") {
            component.set("v.deleteODR",false);
        }
    },
    */
    sectionOne : function(component, event, helper) {
        helper.helperFun(component,event,'articleOne');
    },
    handleCheckODR : function (component,event,helper) {
        
        if(event.getParam("status") === "FINISHED") {
            
            component.set("v.checkODR",false);
            component.set("v.Spinner", true);
            component.set("v.checkODRFinish", false);
            $A.get("e.force:refreshView").fire();
            component.set("v.Spinner", false);
        }
        
    },
    
    handleOnError : function(component, event, helper) {
        
        try{
            component.set("v.errorlogo", true);      
            var errors = event.getParams();
            var error= errors.output.errors;            
            var fieldError=[];
            var uniqueObjs = {};
            var fieldErrors= errors.output.fieldErrors;
            var keyList=Object.keys(fieldErrors);
            keyList.forEach(function(item) { 
                var itemList=fieldErrors[item]; 
                fieldError.push(itemList);
                
            });
            
            
            
            var pageLevelErrors=[];
            var fieldLevelErrors=[];
            
            error.forEach(function(item) {
                if(!$A.util.isEmpty(item.message)){
                    pageLevelErrors.push(item);
                }
                
                if(!$A.util.isEmpty(item.fieldLabel)){
                    fieldLevelErrors.push(item);
                }
            });    
            
            fieldError.forEach(function(item) {
                item.forEach(function(row) {
                    /*If we want Field Label Error Texts to be displayed in Popover
                 // Uncomment this section
                    if(!$A.util.isEmpty(row.message)){
                        pageLevelErrors.push(row);
                    }*/
                    
                    if(!$A.util.isEmpty(row.fieldLabel) ){
                        if(fieldLevelErrors.length==0){
                            
                            fieldLevelErrors.push(row);
                        }
                        else{
                            var rowDataIndex=fieldLevelErrors.map(function(e){ return e.fieldLabel; }).indexOf(row.fieldLabel);
                            if(rowDataIndex===-1){
                                fieldLevelErrors.push(row);
                            }  
                        }
                        
                        
                    }
                    
                    
                    
                    
                    
                });  
            });  
            component.set("v.pageLevelErrors",pageLevelErrors);
            component.set("v.fieldLevelErrors",fieldLevelErrors);            
            component.set("v.closePopupBtn",false);
        } catch (e) {
            // Handle Exception error
            console.error(e);                    
        } 
        
    },
    // This function will close the PopOver -NOKIASC-23325
    closePopup : function(component, event, helper) {
        component.set("v.closePopupBtn",true);
    },
    
    openPopup : function(component, event, helper) {
        component.set("v.closePopupBtn",false);
        
        
    },
    // Changes added as a part of NOKIASC-31215
    // Updating the Outage Value based on the severity
    onchangeSeverity : function(component,event,helper) {
        var getSeverityValue = component.find("isSeverity").get("v.value");
        if(getSeverityValue == "Minor"){
            component.find("outageType").set("v.value", "No");
        }
        else if(getSeverityValue == "Critical" || getSeverityValue == "Major" || getSeverityValue =="Information Request"){
            component.find("outageType").set("v.value", "");
        }
        
    },
     closeChkODRpopup: function (component, event, helper) {
        component.set("v.checkODRFinish", false);
        $A.get('e.force:refreshView').fire();
    }
})