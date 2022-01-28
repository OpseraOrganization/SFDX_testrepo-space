({
    // Get the recordtype of the workgroup member
    onload : function(component, event, helper) {
        /*if(component.get("v.runOnce")){
            var recordUI = event.getParam("recordUi");
            var recordTypeName = recordUI.record.fields["CH_RecordTypeName__c"].value;
            //alert('recordTypeName'+recordTypeName);
            component.set("v.recordTypeName", recordTypeName);
            var recordTypeId = recordUI.record.fields["RecordTypeId"].value;
            component.set("v.recordTypeId", recordTypeId);
            
            // Set default value for new record
            if (recordTypeName == null){
                recordTypeName='';
                var recordTypeId = component.get("v.pageReference").state.recordTypeId;
                component.set("v.recordTypeId", recordTypeId);
                helper.getRecordTypeName(component, recordTypeId)
                .then(function(result){
                    component.set("v.recordTypeName", result);
                });
            }
            
            var workgroupMemberType = recordUI.record.fields["CH_Workgroup_Member_Type__c"].value;
            // Set default value for new record
            if (workgroupMemberType == null){
                workgroupMemberType='User';
            }
            component.set("v.workgroupMemberType", workgroupMemberType);   
        }*/
		if(component.get("v.runOnce")){
            var recordTypeId,recordTypeName,workgroupMemberType="";   
            recordTypeName=component.get("v.recordTypeName");
            // When a exisiting record is selected the recordtype info is known
            var recordUI = event.getParam("recordUi");
            var recordId= component.get("v.recordId");
            if(recordId){
                recordTypeName = recordUI.record.fields["CH_RecordTypeName__c"].value;
                component.set("v.recordTypeName", recordTypeName);
                recordTypeId = recordUI.record.fields["RecordTypeId"].value;
                component.set("v.recordTypeId", recordTypeId);
                workgroupMemberType = recordUI.record.fields["CH_Workgroup_Member_Type__c"].value;
            }
            else{
                // When New record selected
                // if (!recordTypeName){
                 //Start 30651 
                if(!component.get("v.recordTypeId")){
                    recordTypeId = component.get("v.pageReference").state.recordTypeId;                    
                    component.set("v.recordTypeId", recordTypeId);
                }
                else{
                    recordTypeId =  component.get("v.recordTypeId"); 
                }
                //End 30651
                //recordTypeId = component.get("v.pageReference").state.recordTypeId;
                //component.set("v.recordTypeId", recordTypeId);
                if(!recordTypeName){
                    // User has multiple recordtypes and needs to choose one
                    if (recordTypeId != null){
                        helper.getRecordTypeName(component, recordTypeId)
                        .then(function(result){
                            component.set("v.recordTypeName", result);
                        });                  
                    }
                    else { // User has 1 recordtype
                        helper.getDefaultRecordTypeName(component)
                        .then(function(result){
                            component.set("v.recordTypeName", result);
                        });
                    }
                }
                // }
            }
            workgroupMemberType = recordUI.record.fields["CH_Workgroup_Member_Type__c"].value;
            // Set default value for new record
            if (!workgroupMemberType){
                workgroupMemberType='User';
            }
			if (!component.get("v.workgroupMemberType")){
            component.set("v.workgroupMemberType", workgroupMemberType); 
			}		
        }
        component.set("v.runOnce", false);   
    },
	handleOnError: function(component, event, helper) {
        var errors = event.getParams();
        console.log("response", JSON.stringify(errors));
    },
    doInit : function(component, event, helper) {
        var myPageRef = component.get("v.pageReference");
        var cloneRecordId = myPageRef && myPageRef.state ? myPageRef.state.c__cloneRecordId : "";
        if(cloneRecordId){
            var edit = myPageRef && myPageRef.state ? myPageRef.state.c__edit : "";
            if(edit!=""){
                component.set("v.cloneRecordId", cloneRecordId);
                component.set("v.edit", edit);                
                component.set("v.recordTypeId", myPageRef && myPageRef.state ? myPageRef.state.c__recordTypeId : "");
                component.set("v.workgroupMemberType", myPageRef && myPageRef.state ? myPageRef.state.c__selectedType : "");
            }
        }
        var action = component.get("c.accessCheckMember");
        action.setParams({ getRecordId : component.get("v.recordId") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.edit",response.getReturnValue());
                if(component.get("v.recordId") != undefined){
                    helper.getwrkRecordTypeName(component)
                    .then(function(result){
                        var userId = $A.get("$SObjectType.CurrentUser.Id");
                        var getUserId=result.CH_User__c;
                        if(result.CH_Off_Duty__c){
                            component.set("v.buttonValue", "Unset Off Duty");
                            component.set("v.OffDutyButtonValue", false);
                        }
                        else{
                            component.set("v.buttonValue", "Set Off Duty");
                            component.set("v.OffDutyButtonValue", true);
                        }
                        if(getUserId==userId){
                            component.set("v.disableOffDutyButton", "");
                            
                        }
                        else{
                            component.set("v.disableOffDutyButton", "slds-hidden");
                            
                        }
                        // component.set("v.getOffDuty", result.CH_Off_Duty__c);
                        // component.set("v.workgroupUser", result.CH_User__c);
                        component.set("v.workgroupMemberType", result.CH_Workgroup_Member_Type__c);
                        component.set("v.recordTypeId", result.RecordTypeId);
                        component.set("v.recordTypeName", result.CH_RecordTypeName__c);
                    })
                }
            }
        });
        $A.enqueueAction(action);                
    },
	handlePageChange: function(cmp, evt, hlp) {
        var myPageRef = cmp.get("v.pageReference");
        var recordId = myPageRef && myPageRef.state ? myPageRef.state.c__recordId1 : "World";
       // alert(recordId);
    },
})