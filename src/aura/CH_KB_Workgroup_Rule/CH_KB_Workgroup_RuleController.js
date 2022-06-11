({
    saveCompleted: function(component,event,helper){
        helper.closeConsoleTAB(component);
        // Display the status of the save                        
        var messageBox = component.find('messageBox'); 
        messageBox.displayToastMessage('Workgroup Rule is saved');
    },
    // When save on a user is clicked
    saveRule: function(component,event,helper){
        event.preventDefault();
        var fields = event.getParam("fields");
		fields["RecordTypeId"] = component.get("v.recordTypeId");
        component.find("kbworkgroupRuleForm").submit(fields);  
    },
    // When cancel is pressed
    cancel: function(component,event,helper){
        helper.closeConsoleTAB(component);
    },
})