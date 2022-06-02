({
    getTagDetails: function(component, field, filter) {
        let helper = this;
        return new Promise(function(resolve, reject) {
            let params = {
                field : field,
                productId : filter.CH_Product__c,
                issueType : filter.CH_IssueType__c,
                issueDetails : filter.CH_IssueDetails__c,
                additionalDetails : filter.CH_AdditionalDetails__c
            }
            helper.apexAction(component, 'c.getCaseTagDetails', params, true).then((result) => resolve(result));
        });
    },
    //
    apexAction: function(component, method, params, handleError) {
        let helper = this, action = component.get(method);
        helper.incrementActionCounter(component);
        return new Promise(function(resolve, reject) { 
        	if(params) action.setParams(params);
        	action.setCallback(helper, function(response) {
                let state = response.getState();
                helper.decrementActionCounter(component);
                if (state === "SUCCESS") {
                    resolve(response.getReturnValue());
                } else {
                    if(handleError) {
                        helper.showToast('error', 'Error', error && error[0] && error[0].message ? error[0].message : "Something went wrong");
                        console.log(error);
                    }
                    else reject(response.getError());
                }
            });
            $A.enqueueAction(action);
        });
    },
    // Generic Toast Message
    showToast: function(sType, title, message) {
        $A.get("e.force:showToast").setParams({
            "title": title,
            "message": message,
            "type": sType
        }).fire();
    },
    // Loading Framework
    isLoading: function(component) {
        return component.get("v.showSpinner");
    },
    incrementActionCounter: function(component) {
        var counter = component.get("v.actionCounter") + 1;
        if (counter === 1) {
            component.set("v.showSpinner", true);
        }
        component.set("v.actionCounter", counter);
    },
    decrementActionCounter: function(component) {
        var counter = component.get("v.actionCounter") - 1;
        if (counter === 0) {
            component.set("v.showSpinner", false);
        }
        component.set("v.actionCounter", counter);
    }
})