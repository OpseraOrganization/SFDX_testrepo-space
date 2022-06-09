/*****************************************
* Name : CH_CN_EventSubscription
* Description : This component used to handle event subscription dimension
* By Afif Reja
* User story :NOKIASC-29003,NOKIASC-29005
******************************************/

({
    
    init: function(component, event, helper) {  
        var recordId=component.get("v.recordId");
        var newValue = component.get("v.eventTypeList");
        
        if(recordId){
            var checkedAllEventType=component.get("v.checkedAllEventType");
            if(checkedAllEventType){
                component.find("EventType").set("v.value",'');                 
            }
            else{         
                component.find("EventType").set("v.value",newValue);
            }
        }
        else{
            component.set("v.checkedAllEventType",false);
            component.find("EventType").set("v.value","");
            component.set("v.notificationMode",'');
        }
    },
    handleChange: function(component, event, helper) {        
        var newValue = component.find("EventType").get("v.value");
        component.set("v.eventTypeList",newValue)
    },
    handleReset: function(component, event, helper) {
        component.find("EventType").reset();
        component.find("NotificationMode").reset();
    },
    onCheckedAllEventType: function (component, event, helper) {
            
        var checkedAllEventType=component.get("v.checkedAllEventType");
            if(checkedAllEventType){
              component.find("EventType").set("v.value",'');                 
            }
    },
    
})