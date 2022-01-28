({
    getCaseDetails: function(component, caseId) {
        var action = component.get("c.getCaseDetails");
        var newStatus;
        
        action.setParams({"caseId": caseId});
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var caseRecord = response.getReturnValue();
                component.set("v.caseRecord", caseRecord);                
            }
        });
        $A.enqueueAction(action);
    },backToPreviousPage : function() {
    	var url = window.location.href; 
        var value = url.substr(0,url.lastIndexOf('/') + 1);
        window.history.back();
        return false;
    }
})