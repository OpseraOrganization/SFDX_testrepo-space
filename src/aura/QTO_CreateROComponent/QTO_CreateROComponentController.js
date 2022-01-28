({
	generateRO : function(component, event, helper) {
        component.set('v.Spinner', true);
		var roNumber = component.get('v.roNumber');
        var quoteId = component.get('v.recordId');
        
        console.log(roNumber, quoteId);
        
        if (roNumber == undefined || roNumber == '') {
            component.set('v.Spinner', false);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": 'Error',
                'type': 'error',
                "message": 'Please enter Risk Order number'
            });
            toastEvent.fire();
            
            return false;
        }
        
        var action = component.get('c.createRO'); 
        action.setParams({
            "roNumber" : roNumber,
            "quoteId" : quoteId
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('state', state);
            
            console.log(':::::::', response.getReturnValue());
            if(state == 'SUCCESS') {
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": response.getReturnValue()
                });
                component.set('v.Spinner', false);
                navEvt.fire();
            } else {
                component.set('v.Spinner', false);
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": 'Error',
                            'type': 'error',
                            "message": errors[0].message
                        });
                        toastEvent.fire();
                    }
                    
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
	},
    
    doInit : function(component, event, helper) {
        console.log('its coming');
        var action = component.get('c.retriveStatus'); 
        action.setParams({
            "quoteId" : component.get('v.recordId')
        });
        
        action.setCallback(this, function(response){
            console.log('response', response);
            console.log('response', response.getReturnValue());
            if (response.getReturnValue() == true) {
                console.log('its came');
                component.set('v.isApproved', true);
            } else {
                component.set('v.isApproved', false);
                
                var toastEvent = $A.get("e.force:showToast");
            	toastEvent.setParams({
                "title": 'Error',
                'type': 'error',
                "message": "RO can't be created"
            });
            toastEvent.fire();
            }
        });
        
        $A.enqueueAction(action);
    }
})