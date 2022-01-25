({
	 selectObject : function(component, event, helper){      
    	// get the selected Account from list  
      	var getSelectObject = component.get("v.object");
    	// call the event   
      	var compEvent = component.getEvent("objectEvent");
    	// set the Selected object to the event attribute.  
        compEvent.setParams({"objectByEvent" : getSelectObject});  
    	// fire the event  
        compEvent.fire();
    },
})