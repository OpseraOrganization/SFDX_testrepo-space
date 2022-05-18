({
	searchHelper : function(component,event,getInputkeyWord, selectedContractLineItem) {
      console.log('selectedContractLineItem====******'+selectedContractLineItem);
	  // call the apex class method 
     var action = component.get("c.fetchLookUpValues");
        var test = component.get("v.objectAPIName");
        console.log('getInputkeyWord====='+getInputkeyWord);
        console.log('test==='+test);
        console.log('selectedContractLineItem===='+selectedContractLineItem);
      // set param to method  
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'ObjectName' : component.get("v.objectAPIName"),
            'contractLineItemId' :selectedContractLineItem 
          });
      // set a callBack    
        action.setCallback(this, function(response) {
          $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            console.log('state====='+state);
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
              // if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", '');
                    var accountRetro = component.find("accountretroId"); 
                    $A.util.removeClass(accountRetro, 'slds-hide');
                }
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecords", storeResponse);
                console.log('*******BPPPP'+storeResponse);
                /*var resultsLookup = component.get("v.listOfSearchRecords");
                if (resultsLookup.length > 0) {
                    var myCmp = component.find("lookupResults");
                    $A.util.removeClass(myCmp, "slds-hide");
                }*/
            } else {
            	console.log('Error====='+response);    
            }
 
        });
      // enqueue the Action  
        $A.enqueueAction(action);
    
	},
    
})