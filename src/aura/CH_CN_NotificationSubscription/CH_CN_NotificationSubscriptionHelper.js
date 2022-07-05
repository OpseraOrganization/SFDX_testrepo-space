({
    getRecordTypeName: function(component, recordTypeId){
        var promise = new Promise( function( resolve , reject ) {
            const sharedjs = component.find("sharedJavaScript");
            resolve(sharedjs.apex(component, 'getRecordTypeName',{ recordTypeId : recordTypeId, objectName : 'CH_NotificationSubscription__c'}));
        });           
        return promise; 
    },
    getDefaultRecordTypeName: function(component){
        var promise = new Promise( function( resolve , reject ) {
            const sharedjs = component.find("sharedJavaScript");
            resolve(sharedjs.apex(component, 'getDefaultRecordTypeName',{ objectName : 'CH_NotificationSubscription__c'}));
        });           
        return promise; 
    },
 /****************************************
* Name : getCustomSettingsForNotificationPerUser
* Description : this method is is used to check how many Notification Subscriptions allowed per user
* written on 6th Aug 2020
* By Afif Reja
* NOKIASC-29178
*****************************************/  
    getCustomSettingsForNotificationPerUser: function(component){
        var promise = new Promise( function( resolve , reject ) {
            const sharedjs = component.find("sharedJavaScript");
            resolve(sharedjs.apex(component, 'getCustomSettingsForNotificationPerUser',{}));
        });           
        return promise; 
    },
    showToast : function(type,title,message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : title,
            message: message,
            duration:'10000',
            key: 'info_alt',
            type: type,
            mode: 'dismissible'
        });
        toastEvent.fire();
    },
    //For Cancel button click close the current tab
    closeTab : function(component,event,helper) {          
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response,event) {
            var focusedTabId = response.tabId;                         
            workspaceAPI.closeTab({tabId: focusedTabId}).then(function(response,event) {
                console.log(response);
            })
        })
        .catch(function(error) {
            console.log(error);
        });                  
    },
})