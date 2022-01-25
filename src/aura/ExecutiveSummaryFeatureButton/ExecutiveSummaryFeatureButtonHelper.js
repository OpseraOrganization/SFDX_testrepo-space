({
helperStatusUpdateMethod : function(component, event, helper,status) {
        var actionstatusUpdateDetails = component.get("c.getDocumentIdforLine1");
        
        var currentId=component.get("v.recordId");
        alert("currentId"+currentId);
        actionstatusUpdateDetails.setParams({
            "QuoteLineID":currentId,
            "Status":status
            
        });  
        actionstatusUpdateDetails.setCallback(this, function(response) {
            
           var state = response.getState();
            if (state === 'SUCCESS'){
                $A.get('e.force:refreshView').fire(); 
                $A.get("e.force:closeQuickAction").fire();
            }
            
         
        });
        $A.enqueueAction(actionstatusUpdateDetails);
		
	}
})