({
    helperActionExecute : function(component, event, action) {
      action.setCallback(this, function(response) {
          var state = response.getState();
          var response = response.getReturnValue();
          Alert(response);
          if(state == "SUCCESS" && response){
              Alert(response);
          }else{
           
       
          }
        });
        $A.enqueueAction(action);
    }
})