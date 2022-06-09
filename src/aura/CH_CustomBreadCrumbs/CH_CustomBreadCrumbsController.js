({
    doInit: function(component, event, helper) {
        var recordId = component.get("v.recordId");	
        
        var action = component.get("c.FetchRecordIds");
        action.setParams({
            "recordID": recordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var response = response.getReturnValue();
          
            component.set("v.caseId",response);
        });
        $A.enqueueAction(action);
        
        
    },
    navigateToSupportTicket: function (cmp, event) {
        var caseId =  cmp.get("v.caseId");
        
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": caseId,
            "slideDevName": "related"
        });
        navEvt.fire();
    },
})