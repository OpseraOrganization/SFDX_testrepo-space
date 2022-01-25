({
    doInit : function(component, event, helper){
        
        var action = component.get("c.fetchCurrentUser");
        action.setCallback(this, function(actionResult) {
            var result = actionResult.getReturnValue();    
             
            if (result != null){
                component.set('v.users',result);
                var value = { 
                    label: result.Name, 
                    value: result.Id, 
                }; 
                component.set("v.defaultselectedRecord",value);
                component.find("userLookup").set("v.value",result.Id);
                
            }
        });
        
        $A.enqueueAction(action);
    },
    search : function(component, event, helper){
        
        var UserId = component.find("userLookup").get("v.value");      
        var action = component.get("c.searchWorkgroupByUser");        
     
        	action.setParams({"userId": UserId});   
            action.setCallback(this, function(actionResult) {
                var result = actionResult.getReturnValue(); 
                 $('#searchworkgroupByUserId').DataTable().clear().rows.add(result).draw();
                
            });  
      
        
        $A.enqueueAction(action); 
    },
    clear: function(component,event) {
        location.reload();
    },
    scriptsLoaded : function(component, event, helper){
        var result='';
        helper.createTable(component,event, result);    
        
    },
})