({
	myAction : function(component, event, helper) {
		var actionUser = component.get('c.getUserPartner');
        actionUser.setCallback(this, function(a) {
            component.set("v.UserType",a.getReturnValue());
        });
        $A.enqueueAction(actionUser);
        
        var actionUser2 = component.get('c.getUserHeading');
        actionUser2.setCallback(this, function(a) {
            component.set("v.User",a.getReturnValue());
            var a = component.get("v.User");
            var userDetail = component.get("v.UserType");
            for(var b=0;b<a.length;b++){
                if(a[b].Name == userDetail){
                   
                    //component.set("v.Userrr",a[b]);
                    component.set("v.heading",a[b].Heading__c);
                    
                }
                else if(userDetail == null  && a[b].Name == 'No Partner' ){
                   component.set("v.heading",a[b].Heading__c); 
                }
                
                
            }
        });
        $A.enqueueAction(actionUser2);
	}
    
})