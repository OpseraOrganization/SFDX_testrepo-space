({
	getEntitleMent : function(component, event, helper) {
		 var actionstatusDetails = component.get("c.GetEntitleRec"); 
        actionstatusDetails.setParams({
            "currentRecordId":component.get("v.recordId")
        });  
        
        actionstatusDetails.setCallback(this, function(response) {
        	if (response.getState() === "SUCCESS") {
                component.set("v.EntitleMent",response.getReturnValue());
                   component.set("v.Showrecommendation",true);
                
            }
            
            
        });
        $A.enqueueAction(actionstatusDetails); 

	}
})