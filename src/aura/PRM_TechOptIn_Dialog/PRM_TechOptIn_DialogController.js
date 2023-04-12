({
    doInit : function(component, event, helper) {
        var action = component.get("c.getTechOptinChoice");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var user = response.getReturnValue();
                console.log(JSON.stringify(user));
                if(user){
                    if(user.ContactId && user.Contact.PRM_Tech_Squad_Eligible__c && !user.Contact.PRM_Tech_Squad_Opt_In__c){
                        component.set("v.isModalOpen", "slds-show");
                        component.set("v.contactId", user.ContactId);
                    }
                }
            }
        });

        $A.enqueueAction(action);
    },

    setChoice : function(component, event, helper) {
        var buttonPressed = event.getSource().get("v.name");
        console.log(buttonPressed);
        var contact = {"Id":component.get("v.contactId")};
        if(buttonPressed === "accept"){
            contact.PRM_Tech_Squad_Opt_In__c = "Yes";
        }
        else{
            contact.PRM_Tech_Squad_Opt_In__c = "No";
        }
        console.log(contact);

        var action = component.get("c.setTechOptinChoice");
        action.setParams({"con" : contact});
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(state+':'+JSON.stringify(response));
            if (state === "SUCCESS") {
                
                var response = response.getReturnValue();
                if(response === 'success'){
                    component.set("v.isModalOpen", "slds-hide");
                }
            }
            if (state === "ERROR"){
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });

        $A.enqueueAction(action);
    }
})