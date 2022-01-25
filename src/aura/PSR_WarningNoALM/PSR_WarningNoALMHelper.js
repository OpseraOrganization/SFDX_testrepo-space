({
    displayWarningMessageOnPreSalesOpportunity : function(component,event,helper) {
		console.info('in displayWarningMessageOnPreSalesOpportunity'+component.get("v.recordId"));
        var action = component.get("c.opptyNoALMErrorMessage");
        action.setParams({ recordId: component.get("v.recordId")});
        action.setCallback(this, function(response) 
		{
           	var state = response.getState();
            console.info('In setCallBack');
            if (component.isValid() && state === "SUCCESS") 
            {
                console.info('In Success state >>>'+response.getReturnValue());
               	var showToast = $A.get('e.force:showToast');

        		//set the title and message params
        		showToast.setParams(
            	{
                	'message': response.getReturnValue(),
                    'type' : 'warning',
                    'duration' : 30000
            	}
        		);

                //fire the event
                showToast.fire(); 
                
            }else{
                console.info('No warning message to display');
            }
        });
        
        $A.enqueueAction(action); 
	}
})
})