({
   doInit : function(component, event, helper){
            helper.getAllContacts(component,event,'Name');
       
    },
    
   OpenPage: function(component, event, helper) {

         var Id = event.getSource().get("v.name");
         var urlEvent = $A.get("e.force:navigateToURL");
         urlEvent.setParams({
            "url": "/proposal/"+Id,
    });
    urlEvent.fire();
  },
})