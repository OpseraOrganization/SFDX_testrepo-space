({
    basicDetailsHelper : function(component,event,helper) {
        //alert('Begin');
        var recId = component.get("v.recordId");           
        // alert('recId::>'+recId);
        var action = component.get("c.basicApprovalDetails");        
        //alert('action');
        action.setParams({
            'oppRecordId': recId
        });        
        //alert('1asd1');
        action.setCallback(this, function(response) { 
            // alert('2');
            var state = response.getState();            
            // alert('state'+state);
            if (state === "SUCCESS") { 
                
                var storeResponse = response.getReturnValue();
                var beingApproverDelegateCount = 0;
                var userId = $A.get("$SObjectType.CurrentUser.Id");
                for(var i in storeResponse.approverRecList)
                {                    
                    var temp = storeResponse.approverRecList[i].Apttus_Approval__DelegateApproverIds__c;  
                    if(temp != undefined)
                    {
                        var myarray = temp.split(',');     
                        for(var x = 0; x < myarray.length; x++)
                        {                            
                            myarray[x] = myarray[x].slice(0, 15);                                
                            if(userId == myarray[x] &&(storeResponse.approverRecList[i].Apttus_Approval__Approval_Status__c == 'Assigned'|| storeResponse.approverRecList[i].Apttus_Approval__Approval_Status__c == 'Reassigned'))
                            {                                
                                storeResponse.approverRecList[i].Apttus_Approval__DelegateApproverIds__c = myarray[x];
                                beingApproverDelegateCount = beingApproverDelegateCount+1;   
                            }
                        }                                           
                    }
                }  
                component.set("v.approverDelgateCount", beingApproverDelegateCount);
                var beingValidatorDelegateCount = 0;
                for(var j in storeResponse.validatorRecList)
                {
                    var temp1 = storeResponse.validatorRecList[j].Apttus_Approval__DelegateApproverIds__c;   
                    if(temp1 != undefined)
                    {
                        var myarray1 = temp1.split(',');     
                        for(var y = 0; y < myarray1.length; y++)
                        {                            
                            myarray1[y] = myarray1[y].slice(0, 15);                            
                            if(userId == myarray1[y]  && storeResponse.validatorRecList[j].Validator_Status__c != 'Validated')
                            {                                   
                                storeResponse.validatorRecList[j].Apttus_Approval__DelegateApproverIds__c = myarray1[y];
                                beingValidatorDelegateCount = beingValidatorDelegateCount+1;                                   
                            }
                        }                                                        
                    } 
                }
                component.set("v.validatorDelgateCount", beingValidatorDelegateCount);                         
                //alert('DP URL::>'+storeResponse.approverPhotoURL);
                component.set("v.userPicURL", storeResponse.approverPhotoURL);
                if(!storeResponse.validatorOrApprover)
                {
                    if(storeResponse.isApprovalRequested)
                    {                        
                        component.find("approveButton").set("v.disabled", false);
                        component.find("rejectButton").set("v.disabled", false);                    
                        component.find("addComments").set("v.disabled", false);
                    }
                    else
                    {
                        component.find("approveButton").set("v.disabled", true);
                        component.find("rejectButton").set("v.disabled", true);                    
                        component.find("addComments").set("v.disabled", true);
                    } 
                }
                else
                {
                    if(storeResponse.isApprovalRequested)
                    {                        
                        component.find("addComments").set("v.disabled", false);
                    }
                    else
                    {
                        component.find("addComments").set("v.disabled", true);
                    }
                }                
                if(storeResponse.validatorEligibilityExpired)
                {                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Sorry!",
                        "key": "ban",
                        "type":"warning",
                        "mode":"dismissible",
                        "message": "You cannot leave validation comments after one week of approval decision"
                    });
                    toastEvent.fire();
                }
                
                if(storeResponse.ValidatonCompletion)
                {                          
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Sorry!!",
                        "key": "ban",
                        "type":"warning",
                        "mode":"dismissible",                         
                        "message": "Validation Request Already Completed"                        
                    });
                    toastEvent.fire();
                }
                if(storeResponse.notAllowToCreateTask){
                    //alert('inside if');
                    var setBtn = component.find("tskBtn");
                    setBtn.set("v.disabled", true);
                }
            }  
            //alert('End');
            component.set("v.wrapper", response.getReturnValue());
        });
        $A.enqueueAction(action);
        //$A.get('e.force:refreshView').fire();
    },
    navigateToObject : function (component, event, helper)
    {        
        // alert('component.find("contentDocumentId").get("v.value") : '+component.find("contentDocumentId").get("v.value"));
        // alert('event.getSource().get("v.value") : '+event.getSource().getLocalId());
        var taskRecId = event.target.id;
        var navEvt = $A.get("e.force:navigateToSObject");        
        navEvt.setParams
        ({
            "recordId": taskRecId
        });
        navEvt.fire();
    },
    getTaskInformation : function(component, event, helper)
    {
        var taskAction = component.get("c.getTaskDetails");
        taskAction.setParams({ oppRecordId: component.get("v.recordId") });
        
        taskAction.setCallback(this, function(response)
                               {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS")
            {
                component.set("v.approvalCenter", response.getReturnValue());
            }
            else
            {
                console.log('TaskInformationController : getTaskDetails not successful');
            }
        });
        $A.enqueueAction(taskAction);
    },
    
    
    getDocumentsHelper : function(component, event, helper) 
    {
        helper.showSpinner(component, event, helper);
        var documentAction = component.get("c.getConfidentialDocs");
        documentAction.setParams({ currentRecordId: component.get("v.recordId") });
        documentAction.setCallback(this, function(response)
                                   {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS")
            {
                console.log('ApprovalCenter : getConfidentialDocs  successful : '+response.getReturnValue());
                component.set("v.DocWrapper", response.getReturnValue());                
            }
            else
            {
                console.log('ApprovalCenter : getConfidentialDocs not successful : '+response.getReturnValue());
            }
            helper.hideSpinner(component, event, helper);
        });
        $A.enqueueAction(documentAction);
        
        var documentAction1 = component.get("c.getG4_G5_Docs");
        documentAction1.setParams({ currentRecordId: component.get("v.recordId") });
        documentAction1.setCallback(this, function(response)
                                   {
            var state1 = response.getState();
            if(component.isValid() && state1 === "SUCCESS")
            {
                console.log('ApprovalCenter : G4_G5_Documents  successful : '+response.getReturnValue());
                component.set("v.G4G5DocWrapper", response.getReturnValue());                
            }
            else
            {
                console.log('ApprovalCenter : G4_G5_Documents not successful : '+response.getReturnValue());
            }
        });
        $A.enqueueAction(documentAction1);
    },
    
    approvalRequestHelper : function(component, event, helper, appReqId) 
    {      
        helper.showSpinner(component, event, helper);
        var commentValue = component.find("addComments").get("v.value");        
        var reqId = appReqId;        
        console.log('Approval RequestId : '+reqId);
       var approvalAction = component.get("c.approvalRequest");
        
        approvalAction.setParams({ approvalRequestId: reqId,
                                  comment: commentValue
                                 });
        approvalAction.setCallback(this, function(response)
                                   {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS")
            {
                if(response.getReturnValue() === "approved")
                {
                    helper.successToast(component, event, helper, response.getReturnValue());                                               
                    location.reload();
                }
                else
                {
                    helper.failureToast(component, event, helper, response.getReturnValue());
                }
                component.find("addComments").set("v.value", "");
                //  $A.get('e.force:refreshView').fire();
                
            }
            else
            {
                console.log('ApprovalCenter : approveRequest not successful : '+response.getReturnValue());
            }
            helper.hideSpinner(component, event, helper);
        });
        $A.enqueueAction(approvalAction); 
    },
    
    rejectionRequestHelper : function(component, event, helper, appReqId) 
    {   
        helper.showSpinner(component, event, helper);
        var commentValue = component.find("addComments").get("v.value");        
        var reqId = appReqId;
        
        console.log('Approval RequestId : '+reqId);
        
        var rejectionAction = component.get("c.rejectionRequest");
        
        rejectionAction.setParams({ 
            approvalRequestId: reqId,
            comment: commentValue
        });
        
        rejectionAction.setCallback(this, function(response)
                                    {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS")
            {
                if(response.getReturnValue() === "rejected")
                {
                    helper.successToast(component, event, helper, response.getReturnValue());                                                
                    location.reload();
                }
                else
                {
                    helper.failureToast(component, event, helper, response.getReturnValue());
                }
                component.find("addComments").set("v.value", "");
                //$A.get('e.force:refreshView').fire();
            }
            else
            {
                console.log('ApprovalCenter : rejectionRequest not successful : '+response.getReturnValue());
            }
            helper.hideSpinner(component, event, helper);
        });
        $A.enqueueAction(rejectionAction);
    },
    
  
    getApprovalsDetails : function(component, event, helper)
    {
        var oppId = component.get("v.recordId");
        var getapprovalDetails = component.get("c.getApprovalsDetailsRec");
        getapprovalDetails.setParams({ oppRecordId : oppId });
        getapprovalDetails.setCallback(this, function(response)
                                       {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS")
            {
                component.set("v.approvalList", response.getReturnValue())  
            }
            else
            {
                console.log('ApprovalCentreController : getApprovalsDetails not successful');
            }   
        });
        $A.enqueueAction(getapprovalDetails);        
    },
    
    navigateToFile : function (component, event, helper)
    {
        var contDocId = event.target.id;
        var navEvt = $A.get("e.force:navigateToSObject");        
        navEvt.setParams
        ({
            "recordId": contDocId,
            "slideDevName": "detail, related"
        });
        navEvt.fire();
    },
    
    showUnauthoriseToast : function(component, event, helper) 
    {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Oops!",
            "key": "ban",
            "type":"error",
            "mode":"dismissible",
            "message": "Sorry, you are not authorised to view this file"
        });
        toastEvent.fire();
    },       
    
    successToast : function(component, event, helper, message)
    {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Congrats!",
            "key": "ban",
            "type":"success",
            "mode":"dismissible",
            "message": "Great, you succesfully "+message+" the request"
        });
        toastEvent.fire();
    },
    
    failureToast : function(component, event, helper, message)
    {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Sorry!",
            "key": "ban",
            "type":"warning",
            "mode":"dismissible",
            "message": message
        });
        toastEvent.fire();
    },
    validateOrRejectHelper : function(component,helper,event,appReqId,actionType)
    {
        helper.showSpinner(component, event, helper);
        var validateOrRej = actionType;               
        var reqId = appReqId;             
        var commentValue = component.find("addComments").get("v.value");          
        var validateAction = component.get("c.validateOrReject");        
        validateAction.setParams({
            'approvalReqId' : reqId,
            'comment' : commentValue,
            'validateOrRej' : validateOrRej
        });
        validateAction.setCallback(this, function(response)
                                   {                                       
            var state = response.getState();                                                                           
            if(component.isValid() && state === "SUCCESS")
            {                                           
                helper.successToast(component, event, helper, response.getReturnValue());  
                //$A.get('e.force:refreshView').fire();                                           
                location.reload();                                           
            }
            else
            {
                helper.successToast(component, event, helper, response.getReturnValue());
            }
            component.find("addComments").set("v.value", "");          
            helper.hideSpinner(component, event, helper);
        });
        $A.enqueueAction(validateAction);  
    },
    
    getRequestorComment : function(component, event, helper)
    {
        var oppId = component.get("v.recordId");
        var getRequestorComments = component.get("c.getRequestorComment");
        getRequestorComments.setParams({ oppRecordId : oppId });
        
        getRequestorComments.setCallback(this, function(response)
                                        {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS")
            {
                component.set("v.strAppComments", response.getReturnValue())  
            }
            else
            {
                console.log('ApprovalCentreController : getApproverComments not successful');
            }
            helper.hideSpinner(component,event,helper);
        });
        $A.enqueueAction(getRequestorComments);
        
    },
    closeDelegateModelhelper : function (component, event, helper)
    {        
        component.set("v.ApproverDelegatePopUp", false);   
        component.set("v.ValidatorDelegatePopUp", false);   
    },
    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for display loading spinner
        component.set("v.Spinner", true);  
    },
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hide loading spinner    
        component.set("v.Spinner", false);
    }
})