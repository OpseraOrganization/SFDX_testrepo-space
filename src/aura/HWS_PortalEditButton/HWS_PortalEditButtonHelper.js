({
	 checkSpsVerification : function(component,event,helper) {
        var action=component.get('c.customerPoHide');
        action.setParams({
            parentCaseId : component.get("v.recordId")});
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                 if(response.getReturnValue()==='SPS'){
                    component.set("v.servicetype", true);
                }  else if(response.getReturnValue()==='isChild'){
                    component.set("v.isChild", true);                     
                 }               
            }
        }));
        $A.enqueueAction(action);     
    }
})