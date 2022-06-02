({
	getExecSummaryPPT : function(component, event, helper) {        
        var action = component.get("c.getAccountAttachment");
        action.setCallback(this, function(a) {
            component.set("v.contents", a.getReturnValue()); 
        });        
        $A.enqueueAction(action);
	}
})