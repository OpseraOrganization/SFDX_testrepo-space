({
	getCaseData : function(component, event, helper) {
		var caseRecId = component.get("v.recordId");
		var action = component.get("c.getCase");     
        action.setParams({
            caseId : caseRecId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue(); 
                if(result.Status == 'Pending Customer'){
                    component.set("v.isPendingCustomer",true);
                }
            }    
        });
        $A.enqueueAction(action);
	}
})