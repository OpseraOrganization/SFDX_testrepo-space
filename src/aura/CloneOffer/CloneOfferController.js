({
    recordDataUpdated : function(component, event, helper){
       var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED") {
            if(component.get("v.offerRecord.Opportunity__r.Business_Type__c") === $A.get("$Label.c.Fast_Track_Oppty_Type") ){
                helper.fastTrackOppty(component, event, helper);
            } else {
                component.set("v.showPopup", true); 
            }
        } else if(eventParams.changeType === "ERROR") {
            console.log(component.get("v.recordLoadError"));
            helper.errorHandler(component, event, helper);
        } 
    },
    
    
    clone : function(component, event, helper){
        component.set("v.Spinner", true); 
        var recordId = component.get("v.recordId")
        var action = component.get("c.getCloneOffer");
        action.setParams({"recordId": recordId});
        action.setCallback(this, function(response){
            var state = response.getState();
            $A.get("e.force:closeQuickAction").fire()
            if (component.isValid() && state === "SUCCESS")
            {
                var returned =response.getReturnValue();   
                var warningLabel = $A.get("$Label.c.AccessDenied");
                var successLabel = $A.get("$Label.c.Offer_Clone");
                var showToast = $A.get('e.force:showToast');
                if(returned.includes(' '))
                {
                    showToast.setParams(
                        {
                            'message': returned,
                            'type' : 'warning',
                            'duration' : 10000
                        }
                    ); 
                    
                    showToast.fire(); 
                }
                else
                {
                    showToast.setParams(
                        {
                            'message': successLabel,
                            'type' : 'success',
                            'duration' : 10000
                        }
                    ); 
                    
                    showToast.fire();
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": returned,
                        "slideDevName": "related"
                    });
                    navEvt.fire();
                }
                
            }
            
            component.set("v.Spinner", false);
        });
        $A.enqueueAction(action);       
    },
    
    closePopUp : function(component, event, helper){
        $A.get("e.force:closeQuickAction").fire();
    }
})