({
    doInit: function(component, event, helper) {
        var action = component.get("c.getSessionAndBaseUrl");
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
                var resp = response.getReturnValue();
                var urlEvent = $A.get("e.force:navigateToURL");
                var parentId = component.get("v.recordId");
                var hostUrl = resp.baseUrl; 
                var appId = "6f729ce9-9a22-4d15-a3df-e064ef70bb9c";
                var actionflowName = "Action Flow ALI";
                var sessionId = resp.session;
                var urlVal = ('xauthorforexcel:export '+ appId + ' ' + parentId
                              + ' ' + sessionId + ' ' + hostUrl + ' ' + actionflowName);
                
                urlEvent.setParams({
                    "url":urlVal
                });
                urlEvent.fire();
                
            }
        });
        $A.enqueueAction(action); 
        
    },
})