({
	getDPTypeHelper : function(component, event, helper) {
            var actionstatusDetails = component.get("c.getDPType"); 
            actionstatusDetails.setParams({
                "recordId":component.get("v.recordId")
            });
            
            actionstatusDetails.setCallback(this, function(response) {
            component.set('v.dpType',response.getReturnValue());
             var contacts = component.get("v.dpType");
            //if(contacts === "CXM"){
                 var contacts = component.get("v.dpType");
          
                 component.set('v.dpType',1);
          //  }
             
             
          });
            $A.enqueueAction(actionstatusDetails); 
	}
})