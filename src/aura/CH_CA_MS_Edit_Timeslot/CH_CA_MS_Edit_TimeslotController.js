({
    // Get the timeslot 
    doInit: function(component, event, helper) {
        component.set("v.Spinner", true);
        helper.refreshTimeslot(component)
        .then(function(result){
            helper.createTable(component, result.Workgroup_Member_Timeslot_Association__r);
            // If a new schedule needs to be created open the schedule section 
            if (component.get("v.timeslotId") == null){
                component.find("editTimeslot").set('v.activeSectionName', 'timeslotInfo');
                component.set('v.dataChanged', true);
            }
            // If there are timeslots open timelsots otherwise open the header
            if (component.get("v.timeslot").Workgroup_Member_Timeslot_Association__r == null){
                component.find("editTimeslot").set('v.activeSectionName', 'timeSlotInfo');
            }
            else {
                component.find("editTimeslot").set('v.activeSectionName', 'workgroupMembers');
            }
            
            component.set("v.Spinner", false);
        })
    },
    // Display a confirmation message before the delete
    confirmDelete: function(component, event, helper) {
        // Display confirmation message
        var message;
        var scheduleId = component.get("v.scheduleId");
        
            var buttonClickedId = event.getSource().getLocalId();
            switch (buttonClickedId) {
                case 'deleteTimeslotButton': {
                    message = 'Do you want to delete the timeslot?';
                    break;
                }
                case 'deleteTimeslotWorkgroupMembers': {
                    var tableId = helper.getTableId(component);
                    var selectedRows = $(tableId).DataTable().rows({ selected: true }).ids(false).toArray();
                    message = 'Do you want to delete ' + selectedRows.length + ' workgroup member' + (selectedRows.length > 1 ? 's?' : '?');
                    break;
                }
            }
            
            var messageBox = component.find('messageBox');        
            messageBox.displayModelMessage(buttonClickedId, true, false ,true ,message);
    },
    // Handle events from the messagebox button clicks
    handleMessageboxEvent: function(component, event, helper){        
        var popupButtonClicked = event.getParam("popupButtonClicked");
        var sourceButtonClicked = event.getParam("sourceButtonClicked");
      
        if (popupButtonClicked == 'delete'){
            var scheduleId = component.get('v.scheduleId');
            component.set("v.Spinner", true);
            switch (sourceButtonClicked) {
                case 'deleteTimeslotButton': {
                    helper.deleteTimeslot(component, scheduleId)
                    .then(function(result){
                        // Display the validation errors
                        var cmp = component.find('validateSchedule');
                        cmp.validateSchedule(scheduleId);
                        
                        // If save was successfull
                        if(result =='Timeslot Deleted'){
                            component.set('v.timeslot', null);
                            component.set('v.timeslotId', null);
                            helper.refreshTimeslot(component);
                            // Display the status of the save                        
                            var messageBox = component.find('messageBox'); 
                            messageBox.displayToastMessage('Timeslot is deleted');
                        }
                        // If an error occured during the save
                        else if (result.startsWith('An error')) {
                            var messageBox = component.find('messageBox'); 
                            messageBox.displayToastMessage('Timeslot could not be deleted ' + result, 'error');
                        }
                        // If a validation error occured
                        else{
                            var messageBox = component.find('messageBox'); 
                            messageBox.displayToastMessage('Schedule has validation errors and timeslot cannot be deleted','ERROR');        
                            
                            var validationResult = component.find('validateSchedule');
                            validationResult.set("v.warningMessage", result);
                        }
                    });   
                    break;
                }	
                case 'deleteTimeslotWorkgroupMembers': {
                    var status;
                    helper.deleteTimeSlotAssociations(component, scheduleId)
                    .then(function(result){
                        status = result;
                        return helper.refreshTimeslot(component);
                    })
                    .then(function(result){
                        // Display the validation errors
                        var cmp = component.find('validateSchedule');
                        cmp.validateSchedule(scheduleId);
                        
                        // To prevent errors in the datatable if there are no timeslost
                        if (result.Workgroup_Member_Timeslot_Association__r == null){
                            result.Workgroup_Member_Timeslot_Association__r = new Array();
                        }
                        var tableId = helper.getTableId(component);
                        $(tableId).DataTable().clear().rows.add(result.Workgroup_Member_Timeslot_Association__r).draw();  
                        // Disable the delete button
            			var button = component.find('deleteTimeslotWorkgroupMembers');
                		button.set('v.disabled',true);
                        // Display the status of the save
                        var messageBox = component.find('messageBox');
                        // If the delete was successfull
                        if(status.startsWith('Deleted')){
                            messageBox.displayToastMessage(status);
                        }                        
                        // If a validation error occured
                        else{
                            var messageBox = component.find('messageBox'); 
                            messageBox.displayToastMessage('Schedule has validation errors and timeslot members cannot be deleted','ERROR');        
                            
                            var validationResult = component.find('validateSchedule');
                            validationResult.set("v.warningMessage", status);
                        }
                    });
                    break;
                }
            }
			component.set("v.Spinner", false);            
        }
    },
    // Handle events from the messagebox button clicks
    handleAddMemberEvent: function(component, event, helper){        
        var buttonClicked = event.getParam("buttonClicked");               
        if (buttonClicked == 'Close'){
            component.set("v.Spinner", true);
            helper.refreshTimeslot(component)
            .then(function(result){
                // Display the validation errors
                var scheduleId = component.get("v.scheduleId");
                var cmp = component.find('validateSchedule');
                cmp.validateSchedule(scheduleId);
                
                component.set("v.Spinner", false);
                // To prevent errors in the datatable if there are no timeslost
                if (result.Workgroup_Member_Timeslot_Association__r == null){
                    result.Workgroup_Member_Timeslot_Association__r = new Array();
                }
                var tableId = helper.getTableId(component);
                $(tableId).DataTable().clear().rows.add(result.Workgroup_Member_Timeslot_Association__r).draw();  
            })            
        }
    },
    // On timeslot save make sure that the schedule id is filled in 
    timeslotSubmit: function(component, event, helper){
        event.preventDefault();
        // Validate that the start time is before the endtime
        var startTime = component.find("CH_Start_Time__c").get("v.value");
        var endTime = component.find("CH_End_Time__c").get("v.value");
		//Start Changes for 27751
       //if (startTime > endTime){
		   if ((startTime > endTime) && !endTime.includes('00:00:00.000')){
        	var messageBox = component.find('messageBox'); 
    	    messageBox.displayToastMessage('The start time needs to be less than the end time','ERROR');            
			return;
        }
        
        var appEvent = $A.get("e.c:CH_CA_MS_Child_Event");
        var oldTimeSlotId = component.get("v.timeslotId");
        component.set("v.Spinner", true);
    	var fields = event.getParam("fields");
        fields["CH_Workgroup_Schedule__c"] = component.get("v.scheduleId");
        fields["CH_Start_Time__c"] = component.find("CH_Start_Time__c").get("v.value");
        fields["CH_End_Time__c"] = component.find("CH_End_Time__c").get("v.value");
        fields["Id"] = component.get("v.timeslotId");
        var fieldsJSON = JSON.stringify(fields);
        helper.saveTimeslot(component, fieldsJSON)
        .then(function(result){
            // If no validation errors or the schedule is inactive 
            // then the schedule can be saved
            if (!result || !component.get("v.schedule").CH_Active__c){
                // Display the validation errors
                var scheduleId = component.get("v.scheduleId");
                var cmp = component.find('validateSchedule');
            	cmp.validateSchedule(scheduleId);
                
                var messageBox = component.find('messageBox'); 
    	        messageBox.displayToastMessage('Timeslot is saved');
                component.set("v.dataChanged", false);
                
                // If the save was successfull go back to the scheduke
                // page so that the ids are set correctly to add 
                // workgroup members
                // Maybe can be refactored
                if (!oldTimeSlotId) {
                    appEvent.setParams({"action" : 'timeslotBackButton',
                                        "scheduleId" : component.get("v.scheduleId"),
                                        "timeslotId" : component.get("v.timeslotId")});
                    appEvent.fire();
                }
	        }
            else{
	            var messageBox = component.find('messageBox'); 
    	        messageBox.displayToastMessage('Schedule has validation errors and timeslot cannot be saved','ERROR');        
                
                var validationResult = component.find('validateSchedule');
                validationResult.set("v.warningMessage", result);
            }
            component.set("v.Spinner", false);
        })
        .catch(result => {
	        var messageBox = component.find('messageBox'); 
    	    messageBox.displayToastMessage('An error occured timeslot is not saved. ' + result,'ERROR');        
            component.set("v.Spinner", false);
        });
    },
    // Add a new workgroup member to the timeslot
    addWorkgroupMembersToTimeSlot: function(component, event, helper){
        //alert('Will be done in another US');
        var modal = component.find('addMembersModal');        
        modal.displayAddMembersModal(component.get("v.timeslotId"));
    },
    // Validate the schedule
    validate: function(component, event, helper) {
        // If data has changed, stop the validation until the changes are saved 
        if(!component.get("v.dataChanged")){
            var scheduleId = component.get("v.scheduleId");
            var cmp = component.find('validateSchedule');
            cmp.validateSchedule(scheduleId);
        }
        else{
            var messageBox = component.find('messageBox'); 
            messageBox.displayToastMessage("The Schedule cannot be validated before saving updates on the form.","Error");
        }
    },
    // Event on all input elements that marks that data has changed
    // This is used to warn the user to save the data before a validate 
    handleChange: function(component, event, helper) {
        component.set("v.dataChanged", true);
    },
    // When the Home or Back button is clicked
    navigationClicked : function(component, event) {
        var buttonClicked = event.getSource().getLocalId();
        var appEvent = $A.get("e.c:CH_CA_MS_Child_Event");
        appEvent.setParams({"action" : buttonClicked,
        					"scheduleId" : component.get("v.scheduleId"),
                            "timeslotId" : component.get("v.timeslotId")});
        appEvent.fire();
    },
    // When a breadcrumb is clicked
    breadCrumbClicked : function(component, event) {
        var crumbName = event.getSource().get('v.name');

        var appEvent = $A.get("e.c:CH_CA_MS_Child_Event");
        appEvent.setParams({"action" : crumbName,
        					"scheduleId" : component.get("v.scheduleId"),
                            "timeslotId" : component.get("v.timeslotId")});
        appEvent.fire();
    },
})