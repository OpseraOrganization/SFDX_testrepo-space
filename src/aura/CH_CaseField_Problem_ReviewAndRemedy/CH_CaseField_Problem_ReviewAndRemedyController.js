({
    doInit : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var action = component.get("c.accessCheck");
        action.setParams({ caseId : recordId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.edit",response.getReturnValue());
            }
        });
        $A.enqueueAction(action);

        var actionTransferRndShowButton = component.get("c.transferRndAccessCheck");
        actionTransferRndShowButton.setParams({ caseId : recordId });
        actionTransferRndShowButton.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.transferRndShowButton",response.getReturnValue().length > 0);
                component.set("v.interfaceType",response.getReturnValue().toLowerCase());
            }
        });
        $A.enqueueAction(actionTransferRndShowButton);
    },
    handleSuccess : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The record has been updated successfully.",
            "type": "success"
        });
        toastEvent.fire();
    },
    update : function(component,event,helper) {
        component.find("recordEditForm").submit();
        $A.get('e.force:refreshView').fire();
    },
    shareTemporarySolution : function (component,event,helper) {
        component.set("v.shareTemporarySolutionFinished",true);
        var flow = component.find("shareTemporarySolution");
        var inputVariables = [
            { name : "recordId", type : "String", value: component.get("v.recordId") }
        ];
        flow.startFlow("CH_ProvideTemporarySolution",inputVariables);
    },
    shareSolution : function (component,event,helper) {
        component.set("v.shareSolutionFinished",true);
        var flow = component.find("shareSolution");
        var inputVariables = [
            { name : "recordId", type : "String", value: component.get("v.recordId") }
        ];
        flow.startFlow("CH_PopulateSolutionFromProblem",inputVariables);
    },
    withdrawTemporarySolution : function (component,event,helper) {
        component.set("v.withdrawTemporarySolutionFinished",true);
        var flow = component.find("withdrawTemporarySolution");
        var inputVariables = [
            { name : "recordId", type : "String", value: component.get("v.recordId") }
        ];
        flow.startFlow("CH_WithdrawTemporarySolution",inputVariables);
    },
    transferToRnd : function (component,event,helper) {
        var recordId = component.get("v.recordId");
        var action = component.get("c.transferRndRequiredFieldsCheck");
        action.setParams({ caseId : recordId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue()) {
                    $A.createComponent(
                        "c:CH_TransferRndInteraction",
                        {
                            "interfaceType": component.get("v.interfaceType").toLowerCase(),
                            "problemId": component.get("v.recordId"),
                            "headerMessage": "Transfer to R&D"
                        },
                        function(msgBox){                
                            if (component.isValid()) {
                                var cmp = component.find('transferRndModal');
                                var body = cmp.get("v.body");
                                body.push(msgBox);
                                cmp.set("v.body", body); 
                                msgBox.setDefaultOutboundRndInteractionProperties();
                            }
                        }
                    );
                } else {
                    $A.createComponent(
                        "c:CH_TransferRndInteraction",
                        {
                            "showValidationError": "true",
                            "headerMessage": "Transfer to R&D"
                        },
                        function(msgBox){                
                            if (component.isValid()) {
                                var cmp = component.find('transferRndModal');
                                var body = cmp.get("v.body");
                                body.push(msgBox);
                                cmp.set("v.body", body); 
                            }
                        }
                    );
                }
            }
        });
        $A.enqueueAction(action);
    },
    closeTransferToRnd : function (component,event,helper) {
        $A.util.removeClass(component.find("transferRndModal"), "slds-fade-in-open");
        $A.util.removeClass(component.find("transferRndModalBack"), "slds-fade-in-open");
    },
    createKnownError : function (component,event,helper) {
        component.set("v.createKnownErrorFinished",true);
        var flow = component.find("createKnownError");
        var inputVariables = [
            { name : "recordId", type : "String", value: component.get("v.recordId") }
        ];
        flow.startFlow("Create_Article_from_Case",inputVariables);
    },
    handleShareTemporarySolutionChange : function (component,event,helper) {
        if(event.getParam("status") === "FINISHED") {
            component.set("v.shareTemporarySolutionFinished",false);
        }
    },
    handleShareSolutionChange : function (component,event,helper) {
        if(event.getParam("status") === "FINISHED") {
            component.set("v.shareSolutionFinished",false);
        }
    },
    handleWithdrawTemporarySolutionChange : function (component,event,helper) {
        if(event.getParam("status") === "FINISHED") {
            component.set("v.withdrawTemporarySolutionFinished",false);
        }
    },
    handleCreateProblemFinished : function (component,event,helper) {
        if(event.getParam("status") === "FINISHED") {
            component.set("v.createProblemFinished",false);
        }
    },
    handleCreateKnownErrorChange : function (component,event,helper) {
        if(event.getParam("status") === "FINISHED") {
            component.set("v.createKnownErrorFinished",false);
        }
    }
})