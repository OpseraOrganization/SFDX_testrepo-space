({
	doinit : function(component, event, helper) {
        
        helper.getReportLink(component, event, helper);
		var userId = $A.get("$SObjectType.CurrentUser.Id");
    	var action = component.get("c.accessToOBM");
        action.setParams({ "userId" : userId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('response.getState()'+response.getState());
            if(response.getState()==="SUCCESS")
            {
                if(response.getReturnValue()){
					 var urlEvent = $A.get("e.force:navigateToURL");
    				urlEvent.setParams({
     				 //"url": $A.get("$Label.c.CH_IMReportLink")
     				 "url": component.get("v.LinkValue") 
    				});
   					 urlEvent.fire();
                    helper.closeTab(component,event,helper);
                }
                else
                {
                    var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error",
                    "message": $A.get("$Label.c.CH_IMError"),
                    type: 'error'
                });
                toastEvent.fire();
                    helper.closeTab(component,event,helper);
                }
            }
        });
        $A.enqueueAction(action);
	},
    handleConfirmDialogNo : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
    urlEvent.setParams({
      "url": $A.get("$Label.c.CH_IMListLink")
    });
    urlEvent.fire();
        helper.closeTab(component,event,helper);  
    }
})