({
    
  doInit : function(component, event, helper) {
     
        var recordId = component.get("v.recordId");      
        var action = component.get("c.closeME");
        action.setParams({ recordId : recordId
                          });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var errorrtnmsg=response.getReturnValue();           
            
            
            if (state === "SUCCESS" && (errorrtnmsg==null || errorrtnmsg=='')) {
                 
         
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "The record has been closed successfully.",
                    "type": "success"
                });
                toastEvent.fire();
                 $A.get('e.force:refreshView').fire();               
            }
            
            else {
                var errorMessage;
                var errors = response.getError();
                 var toastEvent = $A.get("e.force:showToast");
                 var errorrtnmsg=response.getReturnValue();
                if(errorrtnmsg != null && errorrtnmsg !=''){ 
                    errorMessage = errorrtnmsg;
                }
                
                
                else if (errors) {
                        if (errors[0] && errors[0].message) {
                            // System error
                            errorMessage = errors[0].message;
                        }
                        else if (errors[0] && errors[0].pageErrors) {
                            // DML Error
                            errorMessage = errors[0].pageErrors[0].message;
                        }
                    }
                toastEvent.setParams({
                    "title": "Error!",
                    "message": errorMessage,
                    "type": "error",
                    "duration":"5000"
                });
                toastEvent.fire();
                
            }
            $A.get("e.force:closeQuickAction").fire();
        });
        $A.enqueueAction(action); 
        
    },
    
    
})