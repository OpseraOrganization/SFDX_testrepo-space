({
	doInit : function(component, event, helper) {
        var caseId = component.get("v.recordId");
        helper.getCaseDetails(component, caseId);
	},
    // Add the comments to the case
    submit : function(component, event, helper) {
        var caseId = component.get("v.recordId");
        var comment = component.find("comments").get("v.value");
        console.log('comment====> 131072==='+comment.length);
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
                helper.showMessage(component, "Enter a comment", false);
            }    
        } else {
            
         	helper.showMessage(component, "Please reduce the character", false);   
        }
       
    },
    // Cancel the page and go back to the previous case details page
    cancel : function(component, event, helper) {
        var caseId = component.get("v.recordId");
        helper.backToPreviousPage(caseId);
    },
    // Hide or display the toast message
    hideMessage : function(component) {
        var toastMessage = component.find("ToastMessageSuccess");
        $A.util.addClass(toastMessage, "slds-hidden");
        var toastMessage = component.find("ToastMessageError");
        $A.util.addClass(toastMessage, "slds-hidden")
    }
})