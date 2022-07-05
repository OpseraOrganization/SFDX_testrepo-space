({
    doInit : function(component, event, helper) {
        for(var i = 0 ; i< 6 ; i++){
            helper.createObjectData(component, event);
        }
    },
    
    addNewRow: function(component, event, helper){
        helper.createObjectData(component, event);
    },
    
    removeRow:function(component, event, helper){
        var selectedItem = event.currentTarget;
        //Get the selected item index
        var index = selectedItem.dataset.record;
        var AllRowsList = component.get("v.teamWraplist");
        AllRowsList.splice(index, 1);
        // set the teamWraplist after remove selected row element  
        component.set("v.teamWraplist", AllRowsList);
    },
    
    handleCancel : function(component, event, helper){
        helper.cancelQT(component, event);
    },
    
    handleSave : function(component, event, helper){
        helper.saveQuoteTeam(component, event);
    },
})