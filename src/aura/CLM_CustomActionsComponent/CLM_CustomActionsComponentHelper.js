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
                
                /*if(agrmntRec.Apttus__Contract_End_Date__c !== undefined){
                    var date = new Date(agrmntRec.Apttus__Contract_End_Date__c);
                    var month = new Array();
                    month[0] = "Jan";
                    month[1] = "Feb";
                    month[2] = "Mar";
                    month[3] = "Apr";
                    month[4] = "May";
                    month[5] = "Jun";
                    month[6] = "Jul";
                    month[7] = "Aug";
                    month[8] = "Sept";
                    month[9] = "Oct";
                    month[10] = "Nov";
                    month[11] = "Dec";
                    var day = date.getDate();
                    component.set("v.currentAgrmntEndDate",month[date.getMonth()] +" "+day + ", " + date.getFullYear());
                }*/
                
                if(agrmntRec.CLM_Contract_Category__c === 'Non-Transactional (NDA, LOI, MOU etc.)'){
                    component.set("v.RecordTypeVal",'Frame_Agreement');
                    component.set("v.nextEnable",false);
                }
                if(agrmntRec.CLM_Contract_Category__c === 'Transactional (SSA, Care, etc.)'){
                    component.set("v.RecordTypeVal",'SSA');
                    component.set("v.nextEnable",false);
                }
                component.set("v.showGenerateButton",false);
                component.set("v.showreturnRequestor",false);
                component.set("v.showSubmitButton",false);
                component.set("v.ReadyForReviewSignature",false);
                component.set("v.ReadyForReview",false);
                component.set("v.sendForSignature",false);
                component.set("v.cancelRequest",false);
                component.set("v.newAgreement",false);
                component.set("v.userOwnerAccess",false);
                component.set("v.reactivateRequest",false);
                
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
                   && (agrmntRec.RecordType.Name === 'NDA')
                   && (agrmntRec.CLM_Qualifies_for_Self_Service__c == 'Yes')){
                    component.set("v.showGenerateButton",true);
                }
                
                if((agrmntRec.RecordType.Name === 'NDA')
                   && (agrmntRec.CLM_Qualifies_for_Self_Service__c == 'No')
                   &&((agrmntRec.Apttus__Status_Category__c === 'In Authoring')
                      || (agrmntRec.Apttus__Status_Category__c === 'Request')
                      || (agrmntRec.Apttus__Status__c === 'Ready for Review')
                      || (agrmntRec.Apttus__Status__c === 'Other Party Review')
                     )){
                    component.set("v.showNDASubmitButton",true);
                }
                if(agrmntRec.Apttus__Status__c === 'Expired'
                   && (agrmntRec.RecordType.Name === 'NDA'
                       || agrmntRec.RecordType.Name === 'Supply and Services Agreement'
                       || agrmntRec.RecordType.Name === 'Care Agreement'
                       || agrmntRec.RecordType.Name === 'Non-Transactional Agreement')){
                    component.set("v.reactivateRequest",true);
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
               /* if((agrmntRec.Apttus__Status_Category__c === 'In Authoring') &&
                   (agrmntRec.RecordType.Name !== 'NDA') &&
                   ((agrmntRec.Apttus__Status__c === 'Other Party Review') || 
                    (agrmntRec.Apttus__Status__c === 'Author Contract'))){
                    component.set("v.ReadyForReviewSignature",true);
                    component.set("v.ReadyForReview",true);
                }*/
                
                if((agrmntRec.Apttus__Status_Category__c === 'Request')
                   && (agrmntRec.Apttus__Status__c !== 'Cancelled Request')
                   && (agrmntRec.Apttus__Status__c !== 'Fully Signed')
                   && (agrmntRec.Apttus__Status__c !== '')
                   && (agrmntRec.RecordType.Name === 'Contract Request')){
                    component.set("v.cancelRequest",true);
                }
                
                /*if((agrmntRec.Apttus__Status_Category__c === 'In Authoring')
                   && (agrmntRec.Apttus__Status__c === 'Language Approved')
                   && (agrmntRec.RecordType.Name !== 'NDA') ){
                    component.set("v.ReadyForReviewSignature",true);
                    component.set("v.sendForSignature",true);
                }*/
                
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
            "objectAPI" : "Apttus__APTS_Agreement__c",
            "objDetails" : JSON.stringify(component.get("v.agrmntObject"))
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                component.set("v.wrapper",response.getReturnValue());
                if(response.getReturnValue().length === 0){
                    component.set("v.spinner",false);
                    if((requestType === "SubmitRequest")
                       || (requestType === "NDASubmitRequest")){
                        helper.submitRequest(component, event, helper);
                    }
                    
                }else if(response.getReturnValue().length > 0){
                    component.set("v.spinner",false);
                    if(requestType === "NDASubmitRequest"){
                        component.set("v.openSuggestion",true);
                        
                    }else{
                        if(requestType === "SubmitRequest"){
                            component.set("v.generateDocumentHeader",false);
                        }else if((requestType === "GenerateDocument") || (requestType === "ReGenerateDocument")){
                            component.set("v.generateDocumentHeader",true);
                        }
                        component.set("v.isOpen",true);
                    }
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
    },
    selectRecordType: function(component, event, helper) {
        var agrmntRec = component.get("v.agrmntObject");
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:CLM_AgrmntRelatedCntrctRequest",
            componentAttributes: {
                recordTypeVal : component.get("v.RecordTypeVal"),
                nameOfAgrmnt : agrmntRec.Name,
                recordId : agrmntRec.Id,
                showRecordTable : true
            }
        });
        evt.fire();
    },
    nonTransactionAgrmnt: function(component, event, helper, requestType) {
        component.set("v.spinner",true);
        var action = component.get("c.createNonTranAgrmnt");
        action.setParams({
            "recordId" : component.get("v.recordId"),
            "objAPI" : 'Apttus__APTS_Agreement__c'
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                this.createAgrmntTeamsRecds(component, event, helper,response.getReturnValue(),component.get("v.recordId"));
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url":'/'+response.getReturnValue()
                });
                urlEvent.fire(); 
                component.set("v.spinner",false);
                
            }else{
                console.error("fail:" + response.getError()[0].message);
            }
        });
        $A.enqueueAction(action);
    },
    
    createAgrmntTeamsRecds: function(component, event, helper, agrmntId,parentAgrmntId) {
        var action = component.get("c.createAgrmntTeam");
        
        action.setParams({
            "agrmntId" : agrmntId,
            "parentAgrmntId" : parentAgrmntId
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
            }
        });
        $A.enqueueAction(action);
    },
    
    checkgenerateNDARequest: function(component, event, helper) {
        component.set("v.spinner",true);
        var action = component.get("c.getRequiredFields");
        action.setParams({
            "recordId" : component.get("v.recordId"),
            "requestType" : 'NDAGenerateDocument',
            "objectAPI" : "Apttus__APTS_Agreement__c",
            "objDetails" : JSON.stringify(component.get("v.agrmntObject"))
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                component.set("v.wrapper",response.getReturnValue());
                if(response.getReturnValue().length === 0){
                    helper.generateNDADocument(component, event, helper);
                }else if(response.getReturnValue().length > 0){
                    component.set("v.spinner",false);
                    component.set("v.isOpen",true);
                }
            }else{
                console.error("fail:" + response.getError()[0].message);
            }
        });
        $A.enqueueAction(action);
    },
    generateNDADocument : function(component, event, helper){
        component.set("v.spinner",true);
        var agrmntReq = component.get("v.agrmntObject");
        var action = component.get("c.generateNDADoc");
        action.setParams({
            "agrmntObj" : JSON.stringify(agrmntReq),
            "accLegalName" : (agrmntReq.Apttus__Account__c === undefined ? '' : agrmntReq.Apttus__Account__r.Name),
            "nokiaLegalName" : (agrmntReq.Nokia_Legal_Entity_lookup__c === undefined ? '' : agrmntReq.Nokia_Legal_Entity_lookup__r.Name)
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                var docVersion = response.getReturnValue();
                helper.redirectToAgreement(component, event, helper,docVersion.Id,docVersion.Apttus__DocumentVersionId__c);
            }
        });
        $A.enqueueAction(action);  
    },
    
    redirectToAgreement : function(component, event, helper, docId, tempId){
        component.set("v.spinner",true);
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url":"/apex/CLM_CallApttusAPI?Id="+component.get("v.recordId")+'&docVersionId='+docId+'&docVersTempId='+tempId
        });
        
        urlEvent.fire(); 
    },
    submitNdaRequest: function(component, event, helper) {
        component.set("v.spinner",true);
        helper.getFields(component, event, helper, 'NDASubmitRequest');
    },
    reActivateRequest: function(component, event, helper) {
        component.set("v.isReactivateOpen", false);
        component.set("v.spinner",true);
        var action = component.get("c.reactivateContract");
        action.setParams({
            "agmrntRec" : JSON.stringify(component.get("v.agrmntObject")),
            "endDate" : component.get("v.reactivateEndDate")
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                helper.showToast(component, event, 'Success', 'Record Activated successfully');
                component.set("v.spinner",false);
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url":"/"+component.get("v.recordId")
                });
                urlEvent.fire(); 
                
            }else{
                var errorMsg = action.getError()[0].message;
                component.set("v.spinner",false);
                component.set("v.reactivateEndDate", undefined);
                helper.showToast(component, event, 'Error', errorMsg);
                toastEvent.fire();
                
            }
        });
        $A.enqueueAction(action);
    }
    
})