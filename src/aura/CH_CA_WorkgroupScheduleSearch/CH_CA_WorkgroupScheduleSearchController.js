({
    doInit : function(component, event, helper) { 
        helper.getDateTimeDetails(component, event, helper);
        helper.fetchPickListVal(component, 'CH_Region__c', 'regionId');
        helper.fetchPickListVal(component, 'CH_Country__c', 'countryId');
        helper.fetchPickListVal(component, 'CH_Workgroup_Type__c', 'wgTypeId');
        helper.fetchPickListVal(component, 'CH_LevelOfSupport__c', 'levelOfSupport');
    },
    Search: function(component, event, helper) {
        helper.Search(component, event, helper);
    },
    editRecord: function(component, event,helper) {
        helper.editRecord(component,event,helper);
    },
    deleteRecord: function(component, event,helper) {
        helper.deleteRecord(component,event,helper);
    },
    goDetail: function(component, event, helper) {
        var idstr = event.target.getAttribute("data-recId");
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": idstr
        });
        navEvt.fire();
    },
})