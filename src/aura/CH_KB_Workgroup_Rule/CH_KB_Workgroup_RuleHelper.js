({
    // Close the current tab that was created for editing or creating a workgroup member
    closeConsoleTAB: function(component) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
        });  
    },
})