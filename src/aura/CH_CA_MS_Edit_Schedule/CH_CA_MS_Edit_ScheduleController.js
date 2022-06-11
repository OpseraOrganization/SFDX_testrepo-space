({
    doInit : function(component, event, helper) {
        component.set("v.Spinner", true);
		// PRB0017989
		const sharedjs = component.find("sharedJavaScript");
        sharedjs.apex(component,'getLocale',{})
        .then(function(result){
            component.set('v.userLocale', result);
        })
        helper.refreshSchedule(component)
        .then(function(result){
            helper.createTable(component, result.Workgroup_Schedule_Timeslots__r);
            // If a new schedule needs to be created open the schedule section 
            if (component.get("v.scheduleId") == null){
                component.find("editSchedule").set('v.activeSectionName', 'scheduleInfo');
                component.set('v.dataChanged', true);
            }
            // If there are timeslots open timelsots otherwise open the header
            if (component.get("v.schedule").Workgroup_Schedule_Timeslots__r == null){
                component.find("editSchedule").set('v.activeSectionName', 'scheduleInfo');
            }
            else {
                component.find("editSchedule").set('v.activeSectionName', 'timeSlots');
            }

            component.set("v.Spinner", false);
        })  
    },  
    // Display a confirmation message before the delete
    confirmDelete: function(component, event, helper) {
        // Display confirmation message
        var message;
        
        var buttonClickedId = event.getSource().getLocalId();
        switch (buttonClickedId) {
            case 'deleteScheduleButton': {
                message = 'Do you want to delete the schedule?';
                break;
            }
            case 'deleteFilterButton': {
                message = 'Do you want to delete the filter?';
                break;
            }
            case 'deleteTimeslotButton': {
                var tableId = helper.getTableId(component);
                var selectedRows = $(tableId).DataTable().rows({ selected: true }).ids(false).toArray();
        		message = 'Do you want to delete ' + selectedRows.length + ' timeslot' + (selectedRows.length > 1 ? 's?' : '?');
                break;
            }
        }
        
        var messageBox = component.find('messageBox');        
        messageBox.displayModelMessage(buttonClickedId, true, false ,true ,message);
    },   
    // Handle events from the delete messagebox button clicks
    handleMessageboxEvent: function(component, event, helper){        
        var popupButtonClicked = event.getParam("popupButtonClicked");
        var sourceButtonClicked = event.getParam("sourceButtonClicked");
                
        if (popupButtonClicked == 'delete'){
            component.set("v.Spinner", true);
            switch (sourceButtonClicked) {
                case 'deleteScheduleButton': {
                    helper.deleteSchedule(component)
                    .then(function(result){
                        component.set('v.schedule', null);
                        component.set('v.scheduleId', null);
                        helper.refreshSchedule(component);
                    })
                    .then(function(result){
                        // Display the status of the save                        
                    	var messageBox = component.find('messageBox'); 
        				messageBox.displayToastMessage('Schedule is deleted');
                    });
                    break;
                }	
                case 'deleteFilterButton': {
                    helper.deleteFilter(component)
                    .then(function(result){
                        component.set('v.filter', null);
                        helper.refreshSchedule(component);
                    })
                    .then(function(result){
                        // Display the validation errors
                        var scheduleId = component.get("v.scheduleId");
                        var cmp = component.find('validateSchedule');
                        cmp.validateSchedule(scheduleId);
                        
                        // Display the status of the save
                    	var messageBox = component.find('messageBox'); 
        				messageBox.displayToastMessage('Filter is deleted');
                    });
                    break;
                }
                case 'deleteTimeslotButton': {
                    var status;
                    helper.deleteTimeSlots(component)
                    .then(function(result){
                        status = result;
                        return helper.refreshSchedule(component);
                    })
                    .then(function(result){
                        // Display the validation errors
                        var scheduleId = component.get("v.scheduleId");
                        var cmp = component.find('validateSchedule');
                        cmp.validateSchedule(scheduleId);
                        
                        // To prevent errors in the datatable if there are no timeslost
                        if (result.Workgroup_Schedule_Timeslots__r == null){
                            result.Workgroup_Schedule_Timeslots__r = new Array();
                        }
                        var tableId = helper.getTableId(component);
                        $(tableId).DataTable().clear().rows.add(result.Workgroup_Schedule_Timeslots__r).draw();  
                        // Disable the delete button
            			var button = component.find('deleteTimeslotButton');
                		button.set('v.disabled',true);
                        // Display the status of the save
                        var messageBox = component.find('messageBox');
                        if(status.includes('Deleted 0'))
                        	messageBox.displayToastMessage(status, 'error');
                        else{
                            messageBox.displayToastMessage(status);
                        }
                    });
                    break;
                }
            }
            
			component.set("v.Spinner", false);            
        }
    },
    // After a filter save, refresh the filter and display success message    
    savedFilter : function(component, event, helper){
        // Refresh the UI
        component.set("v.Spinner", true);
        // Save the related lists for the products and customers
        helper.saveFilterRelatedLists(component)
        .then(function(result){
            // Display the validation errors
            var scheduleId = component.get("v.scheduleId");
            var cmp = component.find('validateSchedule');
            cmp.validateSchedule(scheduleId);
            
            component.set("v.Spinner", false);
        	var messageBox = component.find('messageBox'); 
        	messageBox.displayToastMessage('Filter is saved');
            component.set("v.dataChanged",false);
			helper.refreshSchedule (component);
        })
        .catch(result => {
	        var messageBox = component.find('messageBox'); 
    	   //Ref: NOKIASC-36332 Replaced Error Message With Custom Label
    	    messageBox.displayToastMessage($A.get("$Label.c.CH_Filter_Not_Saved") + result,'ERROR');        
            component.set("v.Spinner", false);
        });
    },        
    // On schedule save make sure that the workgroup id is filled in 
    scheduleSubmit : function(component, event, helper){
		event.preventDefault();        
        component.set("v.Spinner", true);
       //Group all the fields aura ids 
        var controlAuraIds = ["startDateField","CH_Start_Time__c","enddatefield","CH_End_Time__c"];
        //reducer function iterates over the array and return false if any of the field is invalid otherwise true.
        let isAllValid = controlAuraIds.reduce(function(isValidSoFar, controlAuraId){
            //fetches the component details from the auraId
            var inputCmp = component.find(controlAuraId);
            var value = inputCmp.get("v.value");
            // is input valid text?
            if (value === ""||value === "undefined"||value === null) {
                inputCmp.setCustomValidity("Complete this field.");
                component.set("v.Spinner", false);
            } else {
                inputCmp.setCustomValidity(""); 
            }
            //displays the error messages associated with field 
            inputCmp.reportValidity();
            //form will be invalid if any of the field's valid property value is false.
            return isValidSoFar && inputCmp.checkValidity();
        },true);
        
        //check if the input value is valid if yes the proceed to save/edit
        if(isAllValid){
            var startTime = component.find("CH_Start_Time__c").get("v.value");
            var endTime = component.find("CH_End_Time__c").get("v.value");
            var startDate = component.find("startDateField").get("v.value");
            var endDate = component.find("enddatefield").get("v.value");
            if ((endDate<=startDate) &&(endTime<=startTime)){
                var messageBox = component.find('messageBox'); 
                 //Ref: NOKIASC-36332 Replaced Error Message With Custom Label
                messageBox.displayToastMessage($A.get("$Label.c.CH_End_Date_Later_Than_Start_Date"),'ERROR');
                component.set("v.Spinner", false);
                return;
            }
        var appEvent = $A.get("e.c:CH_CA_MS_Child_Event");
        var oldScheduleId = component.get("v.scheduleId");
        component.set("v.Spinner", true);
    	event.preventDefault();            
        var fields = event.getParam("fields");
    	fields["CH_Workgroup__c"] = component.get("v.workgroupId");
        fields["Id"] = component.get("v.scheduleId");
        var fieldsJSON = JSON.stringify(fields);
        helper.saveSchedule(component, fieldsJSON)
        .then(function(result){
            // The save result is a map <scheduleId, errormessage>
            var map = result;
            var errorMessage;
            var scheduleId = Object.keys(map)[0];
            component.set("v.scheduleId",scheduleId);
            errorMessage = map[scheduleId];
            return errorMessage;
        })
        .then(function(result){
            // If no validation errors or the schedule is inactive 
            // then the schedule can be saved
            if (!result || !component.find("active").get("v.value")){
                // Display the validation errors
                var scheduleId = component.get("v.scheduleId");
                var cmp = component.find('validateSchedule');
            	cmp.validateSchedule(scheduleId);
                
                var messageBox = component.find('messageBox'); 
    	        messageBox.displayToastMessage('Schedule is saved'); 
                component.set("v.dataChanged",false);
                
                // When creating a new schedule you need to go back to the schedule list
                // so that Ids are loaded corrcelty to create a filter. 
                // This is not needed for updates.
                // When scheduleId is null, so a new schedule
                // Maybe can be refactored
                if (!oldScheduleId){
                    appEvent.setParams({"action" : 'scheduleBackButton',
                                        "scheduleId" : component.get("v.scheduleId"),
                                        "timeslotId" : component.get("v.timeslotId")});
                    appEvent.fire();
                }
            }
            else{
	            var messageBox = component.find('messageBox'); 
    	         //Ref: NOKIASC-36332 Replaced Error Message With Custom Label
    	        messageBox.displayToastMessage($A.get("$Label.c.CH_Schedule_Has_Errors"),'ERROR');        
                var validationResult = component.find('validateSchedule');
                validationResult.set("v.warningMessage", result);
            }
            component.set("v.Spinner", false);
        })
        .catch(result => {
	        var messageBox = component.find('messageBox'); 
    	    //Ref: NOKIASC-36332 Replaced Error Message With Custom Label
    	    messageBox.displayToastMessage( $A.get("$Label.c.CH_Timeslot_Not_Saved")+ result,'ERROR');        
            component.set("v.Spinner", false);
        });
	 }
    },
    // On filter save make sure that the schedule id is filled in 
    filterSubmit : function(component, event, helper){
    	event.preventDefault();
        var fields = event.getParam("fields");
    	fields["CH_Workgroup_Schedule__c"] = component.get("v.scheduleId");
    	component.find("filterViewForm").submit(fields);
    },
    // Event fired when a record is selected
    selectRecord : function(component, event, helper){
       var selectedRecord = event.getParam("record");
        var variableName;
        var displayNoItemsMessage;
        if (event.getParam("objectName") == "Product2"){
            variableName = "v.filterProducts";
            displayNoItemsMessage = "v.noFilterProducts";
        }
        if (event.getParam("objectName") == "Account"){
            variableName = "v.filterCustomers";
            displayNoItemsMessage = "v.noFilterCustomers";
        }
        var pillItems = component.get(variableName);
        pillItems.push({relatedObjectId: selectedRecord.value, 
                        filterId: component.get("v.filter").Id,
                        label: selectedRecord.label, 
                        deleted: false});
        component.set(variableName, pillItems);
        component.set(displayNoItemsMessage, false);        
    },
    // When the cross on the pill is clicked remove the pill from the UI
    pillRemove: function(component, event, helper){
        var componentId = event.getSource().getLocalId();
        var variableName;
        var displayNoItemsMessage;
        if (event.getSource().getLocalId() == "productPillContainer"){
            variableName = "v.filterProducts";
            displayNoItemsMessage = "v.noFilterProducts";
        }
        else {
            variableName = "v.filterCustomers";
            displayNoItemsMessage = "v.noFilterCustomers";
        }
        
        // Remove the pill from view
        var selectedPillrelatedObjectId = event.getSource().get('v.name');
        var pillItems = component.get(variableName);
        pillItems.forEach(function(pill) {
            if (pill.relatedObjectId == selectedPillrelatedObjectId){
                pill.deleted = true;
        	}
        });
        component.set(variableName, pillItems);
        //component.set(displayNoItemsMessage, pillItems.filter(function(item){item.deleted==false}).length == 0);
		var isLength=[];
        for(var i=1;i<pillItems.length;i++){
            var getAPI =  pillItems.filter(function(item) {
                if(item.deleted == false){
                    isLength.push(item.deleted);
                }
            });
        }
        var isdeleted=isLength.length != 0 ? false:true;
        component.set(displayNoItemsMessage,isdeleted);
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
            //Ref: NOKIASC-36332 Replaced Error Message With Custom Label
            messageBox.displayToastMessage($A.get("$Label.c.CH_Schedule_Cannot_Be_Validated_Before_Saving_Updates"),"Error");
        }
    },
    // Event on all input elements that marks that data has changed
    // This is used to warn the user to save the data before a validate 
    handleChange: function(component, event, helper) {
        var oldValue = component.get("v.oldOutageValue");
        //var newValue = component.get("v.outage");
		var newValue = component.find("outage").get("v.value");//28410
		var oldLevelOfSupportValue = component.get("v.oldLevelOfSupportValue");//28410
        //var newLevelOfSupportValue = component.get("v.levelofsupport");//28410
		var newLevelOfSupportValue =  component.find("levelofsupport").get("v.value");//28410
        var inputChanged = event.getSource().getLocalId();
        // If the outage oldvalue = "" and the new value = ""
        // Then the --None-- value is loaded and then ignore the dataChanged flag
        if (inputChanged == "outage" &&
            component.get("v.scheduleId") != null &&
           ((oldValue == newValue) || // Initial loading of schedule with filter with no severity (--None--)
            (oldValue == '' && newValue === undefined)||(oldValue === undefined && newValue =='')||(oldValue === null && newValue ==''))){ // Intial load of schedule without filter
            component.set("v.dataChanged", false);
            component.set("v.oldOutageValue", component.find("outage").get("v.value"));
        }
		else if ((inputChanged == "levelofsupport") && // prod issue 28410
            component.get("v.scheduleId") != null &&
            ((oldLevelOfSupportValue == newLevelOfSupportValue) || // Initial loading of schedule with filter with no severity (--None--)
             (oldLevelOfSupportValue == '' && newLevelOfSupportValue === undefined)||(oldLevelOfSupportValue === undefined && newLevelOfSupportValue == '')||(oldLevelOfSupportValue === null && newLevelOfSupportValue == ''))){ // Intial load of schedule without filter
            component.set("v.dataChanged", false);
            component.set("v.oldLevelOfSupportValue", component.find("levelofsupport").get("v.value"));
        }
        else {
            component.set("v.dataChanged", true);
        }
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
	onLoad : function(component, event) {
         component.set("v.oldOutageValue", component.find("outage").get("v.value"));
         component.set("v.oldLevelOfSupportValue", component.find("levelofsupport").get("v.value"));
    },

})