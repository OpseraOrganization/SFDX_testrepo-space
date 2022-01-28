({
    // Close the current tab that was created for editing or creating a workgroup instruction
    closeConsoleTAB: function(component) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
        }); 
       
    },
	
	//Open the Clone Record in a new tab
    openSubTab : function(component, lightningComp, recordId, title) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId()
        .then(function(tabId) {
            return workspaceAPI.openSubtab({
                parentTabId: tabId,
                recordId: recordId,
                pageReference: {
                    "type": "standard__component",
                    "attributes": {
                        "componentName": lightningComp
                    },
                    "state": {
                        "uid": "1",
                        "c__cloneRecordId": recordId,
                        "c__booleanEdit":"True" 
                    }
                },
                focus: true
                
            });
        })
        .then(function(response) {
            var focusedTabId = response;
            workspaceAPI.setTabLabel({
                tabId: focusedTabId,
                label: title
            });
        })
        .catch(function(error) {
            console.log(error);
        });
    },
	
	  // Search for Workgroup Instructions
    getWorkgroupInstructions: function(component,recrdId) {
        var promise = new Promise(function(resolve, reject) {
            const sharedjs = component.find("sharedJavaScript");
            resolve(
                sharedjs.apex(component, "getWorkgroupInstructionRecord", {
                    recordId: recrdId
                })
            );
        });
        return promise;
    },
})