({
    updateCase : function(component, event, helper) {
        component.set("v.spinner", true);
        var recordId = component.get("v.recordId");
        component.set("v.cas.Id", recordId);
        
        var action = component.get("c.editCase");
        var casRecord = component.get("v.cas");
        action.setParams({
            casRec: casRecord
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
            	var casId = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"Success",
                    "message": "Case updated successfully."
                });
                toastEvent.fire();
                component.set("v.cas", '');
                component.set("v.spinner", false);
                component.set("v.isOpen", false); 
               
            } else if (state === "ERROR") {
                var toastEvent = $A.get("e.force:showToast");
                var errors = response.getError();
                 console.log("Error message: " + 
                                 errors[0].message);
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        toastEvent.setParams({
                    "title": "Error!",
                    "type":"error",
                    "message": errors[0].message
                });
                toastEvent.fire();
                    }
                } else {
                    console.log("Unknown error");
                }
                 component.set("v.spinner", false);
            }
			$A.get('e.force:refreshView').fire();
        });
        $A.enqueueAction(action);
    },
    
    edit : function(component, event, helper) {
        var editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
            "recordId": component.get("v.recordId")
        });
        editRecordEvent.fire();
    },
    openModel : function(component, event, helper) {
        helper.checkSpsVerification(component,event,helper);
        component.set("v.isOpen", true); 
        component.set("v.spinner", true);
        var recordId = component.get("v.recordId");
        var objectId = event.getParam("selectedServiceType"); 
        var action = component.get("c.getCaseInfo");
        action.setParams({
            caseId: recordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
            	var caseRecord = response.getReturnValue();
                var isCaseSubmitted;
				//NOKIASC-31301
                if(caseRecord.ParentId == null){
                	isCaseSubmitted = caseRecord.HWS_Sent_To_SOO__c;
                }
                else if(caseRecord.ParentId != null && caseRecord.HWS_FaultyUnitReceivedDate__c != null ){ 
                    isCaseSubmitted = true;
                }
                component.set("v.isCaseSubmitted", isCaseSubmitted);
                component.set("v.cas", caseRecord);
                component.set("v.spinner", false);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                component.set("v.spinner", false);
            }
        });
        $A.enqueueAction(action);
    	   
    },
    closeModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"
        component.set("v.cas", '');  
        component.set("v.isOpen", false);
    }    
})