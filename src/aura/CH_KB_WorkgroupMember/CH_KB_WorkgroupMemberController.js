({
    // When save on a user is clicked
    saveUser: function(component,event,helper){
        event.preventDefault();
        var fields = event.getParam("fields");
        var message = "";
        // Validate the input fields
        if (!fields["CH_User__c"]){
            message += "A User needs to be selected. ";
        }
        if (!fields["CH_Role__c"]){ 
            message += "A role needs to be selected. ";
        }
        if (!fields["CH_Workgroup__c"] && !component.get("v.recordId")){
            message += "A workgroup needs to be selected. ";
        }
        // If there is an error message
        if (message != ""){
            message = "User cannot be saved. \n" + message;
        	var messageBox = component.find('messageBox'); 
        	messageBox.displayToastMessage(message);
        }
        else{
            var userId = component.find("user").get("v.value");
            helper.getUserName(component,userId)
            .then(function(result){
            	fields["Name"] = result;
                fields["RecordTypeId"] = component.get("v.recordTypeId");
            	component.find("kbworkgroupMemberForm").submit(fields);  
            });
        }        
    },
    // When the user is loaded
    loadUser : function(component, event, helper) {
        // The refersh is needed to refresh the dependend picklist
        component.set("v.refresh", true);
        component.find("type").set("v.value","User");
    },
    saveCompleted: function(component,event,helper){
        helper.closeConsoleTAB(component);
        // Display the status of the save                        
        var messageBox = component.find('messageBox'); 
        messageBox.displayToastMessage('Workgroup member is saved');
    },
    // When cancel is pressed
    cancel: function(component,event,helper){
        helper.closeConsoleTAB(component);
    },
})