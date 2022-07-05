({
    GridLock: function(component, event)
    {
        var action = component.get("c.getOIFByOpportunityId");
        var pageid=component.get("v.recordId");
        action.setParams({
            oppid:pageid 
        });
        
        //Setting the Callback
        action.setCallback(this,function(a){
            //get the response state
            var state = a.getState();
            //check if result is successfull
            if(state == "SUCCESS")
            {
                var result = a.getReturnValue();
                var recId = component.get("v.recordId");
                var gbc = result.oppData.Grid_Buddy_Closed__c;
                var gridName;
                if(result.isPreOpp)
                {
                    var gridName ='Pre-opportunity+OIF+Grid';
                }
                else
                {
                    var gridName = 'OIF+Grid';
                }   
                component.set("v.LockRec",gbc);
                component.set("v.gridName",gridName);
            }  
            else if(state == "ERROR")
            {
                alert('Please refresh the Browser');
            }
        });
        //adds the server-side action to the queue        
        $A.enqueueAction(action);
    }
})