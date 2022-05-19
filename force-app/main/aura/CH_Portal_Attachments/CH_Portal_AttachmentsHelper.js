({
    getCaseDetails: function(component, caseId) {
        var action = component.get("c.getCaseDetails");
        var newStatus;
        
        action.setParams({"caseId": caseId});
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var caseRecord = response.getReturnValue();
                component.set("v.caseRecord", caseRecord);                
            }
        });
        $A.enqueueAction(action);
    }
})