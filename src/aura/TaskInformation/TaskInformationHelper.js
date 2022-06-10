({
    getSubDetailsHelper : function(component,event, helper) {
        //alert('Begin');
		var recId = component.get("v.recordId");    
       // alert('recId::>'+recId);
        var action = component.get("c.getOpptyOfferValues");        
        //alert('action');
        action.setParams({
            'oppRecordId': recId
        });        
        //alert('11');
        action.setCallback(this, function(response){ 
         var state = response.getState();
         if (state === "SUCCESS")
         { 
            
            component.set("v.wrapper", response.getReturnValue());                
         }                
         else
         {                 
           var errors = response.getError();
           if (errors){
             
              if (errors[0] && errors[0].message){
                 alert("Error message: " + errors[0].message);
            }
           }
         }    
        });
        $A.enqueueAction(action);
      
	},
    
    getPhaseValue : function(component,event, helper)
    { 
      var action = component.get("c.getOpportunityPhaseStatusValues");
      action.setCallback(this, function(response)
        {
           	var state = response.getState();
            if(component.isValid() && state === "SUCCESS")
            {
               	component.set("v.gateList", response.getReturnValue());
            }
            else
            {
                console.log('TaskInformationController : getOpportunityPhaseStatusValues not successful');
            }
        });
        $A.enqueueAction(action);  
    },
    
	saveTaskInformation : function(component,event, helper) 
    { 
        var createdAtVal = component.get("v.GateValue");
        var action = component.get("c.saveTaskDetails");
        action.setParams({
            objTask: component.get("v.task"),
            offerNumber: component.get("v.wrapper.offerNumber"),
            offerRecId: component.get("v.wrapper.offerRecordId"), 
            oppRecordId: component.get("v.recordId"),
            selectGateVal: createdAtVal
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS")
            {
                var taskRec = response.getReturnValue();
                var showToast;    
                if(!taskRec){                    
                    var recId = component.get("v.recordId");
                    var navEvent = $A.get("e.force:navigateToSObject");  
                    navEvent.setParams({
                    "recordId": recId
                    });
            		navEvent.fire();
                    showToast = $A.get('e.force:showToast');
                            //set the title and message params
                            showToast.setParams(
                            {
                                'message': 'Something Went Wrong',
                                'type' : 'error'
                            }
                            );
                }
                else{                    
                    var recId = component.get("v.recordId");
                    var navEvent = $A.get("e.force:navigateToSObject");  
                    navEvent.setParams({
                    "recordId": recId
                    });
            		navEvent.fire();
                    showToast = $A.get('e.force:showToast');
                            //set the title and message params
                            showToast.setParams(
                            {
                                'message': 'Task Created Successfully',
                                'type' : 'success'
                            }
                            );
                }
              	showToast.fire();
                //$A.get('e.force:refreshView').fire();                    
            }
            else
            {   
                var errors = response.getError();
                if (errors){
                    console.info('Inside if of errors');
                    if (errors[0] && errors[0].message){
                        console.info("Error message: " + errors[0].message);
                    }
                }
            }  
        });
        $A.enqueueAction(action);
	}
})