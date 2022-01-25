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
        
        var action = component.get("c.addCommentToFeed");
        action.setParams({"caseId": caseId, "comment": comment});
        action.setCallback(this, function(response) {
            this.showMessage(component, "Comment added to case " + component.get("v.caseRecord").CaseNumber, true);
            var delay=3000; //1000 = 1 second
        	//setTimeout(this.backToPreviousPage(caseId), delay); 
        	this.backToPreviousPage(caseId);
        });
        $A.enqueueAction(action);         
        
        
    },
    // Show the toast message
    showMessage : function(component, text, succes){
        component.set("v.message", text);
        if (succes){
        	var toastMessage = component.find("ToastMessageSucces");
        }
        else {
            var toastMessage = component.find("ToastMessageError");
        }
        $A.util.removeClass(toastMessage, 'slds-hidden')
    },
    // Go back to the previous page (case details page)
    backToPreviousPage : function(caseId) {
        
		var url;
        if (window.location.pathname.split('/')[1] !== 's') { 
            var communityName = window.location.pathname.split('/')[1];
            url = window.location.origin + '/' + communityName + '/s/case';
        } else { 
            url = window.location.origin + '/s/case';
        }  

        //PRB0017745 - HTTP 404 Page not found after commenting a case in customer support portal.		
        if(url.includes('customer.nokia.com')){
            window.open( url.substr(0, url.indexOf('/customers/apex/')) + '/' + caseId,'_top');
        }else{
            window.open(url + '/' + caseId,'_top');
        }		
         
        /*
        var url = window.location.href;
        var instanceURL = url.substr(0, url.indexOf('/customers/apex/')); 
        window.open(instanceURL + '/customers/s/case/' + caseId,'_top')
        */
        
        /*
    	var url = window.location.href; 
        var value = url.substr(0,url.lastIndexOf('/') + 1);
        window.history.back();
        //window.location.reload(true);
        */
        return false;
        
    }
})