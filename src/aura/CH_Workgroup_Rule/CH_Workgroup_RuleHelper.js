({
    getRecordTypeName: function(component, recordTypeId){
        var promise = new Promise( function( resolve , reject ) {
            const sharedjs = component.find("sharedJavaScript");
            resolve(sharedjs.apex(component, 'getRecordTypeName',{ recordTypeId : recordTypeId, objectName : 'CH_Workgroup_Rule__c'}));
        });           
        return promise; 
    },
    getDefaultRecordTypeName: function(component){
        var promise = new Promise( function( resolve , reject ) {
            const sharedjs = component.find("sharedJavaScript");
            resolve(sharedjs.apex(component, 'getDefaultRecordTypeName',{ objectName : 'CH_Workgroup_Rule__c'}));
        });           
        return promise; 
    },
	 //Get the RecordtypeId for the Workgroup rule record
    getwrkRecordTypeName: function(component){
        var promise = new Promise( function( resolve , reject ) {
            const sharedjs = component.find("sharedJavaScript");
            resolve(sharedjs.apex(component, 'getRecrdTypeName',{ RecordId : component.get("v.recordId")}));
        });           
        return promise; 
    },
	
	// Close the current tab that was created for editing or creating a workgroup rule
    closeConsoleTAB: function(component) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
        });  
    },
})