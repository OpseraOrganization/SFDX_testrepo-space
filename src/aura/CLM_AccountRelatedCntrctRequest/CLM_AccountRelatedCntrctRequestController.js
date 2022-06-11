({
	doInit : function(component, event, helper) {
        /*var pageReference = component.get("v.pageReference");
        component.set("v.recordId", pageReference.state.c__recordId);*/
        helper.getDefaultAccount(component, event, helper);
    },
    closeAgreementModel: function(component, event, helper) {
        sforce.one.navigateToSObject(component.get("v.recordId"));
        component.set("v.newAgreementRecordType", false);
    },
    handleChange: function (component, event, helper) {
        var changeValue = event.getParam("value");
        component.set("v.recordTypeVal",changeValue),
        component.set("v.nextEnable", false);
        
        
    },
    selectRecordType: function(component, event, helper) {
        component.set("v.isOpen",false);
        helper.selectRecordType(component, event, helper);
    }
})