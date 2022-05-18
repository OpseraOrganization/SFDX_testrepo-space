({
    // Load the schedules for the current workgroup
    doInit: function(component, event, helper) {
        component.set("v.Spinner", true);
        window.setTimeout(
            $A.getCallback(function() {
                const sharedjs = component.find("sharedJavaScript");
                sharedjs.apex(component,'getLocale',{})
                .then(function(result){
                    component.set('v.userLocale', result);
                    return sharedjs.apex(component,'getSchedules',{ workgroupId : component.get("v.workgroupId") });
                })
                .then(function(result){
                    helper.createTable(component, result);
                    component.set("v.Spinner", false);
                });
            }), 3000
        );
        
    },
    // Display a confirmation message before the delete
    confirmDelete: function(component, event, helper) {
        // Display confirmation message
        var tableId = helper.getTableId(component);  
        var selectedRows = $(tableId).DataTable().rows({ selected: true }).ids(false).toArray();
        var message = 'Do you want to delete ' + selectedRows.length + ' schedule' + (selectedRows.length > 1 ? 's?' : '?');
        var buttonClickedId = event.getSource().getLocalId();
        var messageBox = component.find('messageBox');        
        messageBox.displayModelMessage(buttonClickedId, true, false, true, message);        
    },
    // Handle events from the messagebox button clicks
    handleMessageboxEvent: function(component, event, helper){
        var popupButtonClicked = event.getParam("popupButtonClicked");

        // The delete button was clicked then delete the selected schedules
        if (popupButtonClicked == 'delete'){
            component.set("v.Spinner", true);
            
            var status;
            helper.deleteSchedules(component)
            .then(function(result){
                status = result;

            	// Get the latest schedules from the server
            	const sharedjs = component.find("sharedJavaScript");
            	return sharedjs.apex(component,'getSchedules',{ workgroupId : component.get("v.workgroupId") });
            })
            .then(function(result){
                // Refresh the table
                var tableId = helper.getTableId(component);
                $(tableId).DataTable().clear().rows.add(result).draw();
                component.set("v.Spinner", false);
                // Disable the delete button
            	var button = component.find('deleteScheduleButton');
                button.set('v.disabled',true);
				//Start Changes for NOKIASC-32554
                // Disable the Clone Button
                var cloneButton = component.find('cloneButton');
                cloneButton.set('v.disabled',true);
                //End Changes for NOKIASC-32554
				//Start Changes for US-32736
                // Disable the Export Button
                var exportButton = component.find('exportButton');
                exportButton.set('v.disabled',true);
                //End Changes for US-32736
				//Disable the Validate Button
                var validatebutton = component.find('validateButton');
                validatebutton.set('v.disabled',true);
                // Display the status of the save
                var messageBox = component.find('messageBox'); 
                messageBox.displayToastMessage(status);
            });
        }
    },
    // Validate the selected schedules
    validate: function(component, event, helper) {
        var validateSchedule = component.find('validateSchedule');
        var tableId = helper.getTableId(component); 
        var selectedRows = $(tableId).DataTable().rows({ selected: true }).ids(false).toArray();
        validateSchedule.validateSchedule(selectedRows);
    },
    // Event to fire when the new button or the schedule link is clicked
    navigationClicked : function(component, event) {
        var buttonClicked = event.getSource().getLocalId();
        var appEvent = $A.get("e.c:CH_CA_MS_Child_Event");
        appEvent.setParams({"action" : buttonClicked,
        					"scheduleId" : component.get("v.scheduleId")});
        appEvent.fire();
    },
	
	 // Clone Functionality
    clone : function(component, event, helper) {
        component.set("v.isScheduleName", false);
        component.set("v.isScheduleFilterName", false);
        var tableId = helper.getTableId(component);
        var  selectedRows= $(tableId).DataTable().rows({ selected: true }).ids(false).toArray();
        if(selectedRows.length > 1){   
            var messageBox = component.find('messageBox'); 
            messageBox.displayToastMessage("You can not select more than one Schedule.","ERROR");
            
        }
        else{
            component.set("v.openClone", true);
        }
    },
    
    cloneSchedule:function(component, event, helper) {
        component.set("v.isScheduleName", false);
        component.set("v.isScheduleFilterName", false);
        var getScheduleName = component.find("name").get("v.value");
        var getFilterName = component.find("filtername").get("v.value");
        if (getScheduleName.trim() == "" || getScheduleName == null || getScheduleName == undefined) {
            component.set("v.isScheduleName", true);
        }
        if (getFilterName.trim() == "" || getFilterName == null || getFilterName == undefined) {
            component.set("v.isScheduleFilterName", true);
        }
        if(! component.get('v.isScheduleName') &&  !component.get('v.isScheduleFilterName')){
			component.set("v.openClone", false);
            component.set("v.Spinner", true);
            component.set("v.isScheduleName", false);
            component.set("v.isScheduleFilterName", false);
            helper.cloneSchedule(component)
            .then(function(result){
                // Get the latest schedules from the server
                const sharedjs = component.find("sharedJavaScript");
                return sharedjs.apex(component,'getSchedules',{ workgroupId : component.get("v.workgroupId") });
                
            })
            .then(function(result){
                // Refresh the table
                var tableId = helper.getTableId(component);
                $(tableId).DataTable().clear().rows.add(result).draw();
                component.set("v.Spinner", false);
                // Disable the delete button
                var button = component.find('deleteScheduleButton');
                button.set('v.disabled',true);
                // Disable the Clone Button
                var cloneButton = component.find('cloneButton');
                cloneButton.set('v.disabled',true);
				//Start Changes for US-32736
			   // Disable the Export Button
			   var exportButton = component.find('exportButton');
			   exportButton.set('v.disabled',true);
			   //End Changes for US-32736
                //Disable the Validate Button
                var validatebutton = component.find('validateButton');
                validatebutton.set('v.disabled',true);
                // Display the status of the save
                var messageBox = component.find('messageBox'); 
                messageBox.displayToastMessage(getScheduleName+' is cloned Succesfully.');
            }).catch(function(error) {
                const sharedjs = component.find("sharedJavaScript");
                sharedjs.apex(component,'getSchedules',{ workgroupId : component.get("v.workgroupId") })
                .then(function(result){
                    var tableId = helper.getTableId(component);
                    $(tableId).DataTable().clear().rows.add(result).draw();
                    helper.validateButtons(component,event,helper,"Inactive Products/Customers/Variant/Solution in the schedules filter. Please Correct","ERROR");  
                });
            });
        }
        
    },
    
    closeClone: function(component, event, helper) {
        component.set("v.openClone", false);
    },
	
	// Export Functionality
    export : function(component, event, helper) {
        component.set("v.openExport", true);
        component.find("exportSelection").set("v.value","TimeSlot");
    },
    
    closeExport: function(component, event, helper) {
        component.find("exportSelection").set("v.value","TimeSlot");
        component.set("v.openExport", false);
    },
	
	// Export the selected schedules
    exportSchedule: function(component, event, helper) {
        var gtSelectedValue = component.find("exportSelection").get("v.value");
        component.set("v.radioValue", gtSelectedValue);
        component.set("v.isRecordsExist", false);
        component.set("v.Spinner", true);
        component.set("v.openExport", false);
        helper.onLoad(component)
        .then(function(result){
            if( component.get("v.radioValue")=="TimeSlot"){
                component.set('v.listOfTimeSlot', result);
            }  
            else{
                component.set('v.listOfTimeSlotMembers', result); 
            }
            
        })
        .then(function(result){
            // Calling the helper function which "return" the CSV data as a String 
            var getFilterName = component.get("v.radioValue");
            if(getFilterName=="TimeSlot"){
                var getRecords = component.get("v.listOfTimeSlot");
                var csv = helper.convertTimeSlotObject(component,getRecords);  
            }  
            else{
                var getRecords = component.get("v.listOfTimeSlotMembers");
                var csv = helper.convertTimeSlotMembersObject(component,getRecords);   
            }
            component.set("v.value","TimeSlot");
            if (csv == null){
                component.set("v.isRecordsExist",true);
                return;
            } 
            // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####  
            var getCurrentDate = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
            var hiddenElement = document.createElement('a');
            hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
            hiddenElement.target = '_self'; // 
            if(component.get("v.radioValue")=="TimeSlot"){
                hiddenElement.download = 'Export TimeSlot_'+getCurrentDate+'.csv';  // CSV file Name* you can change it.[only name not .csv] 
                
            }  
            else{
                hiddenElement.download = 'Export TimeSlotMembers_'+getCurrentDate+'.csv';  // CSV file Name* you can change it.[only name not .csv] 
            }
            document.body.appendChild(hiddenElement); // Required for FireFox browser
            hiddenElement.click(); // using click() js function to download csv file
            // Get the latest schedules from the server
            const sharedjs = component.find("sharedJavaScript");
            return sharedjs.apex(component,'getSchedules',{ workgroupId : component.get("v.workgroupId") });
            
        })
        .then(function(result){
            if(!component.get("v.isRecordsExist")){
                // Refresh the table
                var tableId = helper.getTableId(component);
                $(tableId).DataTable().clear().rows.add(result).draw();
                helper.validateButtons(component,event,helper,'Data Exported Succesfully.',"SUCCESS");
            }
            else{
                component.set("v.Spinner", false);
                if(component.get("v.radioValue")=="TimeSlot"){
                    //Ref: NOKIASC-36332 Replaced Error Message With Custom Label
                    helper.showToast("ERROR","",$A.get("$Label.c.CH_Selected_Schedules_Dont_Have_Timeslot_Defined"));
                }  
                else{
                    //Ref: NOKIASC-36332 Replaced Error Message With Custom Label
                    helper.showToast("ERROR","",$A.get("$Label.c.CH_Selected_Schedules_Dont_Have_Timeslot_Members_Defined"));
                }
            }
        });        
    },
	
	  //Import the schedule    
    import: function(component, event, helper) {
        component.set("v.openImport", true);
        component.find("importSelection").set("v.value","TimeSlot");
    },
    
    closeImport: function(component, event, helper) {
        component.set("v.openImport", false);
        component.find("importSelection").set("v.value","TimeSlot");
    },
    
    //Import the Selected File
    uploadbutton : function(component, event, helper) {
        component.set("v.isColumnError",false);
        component.set("v.openImport", false);
        component.set("v.Spinner", true);
        event.stopPropagation();
        event.preventDefault();
        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        var gtSelectedValue = component.find("importSelection").get("v.value");
        component.set("v.radioValue", gtSelectedValue);
        if( component.get("v.radioValue")=="TimeSlot"){
            helper.readTimeSlotFile(component,helper,event.getSource().get("v.files")[0]);
        }  
        else{
            helper.readTimeSlotMembersFile(component,helper,event.getSource().get("v.files")[0]);
        }
        
    },
    
})