({
    doInit : function(component, event, helper){
        helper.fetchQuote(component, event);
    },
    
    handleCancel : function(component, event, helper){
        helper.cancelRebid(component, event);
    },
    
    handleRebidSave : function(component, event, helper){
        //Validate for the required fields
        var rebidValidated = helper.validateSave(component,event);
        //Call save action
        if(rebidValidated)
            helper.saveRebid(component, event);
    },
    
    handleSerChange : function(component, event, helper){
        //Get the Selected values   
        var selectedValues = event.getParam("value");         
        //Update the Selected Values  
        component.set("v.selectedserlist", selectedValues);
    },
})