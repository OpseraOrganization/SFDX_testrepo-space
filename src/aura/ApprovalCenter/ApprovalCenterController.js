({
    doInit:  function(component, event, helper) 
    {   
        helper.showSpinner(component, event, helper);
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        component.set("v.loggedinUserId",userId);
        var device = $A.get("$Browser.formFactor");
        if(device === "PHONE" || device === "TABLET")
        {            
            component.set("v.mobileDevice",false);
        }
        else
        {
            component.set("v.mobileDevice",true);   
        }
        var recId = component.get("v.recordId");        
        //var recId = '0066E000002LEfQQAW';        
        helper.basicDetailsHelper(component);
        helper.getDocumentsHelper(component, event, helper);
        helper.getApprovalsDetails(component,event,helper);
        helper.getTaskInformation(component,event,helper);  
        helper.getRequestorComment(component,event,helper);                  
    },
    //Function for navigating to the clicked task
    navigateToTask : function (component, event, helper)
    {
        helper.navigateToObject(component, event, helper);
    },
    openModalBox: function(component, event, helper) 
    {
        var aptusRecId =  event.getSource().get("v.value");               
        //var aptusRecId = 'a2H6E000000CfesUAC';        
        var vfUrl = 'https://nokiasinglecrm--ccrmsp17--apttus-approval.cs85.visual.force.com/apex/OpportunityApprovalSummary?id='+aptusRecId+'&pageMode=approveReject&pageModeSf1=true&actionName=oppty_approval_summary&isdtp=nv';        
        component.set("v.vfURL",vfUrl);
        component.set("v.modalPopUp",true);
    },
    closeModel: function(component, event, helper) {      
        component.set("v.modalPopUp", false);
    },
    openOpportunity: function(component, event, helper) 
    { 
        var sObjectId = event.target.getAttribute("data-recId");  
        var navEvt = $A.get("e.force:navigateToSObject");            
        navEvt.setParams
        ({
            "recordId": sObjectId,
            "slideDevName": "detail, related"
        });
        navEvt.fire();
    },
	/*textAreaBlockAccess: function(component, event, helper) 
    {
        
      	//var a = event.getSource();
        var id = event.getSource().getLocalId();         
        component.find(id).set("v.readonly", true);         
    },
    textAreaAccess : function(component, event, helper) 
    {
      	//var a = event.getSource();
        var id = event.getSource().getLocalId();                
        component.find(id).set("v.readonly", false);                             
    },*/
    
    approvalRequestController:  function(component, event, helper) 
    {   
        var isDelegate = component.get("v.wrapper.type"); 
        component.set("v.actiontype",'Approver Approve');        
        var n = isDelegate.localeCompare(" Approving as Delegate");
        var approverDelegateCount = component.get("v.approverDelgateCount");
        if(n == 0 && approverDelegateCount>1)
        {
            component.set("v.ApproverDelegatePopUp", true);    
        }         
        else
        {
            //alert('Not a approver delegate');
            var appReqId = component.get("v.wrapper.approvalRequestId"); 
            helper.approvalRequestHelper(component, event, helper, appReqId);              
        }        
    },
    showTaskInformation : function(component, event, helper)
    {
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams
        ({
            componentDef: "c:TaskInformation",
            componentAttributes:
            {
                recordId: component.get("v.recordId"),
                relatedFilesMap: component.get("v.approvalCenter")
            }
        });
        evt.fire();  
    },
    
    rejectionRequestController:  function(component, event, helper) 
    { 
        var isDelegate = component.get("v.wrapper.type");      
        component.set("v.actiontype",'Approver Reject');    
        var n = isDelegate.localeCompare(" Approving as Delegate");
        var approverDelegateCount = component.get("v.approverDelgateCount");
        if(n == 0 && approverDelegateCount>1)
        {
            component.set("v.ApproverDelegatePopUp", true);    
        }         
        else
        {
            //alert('Not a approver delegate');
            var appReqId = component.get("v.wrapper.approvalRequestId"); 
            helper.rejectionRequestHelper(component, event, helper, appReqId);        
        }                   
    },
    
    openFileController : function (component, event, helper)
    {
        helper.navigateToFile(component, event, helper);
        
    },
    
    openConfiFileController : function (component, event, helper)
    {
        
        var Action = component.get("c.getUserRestriction");
        Action.setCallback(this, function(response)
                               {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS")
            {
                if(!response.getReturnValue())
                    helper.showUnauthoriseToast(component, event, helper);
                else
                    helper.navigateToFile(component, event, helper);
            }
            else
            {
                console.log('TaskInformationController : getTaskDetails not successful');
            }
        });
        $A.enqueueAction(Action);
        
        
    },
    validateOrRejectController : function (component, event, helper)
    {           
        var isvalidateDelegate = component.get("v.wrapper.type");  
        var validateOrRej = event.getSource().getLocalId(); 
        var appReqId = component.find(validateOrRej).get("v.value");        
        component.set("v.actiontype",validateOrRej);    
        var n = isvalidateDelegate.localeCompare("Validator as Delegate"); 
        var validatorDelegateCount = component.get("v.validatorDelgateCount");
        //alert('validatorDelegateCount::>'+validatorDelegateCount);
        if(n == 0 && validatorDelegateCount>1)
        {                  
            component.set("v.ValidatorDelegatePopUp", true);
        }         
        else
        {            
            //alert('Not a validator delegate');
            helper.validateOrRejectHelper(component,helper,event,appReqId,validateOrRej);  
        }                          
    },
    delegateCheckAction : function (component, event, helper)
    {
        var appReqId = event.getSource().get("v.text");        
        var actionType = component.get("v.actiontype");        
        if(actionType == 'Approver Approve')
        {
            helper.approvalRequestHelper(component, event, helper, appReqId);              
        }
        else if(actionType == 'Approver Reject')
        {
            helper.rejectionRequestHelper(component, event, helper, appReqId);        
        }
        else 
        {
            helper.validateOrRejectHelper(component,helper,event,appReqId,actionType);  
        }
        helper.closeDelegateModelhelper(component, event, helper);
    },
    closeDelegateModel : function (component, event, helper)
    {
        helper.closeDelegateModelhelper(component, event, helper);
    },
    openDelegateModel : function (component, event, helper)
    {
        var buttonId =  event.getSource().getLocalId();
    },

})