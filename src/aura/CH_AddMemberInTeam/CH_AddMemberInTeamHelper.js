({
    displayCaseWorkgroupMembers : function(component) {
        var action = component.get('c.getWorkgroupMembers');
        action.setParams({
            'caseId' : component.get("v.recordId")
        });
        action.setCallback(this,function(actionResult) {
            var caseAssignment = actionResult.getReturnValue();            
            if (caseAssignment != null){
            	component.set('v.workgroupMembers', caseAssignment.validWorkgroupMembers);
                component.find("severity").set("v.value", caseAssignment.severity);
                component.find("contractId").set("v.value", caseAssignment.contract);
                component.find("LevelOfSupport").set("v.value", caseAssignment.levelOfSupport[0]);                
                component.find("region").set("v.value", caseAssignment.region);
                component.find("country").set("v.value", caseAssignment.country);
                // Workaround: Knowledge Article Number	000268561
                var value = [{ 
					type: 'Account', 
					id: caseAssignment.customerId, 
				}]; 
                component.find("accLookup").get("v.body")[0].set("v.values", value);
                // Workaround: Knowledge Article Number	000268561
                var value = [{ 
					type: 'Product2', 
					id: caseAssignment.productId, 
				}];
                component.find("productLookup").get("v.body")[0].set("v.values", value);
                component.find("outageBox").set("v.value", caseAssignment.outage);
                component.find("checkboxrota").set("v.value", caseAssignment.isAvailableAccordingToRota);                
            }
        });
        $A.enqueueAction(action);	
    },
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
                    ControllerField.push('===Select===');
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
        dependentFields.push('===Select===');
        for (var i = 0; i < ListOfDependentFields.length; i++) {
            dependentFields.push(ListOfDependentFields[i]);
        }
        component.set("v.listDependingValues", dependentFields);
    }
})