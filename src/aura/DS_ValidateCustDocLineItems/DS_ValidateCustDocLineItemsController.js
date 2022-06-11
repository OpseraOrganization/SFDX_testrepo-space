({
	doInit: function(component, event, helper) {
        // call the helper function on component load
        helper.fetchPickListVal(component, 'status__c', 'status');
        
    },
    onPicklistChange: function(component, event, helper) {
        // get the value of select option
        component.set("v.changedStatus",event.getSource().get("v.value"));
        helper.updateParentRecord(component, event,event.getSource().get("v.value"));
    },

})