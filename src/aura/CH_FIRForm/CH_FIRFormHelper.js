({
    splitValues : function(values) {
        return values && values.length > 0 ? values.replace(/;\s*$/, "").replace(/\r?\n|\r/g, "").split(';') : null;
    },
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
                        var error = response.getError();
                        var message =  error && error[0] && error[0].message ? error[0].message : "Something went wrong";
                        helper.showToast('error', 'Error', message);
                    }
                    else reject(response.getError());
                }
            });
            $A.enqueueAction(action);
        });
    },
    setAnswers: function(component, answers) {
        component.set('v.answers', answers);
        let completed = true;
        for(let i = 0, len = answers.length; i < len; i++) {
            if(!completed) break;
            switch(answers[i].Mandatory__c) {
                case 'Picklist':
            		completed = completed && answers[i].PicklistAnswer__c !== '';
                    break;
                case 'Answer':
            		completed = completed && answers[i].CustomerAnswer__c !== '';
                    break;
                case 'Picklist and Answer':
            		completed = completed && answers[i].PicklistAnswer__c !== '' && answers[i].CustomerAnswer__c !== '';
                    break;
            }
        }
        this.emit(component, 'onchange', { answers, completed });
    },
    emit: function(component, event, args) {
        component.getEvent("onEvent").setParams({
            message	: event,
            target	:'FIR',
            object	: JSON.stringify(args)
        }).fire();
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