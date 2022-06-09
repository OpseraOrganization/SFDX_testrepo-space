({
	myAction : function(component, event, helper) {
        var mActionGetMappedValues = component.get("c.getAnnouncements");
		mActionGetMappedValues.setCallback(this, function(response) {
        	component.set("v.announcements", response.getReturnValue());
        }); 
        $A.enqueueAction(mActionGetMappedValues);
	}
})