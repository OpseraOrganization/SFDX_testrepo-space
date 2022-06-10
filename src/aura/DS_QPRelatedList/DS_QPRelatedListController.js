({
	 doInit : function(component, event, helper) {         
      helper.getLineItem(component, event, helper)
    },
      OpenPage: function(component, event, helper) {

         var Id = event.getSource().get("v.name");
     var urlEvent = $A.get("e.force:navigateToURL");
    urlEvent.setParams({
      "url": "/"+Id,
    });
    urlEvent.fire();
        
        
    }
})