({
	getcurrentuserHelper: function(component,event,helper){
        component.set('v.IsSpinner',true);
       var action = component.get("c.getcurrentuser");
        action.setCallback(this, function(response){
            var state = response.getState();
            component.set('v.IsSpinner',false);
            if(state === 'SUCCESS' && component.isValid()){ 
                var result=response.getReturnValue();
                 if(result!=null &&result!=undefined &&result!='')
                           component.set('v.Currentuser', result);
                    
            }
            else{
                 var   errors = response.getError();
                var errorpgmsg=JSON.stringify(errors);
               // alert('Error  ++>'+errorpgmsg);
                //errorpgmsg=errors[0].pageErrors[0].message;
            }
        });
        $A.enqueueAction(action);
    },
    
})