({
    // Get the case details
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
    },
    // Ad the comments to a case
    addCommentToFeed: function(component, caseId, comment) {
        const helper = this;
        var action = component.get("c.addCommentToFeed");
        action.setParams({"caseId": caseId, "comment": comment});
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var message = "Comment added to case " + component.get("v.caseRecord").CaseNumber;
                var action1 = component.get("c.checkIfSurveyExists");
                action1.setParams({"caseId": caseId});
                action1.setCallback(this, function(response1) {
                    if (response1.getState() === "SUCCESS") {
                        console.log(response1.getReturnValue());
                        if(response1.getReturnValue()){
                            helper.showMessage(component, "Comment added to case " + component.get("v.caseRecord").CaseNumber, true);
                            helper.backToPreviousPage(caseId);
                        } else {
                            helper.showMessage(component, "Comment added to case " + component.get("v.caseRecord").CaseNumber, true);
                            setTimeout(()=>{ 
                				component.set("v.showSpinner", false);
								component.set("v.toast", null);
                                component.set("v.showPopUp", true); 
                            }, 3000); 
                        } 
                    }		
                });
                $A.enqueueAction(action1);
             }
        });
        $A.enqueueAction(action);
    },
    // Show the toast message
    showMessage: function(component, text, success){
        component.set("v.toast", {
            type : success ? 'success' : 'error',
            message : text
        });
    },
    // Go back to the previous page (case details page)
    backToPreviousPage: function(caseId) {
        var url;
        if (window.location.pathname.split('/')[1] !== 's') { 
            var communityName = window.location.pathname.split('/')[1];
            url = window.location.origin + '/' + communityName + '/s/case';
        } else { 
            url = window.location.origin + '/s/case';
        }  
        //PRB0017745 - HTTP 404 Page not found after commenting a case in customer support portal.		
        if(url.includes('customer.nokia.com')){
            window.open(url.substr(0, url.indexOf('/customers/apex/')) + '/' + caseId,'_top');
        }else{
            window.open(url + '/' + caseId,'_top');
        }  
        return false;
    }
})