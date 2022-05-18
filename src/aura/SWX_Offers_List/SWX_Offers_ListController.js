({
    doInit : function(component, event, helper){
        helper.getAllContactsOnLoad(component,event,helper);  	 
    },

     OpenPage1 :function(component, event, helper){
        var Title= event.getSource().get("v.name");
        var QuoteId= component.get("v.QuoteID");
        var LineId= event.getSource().get("v.value");
        var action = component.get("c.getDocumentId");
        
          action.setParams({
            "QuoteID": LineId,
              "Title":Title
        });
        action.setCallback(this, function(a){
            var ID=a.getReturnValue();
            
              $A.get('e.lightning:openFiles').fire({
        recordIds: [ID]
    });
         });
        $A.enqueueAction(action);
    },
    
    
    OpenPage: function(component, event, helper) {

         var Id = event.getSource().get("v.name");
     var urlEvent = $A.get("e.force:navigateToURL");
    urlEvent.setParams({
      "url": "/proposal/"+Id+"?type=swx",
    });
    urlEvent.fire();
        
        
    },
    
    
    sortOfferId: function(component, event, helper) {
       component.set("v.selectedTabsoft", 'OfferId');
       helper.sortHelper(component, event, 'Name');
        
    },
    
    sortName: function(component, event, helper) {
       component.set("v.selectedTabsoft", 'OfferName');
       helper.sortHelper(component, event, 'Apttus_Proposal__Proposal_Name__c');
    },
    
    sortDate: function(component, event, helper) {
       component.set("v.selectedTabsoft", 'OfferDate');
       helper.sortHelper(component, event, 'Creation_Date__c');
    },
    
    sortStatus: function(component, event, helper) {
       component.set("v.selectedTabsoft", 'OfferStatus');
      /* helper.sortHelper(component, event, 'Apttus_Proposal__Approval_Stage__c');*/
        helper.sortHelper(component, event, 'Quote_Stage__c');
        
    },
    
     sortCategory: function(component, event, helper) {
       component.set("v.selectedTabsoft", 'OfferCategory');
       helper.sortHelper(component, event, 'Proposal_Recommendation_Type__c');
    },
    
})