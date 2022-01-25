({
    loadSelectOptions : function(component) {
        var action = component.get("c.getselectOptions");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.companyRelationshipList', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    validateUser : function(cmp,hlp) {
        var action = cmp.get("c.validateHorizontalUser");
        var companycName = cmp.find("companySelected").get("v.value");
        action.setParams({companyName: companycName});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var inputCompanyName = cmp.find("hCompanyName");
                var companyNameValue = inputCompanyName.get("v.value");
                
                var inputHorizontalUser = cmp.find("horizontalUser");
                var horizontalUserValue = inputHorizontalUser.get("v.checked");
                

                if(response.getReturnValue()[0] && $A.util.isEmpty(companyNameValue)){
                    
                    cmp.set('v.companyNameError',true);
                    var cmpTarget = cmp.find("hCompanyNameForm");
                    $A.util.addClass(cmpTarget, 'slds-has-error');
                    
                    //inputCompanyName.set('v.validity', {valid:false, badInput :true});
                    inputCompanyName.focus();
                    //inputCompanyName.set("v.errors", [{message:"Required field !!"}]);
                    
                }else if(response.getReturnValue()[0] && !$A.util.isEmpty(companyNameValue) && !response.getReturnValue()[1]){
                    cmp.set('v.companyNameError',false);
                    var cmpTarget = cmp.find("hCompanyNameForm");
                    $A.util.removeClass(cmpTarget, 'slds-has-error');
                    hlp.submitAction(cmp);
                }

                if(response.getReturnValue()[1]){
                    inputHorizontalUser.set("v.checked",false);
                    cmp.set('v.horizontalUserError',true);
                    var cmpTarget = cmp.find("horizontalUserForm");
                    $A.util.addClass(cmpTarget, 'slds-has-error');
                }else{
                    cmp.set('v.horizontalUserError',false);
                    var cmpTarget = cmp.find("horizontalUserForm");
                    $A.util.removeClass(cmpTarget, 'slds-has-error');
                }
                
                
                if(!response.getReturnValue()[0] && !response.getReturnValue()[1]){
                     hlp.submitAction(cmp);
                } 
            }
        });
        $A.enqueueAction(action);
    },
    submitAction : function(cmp) {
        var resultCmp = cmp.find("companySelected").get("v.value");
        var action = cmp.get("c.saveUser");
        action.setParams({
            companyName: resultCmp,
            userData : cmp.get("v.user")
        });
        $A.enqueueAction(action);
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/"
        });
        urlEvent.fire();
    }
})