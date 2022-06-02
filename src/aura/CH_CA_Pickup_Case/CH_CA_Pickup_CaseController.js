({
    doInit: function(component, event, helper) {
        helper.getCases(component, event, helper);
		component.set("v.PreviousPageNumber",1);
    },
    selectCase: function(component, event, helper) {
        component.set("v.selectedCases", event.getParam('selectedRows'));
    },
    sortCases: function (component, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        component.set("v.sortedBy", fieldName);
        component.set("v.sortedDirection", sortDirection);
        //helper.sortCases(component, fieldName, sortDirection);
        //var data = component.get("v.unassignedCases");
		var data = component.get("v.allFilterData"); 
        var reverse = sortDirection !== 'asc';
        if(fieldName == 'TicketURL') {
            data.sort(helper.sortBy('TicketID', !reverse ? 1 : -1));
        } else if(fieldName == 'AccountURL') {
            data.sort(helper.sortBy('AccountName', !reverse ? 1 : -1));
        } else if(fieldName == 'ProductURL') {
            data.sort(helper.sortBy('ProductName', !reverse ? 1 : -1));
        } else if(fieldName == 'WorkgroupURL') {
            data.sort(helper.sortBy('WorkgroupName', !reverse ? 1 : -1));
        } else {
            data.sort(helper.sortBy(fieldName, !reverse ? 1 : -1));
        }
       // component.set("v.allData", data);  
		component.set("v.allFilterData", data);  
        component.set("v.unassignedCases", data);
        helper.buildData(component, helper);
    },
    acceptCases: function (component, event, helper) {
        helper.acceptCases(component, event, helper);
    },
    showToast: function (text) {
        helper.showToast(text);
    },
    toggleList : function(component, event, helper){
    	component.set('v.showAll', !component.get('v.showAll'));
	},
	filterEntities : function(component, event, helper) {
        var  text= component.get("v.FilterText");
        var data = component.get("v.allData"), 
            results = data, regex;
        try {
            regex = new RegExp(text, "i");
            results = data.filter(
                row => regex.test(row.TicketID) ||
                regex.test(row.AccountName) ||
                regex.test(row.ProductName) ||
                regex.test(row.WorkgroupName)  ||
                regex.test(row.Severity__c) ||
                regex.test(row.CH_Outage__c) ||
                regex.test(row.Status) ||
                regex.test(row.CH_CurrentQueue__c) ||
                regex.test(row.Subject) ||
                regex.test(row.TargetDate) ||
                regex.test(row.CreatedDate) ||
                regex.test(row.CH_CRStatus__c) 
            );
        }
        catch(e) { results = data; }
        var data = [];
        component.set("v.allFilterData", results);
        
        component.set("v.currentPageNumber",1);
        helper.buildData(component, helper);
        
    },
    onNext : function(component, event, helper) {        
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber+1);
        helper.buildData(component, helper);
		component.set("v.PreviousPageNumber",0);
    },
    
    onPrev : function(component, event, helper) {        
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber-1);
        helper.buildData(component, helper);
		if(component.get("v.currentPageNumber") !=component.get("v.totalPages")){
            component.set("v.NextPageNumber",0);
        }
    },
    
    onFirst : function(component, event, helper) {        
        component.set("v.currentPageNumber", 1);
        helper.buildData(component, helper);
    },
    
    onLast : function(component, event, helper) {        
        component.set("v.currentPageNumber", component.get("v.totalPages"));
        helper.buildData(component, helper);
		 component.set("v.PreviousPageNumber",0);
    },
    dispatchCases: function (component, event, helper) {
        helper.dispatchCases(component, event, helper);
    },
    closeModal: function(component, event, helper) {
      // Set isModalOpen attribute to false  
      component.set("v.isModalOpen", false);
   },
     updateColumnSorting: function (cmp, event, helper) {
        cmp.set('v.ModalSpinner', true);
        // We use the setTimeout method here to simulate the async
        // process of the sorting data, so that user will see the
        // spinner loading when the data is being sorted.
        setTimeout($A.getCallback(function() {
            var fieldName = event.getParam('fieldName');
            var sortDirection = event.getParam('sortDirection');
            cmp.set("v.sortedByUser", fieldName);
            cmp.set("v.sortedDirectionUser", sortDirection);
            helper.sortData(cmp, fieldName, sortDirection);
            cmp.set('v.ModalSpinner', false);
        }), 0);
    },
    handleRowAction: function (cmp, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'Assign_User':
                helper.assignUser(row,cmp, event, helper);
                break;            
        }
    },
    
})