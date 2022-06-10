({
    getAllContacts : function(component, event, sortField) {
  
        var action = component.get("c.getProposal");
        action.setParams({
         'sortField': sortField,
         'isAsc': component.get("v.isAsc"),
            'level1': component.find("searchId1").get("v.value"),
            'level2': component.find("searchId2").get("v.value"),
            'level3': component.get("v.search3"),
            'level5': component.get("v.searchKeyword5"),
            'level6': component.find("searchId6").get("v.value"),
            
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
				
        	var action2 = component.get("c.getCategoryHierarcyDetails");
        	action2.setCallback(this, function(a){
            component.set("v.searchKeyword1", a.getReturnValue());      
            
        });
        $A.enqueueAction(action2);
        
            var action3 = component.get("c.getCategoryDataForSecondLevel");
            action3.setCallback(this, function(a){
            component.set("v.searchKeyword2", a.getReturnValue());
        });
        $A.enqueueAction(action3);
        
        	var action4 = component.get("c.getQuoteStages");
            action4.setCallback(this, function(a){
            component.set("v.searchKeyword6", a.getReturnValue());
        });
        $A.enqueueAction(action4);
        
        var action5 = component.get("c.getQuoteLevel3");
            action5.setCallback(this, function(a){
            component.set("v.searchKeyword3", a.getReturnValue());
        });
        $A.enqueueAction(action5);
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
      // call the onLoad function for call server side method with pass sortFieldName 
      this.getAllContacts(component, event, sortFieldName);
        
        
        }
   ,
    
})