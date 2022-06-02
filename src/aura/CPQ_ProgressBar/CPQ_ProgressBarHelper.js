({
    asyncPollJobStatus: function(component, evt, helper, progressVal) {
        console.log('async call');
        setTimeout(function() {
            helper.pollJobStatus(component, evt, helper, progressVal);
        }, 10000);
    },

    pollJobStatus: function(component, evt, helper, progressVal) {
        var action = component.get("c.checkJobStatus");
        action.setParams({
            "proposalId": component.get("v.recordId")
        });
        let progress = progressVal + 10;
        console.log('inside polljobsttus: ', progress);
        if(progress > 90) {
            progress = 90;
        }
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('pollJobStatus response data: ', response.getReturnValue());
                if(response.getReturnValue()) {
                    component.set("v.progress", progress);
                    helper.asyncPollJobStatus(component, evt, helper, progress);
                } else {
                    $A.get('e.force:refreshView').fire();
                    setTimeout(function() {
                        component.set("v.title", "Processing information - Completed");
                        component.set("v.progress", 100);
                        console.log('end time: ', new Date());
                    }, 2000);
                    setTimeout(function() {
                        component.set("v.showProgressBar", false);
                    }, 15000);
                }
            }
        });
        $A.enqueueAction(action);
    }
})