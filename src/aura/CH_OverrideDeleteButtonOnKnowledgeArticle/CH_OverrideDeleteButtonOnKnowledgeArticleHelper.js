({
    helperActionExecute : function(component, event, action) {
      action.setCallback(this, function(response) {
          var state = response.getState();
          var response = response.getReturnValue();
          if(state == "SUCCESS" && response){
              $A.get("e.force:closeQuickAction").fire();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Knowledge Article has been deleted succesfully"
                });
                toastEvent.fire();
          }else{
             // component.set("v.messageError", true);
              $A.get("e.force:closeQuickAction").fire();
             var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "You Cannot Delete The Article",
            "message": "Please contact the owner of the knowledge Article",
            
        });
        toastEvent.fire();
          }
        });
        $A.enqueueAction(action);
    }
})