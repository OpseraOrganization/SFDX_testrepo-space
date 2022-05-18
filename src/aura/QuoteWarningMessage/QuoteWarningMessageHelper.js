({
	displayWarningMessage : function(component,event,helper) {
		console.info('in displayWarningMessage'+component.get("v.recordId"));
        var action = component.get("c.callInit");
        action.setParams({ recordId: component.get("v.recordId")});
        var wariningMsgToDisplay;
       	action.setCallback(this, function(response)
		{
           	var state = response.getState();
            if (component.isValid() && state === "SUCCESS") 
            {
                var result =response.getReturnValue();               
                component.set("v.obj",result);                
                // if(result.repriceMessage){
                //     component.set("v.showRepriceMessage",true);
                // }else{
                //     component.set("v.showRepriceMessage",false);
                // }                
                if(result.ToastMessage!=''  &&  result.ToastMessage!=undefined){
                    var showToast = $A.get('e.force:showToast');
                            		//set the title and message params
                            		showToast.setParams(
                                	{
                                    	'message': result.ToastMessage,
                                        'type' : 'warning',
                                        'duration' : 60000,
                                        'mode' : 'dismissible'
                                	}
                            		);
                    
                                    //fire the event
                                    showToast.fire(); 
                }
               	
                
            }else{
                console.info('No warning message to display');
            }
        });
        
        $A.enqueueAction(action); 
	},
    
})