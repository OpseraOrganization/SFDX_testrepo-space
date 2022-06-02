({
    doInit: function(component, event, helper) {
        helper.doInit(component, event, helper);
    },
    createUserMember : function(component, event, helper) {
        helper.createUserMember(component, event, helper);
    },
    showSpinner: function(component, event, helper) {
        component.set("v.Spinner", true); 
    },
    hideSpinner : function(component,event,helper){
        component.set("v.Spinner", false);
    },
    handleCancel: function(component,event,helper){
        var getWgId = helper.getJsonFromUrl().id;
        helper.closeFocusedTab(component, event, helper);
    },
})