({
	
    // When a save is complete display a message
    saveCompleted: function(component,event,helper){
       // helper.closeConsoleTAB(component);
        // Display the status of the save                        
        var messageBox = component.find('messageBox'); 
        //messageBox.displayToastMessage('Workgroup outage is saved');
        messageBox.displayToastMessage('Saved');
    },
	handleSubmit : function(component, event, helper) {
        event.preventDefault();       // stop the form from submitting
        const fields = event.getParam('fields');
        var ValidateMinimalReactionTime=fields.CH_Minimal_Reaction_Time__c;
        if(ValidateMinimalReactionTime<0 || ValidateMinimalReactionTime >480 ||ValidateMinimalReactionTime ==='undefined' ||ValidateMinimalReactionTime ===null){
            var messageBox = component.find('messageBox'); 
            //messageBox.displayToastMessage('Workgroup outage is saved');
            messageBox.displayToastMessage('The Minimal Reaction Time value is out of the authorized range [0;480]',"Error");
        }
        else{
            component.find('recMinimalReactionTime').submit(fields);
        }
         
    },
})