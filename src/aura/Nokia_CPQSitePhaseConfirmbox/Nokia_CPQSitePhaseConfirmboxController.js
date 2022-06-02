({
    handleConfirmDialogYes : function(component, event, helper) {
        console.log('Yes');
        component.set('v.showConfirmDialog', false);
    },
     
    handleConfirmDialogNo : function(component, event, helper) {
        console.log('No');
        window.history.back();
    },
    handleTostMessage : function(title,message,variant, event) {
        debugger;
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title:title,
            mode: 'sticky',
            message: message,
            type : variant
        });
        toastEvent.fire();
    },
})