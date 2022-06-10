({
	doInit : function(component, event, helper) {
        
		var actionstatusDetails = component.get("c.getStatusDeatils");        
        actionstatusDetails.setParams({
            "currentRecordId":component.get("v.recordId")
        });  
        actionstatusDetails.setCallback(this, function(response) {
            component.set("v.relatedData",response.getReturnValue());
           
            /*Start Changes*/
            component.set("v.QuoteText",
            "By Accepting this Proposal/Offer you are agreeing to provide to Nokia a Purchase Order at your earliest before the expiry date of this existing Agreement. Purchase Order will be issued under the Terms and Conditions of  relevant Supply/Care Agreement " + response.getReturnValue().Name + ". If you wish to continue and Accept the Proposal/offer please click the 'Accept' button or press 'Back' if you do not wish to proceed.If you wish to Decline the offer/proposal , please click on 'Reject' button with the appropriate comment/reason in the comments box.");
            
            /*End Changes*/
           
            if(response.getReturnValue().Apttus_Proposal__Approval_Stage__c === 'Accepted' || response.getReturnValue().Apttus_Proposal__Approval_Stage__c === 'Rejected' ){
                component.set("v.docFlag",2);
                var btn1 = component.find("btnAccept");
                btn1.set("v.disabled",true);
                var btn2 = component.find("btnReject");
                btn2.set("v.disabled",true);
            }
            else if(response.getReturnValue().Apttus_Proposal__Approval_Stage__c === 'Withdrawn'){
                component.set("v.docFlag",3);
                alert("hello");
                var btn1 = component.find("btnAccept");
                btn1.set("v.disabled",true);
                var btn2 = component.find("btnReject");
                btn2.set("v.disabled",true);
            }
            else if(response.getReturnValue().Apttus_Proposal__Approval_Stage__c === 'Approved'){
                if(response.getReturnValue().Analytics_Source__c === 'CCRE'){
                    component.set("v.docFlag",4);
                }
                else{
                	component.set("v.docFlag",0);
            	}
            }
            
            });
         $A.enqueueAction(actionstatusDetails);
            
          
	},
    statusUpdateAccepted : function(component, event, helper){
        
        var actionstatusDetails1 = component.get("c.getDocumentDeatils");
                actionstatusDetails1.setParams({
                "currentRecordId":component.get("v.recordId")
                });  
                    
                actionstatusDetails1.setCallback(this, function(response) {    
                
                if(response.getReturnValue() === 1 ){ 
                    component.set("v.QuoteText","You can’t proceed this action without uploaded signed contract document, please attach the document first.");
                    var btn1 = component.find("btnAccept");
                    btn1.set("v.disabled",true);
                    var btn2 = component.find("btnReject");
                    btn2.set("v.disabled",true);
                }
                else{
                    //component.find("recordHandler").reloadRecord(); 
                    component.set("v.relatedData.Apttus_Proposal__Approval_Stage__c","Accepted");         
                    component.find("recordHandler").saveRecord($A.getCallback(function(saveResult) {
                     //   alert(saveResult.state)
                    if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                        $A.get("e.force:refreshView").fire();
                    }
                    }));
                }
                });
                $A.enqueueAction(actionstatusDetails1);
    
    },
	
    statusUpdateRejected : function(component, event, helper){
        component.set("v.rejFlag",1);
            var rejReason = component.find("rejReason");
        	var rejReason1 = rejReason.get("v.value"); 
            if(rejReason1 != '' && rejReason1 != null){
                component.set("v.relatedData.Apttus_Proposal__Approval_Stage__c","Rejected");         
                component.find("recordHandler").saveRecord($A.getCallback(function(saveResult) {  
                if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                    $A.get("e.force:refreshView").fire();
                }
                }));
            }
    },
    
    
    closeMsg: function(component, event, helper) {
      var urlEvent = $A.get("e.force:navigateToURL");
    urlEvent.setParams({
      "url": "/proposal/"+component.get("v.recordId"),
    });
    urlEvent.fire();
     
    },
    
    handleRecordUpdated: function(component, event, helper) {
        var changeType = event.getParams().changeType;
        if (changeType == "ERROR") { 
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Saved",
                    "message": "The record was not updated."
                });
                resultsToast.fire();
        }
        else if (changeType == "LOADED") { 
            
        }
        else if (changeType == "CHANGED") { 
            component.find("recordHandler").reloadRecord(); 
        }       
},
 
    
})