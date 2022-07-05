({
    getEvents : function(component, event) {
        var action = component.get("c.getEvents");
        action.setParams({ 
            sObjectName : component.get("v.sObjectName"),
            titleField : component.get("v.titleField"),
            startDateTimeField : component.get("v.startDateTimeField"),
            endDateTimeField : component.get("v.endDateTimeField"),
            descriptionField : component.get("v.descriptionField"),
            userField : component.get("v.userField"),
            filterByUserField : component.get("v.filterByUserField"),
            
            workgroup : component.get("v.workgroupId"),
            workgroupMember : component.get("v.workgroupMember")
        });        
        action.setCallback(this, function(response) {
            component.set("v.eventsMap",response.getReturnValue()); 
        });
        $A.enqueueAction(action);
    },    
    getWorkgroupRota: function(component, event){
        alert('hi');
        var action = component.get("c.getWorkgroupRota");
        action.setParams({ 
            workgroup : component.get("v.workgroupId"),
            workgroupMember : component.get("v.workgroupMember")
        });        
        action.setCallback(this, function(response) {
            component.set("v.eventsMap",response.getReturnValue());                
        });
        $A.enqueueAction(action);
    }
})