({
    statusval : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var action = component.get("c.statusValueforResolve");
        action.setParams({ caseId : recordId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var statusCheck = response.getReturnValue(); 
                if(statusCheck == 'Created' || statusCheck == 'Assigned')
                {
                    component.set('v.disableButton',true);
                }
                else
                {
                    component.set('v.disableButton',false);
                }
            }
        });
        $A.enqueueAction(action);
    },
    setissueresolved : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var action1 = component.get("c.disablesetissueresolved");
        action1.setParams({ caseId: recordId });
        action1.setCallback(this, function(response) { 
            var state = response.getState();
            if (state === "SUCCESS") {
                var statusCheck = response.getReturnValue();
                component.set("v.disablesetissueresolve",response.getReturnValue());
            }
            else{
                console.log('Server connection failed'+response.getState());
            }
            
            
        });
        $A.enqueueAction(action1);
    },
    showToast: function(sType, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "message": message,
            "type": sType,
            "mode": 'sticky'
        });
        toastEvent.fire();
    },
})