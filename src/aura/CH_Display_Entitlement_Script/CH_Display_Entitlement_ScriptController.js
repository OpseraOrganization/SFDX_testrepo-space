({
    doInit : function(component, event, helper) {
        // Get a reference to the getWeather() function defined in the Apex controller
		var action = component.get("c.getEntitlementScript");
        action.setParams({
            "caseId": component.get("v.recordId")
        });
        // Register the callback function
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
				component.set("v.scriptMap", response.getReturnValue());
			} else if (response.getState() === "ERROR") {
				$A.log("Errors", response.getError());
            }
        });
        // Invoke the service
        $A.enqueueAction(action);
    },
    hideComponent: function(component){
        component.set("v.Spinner", true);
        var caseId = component.get("v.recordId");
        var action = component.get("c.closeComponentMethod");
        action.setParams({caseId : caseId});
        action.setCallback(this,function(response){     
            component.set("v.Spinner", false);
            if (response.getState() == "SUCCESS") {
                $A.get('e.force:refreshView').fire();
            }
        }),
        $A.enqueueAction(action);
    }
    
})