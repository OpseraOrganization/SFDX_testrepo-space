({
	doInit : function(component, event, helper) {
        
		var actionstatusDetails = component.get("c.getDigitalProposal"); 
        actionstatusDetails.setParams({
             "currentRecordId":component.get("v.recordId")
        }); 
        
        actionstatusDetails.setCallback(this, function(response) {
              //alert(response.getReturnValue()[0].Entitlement_Info__c)
              component.set("v.entitlementStatus",response.getReturnValue()[0].Entitlement_Info__c);
            //alert('Status:'+response.getReturnValue()[0].Entitlement_Info__c);
            
              if(response.getReturnValue()[0].Entitlement_Info__c === 'Can Be Entitled' || response.getReturnValue()[0].Entitlement_Info__c === 'Cannot be entitled'){
                  //component.set("v.validateHoverMessage","If you wish to continue and validate the execution of this proposal in your network please do proceed by clicking the 'Validate' button.");
                  //component.set("v.rejectHoverMessage","If you wish to continue and reject this please do proceed by clicking the 'Reject' button leaving status in current stage.");
                    //component.set("v.dpType","RMP");
                   component.set("v.QuoteText","By validating this recommendation you indicate that it fits your technical needs, and software will be activated. \
                                    \n \n \
                                             If you wish to decline this recommendation and believe no further activation is needed, you can confirm this by clicking the 'Reject' button	");
              component.set("v.showValdiateRejectButtons",true);
              }
            /*if(response.getReturnValue()[0].Analytics_Source__c === 'RMP'){
                 // component.set("v.validateHoverMessage","If you wish to continue and validate the execution of this proposal in your network please do proceed by clicking the 'Validate' button.");
                 // component.set("v.rejectHoverMessage","If you wish to continue and reject this please do proceed by clicking the 'Reject' button leaving status in current stage.");
                    component.set("v.dpType","RMP");
                   component.set("v.QuoteText","By validating this recommendation you indicate that it fits your technical needs, and software will be activated. \
                                    \n \n \
                                             If you wish to decline this recommendation and believe no further activation is needed, you can confirm this by clicking the 'Reject' button	");
              component.set("v.showValdiateRejectButtons",true);
              }*/
              if(response.getReturnValue()[0].Entitlement_Info__c === 'Quote Needed'){
                 // component.set("v.validateHoverMessage","By validating this proposal you indicated that you are ok to proceed with this proposal and understand that this will be followed by a offer to be confirmed by customer procurement once published / shared on the portal. If you wish to continue and validate the proposal please do proceed by clicking the 'Validate' button.");
                 // component.set("v.rejectHoverMessage","By cancelling this proposal you indicate that you do not wish to proceed with this proposal and understand no further recommendation will be made. If you wish to reverse this decision you will need to contact your account team. If you wish to continue and reject the proposal please do proceed by clicking the 'Reject' button.");
                   component.set("v.QuoteText","By validating this recommendation, you confirm that it fits your technical needs. This will be followed by a commercial proposal to be accepted or rejected by your procurement department once shared on your customer portal. \
                                    \n \n \
                                          However, if you wish to decline this recommendation, please select the reject button and leave a comment.");
              component.set("v.showValdiateRejectButtons",true);
              }
                
               if(response.getReturnValue()[0].Proposal_Status__c === 'Validated' || response.getReturnValue()[0].Proposal_Status__c === 'Close-Reject' ){
                    component.set("v.QuoteText","Digital proposal already validated/rejected");
                    
                   	component.set("v.showValdiateRejectButtons",false);
                   if(response.getReturnValue()[0].Proposal_Status__c === 'Close-Reject'){
                       component.set("v.showRejectionReasons",true);
                       component.set("v.RejectionReasons",response.getReturnValue()[0].Rejection_Reason__c);
                       
                   }
                }
                else if(response.getReturnValue()[0].Proposal_Status__c === 'Replaced' ){
                    component.set("v.QuoteText","Digital proposal already Replaced");
                    component.set("v.showValdiateRejectButtons",false);
                }
                else if(response.getReturnValue()[0].Proposal_Status__c === 'Replacement Pending' ){
                    component.set("v.QuoteText","Digital proposal already in Replacement Pending status");
                    component.set("v.showValdiateRejectButtons",false);
                }
                else if(response.getReturnValue()[0].Proposal_Status__c === 'Close-Validated' ){
                    component.set("v.QuoteText","Digital proposal already Close-Validated");
                    component.set("v.showValdiateRejectButtons",false);
                }
                else if(response.getReturnValue()[0].Proposal_Status__c === 'Reject' ){
                    component.set("v.QuoteText","Digital proposal already in Reject status");
                    component.set("v.RejectionReasons",response.getReturnValue()[0].Rejection_Reason__c);
                    component.set("v.showValdiateRejectButtons",false);
                    component.set("v.showRejectionReasons",true);
                       component.set("v.RejectionReasons",response.getReturnValue()[0].Rejection_Reason__c);
                }
                else if(response.getReturnValue()[0].Proposal_Status__c === 'Cancel' ){
                    component.set("v.QuoteText","Digital proposal already in Cancel status");
                    component.set("v.showValdiateRejectButtons",false);
                }
             else if(response.getReturnValue()[0].Entitlement_Info__c === 'Cannot be entitled' ){
                   
                }
           
        });
        $A.enqueueAction(actionstatusDetails);  
   },
	
    statusUpdate : function(component, event, helper){
        var status ='';
        var proposalStatus ='';
        var whichOne = event.getSource().getLocalId();
        
        if(whichOne == "btnValidate"){
           // var dpType =component.get("v.dpType");
             var entitlementStatus =component.get("v.entitlementStatus");
            if(entitlementStatus==='Cannot be entitled'){
                alert('One or more related products of this technical recommendation are no longer covered by your entitlements. Please contact Nokia');
                
            }
           /* else if(dpType != 'RMP' ){
            	status = "Ready To Convert";
            	proposalStatus = "Validated";
            	helper.helperStatusUpdateMethod(component, event, helper,status,proposalStatus);  */                  
            else if(entitlementStatus==='Quote Needed'){
                status = "Ready To Convert";
            	proposalStatus = "Validated";
                helper.helperStatusUpdateMethod(component, event, helper,status,proposalStatus); 
            }
            else if(entitlementStatus==='Can Be Entitled'){
                status = "Validated";
            	proposalStatus = "Close-Validated";
            	helper.helperStatusUpdateMethod(component, event, helper,status,proposalStatus); 
                //helper.helperStatusUpdateMethod2(component, event, helper,status,proposalStatus);                    
                
            }
                }
        else if(whichOne == "btnReject"){
            component.set("v.rejFlag",1);
                
        }
    },
    
    closeMsg: function(component, event, helper) {
         
      var urlEvent = $A.get("e.force:navigateToURL");
    urlEvent.setParams({
      "url": "/swx-upsell-proposal/"+component.get("v.recordId"),
    });
    urlEvent.fire();  
    },
    
    confirmReject: function(component, event, helper){
        var rejReason = component.find("rejReason");
        var rejReason1 = rejReason.get("v.value"); 
        var status ='';
        var proposalStatus ='';
        if(rejReason1 != '' && rejReason1 != null)
        {	
            status = "Reject";
        	proposalStatus = "Close-Reject";
             //component.set("v.ShowValidateCmp",false);
            helper.helperStatusUpdateMethod(component, event, helper,status,proposalStatus,rejReason1);
            //component.set("v.showRejectMessage",true);
        }
    },
    
    moveToListView : function(component, event, helper){
        var urlEvent = $A.get("e.force:navigateToURL");
       var link = '/technical-proposals';
    	urlEvent.setParams({
      	"url": link+$A.get("$Label.c.DS_RecommendationTabID"),
    	});
    urlEvent.fire(); 
    },
    
    addfeedback : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        var link = '/';
        	urlEvent.setParams({
            	"url": link+"feedback",
        	});
        // alert(window.location.pathname);
    	urlEvent.fire(); 
	},
    
    // function automatic called by aura:waiting event  
    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for displaying loading spinner 
        component.set("v.spinner", true);         
    },
    
    // function automatic called by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hiding loading spinner    
        component.set("v.spinner", false);        
    }
})