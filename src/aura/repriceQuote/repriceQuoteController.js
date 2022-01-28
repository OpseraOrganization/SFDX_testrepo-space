({
	doInit : function(component, event, helper) {
		
        var action = component.get("c.submitForReprice");
        
        action.setParams({
            "recordIdVar": component.get("v.recordId"),            
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('state--->'+state);
            
            if(state === "SUCCESS"){
                var returnMessage = response.getReturnValue();
                component.set("v.returnMsg",returnMessage);
                component.set("v.Spinner",false);
            }
        });
        
        $A.enqueueAction(action);
	},
    
    removeCSS : function(component, event, helper){
    	$A.get("e.force:closeQuickAction").fire();
	}
})