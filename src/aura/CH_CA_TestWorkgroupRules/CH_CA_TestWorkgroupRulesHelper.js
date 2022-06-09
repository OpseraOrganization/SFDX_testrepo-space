({
    fetchPicklistValues: function(component,objDetails,controllerField, dependentField) {
        var action = component.get("c.getDependentMap");
        action.setParams({
            'objDetail' : objDetails,
            'contrfieldApiName': controllerField,
            'depfieldApiName': dependentField 
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var StoreResponse = response.getReturnValue();
                component.set("v.depnedentFieldMap",StoreResponse);
                var listOfkeys = [];
                var ControllerField = [];
                for (var singlekey in StoreResponse) {
                    listOfkeys.push(singlekey);
                }
                if (listOfkeys != undefined && listOfkeys.length > 0) {
                    ControllerField.push('--None--');
                }
                for (var i = 0; i < listOfkeys.length; i++) {
                    ControllerField.push(listOfkeys[i]);
                }
                component.set("v.listControllingValues", ControllerField);
            }
        });
        $A.enqueueAction(action);
    },
    fetchDepValues: function(component, ListOfDependentFields) {
        var dependentFields = [];
        dependentFields.push('--None--');
        for (var i = 0; i < ListOfDependentFields.length; i++) {
            dependentFields.push(ListOfDependentFields[i]);
        }
        component.set("v.listDependingValues", dependentFields);
    },
    loadOptions : function(component, event, helper) {
        var action = component.get("c.getRecords");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.options", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
})