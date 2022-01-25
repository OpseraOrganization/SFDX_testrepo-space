({
	    sendOutboundS2SInteraction : function(component, s2sInteractionId) {
        var action = component.get("c.sendS2SInteraction");
        component.set("v.showSpinner", true);
        action.setParams({outboundS2SInteractionId : s2sInteractionId});
        action.setCallback(this, $A.getCallback(function (response) {
            component.set("v.showSpinner", false);
            var state = response.getState();
            if (state === "SUCCESS") {
                
              
                
                /*if(response.getReturnValue()=='errorValidation'){
                    console.error('This function is only available for failure outbound Customer S2S interface records');
                   component.set("v.errorMessageNew", 'This function is only available for failure outbound Customer S2S interface records');
                }else{*/
                    $A.get('e.force:refreshView').fire();
                    $A.get("e.force:closeQuickAction").fire();  
                //}
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