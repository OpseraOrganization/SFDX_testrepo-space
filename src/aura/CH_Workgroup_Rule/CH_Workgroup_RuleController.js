({
    // Get the recordtype of the workgroup member
    onload : function(component, event, helper) {
		if(component.get("v.runOnce")){
        // When a exisiting record is selected the recordtype info is known
        var recordUI = event.getParam("recordUi");
        var recordTypeName = recordUI.record.fields["CH_RecordTypeName__c"].value;
        component.set("v.recordTypeName", recordTypeName);
        var recordTypeId = recordUI.record.fields["RecordTypeId"].value;
        component.set("v.recordTypeId", recordTypeId);

        // When New record selected
        if (recordTypeName == null){
            recordTypeName='';
            recordTypeId = component.get("v.pageReference").state.recordTypeId;
            component.set("v.recordTypeId", recordTypeId);
 			// User has multiple recordtypes and needs to choose one
            if (recordTypeId != null){
                helper.getRecordTypeName(component, recordTypeId)
                .then(function(result){
                    component.set("v.storeRecordTypeName", result);
					   if(result=='CH_CA_WorkgroupRule'){
                             var action = component.get("c.getValidUser");
                            action.setCallback(this, function(actionResult) {
                                var result = actionResult.getReturnValue();    
                                if(result){
                                    component.set("v.recordTypeName", component.get("v.storeRecordTypeName"));
                                }
                                else{
                                    helper.closeConsoleTAB(component);
                                    var messageBox = component.find('messageBox'); 
                                    messageBox.displayToastMessage('You are not authorized to create CH CA Workgroup Rule. Please Contact DV&T.',"Error");
                                }
                            });
                            $A.enqueueAction(action);
                        }
                        else{
                            component.set("v.recordTypeName", result);
                        }
                });                  
            }
            else { // User has 1 recordtype
                helper.getDefaultRecordTypeName(component)
                .then(function(result){
                    component.set("v.recordTypeName", result);
                });
            }
			}
		}
		component.set("v.runOnce", false);
    },
	
	//Checking the access level for the logged in User
    doInit : function(component, event, helper) {
        var action = component.get("c.accessCheck");
        action.setParams({ getRecordId : component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.edit",response.getReturnValue());
                if(component.get("v.recordId") != undefined){
                    helper.getwrkRecordTypeName(component)
                    .then(function(result){
                        component.set("v.storeRecordTypeName", result.CH_RecordTypeName__c);
                        component.set("v.recordTypeId", result.RecordTypeId);
                        if(result.CH_RecordTypeName__c=='CH_CA_WorkgroupRule'){
                             var action = component.get("c.getValidUser");
                            action.setCallback(this, function(actionResult) {
                                var result = actionResult.getReturnValue();    
                                if(result){
                                    component.set("v.recordTypeName", component.get("v.storeRecordTypeName"));
                                }
                                else{
                                    component.set("v.recordTypeName", component.get("v.storeRecordTypeName"));
                                    component.set("v.edit",false);
                                }
                            });
                            $A.enqueueAction(action);
                        }
                        else{
                            component.set("v.recordTypeName", result.CH_RecordTypeName__c);
                        }
                    })
                }
            }
        });
        $A.enqueueAction(action);
    },
	
})