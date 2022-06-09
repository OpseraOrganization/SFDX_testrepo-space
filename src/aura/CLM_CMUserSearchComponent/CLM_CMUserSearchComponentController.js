({
    doInit : function(component, event, helper) {
        component.set("v.spinner",true);
        component.set('v.columns', [
            {label: 'Title', fieldName: 'Title', type: 'text'},
            {label: 'User name', fieldName: 'Name', type: 'text'},
            {label: 'Market', fieldName: 'Market__c', type: 'text'},
            {label: 'Country', fieldName: 'Country__c', type: 'text'}
            
            
        ]);
        helper.getUsersList(component, event, helper);
    },
    selectedAgreement: function (component, event) {
        var selectedRows = event.getParam('selectedRows');
        component.set("v.userRecd",selectedRows);
        component.set("v.enableButton",false);
    },
    createAgreementTeam: function (component, event, helper) {
        component.set("v.spinner",true);
        helper.createAgreementTeam(component, event, helper);
    },
    /*closeModel: function (component, event) {
        var url = window.location.href; 
        var value = url.substr(0,url.lastIndexOf('/') + 1);
        window.history.back();
        return false;
    },*/
    cancel: function (component, event) {
        sforce.one.navigateToSObject(component.get("v.recordId"));
        
    },
    
    
})