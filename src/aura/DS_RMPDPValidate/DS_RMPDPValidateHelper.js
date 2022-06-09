({
	helperStatusUpdateMethod : function(component, event, helper,status,proposalStatus,rejReason1) {
        var actionstatusUpdateDetails = component.get("c.getStatusUpdate");
       // alert('proposalStatus--->'+proposalStatus) ;
      //  alert('status--->'+status) ;
        // alert('actionstatusUpdateDetails--->'+actionstatusUpdateDetails)
        var currentId=component.get("v.recordId");
        actionstatusUpdateDetails.setParams({
            "recordId":currentId,
            "upsell_status":status,
            "proposal_status":proposalStatus,
            "Rejection_Reason":rejReason1
            
        });  
        actionstatusUpdateDetails.setCallback(this, function(response) {
            component.set("v.updatedstatusDetails",response.getReturnValue());
           var state = response.getState();
            if (state === 'SUCCESS'){
                component.set("v.rejFlag",0);
                component.set("v.docFlag",4);
                component.set("v.QuoteText","The record has been updated");
                var btn1 = component.find('btnValidate');
                $A.util.addClass(btn1, "toggle");
                var btn2 = component.find('btnReject');
                $A.util.addClass(btn2, "toggle");
                
           }
        });        
         $A.enqueueAction(actionstatusUpdateDetails);  
	}, 

})