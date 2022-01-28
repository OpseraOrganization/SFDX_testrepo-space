({
    prepareDatatable: function(component) {
        var action = component.get("c.checkUserPermission"); 
        action.setCallback(this, function(response){
            var state = response.getState();
            var columns = new Array();
            if (state === "SUCCESS") {
                var isAuthorized = response.getReturnValue();
                component.set("v.isNewButtonVisible", isAuthorized); 
                if(isAuthorized) {
                    columns.push(
                        {type: 'button', typeAttributes: { 
                            label: 'Delete', name: 'delete'
                        }}
                    );
                }                        
            }
            columns.push(
                {label: 'Name', fieldName: 'Name', type: 'text', sortable: 'true'}
            );
            columns.push(
                {label: 'Entitlement Name', fieldName: 'EntitlementURL', type: 'url', sortable: 'true', typeAttributes: {
                    label: { fieldName: 'EntitlementName' }
                }}
            );
            columns.push(
                {label: 'Contact Name', fieldName: 'ContactURL', type: 'url', sortable: 'true', typeAttributes: {
                    label: { fieldName: 'ContactName' }
                }}
            );
            columns.push(
                {label: 'Legal Entity Name', fieldName: 'LegalEntityName', type: 'text', sortable: 'true'}
            );
            component.set('v.mycolumn', columns);
        });       
        $A.enqueueAction(action);
    },
    getContactList: function(component) {    
        var action = component.get("c.getContactList");        
        action.setParams({
            "recordId" : component.get("v.recordId")
        });    
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnList = response.getReturnValue();
                for(var i = 0; i < returnList.length; i++) {
                    returnList[i].EntitlementURL = '/one/one.app?#/sObject/' + returnList[i].EntitlementId + '/view';
                    returnList[i].EntitlementName = returnList[i].Entitlement.Name;
                    returnList[i].ContactURL = '/one/one.app?#/sObject/' + returnList[i].ContactId + '/view';
                    returnList[i].ContactName = returnList[i].Contact.Name;                    
                    returnList[i].AccountURL = '/one/one.app?#/sObject/' + returnList[i].Contact.AccountId + '/view';
                    returnList[i].AccountName = returnList[i].Contact.Account.Name;
					returnList[i].AccountId = returnList[i].Contact.AccountId;      
                    returnList[i].LegalEntityName = returnList[i].Contact.CH_Legal_Entity_Name__c;
                }
                // helper.manipulateResponse(returnList);
                component.set("v.EntitlementContacts", returnList);              
            }
        });         
        $A.enqueueAction(action);
    },
    deleteRecord: function(component, row) {               
        var action = component.get("c.deleteRecord");        
        action.setParams({
            "contractId" : component.get("v.recordId"),
            "contactId" : row.ContactId,
            "deleteId" : row.Id
        });    
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") { 
                var rows = component.get('v.EntitlementContacts'); 
        		var rowIndex = rows.indexOf(row);
            	rows.splice(rowIndex, 1);
            	component.set('v.EntitlementContacts', rows); 
                // Display Success Toast Message   
            	var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success Message',
                    message: response.getReturnValue(),
                    type: 'Success'
                });
                toastEvent.fire(); 
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
        var data = component.get("v.EntitlementContacts");
        var reverse = sortDirection !== 'asc';
        if(fieldName == 'EntitlementURL') {
            data.sort(this.sortBy('EntitlementName', reverse));
        } else if(fieldName == 'ContactURL') {
            data.sort(this.sortBy('ContactName', reverse));
        } else if(fieldName == 'AccountURL') {
            data.sort(this.sortBy('AccountName', reverse));
        } else {
            data.sort(this.sortBy(fieldName, reverse));
        }
        component.set("v.EntitlementContacts", data);
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