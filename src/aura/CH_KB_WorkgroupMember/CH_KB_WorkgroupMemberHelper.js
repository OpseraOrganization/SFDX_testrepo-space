({
    // Close the current tab that was created for editing or creating a workgroup member
    closeConsoleTAB: function(component) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
        });  
    },
    // Get the user information
    getUserName: function(component, userId){
        //alert('getUserName');
        var promise = new Promise( function( resolve , reject ) {
        	const sharedjs = component.find("sharedJavaScript");
        	resolve(sharedjs.apex(component, 'getUserName',{ userId : userId}));
        });           
        return promise; 
    },
})