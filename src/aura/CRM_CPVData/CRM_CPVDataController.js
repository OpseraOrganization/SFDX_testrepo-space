({
	init : function(component, event, helper)
    {
        console.log("CRM_CPVDataController");
        component.set("v.accId", component.get("v.recordId"));
        var getCPVCall = component.get("c.getAccountCPVApex");
        getCPVCall.setParams({
            "accId": component.get("v.accId")
        });
        console.log(component.get("v.accId"));
        getCPVCall.setCallback(this, function(response)
        {
            console.log(response.getReturnValue());
            if(helper.checkSuccess(component, event, helper, response))
            {                
        		console.log(response.getReturnValue().accountCPV);
                component.set('v.cpvRec', response.getReturnValue().accountCPV);
            }
        });
        component.set('v.loaded', false);
        $A.enqueueAction(getCPVCall);
    },
})