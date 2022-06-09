({
    deleteOutboundRndInteraction : function(component, rndInteractionId) {
        var action = component.get("c.deleteRndInteraction");
        component.set("v.showSpinner", true);
        action.setParams({outboundRndInteractionId : rndInteractionId});
        action.setCallback(this, $A.getCallback(function (response) {
            component.set("v.showSpinner", false);
            var state = response.getState();
            if (state === "SUCCESS") {
                $A.get("e.force:closeQuickAction").fire();
                
				var workspaceAPI = component.find("workspace");
        		workspaceAPI.getFocusedTabInfo().then(function(response) {
            		var focusedTabId = response.tabId;
            		workspaceAPI.closeTab({tabId: focusedTabId});
        		}).catch(function(error) {
            		console.error(error);
        		});
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
            if (errors[0]) {
                if (errors[0].message) {
                    error = "Error message: " + errors[0].message;
                } else {
                    if (errors[0].pageErrors && errors[0].pageErrors[0] && errors[0].pageErrors[0].message) {
                        error = "Error message: " + errors[0].pageErrors[0].message;
                    }
                }
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