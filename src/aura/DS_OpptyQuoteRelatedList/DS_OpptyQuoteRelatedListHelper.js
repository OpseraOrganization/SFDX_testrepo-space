({
    getOpportunity : function(component, event, helper) {
		  var action2 = component.get("c.getOpportunity");
        action2.setParams({
            "currentRecordId": component.get("v.recordId"),
        });
         
       
        action2.setCallback(this, function(a){
            component.set("v.Opportunity", a.getReturnValue());
         });
         
       
        $A.enqueueAction(action2);
	},
    getQuote : function(component, event, helper) {
		  var action2 = component.get("c.getQuote");
        action2.setParams({
            "currentRecordId": component.get("v.recordId"),
        });
         
         
        action2.setCallback(this, function(a){
            component.set("v.Quotes", a.getReturnValue());
         });
         
       
        $A.enqueueAction(action2);
	}
    
    
})