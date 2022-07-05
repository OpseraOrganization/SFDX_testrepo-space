({
	checkvalidity : function(component, event, helper) {
	 {   
        var Title= event.getSource().get("v.name");
        var CPOId= component.get("v.recordId");
        var urlToRecord = "/"+CPOId;
        var action = component.get("c.checkCPOValidity");
          action.setParams({
            "currentRecordId":CPOId
              
        });
         
        
        action.setCallback(this, function(response){
             var state = response.getState();
             if (state === "SUCCESS"){  
                window.setTimeout(
                    $A.getCallback( function() {
                        // Now set our preferred value
                     var urlEvent = $A.get("e.force:navigateToURL");
                        urlEvent.setParams({
                            "url": urlToRecord
                        });
                        urlEvent.fire();
                        $A.get('e.force:refreshView').fire(); 
                    }),5000); 
             }
         });
        $A.enqueueAction(action);
        
     
       
       
    }
        
	}
})