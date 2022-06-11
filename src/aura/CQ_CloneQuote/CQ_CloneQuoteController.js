({
    doInit : function(component, event, helper){
        helper.fetchQuote(component, event);
    },
    
    handleCancel : function(component, event, helper){
        helper.cancelClone(component, event);
    },
    
    handleCloneSave : function(component, event, helper){
        var cloneValidated = helper.validateNext(component,event);
        if(cloneValidated)
            helper.handlefirstNext(component, event);
    },
    
    handleNext : function(component, event, helper){
        helper.handleSecondNext(component, event);
    },
    
    handleSave: function(component, event, helper){
        var conValidated = helper.validateSave(component,event);
        if(conValidated)
            helper.saveClone(component, event);
    },
    
    handleBack : function(component, event, helper){
        helper.firstBack(component, event);
    },
    
    handleSecondBack : function(component, event, helper){
        helper.SecondBack(component, event);
    },
    
    addNewRow: function(component, event, helper){
        helper.createObjectData(component, event);
    },
    
    addRow: function(component, event, helper){
        helper.createContactData(component, event);
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
    
    removeConRow:function(component, event, helper){
        var selectedItem = event.currentTarget;
        //Get the selected item index
        var index = selectedItem.dataset.record;
        var RowsList = component.get("v.contWraplist");
        RowsList.splice(index, 1);
        // set the contWraplist after remove selected row element  
        component.set("v.contWraplist", RowsList);
    },
    
    handleSerChange : function(component, event, helper){
        //Get the Selected values   
        var selectedValues = event.getParam("value");         
        //Update the Selected Values  
        component.set("v.selectedserlist", selectedValues);
    },
})