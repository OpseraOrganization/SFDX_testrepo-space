({ 
    init: function (component,event,helper) {
        helper.apexAction(component, "c.isPortalUser", null, true).then(function(isPortalUser) {
            component.set('v.isPortalUser', isPortalUser === true);//Can be false or null
            //NOKIASC-34599
            helper.apexAction(component, "c.getCaseInfo", { recordId : component.get('v.recordId')}, true).then(function(record){
                helper.hideEscalate = ((record && record.HWS_Sent_To_SOO__c) || !component.get('v.actionsVisible') || isPortalUser);
                component.find("childDatatable").setSelectedRows([]);
        		helper.doInit(component,event,helper);
            });
        });
    },    
    closeModel: function(component, event, helper) {
        component.set("v.isOpen", false);// to Hide Model set the "isOpen" attribute to "false"
    },
    //NOKIASC-34599
    handleGlobalAction : function(component, event, helper) {
		var skipSplit; //NOKIASC-37508
        switch(event.getParam('action')) {
            case 'escalate':
                var childCases = component.find("childDatatable").getSelectedRows();
				skipSplit = childCases.length == component.get('v.data').length;
                if(childCases.length == 0) return helper.showToast('error', 'Error', 'Select at least one row.');
                helper.apexAction(component, "c.escalateCases", {
                    parentCaseId : component.get('v.recordId'),
                    oChildCaseList : childCases,
                    //skipSplit : childCases.length == component.get('v.data').length,
					skipSplit : skipSplit,
					emailType : 'HWS Order Acknowledgement Escalated Case'
                }, true).then(function(record){
					 if(!skipSplit)
                    {
				   $A.get('e.force:refreshView').fire();
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        message: 'The case has been escalated to Nokia Specialist.',
                        messageTemplate: 'Selected child case(s) have been escalated to a Nokia Specialist under new parent case number:  {0}',
                        messageTemplateData: [{ url: '/one/one.app?#/sObject/' + record.Id + '/view', label: record.CaseNumber }],
                        duration:'10000',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
					}
					else
                    {
                       
                        // fire event and set some instructionMsg in parent 
                       var cmpEvent = component.getEvent("cmpEventReview");
        				cmpEvent.setParams({
            			"messageValue" : $A.get("$Label.c.HWS_WCheck_UnKnowns_Escalated") });
        				cmpEvent.fire();
                    }
                });
                break;
        }
    },
    //NOKIASC-34220
    handleRowAction : function(component, event, helper) {
        var row = event.getParam('row');
        component.set('v.selectedrow',row);
        component.set("v.isOpen", true); 
        component.set("v.rowId",row.Id);
        component.set("v.serialNumber", row.HWS_Faulty_Serial_Number__c);
        component.set("v.origSerialNumber", row.HWS_Faulty_Serial_Number__c);
    },
    //NOKIASC-34220
    handleSave : function(component, event, helper) {
        var origSerialNum = component.get("v.origSerialNumber");
        var editedCaseId = component.get('v.rowId');
        var editedSerialNum = component.get('v.serialNumber');
        if(origSerialNum != editedSerialNum && editedSerialNum!=''){
            component.set("v.showSpinner",true);
            var action = component.get("c.editCase");
            action.setParams({
                caseId: editedCaseId,
                serialNumber: editedSerialNum
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var casId = response.getReturnValue();
                    var row = component.get('v.selectedrow');
                    row[0].HWS_Faulty_Serial_Number__c = editedSerialNum;
                    helper.getWarrantyStatus(component, event, helper, row);                                  
                } else if (state === "ERROR") {
                    var message = 'Unkown Error Occurred';
                    var errors = response.getError();
                    if (errors) {
                        if(errors[0].fieldErrors){
                            message = errors[0].fieldErrors.HWS_Faulty_Serial_Number__c[0].message;
                        } else if (errors && Array.isArray(errors) && errors.length > 0) {
                            console.log("Error message: " + 
                                        errors[0].message);
                            message = errors[0].message;
                        }
                    } else {
                        console.log("Unknown error");
                    }
                    helper.showToast('error','Error Message',message);
                    component.set("v.isOpen", false);
                    component.set("v.showSpinner",false);
                }
            });
            $A.enqueueAction(action);
        }
    },
})