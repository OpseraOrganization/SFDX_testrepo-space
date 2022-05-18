({
	getIcon : function(component, event, helper) {        
        var action = component.get("c.getAccountAttachment");
        console.log('action>>'+action);
        action.setCallback(this, function(a) {
            console.log('action>>inside');
            component.set("v.contents", a.getReturnValue()); 
            console.log('action>>inside'+a.getReturnValue());
            
        });        
        $A.enqueueAction(action);
	}
})