({
	doInit : function(component, event, helper){
        helper.fetchAccount(component, event);
    },
    handleSave: function(component, event, helper){
        var conValidated = helper.validateSave(component,event);
        if(conValidated)
            helper.saveContact(component, event);
    },
    handleCancel : function(component, event, helper){
        helper.cancelContact(component, event);
    },
    addRow: function(component, event, helper){
        helper.createContactData(component, event);
    },
    removeConRow:function(component, event, helper){
        var selectedItem = event.currentTarget;
        //Get the selected item index
        var index = selectedItem.dataset.record;
        var RowsList = component.get("v.contWraplist");
        RowsList.splice(index, 1);
        // set the contWraplist after remove selected row element  
        component.set("v.contWraplist", RowsList);
    },
})