({
    doInit : function(component, event, helper){        
     var actionstatusDetails = component.get("c.getStatusDeatils");
        actionstatusDetails.setParams({
            "currentRecordId":component.get("v.recordId")
        });  
        actionstatusDetails.setCallback(this, function(response) {
            component.set("v.relatedData",response.getReturnValue());
            if(response.getReturnValue().Analytics_Source__c == 'CCRE')
            {
                component.set("v.ccreFlag",2);
              
            }
            else
            {
              component.set("v.ccreFlag",1);  
            }
            });
         $A.enqueueAction(actionstatusDetails);
        
    },
   
     OpenDocument :function(component, event, helper)
    {   
        var Title= event.getSource().get("v.name");
       
        var QuoteId= component.get("v.recordId");
      
         var action = component.get("c.getDocumentId");
          action.setParams({
            "QuoteID":QuoteId,
              "Title":Title
        });
        action.setCallback(this, function(a){
            var ID=a.getReturnValue();
            
              $A.get('e.lightning:openFiles').fire({
        recordIds: [ID]
    });
           // alert(a.getReturnValue());
         });
        $A.enqueueAction(action);
    },
    OpenComp : function(component, event, helper){
        
        var WaitMsg = component.find("divMessage");
                $A.util.addClass(WaitMsg,'slds-show');                            
                $A.util.removeClass(WaitMsg,'slds-hide'); 
    },
    statusUpdate : function(component, event, helper){
        var QuoteId= component.get("v.recordId");
       
        var status ='';
        var whichOne = event.getSource().getLocalId();
      
        
        if(whichOne == "btnAccept")
        {
            status = "Accepted";
        }
        else
        {
            status = "Rejected";
        }
        helper.helperStatusUpdateMethod(component, event, helper,status);
    },
    closeMsg : function(component, event, helper){
        var container = component.find("divMessage");
                $A.util.addClass(container,'slds-hide');                            
                $A.util.removeClass(container,'slds-show'); 
    }
    
	
})