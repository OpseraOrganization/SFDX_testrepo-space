({
    setDefaultOutboundRndInteractionProperties: function(component, event, helper) {
        helper.setDefaultValuesToOutboundRndInteraction(component);
        helper.setInboundRndInteractionValuesToOutboundRndInteraction(component);
	},
	
    openCase: function (component, event, helper) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.outboundRndInteraction").relatedRecordId
        });
        navEvt.fire();
    },
    
    save: function (component, event, helper) {
        var descValue = component.get("v.outboundRndInteraction.description");
        if(descValue != '' && descValue != undefined){
            helper.saveOutboundRndInteraction(component);
        } else {
            helper.errorHandler(component, [{message:"Description is a Required field."}]);
        }
    },

    send: function (component, event, helper) {
        var descValue = component.get("v.outboundRndInteraction.description");
        if(descValue != '' && descValue != undefined){
        	helper.sendOutboundRndInteraction(component);
        } else {
            helper.errorHandler(component, [{message:"Description is a Required field."}]);
        }
    },
	
    close: function (component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },

    closeErrorAlert: function (component, event, helper) {
        component.set("v.errorMessage", null);
    },    
})