({
	
    doInit : function(component, event, helper) {
        console.log('its coming');
        var action = component.get('c.quoteStatus'); 
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
    },
    
    handleOnSubmit : function(component, event, helper) {
        //component.set('v.loading', true);
        event.preventDefault();
        var eventFields = event.getParam("fields");
        var agrementRecId = eventFields['Agreement_Lookup__c'];
        var cusDocId = eventFields['Nokia_Customer_Document_ID__c'];
        var action = component.get("c.createAgreementLines");
        var quoteId = component.get('v.recordId');
        //alert('selected agrementRecId-->'+agrementRecId);
        //alert('quoteId-->'+quoteId);
        //alert('cusDocId-->'+cusDocId);
        action.setParams({ 
                agrId : agrementRecId,
            	quoteId : quoteId,
                cusDocId : cusDocId
            });
        action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    // $A.get("e.force:closeQuickAction").fire(); 
                    var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                        "title": 'Success',
                        'type': 'success',
                        "message": "Agreement Line Items created."
                    });
                    toastEvent.fire();
                    
                    var navEvt = $A.get("e.force:navigateToSObject");
                        navEvt.setParams({
                          "recordId": agrementRecId,
                          "slideDevName": "related"
                        });
                        navEvt.fire();
                }  
            });
        $A.enqueueAction(action);
	},
    handleLoad: function(component, event, helper) {
        component.set('v.loading', false);
    }
})