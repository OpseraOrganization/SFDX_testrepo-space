({
	getMileStoneData : function(component, event, helper) {
		var caseRecId = component.get("v.recordId");
		var action = component.get("c.getMilestoneDetails");     
        action.setParams({
            caseId : caseRecId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result =[];
                result = response.getReturnValue(); 
                component.set("v.mileStoneLst",result);
            }    
        });
        $A.enqueueAction(action);
	}
})