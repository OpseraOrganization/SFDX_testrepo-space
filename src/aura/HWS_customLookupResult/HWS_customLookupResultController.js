({
   selectRecord : function(component, event, helper){    
       console.log('I am hereeeeeeee');
    // get the selected record from list  
      var getSelectRecord = component.get("v.oRecord");
       var storeResponse ;
     // this.loadCountryList(component,event);
     var action = component.get("c.getCountryList"); 
        var selectedId = component.get("v.oRecord").Id;
      console.log('getSelectRecord====>'+JSON.stringify(getSelectRecord));
    // call the event   
      var compEvent = component.getEvent("oSelectedRecordEvent");
    // set the Selected sObject Record to the event attribute.  
       compEvent.setParams({"recordByEvent" : getSelectRecord, "Countrylist" : JSON.stringify(getSelectRecord)});  
    // fire the event  
        compEvent.fire();
    },
    loadCountryList: function (component,event) {
    	var action = component.get("c.getCountryList"); 
        var selectedId = component.get("v.oRecord").Id;
      // set param to method  
        action.setParams({
            'retroAccountId': selectedId
          });
      // set a callBack    
        action.setCallback(this, function(response) {
          $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                console.log('storeResponse==='+JSON.stringify(storeResponse));
            }
 
        });
      // enqueue the Action  
        $A.enqueueAction(action);
    
    }
})