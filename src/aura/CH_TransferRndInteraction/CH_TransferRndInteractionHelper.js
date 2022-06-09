({
	setDefaultValuesToOutboundRndInteraction : function(component) {
		var outboundRndInteraction = component.get("v.outboundRndInteraction");
		if (!outboundRndInteraction) {
            outboundRndInteraction = {};
        }
        outboundRndInteraction.transactionStatus = "In Progress";
        outboundRndInteraction.interactionType = "Transfer to R&D";
		outboundRndInteraction.direction = "Outbound";
        component.set("v.outboundRndInteraction", outboundRndInteraction);
	},

    setProblemValuesToOutboundRndInteraction : function(component) {
        component.set("v.showSpinner", true);
        var outboundRndInteraction = component.get("v.outboundRndInteraction");
        if(component.get("v.interfaceType") == 'pronto') {
            outboundRndInteraction.subject = "Create new PRONTO";
        } else
        if(component.get("v.interfaceType") == 'jira') {
            outboundRndInteraction.subject = "Create new JIRA";
        }
        var action = component.get("c.loadProblem");
        action.setParams({problemId : component.get("v.problemId")});

        action.setCallback(this, function(response) {
            component.set("v.showSpinner", false);
            var state = response.getState();
            if (state === "SUCCESS") {
                var problem = response.getReturnValue();
                if (problem.description) {
                    outboundRndInteraction.description = problem.description;
                }
                if (problem.interfaceName) {
                    outboundRndInteraction.interfaceName = problem.interfaceName;
                }
                outboundRndInteraction.relatedRecordId = component.get("v.problemId");
                component.set("v.outboundRndInteraction", outboundRndInteraction);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                this.errorHandler(component, errors);
            }
        });
        $A.enqueueAction(action);
    },

    closeModal : function(component) {
        component.destroy();
    },

    createOutboundRndInteraction : function(component) {
        var action = component.get("c.createRndInteraction");
        component.set("v.showSpinner", true);
        action.setParams({rndInteractionJson : JSON.stringify(component.get("v.outboundRndInteraction"))});
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                

                var rndInteractionId = response.getReturnValue();
                
                var action = component.get("c.sendCreateAnalysisRndInteraction");
                action.setParams({"outboundRndInteractionId" : rndInteractionId});
                action.setCallback(this, function(response) {
                    component.set("v.showSpinner", false);
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        var navEvt = $A.get("e.force:navigateToSObject");
                        navEvt.setParams({"recordId": rndInteractionId});
                        navEvt.fire();
                        var savedImEvent = $A.get("e.c:CH_CaseField_Problem_ReviewAndRemedy_Init");
                        savedImEvent.fire();
                        this.closeModal(component);
                    }
                    else if (state === "ERROR") {
                        var errors = response.getError();
                        this.errorHandler(component, errors);
                    }
                });
                $A.enqueueAction(action);
            } else if (state === "ERROR") {
                var errors = response.getError();
                this.errorHandler(component, errors);
            }
        }));

        $A.enqueueAction(action);
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