({
	displayWarningMessage : function(component,event,helper) {
		console.info('in displayWarningMessage'+component.get("v.recordId"));
        var action = component.get("c.getQuoteId");
        action.setParams({ recordId: component.get("v.recordId")});
        var wariningMsgToDisplay;
       	action.setCallback(this, function(response)
		{
           	var state = response.getState();
            if (component.isValid() && state === "SUCCESS") 
            {
                console.info('In Success state >>>'+response.getReturnValue());
               	var showToast = $A.get('e.force:showToast');

        		//set the title and message params
        		showToast.setParams(
            	{
                	'message': response.getReturnValue(),
                    'type' : 'warning',
                    'duration' : 60000,
                    'mode' : 'dismissible'
            	}
        		);

                //fire the event
                showToast.fire(); 
                
            }else{
                console.info('No warning message to display');
            }
        });
        
        $A.enqueueAction(action); 
	},
    
})