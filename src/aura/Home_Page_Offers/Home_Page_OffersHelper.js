({
    getAllContacts : function(component, event, helper) {
        var action = component.get("c.getProposal");
        action.setCallback(this, function(a){
        component.set("v.ProposalRows", a.getReturnValue());
        });
      $A.enqueueAction(action); 
    },
    
 })