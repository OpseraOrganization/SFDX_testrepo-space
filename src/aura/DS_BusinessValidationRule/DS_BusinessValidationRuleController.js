({
    checkStatus :function(component, event, helper)
    {   
        var Title= event.getSource().get("v.name");
        var QuoteId= component.get("v.recordId");
        var urlToRecord = "/"+QuoteId;
        var action = component.get("c.checkRules");
          action.setParams({
            "currentRecordId":QuoteId
              
        });
        
        action.setCallback(this, function(a){
             
         });
        $A.enqueueAction(action);
        
        var urlEvent = $A.get("e.force:navigateToURL");
    	urlEvent.setParams({
      		"url": urlToRecord
    	});
    urlEvent.fire();
        $A.get('e.force:refreshView').fire();
    },
    
    //Sprint- 13 - US-725 -start
    onload: function(component, event, helper) {
        helper.getDPValue(component, event, helper);
    },
    // logic to download json file and insert json file in file object.
	getData : function(component, event, helper) {        
       // helper.getDPValue(component, event, helper);
        var action = component.get("c.getJsonFile");
        var doc;          
        action.setParams({ recordId: component.get("v.recordId")
                          
                         
                         })
        action.setCallback(this, function(response) {            
            var state = response.getState();
           // alert('state--->'+state);
            if (state === "SUCCESS"){   
        		doc = response.getReturnValue(); 
                var digitalProposalName = component.get("v.digitalProposalList");
        		var dpProposalStatus = component.get("v.digitalProposalstatus"); 
                var dpupsellStatus = component.get("v.digitalProposalupsellstatus");
                var entitlementstatus = component.get("v.dislayEntitlementStatus");
                var deliverysystem = component.get("v.deliverySystem");
               // alert('dpupsellStatus--u->'+dpupsellStatus);
               // alert('dpProposalStatus--p->'+dpProposalStatus);
                //if((dpProposalStatus==="Close-Validated" && dpupsellStatus==="Validated") || (dpProposalStatus==="Close-Reject" && dpupsellStatus==="Reject")){
                if(entitlementstatus =='Entitled' && deliverysystem=='SWMP' ){
                    helper.download(doc,digitalProposalName, 'html/json');
                    helper.InsertJsonFile(component, event, helper);
                }
                else{    
                   alert('The Digital Proposal has not yet been validated or rejected by the customer. The JSON will be available once the customer validates or rejects the Digital Proposal');
                }
               
            }
            else{                 
                var errors = response.getError();
                if (errors){
                    console.info('Inside if of errors');
                    if (errors[0] && errors[0].message){
                        console.info("Error message: " + errors[0].message);
                    }
                }
            } 
        });                        
        $A.enqueueAction(action);   
    }//Sprint- 13 - US-725--finish

})