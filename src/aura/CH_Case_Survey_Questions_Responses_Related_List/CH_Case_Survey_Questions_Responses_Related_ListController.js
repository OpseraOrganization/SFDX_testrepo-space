({
	init : function(component, event, helper) {		
		var action = component.get("c.getRelatedQuestionResponsesList");
        action.setParams({
            recordId : component.get("v.recordId")
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();                        
          	if(state ==='SUCCESS')
            {
                var result = response.getReturnValue();
                if(result === null)
                    component.set("v.isClosed",false);
                else
                {
                    component.set("v.isClosed",true);
                    component.set("v.questionsResponsesList",result);
                    console.log("result[0] - "+result[0]);
                    console.log("result[0].CreatedDate - "+result[0].CreatedDate);
                    component.set("v.submittedDate",(result[0].CreatedDate).substring(0,10));
                }
            }                
        })
        $A.enqueueAction(action);
	}//end init function
})