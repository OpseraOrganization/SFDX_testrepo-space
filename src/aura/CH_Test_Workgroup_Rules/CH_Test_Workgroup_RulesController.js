({
    doInit : function(component, event, helper) { 
        // get the fields API name and pass it to helper function  
        var controllingFieldAPI = component.get("v.controllingFieldAPI");
        var dependingFieldAPI = component.get("v.dependingFieldAPI");
        var objDetails = component.get("v.objDetail");
        // call the helper function
        helper.fetchPicklistValues(component,objDetails,controllingFieldAPI, dependingFieldAPI);
    },
    onControllerFieldChange: function(component, event, helper) {     
        var controllerValueKey = event.getSource().get("v.value"); // get selected controller field value
        var depnedentFieldMap = component.get("v.depnedentFieldMap");
        if (controllerValueKey != '--- None ---') {
            var ListOfDependentFields = depnedentFieldMap[controllerValueKey];
            if(ListOfDependentFields.length > 0){
                component.set("v.bDisabledDependentFld" , false);  
                helper.fetchDepValues(component, ListOfDependentFields);    
            }else{
                component.set("v.bDisabledDependentFld" , true); 
                component.set("v.listDependingValues", ['--- None ---']);
            }  
        } else {
            component.set("v.listDependingValues", ['--- None ---']);
            component.set("v.bDisabledDependentFld" , true);
        }
    },
    Search : function(component,event) {
        var action = component.get("c.fetchFilterValues");
        var Contract = component.find("contractId").get("v.value");
        var Severity= component.find("severity").get("v.value");
        var Region= component.find("region").get("v.value");
        var Country= component.find("country").get("v.value");
        var levelOfSupport= component.find("LevelOfSupport").get("v.value");
        var customer = component.find("accLookup").get("v.value");
        var custoGroup = component.find("custoGroupLookup").get("v.value");
        var product = component.find("productLookup").get("v.value");
        var productGroup = component.find("productGroupLookup").get("v.value");
        var Outage = component.find("outageBox").get("v.value");
		action.setParams({Contract : Contract, Severity : Severity, Region : Region, Country : Country, levelOfSupport : levelOfSupport, 
                          Customer : customer, CustomerGroup : custoGroup, Product : product, ProductGroup : productGroup, Outage : Outage });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var rules = response.getReturnValue();
            if (state === "SUCCESS") {
                component.set('v.workGroupRules', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    refresh : function(component,event) {
        $A.get('e.force:refreshView').fire();
    },
    newRecord: function(component, event) {
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            'entityApiName' : 'CH_Workgroup_Rule__c'
        });
        createRecordEvent.fire();
    },
    deleteRecord: function(component, event) {
        var rectarget = event.currentTarget;
        var idstr = event.target.getAttribute("data-recId");       
        var Workgrouprule = component.get("v.workGroupRules");       
        var items = [];
        var i=0;
        for (i = 0; i < Workgrouprule.length; i++) {
            if(Workgrouprule[i].Id!==idstr) {
                items.push(Workgrouprule[i]);  
            }
        }
        component.set("v.workGroupRules",items);
        var action = component.get("c.deleteRule");
        action.setParams({idstr : idstr, ListWGR : Workgrouprule});
        action.setCallback(this, function(response) {
        });
        $A.enqueueAction(action);
    },
    editRecord: function(component, event) {
        var rectarget = event.currentTarget;
        var idstr = event.target.getAttribute("data-recId"); 
        var editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
            "recordId": idstr
        });
        editRecordEvent.fire();    
    }
})