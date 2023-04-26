({
	fastTrackOppty : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Not Allowed",
            "type": "warning",
            "mode": "pester",
            "duration": 10000,
            "message": "Creating a new offer is not allowed for fast track opportunities"
        });
        toastEvent.fire();
         $A.get("e.force:closeQuickAction").fire();
        component.destroy();
    },
    
    errorHandler : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error",
            "type": "error",
            "mode": "pester",
            "duration": 10000,
            "message": "An error occurred, please contact an admin."
        });
        toastEvent.fire();
         $A.get("e.force:closeQuickAction").fire();
        component.destroy();
    },
})