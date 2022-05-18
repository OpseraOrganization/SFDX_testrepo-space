({
	 doinit : function (component,event,helper) {
        var action = component.get("c.inittoggle");
         action.setCallback(this, function(response) {
             var state = response.getState();
             console.log('state'+ state);
             if (state === "SUCCESS") {
                 var result = response.getReturnValue();
                 console.log('result'+result);
                 component.set("v.currentVal",result);
                 if(result=="HWS Tickets" || result=="Both"){
                 	component.set("v.isHWSDetailsSelected",true);
                 }
                 if(result=="SWS Tickets" || result=="Both"){
                 	component.set("v.isSWSDetailsSelected",true);
                 }
             }    
         });
         $A.enqueueAction(action);
    },
    selectToggleHWS : function (component,event,helper) {
        var isEnabled = component.find("chkboxHW").get("v.value"); 
        component.set("v.isHWSDetailsSelected", isEnabled);
        var action = component.get("c.removeFromDesktopView");
        if (isEnabled) {
            var action = component.get("c.addToDesktopView");  
        }
        action.setParams({
                changeType : 'HWS Tickets',
                currentValue : component.get("v.currentVal")
        });
         action.setCallback(this, function(response) {
             var state = response.getState();
             console.log('state'+ state);
             if (state === "SUCCESS") {
                 var result = response.getReturnValue();
                 console.log('result'+result);
                 component.set("v.currentVal",result);
             }    
         });
         $A.enqueueAction(action);
    },
    selectToggleSWS : function (component,event,helper) {
        var isEnabled = component.find("chkboxSW").get("v.value"); 
        component.set("v.isSWSDetailsSelected", isEnabled);
        var action = component.get("c.removeFromDesktopView");
        if (isEnabled) {
            var action = component.get("c.addToDesktopView");  
        }
        action.setParams({
                changeType : 'SWS Tickets',
                currentValue : component.get("v.currentVal")
        });
         action.setCallback(this, function(response) {
             var state = response.getState();
             console.log('state'+ state);
             if (state === "SUCCESS") {
                 var result = response.getReturnValue();
                 console.log('result'+result);
                 component.set("v.currentVal",result);
             }    
         });
         $A.enqueueAction(action);
    }
})