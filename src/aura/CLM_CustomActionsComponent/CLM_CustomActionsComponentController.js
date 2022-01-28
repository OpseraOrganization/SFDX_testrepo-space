({
    doInit: function(component, event, helper) {
        component.set("v.submitRequestLabel","Submit to L&C");
        helper.getRecordDetails(component, event, helper); 
        helper.checkCustomPermissionForCurrentUser(component, event, helper);
    },
    validatingRequest: function(component, event, helper) {
        component.set("v.spinner",true);
        helper.getFields(component, event, helper, 'SubmitRequest');
    }, 
    returnToRequestor: function(component, event, helper) {
        helper.returnToRequestor(component, event, helper);
    },
    cancelRequest: function(component, event, helper) {
        component.set("v.spinner",true);
        helper.cancelRequest(component, event, helper);
    },
    amendRequest: function(component, event, helper) {
        component.set("v.spinner",true);
        helper.amendRequest(component, event, helper);
    },
    renewRequest: function(component, event, helper) {
        component.set("v.spinner",true);
        helper.renewRequest(component, event, helper);
    },
    createNewAgreement: function(component, event, helper) {
        component.set("v.newAgreementRecordType",true);
    },
    closeModel: function(component, event, helper) {
        component.set("v.isOpen", false);
    },
    handleChange: function (component, event, helper) {
        var changeValue = event.getParam("value");
        component.set("v.nextEnable", false);
        
    },
    closeAgreementModel: function(component, event, helper) {
        component.set("v.newAgreementRecordType", false);
    },
    selectRecordType: function(component, event, helper) {
        var agrmntRec = component.get("v.agrmntObject");
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:CLM_AgrmntRelatedCntrctRequest",
            componentAttributes: {
                recordTypeVal : component.get("v.RecordTypeVal"),
                nameOfAgrmnt : agrmntRec.Name,
                recordId : agrmntRec.Id,
                showRecordTable : true
            }
        });
        evt.fire();
    },
    
})