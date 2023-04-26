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
        var agrmntRec = component.get("v.agrmntObject");
        if(agrmntRec.CLM_Contract_Category__c === 'Non-Transactional (NDA, LOI, MOU etc.)'){
            helper.nonTransactionAgrmnt(component, event, helper);
        }else{
            component.set("v.newAgreementRecordType",true);
        }
    },
    closeModel: function(component, event, helper) {
        component.set("v.isOpen", false);
        component.set("v.openSuggestion", false);
    },
    closeActiveModel: function(component, event, helper) {
        component.set("v.isReactivateOpen", false);
        component.set("v.isReactivateConfirm", false);
        component.set("v.reactivateEndDate", undefined);
    },
    handleChange: function (component, event, helper) {
        var changeValue = event.getParam("value");
        component.set("v.nextEnable", false);
    },
    closeAgreementModel: function(component, event, helper) {
        component.set("v.newAgreementRecordType", false);
    },
    selectRecordType: function(component, event, helper) {
        helper.selectRecordType(component, event, helper);
    },
    generateNDADocument: function(component, event, helper) {
        helper.checkgenerateNDARequest(component, event, helper);
    },
    submitNdaRequest: function(component, event, helper) {
        helper.submitNdaRequest(component, event, helper);
    },
    proceedSubmission: function(component, event, helper) {
        helper.submitRequest(component, event, helper);
    },
    reactivtRequest: function(component, event, helper) {
        component.set("v.isReactivateOpen", true);
    },
    reActivateRequest: function(component, event, helper) {
        if(component.get("v.reactivateEndDate") !== null ){
            helper.reActivateRequest(component, event, helper);
        }else{
            helper.showToast(component, event, 'Error', 'Please enter End Date');
        }
    },
    confirmReactivate: function(component, event, helper) {
        component.set("v.isReactivateConfirm", true);
    },
    validateEndDate: function(component, event, helper) {
        
        var target = event.getSource();
        if(!$A.util.isUndefinedOrNull(target)) {
            var enteredValue = target.get("v.value");
            var g = new Date();
            if(Date.parse(enteredValue) < g.getTime()){
                component.find("end-date").set("v.value",null);
                helper.showToast(component, event, 'Error', 'Please enter an End Date that is in the Future and try again');
            }
        }
    },
    
    activateAgreement: function(component, event, helper) {
        var agrmntRec = component.get("v.agrmntObject");
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:CLM_AgrmntActivationReqFields",
            componentAttributes: {
                recordId : agrmntRec.Id
            }
        });
        evt.fire();
    }
})