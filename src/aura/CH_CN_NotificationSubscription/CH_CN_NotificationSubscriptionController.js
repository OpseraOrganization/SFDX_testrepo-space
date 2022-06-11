({
    onload : function(component, event, helper) {
        
        var recordTypeId,recordTypeName;   
        recordTypeName=component.get("v.recordTypeName");
        var recordId= component.get("v.recordId");
        if(recordId){
            var recordUI = event.getParam("recordUi");
            recordTypeName = recordUI.record.fields["CH_DomainType__c"].value;
            component.set("v.recordTypeName", recordTypeName);
            recordTypeId = recordUI.record.fields["RecordTypeId"].value;
            component.set("v.recordTypeId", recordTypeId);
        }
        else{
            // Description : this method is is used to check how many Notification Subscriptions allowed per user
            //NOKIASC-29178
            helper.getCustomSettingsForNotificationPerUser(component)
            .then(function(result){
                if ($A.util.isEmpty(result)){
                    recordTypeId = component.get("v.pageReference").state.recordTypeId;
                    component.set("v.recordTypeId", recordTypeId);        
                    if(!recordTypeName){
                        if (recordTypeId){
                            helper.getRecordTypeName(component, recordTypeId)
                            .then(function(result){
                                component.set("v.recordTypeName", result);
                            });                  
                        }
                        else {
                            helper.getDefaultRecordTypeName(component)
                            .then(function(result){
                                component.set("v.recordTypeName", result);
                            });
                        }
                    } 
                }
                else{
                    helper.showToast('error',"Error",result) ;
                    helper.closeTab(component, event, helper);
                }                                
            });                                      
        }
        
    },
    handleOnError: function(component, event, helper) {
        var errors = event.getParams();
        console.log("response", JSON.stringify(errors));
    },
    
    
    doInit : function(component, event, helper) {
        
    }
    
})