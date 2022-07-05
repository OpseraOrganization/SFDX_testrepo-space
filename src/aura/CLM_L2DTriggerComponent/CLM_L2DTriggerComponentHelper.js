({
    getL2DTriggerAnswers: function(component, event, helper, requestType) {
        component.set("v.spinner",true);
        var action = component.get("c.getL2DAnswers");
        action.setParams({
            "clauseId" : component.get("v.recordId"),
            "triggerId" : component.get("v.triggerId")
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                component.set("v.trgAnswersLst",response.getReturnValue());
                component.set("v.spinner",false);
                component.set("v.isOpen",true);
            }
        });
        $A.enqueueAction(action);
    },
    getNonL2DTriggerAnswers: function(component, event, helper) {
        component.set("v.spinner",true);
        var action = component.get("c.getNonL2DAnswer");
        action.setParams({
            "recordId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                var res = response.getReturnValue();
                component.set("v.isOpen",true);
                component.set("v.nonL2DAnswer",res.CLM_L2D_Trigger_Answer__c);
                component.set("v.nonL2DClause",res.Apttus__Clause__c);
                component.set("v.nonL2DText",res.Apttus__Text__c);
                 component.set("v.spinner",false);
            }
        });
        $A.enqueueAction(action);
    },
    saveAnswer: function(component, event, helper, requestType) {
        component.set("v.spinner",true);
        var action = component.get("c.saveTriggerAnswer");
        action.setParams({
            "answRec" : JSON.stringify(component.get("v.trgAnswer")),
            "recordId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                sforce.one.showToast({
                    "title": "Success!",
                    "message": "The record was updated successfully."
                });
                sforce.one.back(true);
                sforce.one.navigateToSObject(component.get("v.recordId"));
                
            }
        });
        $A.enqueueAction(action);
    },
    saveNonL2DAnswer: function(component, event, helper, requestType) {
        component.set("v.spinner",true);
        var action = component.get("c.saveNonL2DTriggerAnswer");
        action.setParams({
            "answer" : component.get("v.nonL2DAnswer"),
            "recordId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                sforce.one.showToast({
                    "title": "Success!",
                    "message": "The record was updated successfully."
                });
                sforce.one.back(true);
                sforce.one.navigateToSObject(component.get("v.recordId"));
            }
        });
        $A.enqueueAction(action);
    },
    
})