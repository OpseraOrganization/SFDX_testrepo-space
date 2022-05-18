({
getCurrentrecommendationhelper:function(component,event,helper)
    {
         var action = component.get("c.getCurrentRecommendation"); 
          action.setParams({
             "currentRecordId": component.get("v.recordId"),
        });
        action.setCallback(this, function(response) {             
            var state = response.getState();
            if (state === "SUCCESS") {
        component.set("v.CurrentRecommendation",response.getReturnValue());
                        component.set("v.Showrecommendation",true);
                }
            else{
                 var   errors = response.getError();
                var errorpgmsg=JSON.stringify(errors);
                alert('Error  ++>'+errorpgmsg);
            }            
        });
        $A.enqueueAction(action);
 },
})