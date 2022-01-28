({
    getRecordDetails: function(component, event, helper) {
        var action = component.get("c.getRecordData");
        action.setParams({
            "recordId" : component.get("v.recordId") 
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                component.set("v.agrmntObject",response.getReturnValue());
                var agrmntRec = response.getReturnValue();
                
                component.set("v.showreturnRequestor",false);
                component.set("v.showSubmitButton",false);
                component.set("v.ReadyForReviewSignature",false);
                component.set("v.ReadyForReview",false);
                component.set("v.sendForSignature",false);
                component.set("v.cancelRequest",false);
                component.set("v.newAgreement",false);
                component.set("v.userOwnerAccess",false);
                
                var userId = $A.get("$SObjectType.CurrentUser.Id");
                if(userId === agrmntRec.OwnerId){
                    component.set("v.userOwnerAccess",true);
                }
                
                if((agrmntRec.RecordType.Name === 'Contract Request')
                   && (agrmntRec.Apttus__Status_Category__c !== 'Cancelled')){
                    component.set("v.ctrctRequestEnable",false);
                    component.set("v.showAmend",true);
                    component.set("v.showRenew",true);
                    component.set("v.newAgreement",true);
                }
                
                if((agrmntRec.Apttus__Status_Category__c === 'Request')
                   && (agrmntRec.Apttus__Status__c === 'Submitted Request')
                   && (agrmntRec.RecordType.Name === 'Contract Request') 
                   && (agrmntRec.CLM_Existing_Contract_Reference__c === undefined) ){
                    component.set("v.newAgreement",true);
                }
                
                if((agrmntRec.Apttus__Status_Category__c === 'Request') &&
                    (agrmntRec.RecordType.Name === 'Contract Request') && 
                     (agrmntRec.Apttus__Status__c === undefined)){
                    component.set("v.showSubmitButton",true);
                }
                if((agrmntRec.Apttus__Status_Category__c === 'In Authoring') &&
                   ((agrmntRec.Apttus__Status__c === 'Other Party Review') || 
                    (agrmntRec.Apttus__Status__c === 'Author Contract'))){
                    component.set("v.ReadyForReviewSignature",true);
                    component.set("v.ReadyForReview",true);
                }
                
                if((agrmntRec.Apttus__Status_Category__c === 'Request')
                   && (agrmntRec.Apttus__Status__c !== 'Cancelled Request')
                   && (agrmntRec.Apttus__Status__c !== 'Fully Signed')
                   && (agrmntRec.Apttus__Status__c !== '')
                   && (agrmntRec.RecordType.Name === 'Contract Request')){
                    component.set("v.cancelRequest",true);
                }
                
                if((agrmntRec.Apttus__Status_Category__c === 'In Authoring')
                   && (agrmntRec.Apttus__Status__c === 'Language Approved')){
                    component.set("v.ReadyForReviewSignature",true);
                    component.set("v.sendForSignature",true);
                }
                
                if(((agrmntRec.Apttus__Status_Category__c === 'In Signatures') && 
                    (agrmntRec.Apttus__Status__c === 'Fully Signed')) 
                   ||(agrmntRec.Apttus__Status_Category__c === 'In Filing')
                   ||(agrmntRec.Apttus__Status_Category__c === 'In Application')){
                    component.set("v.showActivate",true);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    getFields: function(component, event, helper, requestType) {
        var action = component.get("c.getRequiredFields");
        action.setParams({
            "recordId" : component.get("v.recordId"),
            "requestType" : requestType,
            "objectAPI" : "Apttus__APTS_Agreement__c"
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                component.set("v.wrapper",response.getReturnValue());
                if(response.getReturnValue().length === 0){
                    component.set("v.spinner",false);
                    if(requestType === "SubmitRequest"){
                        helper.submitRequest(component, event, helper);
                    }
                    
                }else if(response.getReturnValue().length > 0){
                    component.set("v.spinner",false);
                    if(requestType === "SubmitRequest"){
                        component.set("v.generateDocumentHeader",false);
                    }else if((requestType === "GenerateDocument") || (requestType === "ReGenerateDocument")){
                        component.set("v.generateDocumentHeader",true);
                    }
                    component.set("v.isOpen",true);
                }
            }else{
                console.error("fail:" + response.getError()[0].message);
            }
        });
        $A.enqueueAction(action);
    },
    checkCustomPermissionForCurrentUser : function(component, event, helper){
        var action = component.get("c.checkCustomPermission");
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                var accessWrap = response.getReturnValue();
                component.set("v.permissionWrapper",response.getReturnValue());
            }
        });
        $A.enqueueAction(action);  
    },
    submitRequest : function(component, event, helper) {
        component.set("v.spinner",false);
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url":$A.get("$Label.c.CLM_Submit_Request_URL")+"?id="+component.get("v.recordId")
        });
        urlEvent.fire(); 
    }, 
    returnToRequestor : function(component, event, helper){
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url":$A.get("$Label.c.CLM_Return_to_Requestor")+"?id="+component.get("v.recordId")
        });
        urlEvent.fire(); 
    },
    cancelRequest : function(component, event, helper){
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url":$A.get("$Label.c.CLM_Cancel_Url")+"?id="+component.get("v.recordId")
        });
        urlEvent.fire();  
    },
    amendRequest : function(component, event, helper){
        var agrmntReq = component.get("v.agrmntObject");
        if(agrmntReq.CLM_Existing_Contract_Reference__c !== undefined){
            helper.updateAmendRequest(component, event, helper);
        }else{
            helper.showToast(component, event, 'Warning', 'Please specify the Existing Contract Reference and then click Amend');
            component.set("v.spinner",false);
        }
    },
    updateAmendRequest : function(component, event, helper){
        var agrmntReq = component.get("v.agrmntObject");
        var action = component.get("c.updateExistingCtrct");
        action.setParams({
            "curRecId" : component.get("v.recordId"),
            "existRecId" : agrmntReq.CLM_Existing_Contract_Reference__c,
            "optyId" : agrmntReq.Apttus__Related_Opportunity__c
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url":$A.get("$Label.c.CLM_Amend_Url")+"?id="+agrmntReq.CLM_Existing_Contract_Reference__c
                });
                urlEvent.fire(); 
            }
        });
        $A.enqueueAction(action);  
    },
    renewRequest : function(component, event, helper){
        var agrmntReq = component.get("v.agrmntObject");
        if(agrmntReq.CLM_Existing_Contract_Reference__c !== undefined){
            helper.updateRenewRequest(component, event, helper);
        }else{
            helper.showToast(component, event, 'Warning', 'Please specify the Existing Contract Reference and then click Renew');
            component.set("v.spinner",false);
        }
    },
    updateRenewRequest : function(component, event, helper){
        var agrmntReq = component.get("v.agrmntObject");
        var action = component.get("c.updateExistingCtrct");
        action.setParams({
            "curRecId" : component.get("v.recordId"),
            "existRecId" : agrmntReq.CLM_Existing_Contract_Reference__c,
            "optyId" : agrmntReq.Apttus__Related_Opportunity__c
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url":$A.get("$Label.c.CLM_Renew_Url")+"?id="+agrmntReq.CLM_Existing_Contract_Reference__c
                });
                urlEvent.fire();
            }
        });
        $A.enqueueAction(action);  
    },
    showToast : function(component, event, type, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": type,
            "message": message,
            "type":type
        });
        toastEvent.fire();
    }
})