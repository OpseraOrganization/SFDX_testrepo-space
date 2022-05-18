({
    doInit : function(component, event, helper) {
},

	 selectAccount : function(component, event, helper){   
    // get the selected Account from list  
      var getSelectAccount = component.get("v.oAccount");
      // alert(getSelectAccount);  
    // call the event  
      var compEvent = component.getEvent("oSelectedAccountEvent");
    // set the Selected Account to the event attribute.  
         compEvent.setParams({"accountByEvent" : getSelectAccount });  

    // fire the event  
         compEvent.fire();
     // helper.testresults(component, event);    
  
    },
    
    selectUnit:function(component, event, helper){
      var getSelectUnits = component.get("v.Unit");
      //  alert(getSelectUnits);
      var compEvent=component.getEvent("oSelectedAccountEvent");
      compEvent.setParams({"accountByEvent" : getSelectUnits });  
    // fire the event  
         compEvent.fire();

        
    }
})