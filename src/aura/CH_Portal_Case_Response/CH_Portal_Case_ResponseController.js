({
	doInit : function(component, event, helper) {
        var caseId = component.get("v.recordId");
        helper.getCaseDetails(component, caseId);
	},
    // Add the comments to the case
    submit : function(component, event, helper) {
        component.set("v.showPopUp", false);
        component.set("v.showSpinner", true);
        var caseId = component.get("v.recordId");
        var comment = component.find("comments").get("v.value");
        if (comment.length <= 4000) {
        	 // If case is resolved
            if (component.get("v.source") == "RESOLVE_BUTTON"){
                var resolvedMessage = component.find("resolvedMessage").get("v.value");
                comment = resolvedMessage + "\n" + ((comment)?comment:"");
            }
            // If there is a comment, add to the case
            if (comment) {
                helper.addCommentToFeed(component, caseId, comment);
            }
            else {
                component.set("v.showSpinner", false);
                helper.showMessage(component, "Enter a comment", false);
            }    
        } else {
            component.set("v.showSpinner", false);
         	helper.showMessage(component, "Please reduce the character", false);   
        }
    },
    // Cancel the page and go back to the previous case details page
    cancel : function(component, event, helper) {
        var caseId = component.get("v.recordId");
        helper.backToPreviousPage(caseId);
    },
    // Hide or display the toast message
    closeToast : function(component, event, helper) {
		component.set("v.toast", null);
    },
    navigate : function(component, event, helper) {
        component.set("v.showPopUp", false);
        component.set("v.showSpinner", true);
        var url;
        var caseId = component.get("v.recordId");
        var action = component.get("c.createSurveyInvitation");
        action.setParams({"caseId": caseId});
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                component.set("v.showSpinner", false);
                console.log(response.getReturnValue());
                url = response.getReturnValue();
                window.open(url);
                helper.backToPreviousPage(caseId);
            }		
        });
        $A.enqueueAction(action);
    },
    remind : function(component, event, helper) {
        component.set("v.showPopUp", false);
        component.set("v.showSpinner", true);
        var caseId = component.get("v.recordId");
        var action = component.get("c.createSurveyInvitation");
        action.setParams({"caseId": caseId});
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                component.set("v.showSpinner", false);
                helper.backToPreviousPage(caseId);
            }		
        });
        $A.enqueueAction(action);
    }
    //NOKIASC-38992
})