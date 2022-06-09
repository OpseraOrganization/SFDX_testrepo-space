({
    init: function(component, event, helper) {
		let suportTicket = new URL(window.location.href).searchParams.get("ticket");
        component.set('v.supportTicket',suportTicket);
        window.history.replaceState({}, document.title, "/customers/s/ch-public-survey");
    },
    callSurvey: function(component, event, helper) {
        var emailField = component.find("email");
        
        
        if(!component.get('v.supportTicket')){
        	component.set("v.errorMessage","The link is expired. Please open the link from your email");
        	return;
    	}
        if(emailField.get("v.validity").valid) {
            var action = component.get("c.callSurveyApex");
            action.setParams({
                supportTicket	:	component.get('v.supportTicket'),
                email			:	emailField.get('v.value')
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                
                if (state === "SUCCESS"){
                    let result = response.getReturnValue();
                    if(result === ''){
                        component.set("v.errorMessage","Sorry, that email is not authorised to complete this survey");
                    }else if(result == 'Completed'){
                        component.set("v.errorMessage","The Survey was already answered");
                    }else if(result == 'Expired'){
                        component.set("v.errorMessage","The Survey is already expired");
                    }else if(result == 'Started'){
                        component.set("v.errorMessage","The Survey is no longer available");
                    }
                    else window.location.href= result;
                }
                else console.log("Failed with error: " + JSON.stringify(response.getError()));
            });
            
            $A.enqueueAction(action);
        }
        else emailField.showHelpMessageIfInvalid();
	}
})