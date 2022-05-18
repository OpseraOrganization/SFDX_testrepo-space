({
    initialize: function(component, evt, helper) {
        console.log('start time: ', new Date());
        var quoteId = component.get("v.recordId");
        var action = component.get("c.checkIfValidTransaction");
        let progressVal = 10;
        action.setParams({
            "proposalId": quoteId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('initialize response data: ', response.getReturnValue());
                if(response.getReturnValue()) {
                    component.set("v.showProgressBar", true);
                    component.set("v.title", "Processing information - Please wait");
                    component.set("v.progress", progressVal);
                    setTimeout(function() {
                        helper.pollJobStatus(component, evt, helper, progressVal);
                    }, 2000);
                    // helper.asyncPollJobStatus(component, evt, helper, progressVal);
                } else {
                    component.set("v.showProgressBar", false);
                }
            }
        });
        $A.enqueueAction(action);
    },

    
});