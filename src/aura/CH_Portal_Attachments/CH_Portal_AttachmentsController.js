({
	doInit : function(component, event, helper) {
        var caseId = component.get("v.caseId");
        helper.getCaseDetails(component, caseId);
	},
    // Cancel the page and go back to the previous case details page
    goBack : function(component, event, helper) {
        event.preventDefault();
    	var url = window.location.href; 
        var value = url.substr(0,url.lastIndexOf('/') + 1);
        window.history.back();
        return false;
    }
})