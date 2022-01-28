({
    searchHelper : function(component,event,getInputkeyWord) {
        // call the apex class method 
        var action = component.get("c.fetchLookUpValues");
        // set param to method  
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'objectName' : component.get("v.objectAPIName")
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", '');
                }
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecords", storeResponse);
            }
            
        });
        // enqueue the Action  
        $A.enqueueAction(action);
        
    },
    attachEventListBox: function(component){
        var myThis = this;
        document.addEventListener('click', function(event){
            var isFilterOpened = component.get('v.isFilterOpened');
            if (isFilterOpened) {
                myThis.closeFilter(component);
                component.set('v.isFilterOpened', false);
            }
        });
    },
    closeFilter : function(component){
        var element = document.getElementById("ncp-listbox"); 
        $A.util.addClass(element, 'slds-hide');
        $A.util.removeClass(element, 'slds-show');
    },
    openFilter : function(component){
        var element = document.getElementById("ncp-listbox"); 
        $A.util.addClass(element, 'slds-show');
        $A.util.removeClass(element, 'slds-hide');
    }
})