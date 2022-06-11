({
	duplicateCheck : function(component,event,helper) {
        var name = component.find("NameValue").get("v.value");
		var action = component.get("c.isOMSPresent");

        action.setParams({"omName" : name});

        action.setCallback(this,function(response) {

            var state = response.getState();
   
            if (state === "SUCCESS") 
            {
                
                if ( response.getReturnValue()) 
                {
                    component.set("v.dupExist",true);
               
                    component.set('v.errorMessage',response.getReturnValue());
                    component.set('v.error',true);
					
                }
            }
		});
        $A.enqueueAction(action);
                           }
        
})