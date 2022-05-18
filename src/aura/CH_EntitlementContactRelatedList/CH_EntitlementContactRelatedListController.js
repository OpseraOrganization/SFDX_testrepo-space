({    
    doInit: function(component, event, helper) {   
        helper.prepareDatatable(component);
        helper.getContactList(component);        
    },    
    updateColumnSorting: function (component, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        component.set("v.sortedBy", fieldName);
        component.set("v.sortedDirection", sortDirection);
        helper.sortData(component, fieldName, sortDirection);
    },
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'delete':
                helper.deleteRecord(component, row)
                break;
        }
    },
    refreshView: function(component, event, helper) {      	
        // Refresh View
        $A.get('e.force:refreshView').fire(); 
   	},
    openModel: function(component, event, helper) {
      	// for Hide/Close Model,set the "isOpen" attribute to "Fasle"
      	component.set("v.isOpen", true);  
   	},
   	closeModel: function(component, event, helper) {
      	// for Hide/Close Model,set the "isOpen" attribute to "Fasle"
      	component.set("v.isOpen", false);  
   	},
    search: function(component, event, helper) {
        // Get the component event by using the name value from aura:registerEvent
        var contractId = component.get("v.recordId");
        var firstName = component.find("cFirstName").get("v.value");
        var lastName = component.find("cLastName").get("v.value");
        var accountName = component.find("cAccountName").get("v.value");  
        var contactId = component.find("cContactId").get("v.value");
        var emailId = component.find("cEmail").get("v.value");  
            
        if (!firstName && !lastName && !accountName && !contactId && !emailId) {
            // Display Error Toast Message
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
            title : 'Error Message',
            message: 'No search parameter found. Kindly enter search keyword.',
            type: 'Error'
            });
            toastEvent.fire();
            return;  
        }
        
        if ((typeof firstName != 'undefined' && firstName) || (typeof lastName != 'undefined' && lastName))  {
        	if((firstName + lastName).length < 2) {
                // Display Error Toast Message
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error Message',
                    message: 'Search term (First or Last Name) must be longer than one character.',
                    type: 'Error'
                });
                toastEvent.fire();
                return;            
            }
        }        
        var childComponent = component.find("resultList");
        childComponent.searchMethod(contractId, firstName, lastName, contactId, emailId, accountName);
   	}
})