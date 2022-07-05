({
    // When the validate is triggered from an external component
    validate : function(component, event, helper) {
        var params = event.getParam('arguments');
        var scheduleIds = params.scheduleIds;
        helper.validation(component, scheduleIds);	
    },
})