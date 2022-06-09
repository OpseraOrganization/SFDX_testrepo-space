({
    //Function to Check Maintenance Type & No. Of Maintenance Year
    checkMaintenanceTypeUpdateForDirectQuote : function(component,event, helper) {
        
        // collect the Configurations related list records for current quote.
        var action = component.get("c.checkExistingConfigurationLineItems");
        // set parameter to callback method of apex class
        action.setParams({ recordId: component.get("v.recordId")});
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('state---->'+state);                               
            if(state === "SUCCESS") 
            {
                console.info('ConfigLintItems >>>'+response.getReturnValue());                
                //Check field update using lightning data service (recordData)
                var eventParams = event.getParams();                                   
                if(eventParams.changeType === "CHANGED")
                {	
                    // get the fields that are changed for this record
                    var changedFields = eventParams.changedFields;
                    // display toast If --> Quote have configuration related list items and Maintenance Type & no. of maintenance years firld get updated
                    if(response.getReturnValue() ===1 && (JSON.stringify(changedFields).includes('NokiaCPQ_Maintenance_Type__c')==true || JSON.stringify(changedFields).includes('NokiaCPQ_No_of_Years__c')==true))
                    {                
                        var resultsToast = $A.get("e.force:showToast");
                        resultsToast.setParams({
                            "title": "Warning!",
                            "message": "You have changed the maintenance information, please re-configure your products.",
                            "type": "warning",
                            'duration': 10000
                            
                        });
                        resultsToast.fire();
                    }
                }
            } 
            
        });
        $A.enqueueAction(action);
    }
})