({
    doInit : function(component, event, helper) {
    },
    
    showPopUp : function(component, event, helper) {
        helper.fetchOwnersData(component,event,helper);
    },
    
    closeModel: function(component, event, helper) {
        component.set("v.isOpen", false);
    },
})