({
    doInit: function(component, event, helper) {
        component.set('v.showSpinner',true);
        var action = component.get("c.getTimezones");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue(); 
                component.set("v.timezoneOptions",JSON.parse(result));
                component.set('v.openPopup',true);
                component.find('tzId').set('v.value','GMT');
                component.find('tzId').set('v.label','(GMT+00:00) Greenwich Mean Time (GMT)');
                component.set('v.showSpinner',false);
            }
        });
        $A.enqueueAction(action);
    },
	
	closeFocusedTab : function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
        })
        .catch(function(error) {
            console.log(error);
        });
    }
})