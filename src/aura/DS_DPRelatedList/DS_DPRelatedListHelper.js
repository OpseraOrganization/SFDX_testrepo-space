({
	getCXMLineItem : function(component, event, helper) {
		  var action2 = component.get("c.getCXMLineItem");
        action2.setParams({
            "currentRecordId": component.get("v.recordId"),
        });
         
        
        action2.setCallback(this, function(a){
            component.set("v.CXMLineItem", a.getReturnValue());
         });
         
       
        $A.enqueueAction(action2);
	},
    getCCRELineItem : function(component, event, helper) {
		  var action2 = component.get("c.getCCRELineItem");
        action2.setParams({
            "currentRecordId": component.get("v.recordId"),
        });
         
        action2.setCallback(this, function(a){
            component.set("v.CCRELineItem", a.getReturnValue());
         });
         
       
        $A.enqueueAction(action2);
	}
})