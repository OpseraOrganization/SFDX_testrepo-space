({
    doInit : function(component, event, helper){
        var recordId = component.get("v.recordId")
        console.info('recordId = ' + recordId);
        var action = component.get("c.getCloneOpp");
        action.setParams({"recordId": recordId});
        action.setCallback(this, function(response){
            var state = response.getState();
            $A.get("e.force:closeQuickAction").fire()
            if (component.isValid() && state === "SUCCESS")
            {
                var returned =response.getReturnValue();   
                var successLabel = $A.get("$Label.c.OpportunityClonedSuccessfully");
                var showToast = $A.get('e.force:showToast');
                if(returned.includes(' '))
                {
                    showToast.setParams(
                        {
                            'message': returned,
                            'type' : 'warning',
                            'duration' : 10000
                        }
                    ); 
                    
                    showToast.fire(); 
                }
                else
                {
                    showToast.setParams(
                        {
                            'message': successLabel,
                            'type' : 'success',
                            'duration' : 10000
                        }
                    ); 
                    
                    showToast.fire();
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": returned,
                        "slideDevName": "related"
                    });
                    navEvt.fire();
                }
                
            }
        });
         $A.enqueueAction(action);       
    }//doInit finish
})