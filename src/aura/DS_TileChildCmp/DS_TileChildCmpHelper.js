({
	getDPDashboard : function(component, event, helper) {
        var action = component.get("c.getDPDashboard");
        action.setCallback(this, function(response) {
            var state = response.getState();
            var contacts = response.getReturnValue();
            for(var key in contacts){
            	if(key === "Review"){
                            component.set('v.readyForReviewCount',contacts[key]);
                 }
                if(key === "Validated"){

                            component.set('v.ValidatedCount',contacts[key]);
                 }
                if(key === "Rejected"){
                            component.set('v.rejectedCount',contacts[key]);
                 }
            } 
        });
        $A.enqueueAction(action);
	}
})