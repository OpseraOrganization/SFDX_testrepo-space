({
	closeTab : function(component,event,helper) {
		var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
        })
        .catch(function(error) {
            console.log(error);
        });
	},
    getReportLink : function(component,event,helper) {
		var action = component.get("c.getReportLink");
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('response.getState()'+response.getState());
            if(response.getState()==="SUCCESS")
            {
                component.set("v.LinkValue",response.getReturnValue());
                
            }
        });
        $A.enqueueAction(action);
	}
})