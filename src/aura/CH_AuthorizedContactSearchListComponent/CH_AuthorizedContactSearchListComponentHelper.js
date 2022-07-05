({
    fetchData: function (component, event, helper) {
        var params = event.getParam("arguments");
        // Set contract Id 
        component.set("v.contractId", params.contractId);
        var action = component.get("c.getSearchContactList");  
        action.setParams({
            "contractId" : params.contractId,
            "fName" : params.firstName,
            "lName" : params.lastName,
            "contactId" : params.contactId,
            "email" : params.emailId,
            "accountName" : params.accountName
        }); 
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnList = response.getReturnValue();   
                component.set("v.contacts", returnList);              
            }
        });         
        $A.enqueueAction(action);
    },
    addRecord: function(component, row) {        
        var action = component.get("c.addEntitlementContact");        
        action.setParams({
            "contractId" : component.get("v.contractId"),
            "contactObj" : row
        });    
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") { 
                var rows = component.get('v.contacts'); 
        		var rowIndex = rows.indexOf(row);
            	rows.splice(rowIndex, 1);
            	component.set('v.contacts', rows);         
                // Display Success Toast Message   
            	var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success Message',
                    message: response.getReturnValue(),
                    type: 'Success'
                });
                toastEvent.fire(); 
                // Refresh View
                $A.get('e.force:refreshView').fire();
            } else {
            	// Display Error Toast Message
            	var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error Message',
                    message: response.getError()[0].message,
                    type: 'Error'
                });
                toastEvent.fire();   
            }
        });         
        $A.enqueueAction(action);
    },
    sortData: function (component, fieldName, sortDirection) {
        var data = component.get("v.contacts");
        var reverse = sortDirection !== 'asc';
        data.sort(this.sortBy(fieldName, reverse))
        component.set("v.contacts", data);
    },
    sortBy: function (field, reverse, primer) {
        var key = primer ?
            function(x) {return primer(x[field])} :
            function(x) {return x[field]};
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a)?key(a):'', b = key(b)?key(b):'', reverse * ((a > b) - (b > a));
        }
    }
})