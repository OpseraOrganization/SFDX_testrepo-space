({
    init : function(component, event, helper){
        //console.log("entra init");
        var action = component.get("c.getRelatedEvent");
		
        action.setParams({
            recordId : component.get("v.recordId")
        });
        
        action.setCallback(this, function(response){
            var result = JSON.parse(response.getReturnValue());
            var recordId = component.get("v.recordId");
            component.set("v.stakeholder.Event__c", result.eventId);
            if (result.isSession == 'TRUE')
            {
                component.set("v.stakeholder.Session__c",recordId);
                component.set("v.isSession",true);
            }            	
            else
            {
                component.set("v.stakeholder.Participant__c",recordId);   
                component.set("v.isParticipant",true);
            }                                       
        })
        $A.enqueueAction(action);
    },
    save: function(component, event, helper){
        if(!component.get("v.showSpinner")) {
        	component.set("v.showSpinner",true);
            var stakeholder = component.get("v.stakeholder");
            if((stakeholder.Session__c === "" || stakeholder.Session__c == null)||(stakeholder.Participant__c === "" || stakeholder.Participant__c == null))
            {
                component.set("v.isEmptyField",true)
                component.set("v.errorMessage","Required(*) fields must be completed.");
                component.set("v.showSpinner",false);
                return;
            }        
            var action = component.get("c.saveStakeholderRecord"); 
            
            action.setParams({
                stakeholderRecord : component.get("v.stakeholder")
            });
            action.setCallback(this, function(response){
                var result = response.getReturnValue();
                var state = response.getState();
                if (state === 'SUCCESS'){
                    if(result == null) helper.showToast('error', 'Error', "No permissions to create this stakeholder");
                    else $A.get('e.force:refreshView').fire();
                    $A.get("e.force:closeQuickAction").fire();
                }
            })
            $A.enqueueAction(action);
        }
    },
    cancel: function(component, event, helper){
        $A.get("e.force:closeQuickAction").fire();	
    }
});