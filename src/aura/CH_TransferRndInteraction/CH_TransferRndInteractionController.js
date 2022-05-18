({
    setDefaultOutboundRndInteractionProperties: function(component, event, helper) {
        helper.setDefaultValuesToOutboundRndInteraction(component);
        helper.setProblemValuesToOutboundRndInteraction(component);
	},
	
    openCase: function (component, event, helper) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.outboundRndInteraction").relatedRecordId
        });
        navEvt.fire();
    },
    
    proceed: function (component, event, helper) {
        helper.createOutboundRndInteraction(component);
    },
	
    close: function (component, event, helper) {
        helper.closeModal(component);
    },

    closeErrorAlert: function (component, event, helper) {
        component.set("v.errorMessage", null);
    },    
})