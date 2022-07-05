({
    doInit : function(component, event, helper)
    {
        component.set("v.Spinner", true); 
        helper.getWorkgroupMembers(component);
        component.set("v.Spinner", false);
    },
    Assign : function(component, event) {
        component.set("v.Spinner", true); 
        var assignmentType=component.get("v.assignmentType");
        var memId = event.getSource().get("v.value");
        var caseId = component.get("v.recordId");
        var action = component.get('c.updateSupportTicketOwner');
        action.setParams({memId : memId, caseId : caseId});
        action.setCallback(this,function(response){
            component.set("v.Spinner", false);
            if (response.getState() == "ERROR") {
                var errorMessage = 'undefined';
                var errors = response.getError();
                if (errors) {
                	if (errors[0] && errors[0].message) {
                   		errorMessage = errors[0].message;
                	}
                    else if (errors[0] && errors[0].pageErrors) {
                        errorMessage = errors[0].pageErrors[0].message;
                    }
            	}
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Case Assignment Error Occured',
                    message: 'Case is not assigned. Error: '+ errorMessage,
                    type : 'Error',
                    mode: 'sticky'
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);	
        $A.get('e.force:refreshView').fire();
    },
    hideComponent: function(component){
        component.set("v.Spinner", true);
        var caseId = component.get("v.recordId");
        var action = component.get("c.closeCompMethod");
        action.setParams({caseId : caseId});
        action.setCallback(this,function(response){     
            component.set("v.Spinner", false);
            if (response.getState() == "SUCCESS") {
                $A.get('e.force:refreshView').fire();
            }
        }),
        $A.enqueueAction(action);
    },
    //This function will open Cisco jabber window for the user to chat with engineer.
    Connect : function(component, event, helper)
    {
        var email=event.getSource().get("v.value");
        var ciscoLink='CISCOIM:'+email;
        location.href=ciscoLink;
    },
})