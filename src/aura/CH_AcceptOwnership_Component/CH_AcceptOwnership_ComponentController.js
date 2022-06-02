({
    doInit : function(component, event, helper) {
        var action = component.get("c.validUser");
        action.setParams({
            "caseId" : component.get("v.recordId")
        });
        action.setCallback(this, function(result) {
            component.set('v.validUser', result.getReturnValue()?true:false);
        });
        $A.enqueueAction(action);    
        
    },
    //Accept the Case if it is still assigned to the queue
    acceptOwnership : function(component, event, helper) {
        component.set("v.Spinner",true);
        var action = component.get("c.assignSelfOwnership");
        action.setParams({
            "caseId" : component.get("v.recordId")
        });
        action.setCallback(this, function(result) {
            if(result.getState() !== 'ERROR') {
                if(result.getReturnValue()){
                    helper.showToast('Success', '','User assigned to the case');
                }
                else{
                    helper.showToast('Error', '', 'This case is already assigned to a User.');
                }
                
                component.set("v.Spinner",false);
                $A.get('e.force:refreshView').fire();
                
            }
        });
        $A.enqueueAction(action);
        
    }
    
})