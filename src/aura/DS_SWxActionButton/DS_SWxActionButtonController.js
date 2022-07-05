({
	getLineItemOnLoad : function(component, event, helper) {
		 var actionstatusDetails = component.get("c.getFeature"); 
              actionstatusDetails.setParams({
               "recordId":component.get("v.recordId")
            });
            actionstatusDetails.setCallback(this, function(response) {
            component.set('v.contents',response.getReturnValue());
            var contacts = component.get("v.contents");//Getting Map and Its value      
                  
          });
            $A.enqueueAction(actionstatusDetails);
         helper.getDPTypeHelper(component, event, helper);
          helper.getCurrentUserProfileHelper(component, event, helper);
	},
    updateDeliveryExecutionStatusfromcomponent : function(component, event, helper) {
        
         var productCode = event.getSource().get("v.name");
           var actionstatusDetails = component.get("c.updateDeliveryExecutionStatus"); 
              actionstatusDetails.setParams({
                  "productCode":productCode,
                   "recordId":component.get("v.recordId")
            });
            actionstatusDetails.setCallback(this, function(response) {
            component.set('v.contents',response.getReturnValue());
            var contacts = component.get("v.contents");//Getting Map and Its value      
            
          });
            $A.enqueueAction(actionstatusDetails); 
		
	},
     updateDeliveryExecutionStatus412 : function(component, event, helper) {
         var productCode = event.getSource().get("v.name");
        
         var actionstatusDetails = component.get("c.updateStatusInNetwork1"); 
              actionstatusDetails.setParams({
                  "productCode":productCode,
                   "recordId":component.get("v.recordId")
            });
            actionstatusDetails.setCallback(this, function(response) {
               
            component.set('v.contents',response.getReturnValue());
            var contacts = component.get("v.contents");//Getting Map and Its value      
           
          });
            $A.enqueueAction(actionstatusDetails); 
         
         
        
		
	},
     updateAcceptanceOfDeliveryStatusfromcomponent : function(component, event, helper) {
         var productCode = event.getSource().get("v.name");
           var actionstatusDetails = component.get("c.updateAcceptanceOfDeliveryStatus"); 
              actionstatusDetails.setParams({
                  "productCode":productCode,
                   "recordId":component.get("v.recordId")
            });
            actionstatusDetails.setCallback(this, function(response) {
            component.set('v.contents',response.getReturnValue());
            var contacts = component.get("v.contents");//Getting Map and Its value      
             
          });
            $A.enqueueAction(actionstatusDetails); 
		
	},
     updateStatusInNetwork: function(component, event, helper) {
           var productCode = event.getSource().get("v.name");
           var actionstatusDetails = component.get("c.updateStatusInNetwork"); 
           alert('In MethodInsideupdateStatusInNetworkbefore'+productCode) 
              actionstatusDetails.setParams({
                  "productCode":productCode,
                   "recordId":component.get("v.recordId")
            });
            actionstatusDetails.setCallback(this, function(response) {
            component.set('v.contents',response.getReturnValue());
            var contacts = component.get("v.contents");//Getting Map and Its value      
             alert('contacts>>>>'+contacts)     
          });
            $A.enqueueAction(actionstatusDetails); 
		alert('In MethodInsideupdateStatusInNetwork'+productCode) 
	}
})