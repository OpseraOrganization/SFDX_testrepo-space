({
	doInit : function(component, event, helper) {
        var caseId = component.get("v.caseId");
        helper.getCaseDetails(component, caseId);
	},
    // Cancel the page and go back to the previous case details page
    cancel : function(component, event, helper) {
        helper.backToPreviousPage();
    }
})