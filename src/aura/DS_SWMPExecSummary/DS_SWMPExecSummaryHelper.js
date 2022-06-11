({
	getExecSummaryPPT : function(component, event, helper) {        
        var action = component.get("c.getAccountAttachment");
        action.setCallback(this, function(a) {
            component.set("v.contents", a.getReturnValue()); 
            var contacts = component.get("v.contents");
           if(contacts === "NO URL"){
               component.set("v.contents",1);   
           }
        });        
        $A.enqueueAction(action);
	}
})