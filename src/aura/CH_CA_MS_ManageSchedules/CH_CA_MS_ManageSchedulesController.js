({
	handleChildEvent : function(component, event, helper) {
	
        var action = event.getParam("action");
        var scheduleId = event.getParam("scheduleId");
        var timeslotId = event.getParam("timeslotId");
        var elem = component.getElement();
        if (elem && elem.offsetParent !== null) {
            // event handling logic here
            // If in List Schedules the new schedule button was clicked
            if (action == "newScheduleButton" ||
                action == "ListSchedules" ){
                component.set("v.scheduleId",scheduleId);
                component.set("v.timeslotId",null);
                // Display the correct component
                component.set("v.displayScheduleList",false);
                component.set("v.displayEditSchedule",true);
                component.set("v.displayEditTimeslot",false);
            }
            // if in the edit schedule the back, home button are clicked
            if(action == "scheduleBackButton" || 
               action == "scheduleHomeButton" ||
			   action == "scheduleHomeCrumb"){
                //component.set("v.scheduleId",null);
                component.set("v.timeslotId",null);
                // Display the correct component
                component.set("v.displayScheduleList",true);
                component.set("v.displayEditSchedule",false);
                component.set("v.displayEditTimeslot",false);            
            }
            //
            if(action == "newTimeslotButton" ||
               action == "EditSchedule" ){
                component.set("v.scheduleId",scheduleId);
                component.set("v.timeslotId",timeslotId);
                // Display the correct component
                component.set("v.displayScheduleList",false);
                component.set("v.displayEditSchedule",false);
                component.set("v.displayEditTimeslot",true);
            }
            //
            if(action == "timeslotBackButton"){
                component.set("v.scheduleId",scheduleId);
                component.set("v.timeslotId",null);
                // Display the correct component
                component.set("v.displayScheduleList",false);
                component.set("v.displayEditSchedule",true);
                component.set("v.displayEditTimeslot",false);            
            }
            //
            if(action == "timeslotHomeButton"){
                component.set("v.scheduleId",null);
                component.set("v.timeslotId",null);
                // Display the correct component
                component.set("v.displayScheduleList",true);
                component.set("v.displayEditSchedule",false);
                component.set("v.displayEditTimeslot",false);            
            }
            // if in the breadcrumbs All was clicked
            if(action == "homeCrumb"){
                component.set("v.scheduleId",null);
                component.set("v.timeslotId",null);
                // Display the correct component
                component.set("v.displayScheduleList",true);
                component.set("v.displayEditSchedule",false);
                component.set("v.displayEditTimeslot",false);            
            }
            // if in the breadcrumbs the schedule was clicked
            if(action == "scheduleCrumb"){
                component.set("v.scheduleId",scheduleId);
                component.set("v.timeslotId",null);
                // Display the correct component
                component.set("v.displayScheduleList",false);
                component.set("v.displayEditSchedule",true);
                component.set("v.displayEditTimeslot",false);            
            }
        }
        
    },
	
	// Check the User has access for Workgroup Schedules
    doInit: function(component, event, helper) {
        var recordId = component.get("v.recordId");  
        var action = component.get("c.accessCheckForManageSchedules");
        action.setParams({ accessId : recordId });
        action.setCallback(this, function(response) {           
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.isEditEnabled",response.getReturnValue());
                component.set("v.displayScheduleList",true);
            }
            else {
                var errors = response.getError();   
                var messageBox = component.find('messageBox'); 
                messageBox.displayToastMessage('error', errors && errors[0] && errors[0].message?errors[0].message:"Something went wrong",'Error');
            }
        });
        $A.enqueueAction(action);     
    },
})