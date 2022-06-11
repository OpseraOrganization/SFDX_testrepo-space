({
	selectRecord : function(component, event, helper){  
        console.log('In custom lookup');
    // get the selected record from list  
      var getSelectRecord = component.get("v.oRecord");
    // call the event   
      var compEvent = component.getEvent("oSelectedRecordEvent");
    // set the Selected sObject Record to the event attribute.  
         compEvent.setParams({"recordByEvent" : getSelectRecord });  
        console.log('getSelectRecord'+getSelectRecord);
        //console.log('getSelectRecord'+getSelectRecord);
    // fire the event  
         compEvent.fire();
    },
})