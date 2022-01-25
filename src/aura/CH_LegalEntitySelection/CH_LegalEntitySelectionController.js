({
    doInit : function(component, event, helper) {
        helper.init(component, component.get('v.tableColumns'), component.get('v.showOnlyAuthEntities'));
	},
    handleAuthEntities : function(component, event, helper) {
        helper.init(component, component.get('v.tableColumns'), component.get('v.showOnlyAuthEntities'), true);
	},
    handleSelection : function(component, event, helper) {
        helper.select(component, event.getParam('selectedRows')[0]);
    },
    handleSearch : function(component, event, helper) {
        let serviceType = component.get("v.serviceType"), searchText = component.get("v.searchText");
        if(serviceType == 'Internal Support' || !component.get("v.showOnlyAuthEntities")) {
            if(component.get("v.automaticSearch") == false && event.keyCode == 13 ||
            component.get("v.automaticSearch") == true && searchText.length >= 3 ) {
                helper.searchAllLegalEntities(component, searchText, serviceType);
            }
        }
    },
    resetSelection : function(component, event, helper) {
        helper.reset(component);
    },
    emitNotLinkedToCustomer : function(component, event, helper) {
        let notLinkedToCustomer = component.get("v.notLinkedToCustomer");
        component.getEvent("onEvent").setParams({
            message	: 'notLinkedToCustomer',
            target	: 'LegalEntity',
            object 	: notLinkedToCustomer
        }).fire();
        if(notLinkedToCustomer){
            component.set("v.searchText", "");
            component.set("v.legalEntities", []);
        }
    }
})