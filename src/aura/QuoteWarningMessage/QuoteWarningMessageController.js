({
	doInit : function(component, event, helper) {
		console.info('in do init');
        var recordId = component.get("v.recordId");
        console.info('in do init offerId'+recordId);
        helper.displayWarningMessage(component,recordId);
        
	},
          
})