({
    //Function to Check Approval Stage
    checkApprovalStageParams : function(component,event, helper) {
        
        var action = component.get("c.checkApprovalStage");
       
        action.setParams({ recordId: component.get("v.recordId")
                          });
        
        action.setCallback(this, function(response){
        	if(response.getReturnValue() ===1)
            {                
            	var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                "title": "Please Note",
                "message": "Click on button Download Recommendation to track the history of the revisions",
                "type": "info",
                "duration" : "5000",
                "mode":"dismissible"
             	});
                resultsToast.fire();
             }  
        });
        $A.enqueueAction(action);
    }
})