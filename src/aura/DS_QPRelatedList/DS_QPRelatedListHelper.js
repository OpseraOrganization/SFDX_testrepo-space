({
	getLineItem : function(component, event, helper) {
		  var action2 = component.get("c.getLineItem");
        action2.setParams({
            "currentRecordId": component.get("v.recordId"),
        });
         
        action2.setCallback(this, function(a){
            component.set("v.lineItem", a.getReturnValue());
         });
         
       
        $A.enqueueAction(action2);
	}
    
})