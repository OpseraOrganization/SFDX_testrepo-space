({
    pollCount: 0,
    pollAsyncJob: function(cmp) {
        this.pollCount += 1;
        var action = cmp.get('c.pollAsyncJob');
        action.setParams({
            jobId: cmp.get('v.asyncId')
        });
        action.setCallback(this, this.pollResult);
        $A.enqueueAction(action);
    },
    pollResult: function(response, cmp) {
        var jobStatus = response.getReturnValue();

        if (jobStatus.Status !== 'Completed') {
            // Wait for 10 seconds max.
            if (this.pollCount < 20) {
                window.setTimeout(
                    $A.getCallback(function(hlp) {
                        hlp.pollAsyncJob(cmp);
                    }),
                    500,
                    this
                );
            } else {
                var toastEvent = $A.get('e.force:showToast');
                toastEvent.setParams({
                    mode: 'sticky',
                    title: 'Short delay',
                    type: 'info',
                    message: 'Pre-approval is taking longer than anticipated, please wait a minute and then reload the page.'
                });
                toastEvent.fire();
            }
        } else {
            // check for errors
            if (jobStatus.NumberOfErrors) {
                // show a toast?
                var toastEvent = $A.get('e.force:showToast');
                toastEvent.setParams({
                    mode: 'pester',
                    title: '',
                    type: 'error',
                    message: 'An error was recorded during processing.'
                });
                toastEvent.fire();
            }
            console.log('pollcount = ' + this.pollCount);
            cmp.set('v.isSubmitting', false);
            $A.get('e.force:refreshView').fire();
        }
    },
    displayMessage: function(cmp,value) {
    var resultType;
    var resultMessage;
    if(value=='Success')
    {
    resultType='success';
    resultMessage='Case has been approved successfully';    
    }
    else
    {
    resultType='error';
    resultMessage='Case updation is failed';
    }
    var toastEvent = $A.get('e.force:showToast');
                toastEvent.setParams({
                    mode: 'pester',
                    title: '',
                    type: resultType,
                    message: resultMessage
                });
     toastEvent.fire(); 
    }
});