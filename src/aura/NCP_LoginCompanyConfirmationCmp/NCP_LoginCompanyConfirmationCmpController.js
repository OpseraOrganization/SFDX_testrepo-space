({
    doInit : function(component, event, helper) {
        helper.loadSelectOptions(component);
        var action = component.get("c.getAccounts");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var custs = [];
                var conts = response.getReturnValue();
                for (var key in conts) {
                    custs.push({value:conts[key], key:key});
                }
                  component.set('v.companyList', custs);
            }
        });
        $A.enqueueAction(action);
    },
    validateData : function(cmp, evt, hlp){
         hlp.validateUser(cmp,hlp);
    } 
})