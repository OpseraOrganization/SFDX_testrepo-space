({
    doInit : function(component, event, helper){
        //alert('in doinit clone');
        var recordId = component.get("v.recordId")
    //  alert('recordId = ' + recordId);
        var action = component.get("c.getCloneOffer");
     // alert('1. action = ' + action);
        action.setParams({"recordId": recordId});
     // alert('2. action = ' + action);
        action.setCallback(this, function(response){
             var state = response.getState();
             $A.get("e.force:closeQuickAction").fire()
            if (component.isValid() && state === "SUCCESS")
            {
                var returned =response.getReturnValue();   
                var warningLabel = $A.get("$Label.c.AccessDenied");
                var successLabel = $A.get("$Label.c.Offer_Clone");
                var showToast = $A.get('e.force:showToast');
            //   if(returned == null || returned == "")
               if(returned.includes(' '))
                {
        		//set the title and message params        		      		
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