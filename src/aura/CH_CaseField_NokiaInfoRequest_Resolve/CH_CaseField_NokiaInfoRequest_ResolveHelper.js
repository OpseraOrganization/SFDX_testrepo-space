({
    helperMethod : function(component,event,helper) {
        var recordId2 = component.get("v.recordId")
        var action2 = component.get("c.disablesetissueresolved");
        action2.setParams({ caseId: recordId2 });
        action2.setCallback(this, function(response) {
           component.set("v.disableSIRButton",response.getReturnValue());      
        });
        $A.enqueueAction(action2);
    },
    showToast: function(sType, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "message": message,
            "type": sType,
            "mode": 'sticky'
        });
        toastEvent.fire();
    }
})