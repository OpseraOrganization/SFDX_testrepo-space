({
	getDPTypeHelper : function(component, event, helper) {
            var actionstatusDetails = component.get("c.getDPType"); 
            actionstatusDetails.setParams({
                "recordId":component.get("v.recordId")
            });
            
            actionstatusDetails.setCallback(this, function(response) {
            component.set('v.dpType',response.getReturnValue());
            var contacts = component.get("v.dpType");//Getting Map and Its value
          
            if(contacts === "RMP"){
                
                
                 component.set('v.dpType',1);
            }
             
             
          });
            $A.enqueueAction(actionstatusDetails); 
	},
    
    getCurrentUserProfileHelper : function(component, event, helper) {
            var actionstatusDetails = component.get("c.getCurrentUserProfile"); 
           
            actionstatusDetails.setCallback(this, function(response) {
                
            component.set('v.userProfileName',response.getReturnValue());
            var contacts = response.getReturnValue(); //Getting Map and Its value
          
            
             if(contacts === "Customers"){
                
                 
                 component.set('v.userProfileName',1);
            }
                 if(contacts === "Non-Sales User Profile"){
                
                 
                 component.set('v.userProfileName',2);
            }
                
               
             
            
           
          });
            $A.enqueueAction(actionstatusDetails); 
	},
    
    
})