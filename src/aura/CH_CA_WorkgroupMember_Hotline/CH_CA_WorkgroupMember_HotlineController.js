({
    doInit: function(component, event, helper) {
        helper.doInit(component, event, helper);
    },
    createHotlineMember : function(component, event, helper) {
        helper.createHotlineMember(component, event, helper);
    },
    showSpinner: function(component, event, helper) {
        component.set("v.Spinner", true); 
    },
    hideSpinner : function(component,event,helper){
        component.set("v.Spinner", false);
    },
    handleCancel: function(component,event,helper){
        helper.closeFocusedTab(component, event, helper);
    },
})