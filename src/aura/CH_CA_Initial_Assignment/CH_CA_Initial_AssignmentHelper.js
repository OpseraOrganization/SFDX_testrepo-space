({
    init: function(component, event, helper){
        var thisHelper = this;  
        let action = component.get('c.checkInitialAssignment');
        action.setParams({ caseId: component.get('v.recordId')});
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnValue=response.getReturnValue();
                console.log('isInitialAssignment : '+ response.getReturnValue());
                if (returnValue==true){
                    this.handleInitialAssignment(component, event, helper);                    
                }
            }
        })
        $A.enqueueAction(action);    
    },
    
    // When case is in initial assignment new tab will open
    handleInitialAssignment : function(component,event,helper) {        
        
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
                        "componentName": "c__CH_CA_Initial_Assignment_Page"
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
                label: "Initial Assignment"
            });
        })
        .catch(function(error) {
            console.log('Error logged for CH_CA_Initial_Assignment_Page:'+error);
        });  
        
        
    },
})