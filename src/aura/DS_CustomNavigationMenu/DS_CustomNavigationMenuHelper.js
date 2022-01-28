({
	helperMethod : function() {
	},
    
    gotoURL : function (component) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "https://networks.nokia.com/support"
        });
        urlEvent.fire();
    
    },
	getTileDetail : function(component, event, helper) {
        var action = component.get("c.getTiles");
        action.setCallback(this, function(response) {
            var state = response.getState();
           
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                component.set("v.tileService", results);
                
               // this.setStateDetermined(cmp);
            }
        });
        $A.enqueueAction(action);
	}
})