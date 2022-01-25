({
    doInit: function (cmp, evt, helper) {
        cmp.set("v.loading", true);

        // get Case Origin System picklist values
        var action = cmp.get("c.getCaseOriginSystemValues");
        action.setCallback(this, function(response) {
            var state = response.getState();
            cmp.set("v.loading",false);

            if (state === "SUCCESS") {
                if (response.getReturnValue() !== null) {
                    helper.fillCaseOriginPicklist(cmp, JSON.parse(response.getReturnValue()));
                    helper.setActiveOriginSystem(cmp);
                } else {
                    helper.showError(cmp, response.getReturnValue());
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        helper.showError(cmp, errors[0].message);
                    }
                } else {
                    helper.showError(cmp, "Unknown error");
                }
            }
        });

        $A.enqueueAction(action);
    },
    onChange: function (cmp, evt, helper) {
        var selectedPicklistValue = cmp.find("InputSelectDynamic").get("v.value");

        var mappingRecord = cmp.get("v.mappingRecord");
        mappingRecord.CaseOriginSystem__c = selectedPicklistValue;

        cmp.set("v.mappingRecord", mappingRecord);

        helper.markRangesMapping(cmp);
    },
    openIMDetail: function(cmp, evt, helper) {
        var mappingRecord = evt.getParam("im");

        if (mappingRecord.Name === undefined ) {mappingRecord.Name = "";}
        if (mappingRecord.CaseOriginSystem__c === undefined ) {mappingRecord.CaseOriginSystem__c = "";}
        if (mappingRecord.AccountIn__c === undefined ) {mappingRecord.AccountIn__c = "";}
        if (mappingRecord.SolutionIn__c === undefined ) {mappingRecord.SolutionIn__c = "";}
        if (mappingRecord.ProductIn__c === undefined ) {mappingRecord.ProductIn__c = "";}
        if (mappingRecord.VariantIn__c === undefined ) {mappingRecord.VariantIn__c = "";}
        if (mappingRecord.ProductReleaseIn__c === undefined ) {mappingRecord.ProductReleaseIn__c = "";}
        if (mappingRecord.AccountOut__c === undefined ) {mappingRecord.AccountOut__c = "";}
        if (mappingRecord.SolutionOut__c === undefined ) {mappingRecord.SolutionOut__c = "";}
        if (mappingRecord.ProductOut__c === undefined ) {mappingRecord.ProductOut__c = "";}
        if (mappingRecord.VariantOut__c === undefined ) {mappingRecord.VariantOut__c = "";}
        if (mappingRecord.ProductReleaseOut__c === undefined ) {mappingRecord.ProductReleaseOut__c = "";}
        if (mappingRecord.EntitlementOut__c === undefined ) {mappingRecord.EntitlementOut__c = "";}
        if (mappingRecord.RangePrefix__c === undefined ) {mappingRecord.RangePrefix__c = "";}
        if (mappingRecord.RangeStart__c === undefined ) {mappingRecord.RangeStart__c = "";}
        if (mappingRecord.RangeEnd__c === undefined ) {mappingRecord.RangeEnd__c = "";}

        cmp.set("v.mappingRecord", mappingRecord);

        if (!!mappingRecord.Id) {
            cmp.set("v.editMode", false);
        } else {
            cmp.set("v.editMode", true);
            helper.clearForm(cmp);
        }

        helper.setActiveOriginSystem(cmp);
        helper.markRangesMapping(cmp);

        cmp.set("v.success", false);
        cmp.set("v.error", false);
    },
    doUpdate: function (cmp, evt, helper) {
        cmp.set("v.loading", true);

        var action = cmp.get("c.upsertInterfaceMappingRecord");
        action.setParams({record : cmp.get("v.mappingRecord")});

        action.setCallback(this, function(response) {
            var state = response.getState();
            cmp.set("v.loading",false);

            if (state === "SUCCESS") {
                if (response.getReturnValue() !== null && response.getReturnValue() === '') {
                    // fire table refresh event
                    var savedImEvent = $A.get("e.c:CH_InterfaceMappingSavedEvent");
                    savedImEvent.setParams({"im": cmp.get("v.mappingRecord")});
                    savedImEvent.fire();

                    helper.showSuccess(cmp);
                    helper.switchEditMode(cmp);
                } else {
                    helper.showError(cmp, response.getReturnValue());
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        helper.showError(cmp, errors[0].message);
                    }
                } else {
                    helper.showError(cmp, "Unknown error");

                }
            }
        });

        $A.enqueueAction(action);
    },
    switchEditMode: function(cmp, evt, helper) {
        helper.switchEditMode(cmp);
    },
    cancelEditHandler: function (cmp, evt, helper) {
        helper.switchEditMode(cmp);
    },
})