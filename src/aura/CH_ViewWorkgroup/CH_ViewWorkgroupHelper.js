({
    getWorkgroupMembers : function(component)
    {
        var action = component.get('c.getWorkgroupMembers'); 
        action.setParams({'caseId': component.get("v.recordId")});
        action.setCallback(this,function(result) {
            var caseAssignment = action.getReturnValue();
            if (caseAssignment != null){
            	component.set('v.workgroupMembers', caseAssignment.validWorkgroupMembers);
            	component.set('v.assignmentType', caseAssignment.isActiveAssignment);
            	component.set('v.workgroupRule', caseAssignment.validWorkgroupRules);
                component.set('v.initialAssignment', caseAssignment.supportCase.CH_Initial_Assignment__c);
            }
            else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message: 'No workgroup rule found for this case',
                    type : 'Error',
                    mode: 'sticky'
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }, 
})