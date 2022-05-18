({
    selectRecord : function(component, event, helper){      
        // get the selected record from list 
        
         var getSelectRecord = component.get("v.oRecord");
         var selectedid= component.get("v.recordId1"); 
         var selectedvalue =component.get("v.oRecord.Name"); 
         console.log('Check selectedvalue' +selectedvalue);
        // call the event   
        var compEvent = component.getEvent("oSelectedRecordEvent");
        compEvent.setParams({"recordByEvent" : getSelectRecord  });            
        // fire the event  
        compEvent.fire();
    },
})