({
    searchHelper : function(component,event,getInputkeyWord) {
        
        var action = component.get("c.fetchLookUpValues");
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'ObjectName' : component.get("v.objectAPIName"),
            'selectedTerritory':component.get("v.OrganisationName"),
            'fetchASCheck':component.get("v.SelectedAS"),
            'Adduser':component.get("v.Adduser")
        });
        
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Rolenames Found...');
                } else {
                    component.set("v.Message", '');
                }
                var duplicate=[];
                var RoleName=[];
                if(storeResponse!=null)
                {
                     
                  for (var j = 0; j <storeResponse.length; j++)
                  {
                      if(!duplicate.includes(storeResponse[j].Role_name__c))
                      {
                         duplicate.push(storeResponse[j].Role_name__c);
                      RoleName.push(storeResponse[j])
                      }
                  }
                    
                }
                component.set("v.listOfSearchRecords", RoleName);
            }
            
        });
        $A.enqueueAction(action);
        
    },
})