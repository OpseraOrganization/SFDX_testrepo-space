({
	closeConsoleTAB: function(component,param) {      
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
           //console.log('Current TAB ID: ' +focusedTabId);
            workspaceAPI.closeTab({tabId: focusedTabId});
           
                var refreshParentTab=response.parentTabId;
           // comsole.log('Parent TAB ID: ' +refreshParentTab);
                workspaceAPI.refreshTab({
                    tabId: refreshParentTab                   
                });
                
        })
        .catch(function(error) {
            console.log("CH_CA:closeConsoleTAB Error:"+ error);
        });
    },
})