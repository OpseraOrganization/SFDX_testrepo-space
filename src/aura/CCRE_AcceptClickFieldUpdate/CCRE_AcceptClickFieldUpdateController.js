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
            "By accepting this Proposal you are agreeing to provide to Nokia a Purchase Order at your earliest before the expiry date of this existing Agreement. The Purchase Order will be issued under the Terms and Conditions of  relevant Supply/Care Agreement " + response.getReturnValue().Name + ". If you wish to continue and accept the Proposal please click the 'Accept' button or press 'Back' if you do not wish to proceed. If you wish to decline the Proposal, please click on 'Reject' button with the appropriate reason in the comment box.");
            
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
                    var po_number='';
                    if(response.getReturnValue().Apttus_QPConfig__PONumber__c!=undefined){
                    	po_number=response.getReturnValue().Apttus_QPConfig__PONumber__c;
                    }
                    
                	//component.set("v.docFlag",0);
                	if(response.getReturnValue().Proposal_Recommendation_Type__c === 'SW Recommendation' && response.getReturnValue().PO_Required__c === false){
                        component.set("v.docFlag",11);
                        component.set("v.QuoteText",
            "By accepting this binding proposal, you are agreeing to activate the actual software features proposed in the proposal. If you wish to decline the proposal, please select the 'Reject' button and leave a reason.");
                    }
                    else if(response.getReturnValue().Proposal_Recommendation_Type__c === 'SW Recommendation' && response.getReturnValue().PO_Required__c === true){
                        component.set("v.docFlag",12);
                        component.set("v.QuoteText",
         "By accepting this binding proposal you enclosed a signed Purchase Order " + po_number + " in line with the terms of your supply agreement.If you wish to decline the proposal,please select the 'Reject' button and leave a reason");
                    }
                    else if(response.getReturnValue().Proposal_Recommendation_Type__c === 'HW Recommendation' && response.getReturnValue().PO_Required__c === true){
                        component.set("v.docFlag",13);
                        component.set("v.QuoteText",
      "By accepting this binding proposal you enclosed a signed Purchase Order " + po_number + " in line with the terms of your supply agreement.If you wish to decline the proposal,please select the 'Reject' button and leave a reason");

      //      "By accepting this binding recommendation you enclosed a signed Purchase Order " + po_number + " in line with the terms of your supply agreement. If you wish to decline the recommendation, please click on 'Reject' button with the appropriate reason in the comment box");
                    }
                    else if(response.getReturnValue().Proposal_Recommendation_Type__c === 'HW Recommendation' && response.getReturnValue().PO_Required__c === false){
                        component.set("v.docFlag",15);
                        component.set("v.QuoteText",
            "By accepting this binding proposal, you are agreeing to activate the actual software features proposed in the proposal. If you wish to decline the proposal, please select the 'Reject' button and leave a reason.");
                    }
            	}
            }
            
            });
         $A.enqueueAction(actionstatusDetails);  
        
	},
	
    statusUpdate : function(component, event, helper){
        
        var status ='';
        var whichOne = event.getSource().getLocalId();
        
        if(whichOne == "btnAccept"){
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
                else if(response.getReturnValue() === 14 ){                     
                    component.set("v.QuoteText","You can’t proceed this action without providing a purchase order number and upload the purchase order first.");
                    var btn1 = component.find("btnAccept");
                    btn1.set("v.disabled",true);
                    var btn2 = component.find("btnReject");
                    btn2.set("v.disabled",true);
                }
                else{
					status = "Accepted";
            		helper.helperStatusUpdateMethod(component, event, helper,status);                    
                }
                });
                $A.enqueueAction(actionstatusDetails1);	
        }
        else if(whichOne == "btnReject"){
            component.set("v.rejFlag",1);
            var rejReason = component.find("rejReason");
        	var rejReason1 = rejReason.get("v.value"); 
            if(rejReason1 != '' && rejReason1 != null)
            {
                status = "Rejected";
                helper.helperStatusUpdateMethod(component, event, helper,status,rejReason1);
            }        
        }
    },
    
    closeMsg: function(component, event, helper) {
         
      var urlEvent = $A.get("e.force:navigateToURL");
    urlEvent.setParams({
      "url": "/proposal/"+component.get("v.recordId"),
    });
    urlEvent.fire();
       

     
    },
    
})