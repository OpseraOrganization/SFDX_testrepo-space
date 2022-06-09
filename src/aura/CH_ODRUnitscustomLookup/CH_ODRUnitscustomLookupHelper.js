({
	searchHelper : function(component,event,getInputkeyWord) {
	  // call the apex class method 
	
     var action = component.get("c.fetchUnits");
      // set param to method  
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'selectedProduct': component.get("v.productUnits")
           
          });
      // set a callBack    
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
              // if storeResponse size is equal 0 ,display No Result Found... message on screen.
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", 'Search Result...');
                }
                
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecords", storeResponse);
            }
 
        });
      // enqueue the Action  
        $A.enqueueAction(action);
    
	},
    picklistValues : function(component,event) {
	  // call the apex class method 
	  var selectedpicklistrecord =component.get("v.selectedRecord1");
      console.log('selectedpicklistrecord'+JSON.stringify(selectedpicklistrecord));
      var action = component.get("c.builtPicklistString");
      // set param to method  
        action.setParams({
            'selectedProduct': component.get("v.productUnits")
           
          });
      // set a callBack    
        action.setCallback(this, function(response) {
          var result =  response.getReturnValue();
           if(response.getState() === "SUCCESS"){
                component.set('v.productUnitsdata', result);
               if(result.length =='0'){
                   component.set('v.assignDefaultValue', true);
                    component.set('v.selectedRecord1', "Percent Affected");
                   
               }else{
                   component.set('v.assignDefaultValue', false);
               }
                
           // if (state === "SUCCESS") {
             //   var storeResponse = response.getReturnValue();
              // if storeResponse size is equal 0 ,display No Result Found... message on screen.
             //   if (storeResponse.length == 0) {
             /*       component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", 'Search Result...');
                }
                
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecords", storeResponse);
            }*/
           }
        });
      // enqueue the Action  
        $A.enqueueAction(action);
    
	},
})