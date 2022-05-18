({
    click: function (cmp, evt, hlp) {
        var recordDetails = cmp.get('v.componentRecord');
        if((recordDetails.NCP_Internal_Case__c == false && recordDetails.NCP_Contract_Type__c == 'CARES')||(recordDetails.NCP_Contract_Type__c == 'Other Services' ))
        {
         // TO UPDATE: update case status
        var action = cmp.get('c.updateCaseStatus');
        action.setParams({
            caseId: cmp.get('v.recordId')
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var value = response.getReturnValue();
                hlp.displayMessage(cmp,value);
                $A.get('e.force:refreshView').fire();
            }else {
            }
        });
        $A.enqueueAction(action);
        } 
        else
        { 
        cmp.set('v.message', '');
        cmp.set('v.isSubmitting', true);    
        // TO UPDATE: add NAM request call
        var action = cmp.get('c.getNAMResponse');
        // action.setStorable();
        action.setParams({
            oppId: cmp.get('v.recordId')
        });
        action.setCallback(this, function (response) {
            // $A.util.toggleClass(spinner, 'slds-hide');
            var state = response.getState();
            if (state === 'SUCCESS') {
                var asyncId = response.getReturnValue();
                // console.log(asyncId);
                cmp.set('v.asyncId', asyncId);
                // start the polling
                hlp.pollAsyncJob(cmp);

                // $A.get('e.force:refreshView').fire();
                /*cmp.find("workspace").getFocusedTabInfo().then(function (response) {
                    $A.get('e.force:refreshView').fire();
                    cmp.find('subProcRecord').reloadRecord();
                    var focusedTabId = response.tabId;
                    workspaceAPI.refreshTab({
                        tabId: focusedTabId,
                        includeAllSubtabs: true
                    });
                }).catch(function (error) {
                    console.log('Error is : ' + error);
                    location.reload();

                });*/
            } else {
            }
        });
        $A.enqueueAction(action);
        }
        // window.setTimeout(
        // 	$A.getCallback(function() {
        // 		console.log('Nam request');
        //         $A.util.toggleClass(spinner, "slds-hide");
        //     }), 1000
        // );
    },
    caseDetailsReceived: function (component, event, helper) {
        var eventParams = event.getParams();
        var customLabel;
        var NAMEntitlement = component.get('v.NAMEntitlement');
        if (eventParams.changeType === "CHANGED") {
            var recordDetails = component.get('v.componentRecord');
            if (NAMEntitlement != recordDetails.NCP_NAM_Entitlement_Requested__c) {
                if (
                    recordDetails.NCP_NAM_Entitlement_Requested__c == 'SUCCESS' ||
                    recordDetails.Status == 'Rejected' ||
                    (recordDetails.NCP_Internal_Case__c == true && recordDetails.NCP_Contract_Type__c == 'CARES' )||
                    recordDetails.NCP_Contract_Type__c == null
                ) {
                    /*recordDetails.NCP_Contract_Type__c == null && recordDetails.NCP_Internal_Case__c == false) ||
                    recordDetails.NCP_Internal_Case__c == false
                    recordDetails.NCP_Contract_Type__c == 'Other Services'||
                    */
                    component.set('v.isButtonDisabled', true);
                    customLabel = $A.get("$Label.c.NCP_PreApproval_Success");
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        mode: "sticky",
                        title: customLabel,
                        type: "success",
                        message: customLabel
                    });
                    resultsToast.fire();
                    component.set('v.NAMEntitlement', recordDetails.NCP_NAM_Entitlement_Requested__c);
                } else {
                    component.set('v.isButtonDisabled', false);
                    // record is changed so refresh the component (or other component logic)
                    customLabel = $A.get("$Label.c.NCP_PreApproval_Fail");
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        mode: "sticky",
                        title: customLabel,
                        type: "error",
                        message: recordDetails.NCP_NAM_Entitlement_Requested_Err_Resp__c
                    });
                    resultsToast.fire();
                    component.set('v.message', customLabel + ': ' + recordDetails.NCP_NAM_Entitlement_Requested_Err_Resp__c);
                    component.set('v.NAMEntitlement', recordDetails.NCP_NAM_Entitlement_Requested__c);
                }
            }

        } else if (eventParams.changeType === "LOADED") {
            var recordDetails = component.get('v.componentRecord');
            component.set('v.NAMEntitlement', recordDetails.NCP_NAM_Entitlement_Requested__c);
            /*||recordDetails.NCP_Internal_Case__c == false
            // ||(recordDetails.NCP_Contract_Type__c == null && recordDetails.NCP_Internal_Case__c == false) 
             recordDetails.NCP_Contract_Type__c == 'Other Services'|| */
            if (
                recordDetails.NCP_NAM_Entitlement_Requested__c == 'SUCCESS' ||
                recordDetails.Status == 'Rejected' ||
                (recordDetails.NCP_Internal_Case__c == true && recordDetails.NCP_Contract_Type__c == 'CARES' )||
                recordDetails.NCP_Contract_Type__c == null
            ) {
                component.set('v.isButtonDisabled', true);
            } else {
                component.set('v.isButtonDisabled', false);
            }
        } /*else if(eventParams.changeType === "REMOVED") {
            var resultsToast = $A.get("e.force:showToast");
            resultsToast.setParams({
                "title": "Deleted",
                "message": "The record was deleted."
            });
            resultsToast.fire();
        } else if(eventParams.changeType === "ERROR") {
            console.log('Error: ' + component.get("v.error"));
        }*/
    }
});