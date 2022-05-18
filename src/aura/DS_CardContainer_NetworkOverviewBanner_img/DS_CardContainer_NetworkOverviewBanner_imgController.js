({
	doInit : function(component, event, helper) {
		var action = component.get("c.getCurrentUserData");
        action.setCallback(this, function(a) {
            component.set("v.runningUser", a.getReturnValue()); 
        });
        $A.enqueueAction(action);
        helper.getIcon(component, event, helper);
	}    
})