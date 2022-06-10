({
	getCCREServiceInfoLineItem : function(component, event, helper) {
		  var action2 = component.get("c.getCCREServiceInfoLineItem");
        action2.setParams({
            "currentRecordId": component.get("v.recordId"),
        });
         
        action2.setCallback(this, function(a){
            component.set("v.CCREServiceInfoLineItem", a.getReturnValue());
         });
         
       
        $A.enqueueAction(action2);
	},
    
    getCCREProductInfoLineItem : function(component, event, helper) {
		  var action2 = component.get("c.getCCREProductInfoLineItem");
        action2.setParams({
            "currentRecordId": component.get("v.recordId"),
        });
         
        action2.setCallback(this, function(a){
            component.set("v.CCREProductInfoLineItem", a.getReturnValue());
         });
         
       
        $A.enqueueAction(action2);
	}
    
})