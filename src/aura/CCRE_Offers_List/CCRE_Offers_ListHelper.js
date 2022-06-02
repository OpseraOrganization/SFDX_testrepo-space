({
    getAllContacts : function(component, event, sortField) {
 	
        var action = component.get("c.getProposal");
         action.setParams({
         	'sortField': sortField,
         	'isAsc': component.get("v.isAsc"),
            'level5': component.get("v.searchKeyword5"),
           'level6': component.find("searchId6").get("v.value")
      });
        
        action.setCallback(this, function(a){
            component.set("v.proposalRows", a.getReturnValue());
           });  
            $A.enqueueAction(action);
    },
    
    getAllContactsOnLoad : function(component, event, helper) {
        
        var action1 = component.get("c.getProposalOnLoad");
        	action1.setCallback(this, function(a){
            component.set("v.proposalRows", a.getReturnValue()); 
        });
        $A.enqueueAction(action1);
	
        var action4 = component.get("c.getQuoteStages");
            action4.setCallback(this, function(a){
            component.set("v.searchKeyword6", a.getReturnValue());
        });
        $A.enqueueAction(action4);
    },
        
    
     sortHelper: function(component, event, sortFieldName) {
          var currentDir = component.get("v.arrowDirection");
    
          if (currentDir == 'arrowdown') {
             component.set("v.arrowDirection", 'arrowup');
             component.set("v.isAsc", true);
          } else {
             component.set("v.arrowDirection", 'arrowdown');
             component.set("v.isAsc", false);
          }
          this.getAllContacts(component, event, sortFieldName);        
        }
})