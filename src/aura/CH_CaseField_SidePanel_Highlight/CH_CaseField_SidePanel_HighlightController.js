({
    doInit : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var action = component.get("c.accessCheck");
        action.setParams({ caseId : recordId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                 component.set("v.edit",response.getReturnValue());
            }
        });
         $A.enqueueAction(action);
    },
    handleSuccess : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The record has been updated successfully.",
            "type": "success"
        });
        toastEvent.fire();
    },
    update : function(component,event,helper) {
        component.find("recordEditForm").submit();
        $A.get('e.force:refreshView').fire();
    },
    
    handleReaasign : function(component,event,helper) {
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
                        "componentName": "c__CH_CA_ReAssignment_Page"
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
                label: "Re-Assignment"
            });
        })
        .catch(function(error) {
            console.log(error);
        });        
    },
    // Display Workgroup instruction in new tab when clicked
    openWorkGroupInstruction : function(component,event,helper) {
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
                        "componentName": "c__CH_CA_WorkgroupInstructions_Page"
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
                label: "Workgroup Instructions"
            });
        })
        .catch(function(error) {
            console.log('Error logged for CH_CA_WorkgroupInstructions_Page:'+error);
        });        
    },
})