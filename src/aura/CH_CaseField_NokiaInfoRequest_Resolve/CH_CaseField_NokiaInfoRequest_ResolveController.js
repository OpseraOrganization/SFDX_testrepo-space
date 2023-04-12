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
        //
        var action1 = component.get("c.disablebuttoncheck");
        action1.setParams({ caseId: recordId });
        action1.setCallback(this, function(response) {     
            component.set("v.disableCAButton",response.getReturnValue());
            
        });
        $A.enqueueAction(action1);
        //
        var getCaseTag = component.get("c.getCaseTag");
        getCaseTag.setParams({ caseId: recordId });
        getCaseTag.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.tag", response.getReturnValue());
            }
        });
        $A.enqueueAction(getCaseTag);
        //
        helper.helperMethod(component,event,helper);
    },
    reDoInit : function(component, event, helper) {
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
        //
        var action1 = component.get("c.disablebuttoncheck");
        action1.setParams({ caseId: recordId });
        action1.setCallback(this, function(response) {     
            component.set("v.disableCAButton",response.getReturnValue());
            
        });
        $A.enqueueAction(action1);
        //
        var getCaseTag = component.get("c.getCaseTag");
        getCaseTag.setParams({ caseId: recordId });
        getCaseTag.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.tag", response.getReturnValue());
            }
        });
        $A.enqueueAction(getCaseTag);
        //
        helper.helperMethod(component,event,helper);
    },
    handleSuccess : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: "Success!",
            message: "The record has been updated successfully.",
            type: "success"
        });
        toastEvent.fire();
        helper.helperMethod(component,event,helper);
    },
    update: function(component, event, helper) {
        component.find("recordEditForm").submit();
        $A.get('e.force:refreshView').fire();
    },
    finalSolution: function(component, event, helper) {
        //Change for NOKIASC-17514-Start
        /*component.set("v.issueResolvedFinished",true);
        var flow = component.find("issueResolved");
        var inputVariables = [
            { name : "recordId", type : "String", value: component.get("v.recordId") }
        ];
        flow.startFlow("CH_ResolveCase",inputVariables);*/
        var recordId = component.get("v.recordId");
        var action = component.get("c.checkODRValidationQuery");
        action.setParams({ caseId: recordId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                if (storeResponse) {
                    try {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title: "Failure!",
                            message: "You cannot close this support ticket with outage reported or assessed if following no all End dates in the Outage Duration Records (ODR) are populated.",
                            type: "error"
                        });
                        toastEvent.fire();
                    } catch (e) {
                        console.log("Error Occured------------------->" + e.getMessage());
                    }
                } else {
                    //component.set("v.issueResolvedFinished", true);
                    component.set("v.issueResolvedFinish", true);
                    var flow = component.find("issueResolved");
                    var inputVariables = [
                        {
                            name: "recordId",
                            type: "String",
                            value: component.get("v.recordId")
                        }
                    ];
                    flow.startFlow("CH_ResolveCase", inputVariables);
                }
            }
        });
        $A.enqueueAction(action);
        //Change for NOKIASC-17514-End
    },
    launchCreateArticle : function (component,event,helper) {
        component.set("v.createArticleFinished", true);
        component.set("v.createArticleFinish", true);        
        var flow = component.find("createArticle");
        var inputVariables = [
            { name : "recordId", type : "String", value: component.get("v.recordId") }
        ];
        flow.startFlow("Create_Article_from_Case",inputVariables);
    },
    handleCreateArticleChange : function (component,event,helper) {
        if(event.getParam("status") === "FINISHED") {
            
            component.set("v.Spinner", true);
            component.set("v.createArticleFinished", false);
            component.set("v.createArticleFinish", false);
            $A.get("e.force:refreshView").fire();
            component.set("v.Spinner", false);
        }
    },
    handleIssueResolvedChange : function (component,event,helper) {
       if(event.getParam("status") === "FINISHED") {
            // component.set("v.disableSIRButton",true);
            // component.set("v.issueResolvedFinished",false);
            component.set("v.Spinner", true);
            component.set("v.issueResolvedFinish",false);
            $A.get('e.force:refreshView').fire();
            component.set("v.Spinner", false);
        }
        
    },
    close: function (component, event, helper) {
        component.set("v.issueResolvedFinish",false);
        $A.get('e.force:refreshView').fire();
    },
    closeArticlepopup: function (component, event, helper) {
        component.set("v.createArticleFinish", false);
        $A.get('e.force:refreshView').fire();
    }
});