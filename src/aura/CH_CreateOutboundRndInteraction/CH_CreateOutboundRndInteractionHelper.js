({
	setDefaultValuesToOutboundRndInteraction : function(component) {
		var outboundRndInteraction = component.get("v.outboundRndInteraction");
		if (!outboundRndInteraction) {
            outboundRndInteraction = {};
        }
		outboundRndInteraction.direction = "OUTBOUND";
        outboundRndInteraction.transactionStatus = "Open";
        outboundRndInteraction.relatedRndInteractionId = component.get("v.inboundRndInteractionId");
        component.set("v.outboundRndInteraction", outboundRndInteraction);
	},

    setInboundRndInteractionValuesToOutboundRndInteraction : function(component) {
        component.set("v.showSpinner", true);
        var action = component.get("c.loadInboundRndInteraction");
        action.setParams({inboundRndInteractionId : component.get("v.inboundRndInteractionId")});

        action.setCallback(this, function(response) {
            component.set("v.showSpinner", false);
            var state = response.getState();
            if (state === "SUCCESS") {
				var inboundRndInteraction = response.getReturnValue();
				var outboundRndInteraction = component.get("v.outboundRndInteraction");
				if (inboundRndInteraction.relatedRecordNumber) {
					outboundRndInteraction.relatedRecordNumber = inboundRndInteraction.relatedRecordNumber;
                }
				if (inboundRndInteraction.relatedRecordId) {
					outboundRndInteraction.relatedRecordId = inboundRndInteraction.relatedRecordId;
                }
				if (inboundRndInteraction.rndReference) {
					outboundRndInteraction.rndReference = inboundRndInteraction.rndReference;
                }

                component.set("v.outboundRndInteraction", outboundRndInteraction);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                this.errorHandler(component, errors);
            }
        });
        $A.enqueueAction(action);
    },

    saveOutboundRndInteraction : function(component) {
        this.createOutboundRndInteraction(component, false);
    },

    sendOutboundRndInteraction : function(component) {
        this.createOutboundRndInteraction(component, true);
    },

    createOutboundRndInteraction : function(component, isSending) {
        var action = component.get("c.createRndInteraction");
        component.set("v.showSpinner", true);
        action.setParams({rndInteractionJson : JSON.stringify(component.get("v.outboundRndInteraction"))});
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var rndInteractionId = response.getReturnValue();
                if (isSending) {
                    this.processOutboundRndInteraction(component, rndInteractionId);
                } else {
                    component.set("v.showSpinner", false);
                    this.navigateToOutboundRndInteraction(rndInteractionId);
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                this.errorHandler(component, errors);
                component.set("v.showSpinner", false);
            }
        }));

        $A.enqueueAction(action);	
    },

    processOutboundRndInteraction : function(component, rndInteractionId) {
        var action = component.get("c.sendRndInteraction");
        component.set("v.showSpinner", true);
        action.setParams({outboundRndInteractionId : rndInteractionId});
        action.setCallback(this, $A.getCallback(function (response) {
            component.set("v.showSpinner", false);
            var state = response.getState();
            if (state === "SUCCESS") {
                this.navigateToOutboundRndInteraction(response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                this.errorHandler(component, errors);
            }
        }));

        $A.enqueueAction(action);	
    },

    navigateToOutboundRndInteraction : function(rndInteractionId) {
        $A.get("e.force:closeQuickAction").fire();
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": rndInteractionId
        });
        navEvt.fire();
    },

    errorHandler : function(component, errors) {
        var error = "";
        if (errors) {
            if (errors[0] && errors[0].message) {
                error = "Error message: " + errors[0].message;
            }
        }
        if (!error) {
            if (errors) {
                error = "Unknown error: " + JSON.stringify(errors);
            } else {
                error = "Unknown error.";
            }
        }
        console.error(error);
        component.set("v.errorMessage", error);
    }
})