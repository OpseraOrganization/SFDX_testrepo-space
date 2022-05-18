({
	helperStatusUpdateMethod : function(component, event, helper,status,rejReason1) {
        var actionstatusUpdateDetails = component.get("c.getStatusUpdate");
        var currentId=component.get("v.recordId");
        actionstatusUpdateDetails.setParams({
            "recordId":currentId,
            "Approval_Stage":status,
            "Rejection_Reason":rejReason1
            
        });  
        actionstatusUpdateDetails.setCallback(this, function(response) {
            component.set("v.updatedstatusDetails",response.getReturnValue());
           var state = response.getState();
            if (state === 'SUCCESS'){
                component.set("v.rejFlag",0);
                component.set("v.docFlag",4);
                component.set("v.QuoteText","The record has been updated");
                var btn1 = component.find('btnAccept');
                $A.util.addClass(btn1, "toggle");
                var btn2 = component.find('btnReject');
                $A.util.addClass(btn2, "toggle");
                
           }
        });        
         $A.enqueueAction(actionstatusUpdateDetails);  
	},  
})