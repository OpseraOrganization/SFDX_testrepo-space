({
	getQuoteDashboard : function(component, event, helper) {
        var action = component.get("c.getQuoteDashboard");
        action.setCallback(this, function(response) {
            var state = response.getState();
            var contacts = response.getReturnValue();
            for(var key in contacts){
            	if(key === "Accepted"){
                            component.set('v.AcceptedCount',contacts[key]);
                 }
                if(key === "Revision"){
                    		component.set('v.RevisionCount',contacts[key]);
                 }
                if(key === "Approved"){
                            component.set('v.ApprovedCount',contacts[key]);
                 }
                if(key === "Rejected"){
                            component.set('v.RejectedCount',contacts[key]);
                 }
            } 
        });
        $A.enqueueAction(action);
	}
})