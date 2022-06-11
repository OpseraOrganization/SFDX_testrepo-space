({
    switchEditMode: function(cmp) {
        cmp.set("v.editMode", !cmp.get("v.editMode"));
    },
    showSuccess: function (cmp) {
        cmp.set("v.success", true);
        window.setTimeout(
            $A.getCallback(function() {
                cmp.set("v.success", false);
            }), 2000
        );
    },
    showError: function (cmp, message) {
        cmp.set("v.error", true);
        cmp.set("v.errorMessage", message);
        window.setTimeout(
            $A.getCallback(function() {
                cmp.set("v.true", false);
            }), 2000
        );
    },
    fillCaseOriginPicklist: function(cmp, valuesArray) {
        var opts = [{label: '- select a value -', value: null}];

        valuesArray.map(
            function(picklistElement){
                opts.push({label: picklistElement.label, value: picklistElement.value})
            }
        );

        cmp.set("v.origins", opts);
    },
    setActiveOriginSystem: function (cmp, evt) {
        var optionsSet = cmp.get("v.origins");
        var activeValue = cmp.get("v.mappingRecord").CaseOriginSystem__c;

        var optsToShow = [];

        optionsSet.map(
            function(picklistElement){
                if (picklistElement.value === activeValue) {
                    optsToShow.push({label: picklistElement.label, value: picklistElement.value, selected: "true"})
                } else {
                    optsToShow.push({label: picklistElement.label, value: picklistElement.value})
                }
            }
        );
        cmp.find("InputSelectDynamic").set("v.options", optsToShow);
    },
    clearForm: function (cmp, evt) {
        var mappingRecord = {
            "Name" : "",
            "CaseOriginSystem__c" : "",
            "AccountIn__c" : "",
            "SolutionIn__c" : "",
            "ProductIn__c" : "",
            "VariantIn__c" : "",
            "ProductReleaseIn__c" : "",
            "AccountOut__c" : "",
            "SolutionOut__c" : "",
            "ProductOut__c" : "",
            "VariantOut__c" : "",
            "ProductReleaseOut__c" : "",
            "EntitlementOut__c" : "",
        };

        cmp.set("v.mappingRecord", mappingRecord);
    },
    markRangesMapping: function(cmp) {
        var mappingRecord = cmp.get("v.mappingRecord");

        if (mappingRecord.CaseOriginSystem__c === 'tmobile-tim') {
            cmp.set('v.hasRanges', true);
        } else {
            cmp.set('v.hasRanges', false);
        }
    }
})