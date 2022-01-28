({
	 doInit: function(component, event, helper) {
      
       var staticLabel = $A.get("$Label.c.DealProductGridUrl");
        
         component.set("v.URLPATH",staticLabel);
 } 
          
})