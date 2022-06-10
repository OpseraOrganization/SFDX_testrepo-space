({
	doInit : function(component, event, helper) {
        
		var actionstatusDetails = component.get("c.getDigitalProposal"); 
        actionstatusDetails.setParams({
            "currentRecordId":component.get("v.recordId")
        });  
        actionstatusDetails.setCallback(this, function(response) {
               
              /*if(response.getReturnValue()[0].Analytics_Source__c === 'RMP'){
                  component.set("v.validateHoverMessage","If you wish to continue and validate the execution of this proposal in your network please do proceed by clicking the 'Validate' button.");
                  component.set("v.rejectHoverMessage","If you wish to continue and reject this please do proceed by clicking the 'Reject' button leaving status in current stage.");
                    component.set("v.dpType","RMP");
                   component.set("v.QuoteText","By validating this software feature proposal, you are agreeing to activate the proposed software features on your network. \
                                    \n \n \
                                    However, If you wish to decline , please click on 'Reject' button with the optional appropriate reason in the comment box.");
              }*/
              //if(response.getReturnValue()[0].Analytics_Source__c === 'CXM'){
                  component.set("v.validateHoverMessage","By validating this proposal you indicated that you are ok to proceed with this proposal and understand that this will be followed by a offer to be confirmed by customer procurement once published / shared on the portal. If you wish to continue and validate the proposal please do proceed by clicking the 'Validate' button.");
                  component.set("v.rejectHoverMessage","By cancelling this proposal you indicate that you do not wish to proceed with this proposal and understand no further recommendation will be made. If you wish to reverse this decision you will need to contact your account team. If you wish to continue and reject the proposal please do proceed by clicking the 'Reject' button.");
                   component.set("v.QuoteText","By validating this proposal you indicated that this proposal presented fits your technical needs, understand it will be followed by an offer to be accepted/rejected as such by your procurement department once published/shared on your customer portal. \
                                    \n \n \
                                    However, if you wish to wait (for renewed proposals) please feel free to proceed by clicking the 'Back' button or if you wish to decline this proposal and believe no further recommendations are needed you can confirm this by clicking the 'Reject' button.");
            //  }
                
               if(response.getReturnValue()[0].Proposal_Status__c === 'Validated' || response.getReturnValue()[0].Proposal_Status__c === 'Close-Reject' ){
                    component.set("v.QuoteText","Digital proposal already validated/rejected");
                    var btn1 = component.find("btnValidate");
                    btn1.set("v.disabled",true);
                    var btn2 = component.find("btnReject");
                    btn2.set("v.disabled",true);
                }
                else if(response.getReturnValue()[0].Proposal_Status__c === 'Replaced' ){
                    component.set("v.QuoteText","Digital proposal already Replaced");
                    var btn1 = component.find("btnValidate");
                    btn1.set("v.disabled",true);
                    var btn2 = component.find("btnReject");
                    btn2.set("v.disabled",true);
                }
                else if(response.getReturnValue()[0].Proposal_Status__c === 'Replacement Pending' ){
                    component.set("v.QuoteText","Digital proposal already in Replacement Pending status");
                    var btn1 = component.find("btnValidate");
                    btn1.set("v.disabled",true);
                    var btn2 = component.find("btnReject");
                    btn2.set("v.disabled",true);
                }
                else if(response.getReturnValue()[0].Proposal_Status__c === 'Close-Validated' ){
                    component.set("v.QuoteText","Digital proposal already Close-Validated");
                    var btn1 = component.find("btnValidate");
                    btn1.set("v.disabled",true);
                    var btn2 = component.find("btnReject");
                    btn2.set("v.disabled",true);
                }
                else if(response.getReturnValue()[0].Proposal_Status__c === 'Reject' ){
                    component.set("v.QuoteText","Digital proposal already in Reject status");
                    var btn1 = component.find("btnValidate");
                    btn1.set("v.disabled",true);
                    var btn2 = component.find("btnReject");
                    btn2.set("v.disabled",true);
                }
                else if(response.getReturnValue()[0].Proposal_Status__c === 'Cancel' ){
                    component.set("v.QuoteText","Digital proposal already in Cancel status");
                    var btn1 = component.find("btnValidate");
                    btn1.set("v.disabled",true);
                    var btn2 = component.find("btnReject");
                    btn2.set("v.disabled",true);
                }
           
        });
        $A.enqueueAction(actionstatusDetails);  
   },
	
    statusUpdate : function(component, event, helper){
        
        var status ='';
        var proposalStatus ='';
        var whichOne = event.getSource().getLocalId();
        
        if(whichOne == "btnValidate"){
            var dpType =component.get("v.dpType");
            if(dpType != 'RMP' ){
            	status = "Ready To Convert";
            	proposalStatus = "Validated";
            	helper.helperStatusUpdateMethod(component, event, helper,status,proposalStatus);                    
            }else{
                status = "Validated";
            	proposalStatus = "Close-Validated";
               // alert('status--->'+status);
               //alert('proposalStatus--->'+proposalStatus);
            	helper.helperStatusUpdateMethod(component, event, helper,status,proposalStatus); 
                //helper.helperStatusUpdateMethod2(component, event, helper,status,proposalStatus);                    
                
            }
                }
        else if(whichOne == "btnReject"){
            component.set("v.rejFlag",1);
            var rejReason = component.find("rejReason");
        	var rejReason1 = rejReason.get("v.value"); 
            if(rejReason1 != '' && rejReason1 != null)
            {
                status = "Reject";
                proposalStatus = "Close-Reject";
                helper.helperStatusUpdateMethod(component, event, helper,status,proposalStatus,rejReason1);
            }        
        }
    },
    
    closeMsg: function(component, event, helper) {
         
      var urlEvent = $A.get("e.force:navigateToURL");
    urlEvent.setParams({
      "url": "/swx-upsell-proposal/"+component.get("v.recordId"),
    });
    urlEvent.fire();
       

     
    },
    
})