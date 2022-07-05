({
    // createNotifier: function(cmp, evt) {
    //     // get the type to determine whether it should be displayed
    //     var notifierType = evt.getParam('notifierType');
    //     var notifierDetails = evt.getParam('notifierDetails');
    //     var myNotifierType = cmp.get('v.myNotifierType');
    //     // show a notification
    //     if (notifierType === myNotifierType) {
    //         $A.createComponent(
    //             'c:NCP_Alert',
    //             {
    //                 'aura:id': 'notifier',
    //                 'urgency': notifierDetails.NCP_Urgency_Level__c,
    //                 'notifierSubject': notifierDetails.NCP_Subject__c,
    //                 'notifierBody': notifierDetails.NCP_Body__c,
    //                 'notifierLink': notifierDetails.NCP_URL__c
    //                 // 'closeMethod': cmp.closeBanner

    //             },
    //             function (newButton, status, errorMessage) {
    //                 //Add the new button to the body array
    //                 if (status === 'SUCCESS') {
    //                     var body = cmp.get('v.body');
    //                     body.push(newButton);
    //                     cmp.set('v.body', body);
    //                 }
    //                 else if (status === 'INCOMPLETE') {
    //                     console.log('No response from server or client is offline.')
    //                     // Show offline error
    //                 }
    //                 else if (status === 'ERROR') {
    //                     console.log('Error: ' + errorMessage);
    //                     // Show error message
    //                 }
    //             }
    //         );
    //     }
    // },
    setNotifiers: function (cmp, aNotifiers) {
        var myNotifierType = cmp.get('v.myNotifierType');
        aNotifiers.forEach(function (notifier) {
            if (notifier.NCP_Type__c === myNotifierType) {
                $A.createComponent(
                    'c:NCP_Alert',
                    {
                        'aura:id': 'notifier',
                        'urgency': notifier.NCP_Urgency_Level__c,
                        'notifierSubject': notifier.NCP_Subject__c,
                        'notifierBody': notifier.NCP_Body__c,
                        'notifierLink': notifier.NCP_URL__c
                        // 'closeMethod': cmp.closeBanner

                    },
                    function (newNotifier, status, errorMessage) {
                        //Add the new button to the body array
                        if (status === 'SUCCESS') {
                            var body = cmp.get('v.body');
                            body.push(newNotifier);
                            cmp.set('v.body', body);
                        }
                        else if (status === 'INCOMPLETE') {
                            console.log('No response from server or client is offline.')
                            // Show offline error
                        }
                        else if (status === 'ERROR') {
                            console.log('Error: ' + errorMessage);
                            // Show error message
                        }
                    }
                );
            }
        }, this);
    }
})