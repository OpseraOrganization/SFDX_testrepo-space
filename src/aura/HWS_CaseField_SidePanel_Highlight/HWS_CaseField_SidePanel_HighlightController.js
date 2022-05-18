({
	//34727 
    doInit : function(component, event, helper) {
        var action = component.get("c.validUser");
        action.setParams({
            "caseId" : component.get("v.recordId")
        });
        action.setCallback(this, function(result) {
            component.set('v.validUser', result.getReturnValue()?true:false);
        });
        $A.enqueueAction(action);    
        
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
                        "c__recordId": caseId,
						//passing isHWSCase as true -- 34690
                        "c__isHWSCase": true
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
	//34727
    //Accept the Case if it is still assigned to the queue
    acceptOwner : function(component, event, helper) {
        component.set("v.Spinner",true);
        var action = component.get("c.caseOwnerUpdate");
        action.setParams({
            "caseId" : component.get("v.recordId")
        });
        action.setCallback(this, function(result) {
            if(result.getState() !== 'ERROR') {
                if(result.getReturnValue()){
                    helper.showToast('Success', '','User assigned to the case');
                }
                else{
                    helper.showToast('Error', '', 'This case is already assigned to a User.');
                }
                
                component.set("v.Spinner",false);
                $A.get('e.force:refreshView').fire();
                
            }
        });
        $A.enqueueAction(action);
        
    },
	
	    // When clicked display the reassign window --> 34690
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
                        "c__recordId": caseId,
                        //passing isHWSCase as true -- 34690
                        "c__isHWSCase": true
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
})