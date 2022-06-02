({
	init : function(component, event, helper)
    {   
        helper.initHelper(component, event, helper);
    },
    
    handleCompMenu : function(component, event, helper)
    {   
        var parcedValue;
        if(typeof event.getParam("value") != 'undefined'  )
        {
            parcedValue = event.getParam("value").split(','); //for lightning:menuItem
        }
        else
        {
           parcedValue = event.getSource().get("v.value").split(','); //for lightning:buttonIcon
        }
        var action = parcedValue[0];
        var compIndex = parseInt(parcedValue[1]);
        
        switch(action) 
        {
            case "edit": helper.editCompetitor(component, event, helper, compIndex); break;
            case "cancel": helper.cancelCompetitor(component, event, helper, compIndex); break;
            case "save": helper.saveCompetitor(component, event, helper, compIndex); break;
            case "delete": helper.confirmDeletionPopup(component, event, helper, compIndex); break;
        }
    },
    
    handleCreateCompetitor : function(component,event,helper)
    {
        helper.createCompetitor(component, event, helper);
    },
    
    /*Delete Confirmation popup*/    
    handleCancelDeletion : function(component, event, helper)
    {
        component.set('v.deleteConfirmation', false);
        component.set('v.compIndexToDelete', -1);
    },
    
    handleConfirmDeletion : function(component, event, helper)
    {
        var compIndex = component.get('v.compIndexToDelete');
        helper.deleteCompetitor(component, event, helper, compIndex);
        component.set('v.deleteConfirmation', false);
        component.set('v.compIndexIndexToDelete', -1);
    },
    
    /*Notes and Comments*/
    handleEditReadNotes : function(component, event, helper)
    {
        var readOnlyNotesComp = component.get('v.readOnlyNotesComp');
        component.set('v.readOnlyNotesComp', !readOnlyNotesComp);
    },
    
    handleNotesSuccesss : function(component, event, helper)
    {
        component.set('v.readOnlyNotesComp', true);
        component.set('v.loaded', true);
    },
    
    handleNotesSubmit : function(component, event, helper)
    {
        var competitorList = component.get('v.competitorWrapperList');
        var commentsValue = component.get('v.comments');
        var contactCounter = 0;
        var canSubmit = true;
        if(commentsValue == '' || commentsValue == null)
        {
            for(var i = 0; i < competitorList.length; i++)
            {
                var weaknessList = competitorList[i]['weakness'];
                var strengthList = competitorList[i]['strength'];
                if( weaknessList.includes('Other + Comment*') || strengthList.includes('Other + Comment*') )
                {
                    helper.showErrorToast(component, event, helper, 'Please fill "Comments on Competitive Analysis"');
                    component.set('v.readOnlyNotesComp', false);
                    canSubmit = false
                }   
            }
        }
        if(canSubmit)
        {
            helper.updateComments(component, event, helper, component.get("v.oppId"), commentsValue);
        } 
    }
})