({    
	
		doInit: function(component, event, helper) {
        var action = component.get("c.method");
           
        action.setParams({
              "recordId" : component.get("v.recordId")
          });  
         action.setCallback(this, function(response){
            var name = response.getState();
           
            if(name === "SUCCESS") {
               component.set("v.item", response.getReturnValue());
			}
        });
     $A.enqueueAction(action);
     helper.getDPTypeHelper(component, event, helper);       
    },
  
   
});