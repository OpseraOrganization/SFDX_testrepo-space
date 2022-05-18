({
    //init function for initial page load
    doInit : function(component, event, helper) {     
		helper.getDateTimeDetails(component, event, helper);
        helper.getUserDetail(component, event, helper)
        .then(function(response){                                   
            component.find("user").set("v.value", response);                                              
        }).then(function(response){            
            helper.Search(component, event, helper);
        });
    },
    //Search button click action
    Search: function(component, event, helper) {
        helper.Search(component, event, helper);
    },
    //sorting funtion for data table
    updateColumnSorting: function (cmp, event, helper) {
        cmp.set('v.ModalSpinner', true);
        // We use the setTimeout method here to simulate the async
        // process of the sorting data, so that user will see the
        // spinner loading when the data is being sorted.
        setTimeout($A.getCallback(function() {
            var fieldName = event.getParam('fieldName');
            var sortDirection = event.getParam('sortDirection');
            cmp.set("v.sortedByValue", fieldName);
            cmp.set("v.sortedDirectionUser", sortDirection);
            helper.sortData(cmp, fieldName, sortDirection);
            cmp.set('v.ModalSpinner', false);
        }), 0);
    },
    //data table pagination next button click
    onNext : function(component, event, helper) {        
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber+1);
        helper.initializationPagination(component, helper);
        component.set("v.PreviousPageNumber",0);
    },
    //data table pagination Previous button click
    onPrev : function(component, event, helper) {        
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber-1);
        helper.initializationPagination(component, helper);
        if(component.get("v.currentPageNumber") !=component.get("v.totalPages")){
            component.set("v.NextPageNumber",0);
        }
    },    
    //data table pagination First button click
    onFirst : function(component, event, helper) {        
        component.set("v.currentPageNumber", 1);
        helper.initializationPagination(component, helper);
    },    
    //data table pagination Last button click
    onLast : function(component, event, helper) {        
        component.set("v.currentPageNumber", component.get("v.totalPages"));
        helper.initializationPagination(component, helper);
        component.set("v.PreviousPageNumber",0);
    },
})