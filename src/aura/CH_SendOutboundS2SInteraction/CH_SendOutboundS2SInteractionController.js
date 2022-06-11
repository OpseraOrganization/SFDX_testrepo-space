({
	init: function(component, event, helper) {
		var s2sInteractionId = component.get("v.recordId");
		helper.sendOutboundS2SInteraction(component, s2sInteractionId);
	},
    closeErrorAlert: function (component, event, helper) {
        component.set("v.errorMessage", null);
    }
    
})