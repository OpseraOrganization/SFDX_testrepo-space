({
    // Validate the list of schedules
    validation : function(component, scheduleIds) {
        component.set("v.Spinner", true);
        component.set("v.warningMessage",'');
        var action = component.get('c.validateWorkgroupSchedule');
        action.setParams({workgroupScheduleId : scheduleIds});
        action.setCallback(this,function(response){
            var errorMessage = response.getReturnValue();
            component.set("v.warningMessage", errorMessage);
        	component.set("v.Spinner", false);
        });
        $A.enqueueAction(action);
    }
})