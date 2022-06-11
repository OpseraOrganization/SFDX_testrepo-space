({
    getcurrentusercontactHelper: function(component,event,helper){
       var action = component.get("c.getcurrentuserContactcard");
        action.setCallback(this, function(response){
            var state = response.getState();
            component.set('v.IsSpinner',false);
            if(state === 'SUCCESS' ){ 
                var result=response.getReturnValue();
                 	if(result!=null && result!=undefined && result!='')
                     	component.set('v.Currentuserval', result);
            }
            else{
                var   errors = response.getError();
                var errorpgmsg=JSON.stringify(errors);
            }
        });
        $A.enqueueAction(action);
    },
})