({
    closeTab : function(component) {
        var workspaceAPI = component.find("ProductPulldownWorkspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
			$A.get('e.force:refreshView').fire();
        })
        .catch(function(error) {
            console.log(error);
        });
    },
    setTabIcon : function(component) {
        //Js Controller
        var workspaceAPI = component.find("ProductPulldownWorkspace");        
        workspaceAPI.getEnclosingTabId().then(function(response) {
            workspaceAPI.setTabLabel({
                tabId: response,
                label: "Product Pulldown", //set label you want to set
                title: "Product Pulldown"
            });
            workspaceAPI.setTabIcon({
                tabId: response,
                icon: "standard:case_change_status", //set icon you want to set
                iconAlt: "Product Pulldown" //set label tooltip you want to set
            });
            workspaceAPI.focusTab({
                tabId : response
            }); 
        })
    },
    // Apex Action
    apexAction : function(component, method, params, callback) {
        let helper = this, action = component.get(method);
        if(params) {
            action.setParams(params);
        }
        action.setCallback(helper, function(response) { 
            let state = response.getState();
            if (state === "SUCCESS") {
                callback(null, response.getReturnValue());
            }
            else {
                callback(response.getError(), null);
            }
        });
        $A.enqueueAction(action);
    },
    // Generic Toast Message
    showToast: function(sType, title, message) {
        $A.get("e.force:showToast").setParams({
            "title": title,
            "message": message,
            "type": sType
        }).fire();
    },
    // Loading Framework
    isLoading : function(component) {
        return component.get("v.showSpinner");
    },
    incrementActionCounter : function(component) {        
        var counter = component.get("v.actionCounter") + 1;
        if(counter === 1) {
            component.set("v.showSpinner", true);
        }
        component.set("v.actionCounter", counter);        
    },
    decrementActionCounter : function(component) {
        var counter = component.get("v.actionCounter") - 1;
        if(counter === 0) {
            component.set("v.showSpinner", false);
        }
        component.set("v.actionCounter", counter);    
    }
})