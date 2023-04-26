({
    onControllerFieldChange: function(component, event, helper) {     
        var controllerValueKey = event.getSource().get("v.value"); // get selected controller field value
        var depnedentFieldMap = component.get("v.depnedentFieldMap");
        if (controllerValueKey != '===Select===') {
            var ListOfDependentFields = depnedentFieldMap[controllerValueKey];
            if(ListOfDependentFields.length > 0){
                component.set("v.bDisabledDependentFld" , false);  
                helper.fetchDepValues(component, ListOfDependentFields);    
            }else{
                component.set("v.bDisabledDependentFld" , true); 
                component.set("v.listDependingValues", ['===Select===']);
            }  
        } else {
            component.set("v.listDependingValues", ['===Select===']);
            component.set("v.bDisabledDependentFld" , true);
        }
    },   
    doInit : function(component, event, helper)
    {
        component.set("v.Spinner", true); 
        // Preload the member list with the current workgroup team members
        helper.displayCaseWorkgroupMembers(component);
        // Load the region and country picklists
        //helper.fetchPicklistValues(component,"{'sobjectType' : 'CH_Workgroup_Rule__c'}",'CH_Region__c', 'CH_Country__c');
 
        // get the fields API name and pass it to helper function  
        var controllingFieldAPI = component.get("v.controllingFieldAPI");
        var dependingFieldAPI = component.get("v.dependingFieldAPI");
        var objDetails = component.get("v.objDetail");
        // call the helper function
        helper.fetchPicklistValues(component,objDetails,controllingFieldAPI, dependingFieldAPI);
               
        component.set("v.Spinner", false);
    },
    searchWorkgroupMembers2 : function(component, event, helper)
    {
        component.set("v.Spinner", true); 
        var action = component.get("c.searchWorkgroupMembers");
        var caseId = component.get("v.recordId")
        var contract = component.find("contractId").get("v.value");
        var severity= component.find("severity").get("v.value");
        var region= component.find("region").get("v.value");
        var country= component.find("country").get("v.value");
        var levelOfSupport = [];
		levelOfSupport.push({value: component.find("LevelOfSupport").get("v.value")});
        var levelOfSupport= component.find("LevelOfSupport").get("v.value");
        var customer = component.find("accLookup").get("v.value");
        var customerGroup = component.find("custoGroupLookup").get("v.value");
        var product = component.find("productLookup").get("v.value");
        var productGroup = component.find("productGroupLookup").get("v.value");
        var outage = component.find("outageBox").get("v.value");
        var rota = component.find("checkboxrota").get("v.value");
        
        action.setParams({caseId: caseId, contract : contract, severity : severity, region : region, 
                          country : country, levelOfSupport : levelOfSupport, 
                          customer : customer, customerGroup : customerGroup, product : product, 
                          productGroup : productGroup, outage : outage, rota : rota});
        action.setCallback(this, function(actionResult) {
            var caseAssignment = actionResult.getReturnValue();            
            if (caseAssignment != null){
                component.set('v.workgroupMembers',caseAssignment.validWorkgroupMembers);
            }
            component.set("v.Spinner", false);
        });
        $A.enqueueAction(action);
    },
    // When the add button is clicked display the assign role window
    showSelectRolePopup : function(component, event) {
        component.set("v.ShowModal",true);
        var memId=event.getSource().get("v.value");
        var caseId = component.get("v.recordId");
        component.set("v.CurrentUserId",memId);
        component.set("v.CurrentCaseId",caseId);
    },    
    // When add is clicked in the assign role window
    addMemberToTeam : function(component) {
        component.set("v.Spinner", true); 
        var action = component.get("c.InsertMember");
        var UserId  = component.get("v.CurrentUserId");
        var caseId = component.get("v.CurrentCaseId");
        var memberSelectedRole = component.find("Member").get("v.value");
        action.setParams({ UserId : UserId, caseId : caseId, memberSelectedRole : memberSelectedRole });
        action.setCallback(this, function(response) {
			component.set("v.Spinner", false);            
            var state = response.getState();            
            component.set("v.ShowModal",false);
            if (response.getState() == "ERROR") {
                var errorMessage = 'undefined';
                var errors = response.getError();
                if (errors) {
                	if (errors[0] && errors[0].message) {
                   		errorMessage = errors[0].message;
                	}
                    else if (errors[0] && errors[0].pageErrors) {
                        errorMessage = errors[0].pageErrors[0].message;
                    }
            	}
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Case Team Error Occured',
                    message: 'Person could not be added to the case team. Error: '+ errorMessage,
                    type : 'Error',
                    mode: 'sticky'
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
        $A.get('e.force:refreshView').fire();
    },
    // When cancel is clicked in the assign role window
    cancelSelectRolePopup : function(component) {
        component.set("v.ShowModal",false);
    }
})