({
	 doInit : function(component, event, helper) {
       var actionstatusDetails = component.get("c.getDPAnalyticsSource");
        actionstatusDetails.setParams({
            "currentRecordId":component.get("v.recordId")
        });  
        actionstatusDetails.setCallback(this, function(response) {
           
            
            });
         $A.enqueueAction(actionstatusDetails);
         var DPType = component.get("v.DPFlag")
       
     
      helper.getQuote(component, event, helper)
      helper.getOpportunity(component, event, helper)
      
    },
      OpenPage: function(component, event, helper) {
		
        var id_str = event.srcElement.name
        
       
     var urlEvent = $A.get("e.force:navigateToURL");
    urlEvent.setParams({
      "url": "/"+id_str,
    });
    urlEvent.fire();
        
        
    },
    
     OpenAccount: function(component, event, helper) {
        var id_str = event.srcElement.name
        // var Id = event.getSource().get("v.name");
     var urlEvent = $A.get("e.force:navigateToURL");
    urlEvent.setParams({
      "url": "/"+id_str,
    });
    urlEvent.fire();
        
        
    },
    
    OpenOppty: function(component, event, helper) {
         var id_str = event.srcElement.name
         //var Id = event.getSource().get("v.name");
     var urlEvent = $A.get("e.force:navigateToURL");
    urlEvent.setParams({
      "url": "/"+id_str,
    });
    urlEvent.fire();
        
    }
})