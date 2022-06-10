({
	 doInit : function(component, event, helper) {
      helper.getCCREServiceInfoLineItem(component, event, helper)
      helper.getCCREProductInfoLineItem(component, event, helper)
    },
      
    OpenService: function(component, event, helper) {

         var Id = event.getSource().get("v.name");
     var urlEvent = $A.get("e.force:navigateToURL");
    urlEvent.setParams({
      "url": "/"+Id,
    });
    urlEvent.fire();
        
    },
    
     OpenProduct: function(component, event, helper) {

         var Id = event.getSource().get("v.name");
     var urlEvent = $A.get("e.force:navigateToURL");
    urlEvent.setParams({
      "url": "/"+Id,
    });
    urlEvent.fire();
        
    }
})