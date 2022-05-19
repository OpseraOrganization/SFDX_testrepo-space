({
	init : function(component, event, helper)
    {   
        helper.initHelper(component, event, helper, -1);
    },
    
    handleCRMenu : function(component, event, helper)
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
        var crIndex = parseInt(parcedValue[1]);
        
        switch(action) 
        {
            case "edit": helper.editContactRole(component, event, helper, crIndex); break;
            case "cancel": helper.cancelContactRole(component, event, helper, crIndex); break;
            case "save": helper.saveContactRole(component, event, helper, crIndex); break;
            case "delete": helper.confirmDeletionPopup(component, event, helper, crIndex, -1); break;
            case "createTask": helper.createTask(component, event, helper, crIndex); break;
        }
    },
    
    handleCAMenu : function(component, event, helper)
    {   
        var parcedValue = event.getParam("value").split(',');
        var action = parcedValue[0];
        var crIndex = parseInt(parcedValue[1]);
        var caIndex = parseInt(parcedValue[2]);
        switch(action) 
        {
            case "edit": helper.editTask(component, event, helper, crIndex, caIndex); break;
            case "delete": helper.confirmDeletionPopup(component, event, helper, crIndex, caIndex); break;
        }
    },
    
    showHideActions : function(component,event,helper)
    {
        var crIndex = parseInt(event.getSource().get('v.value'));
        var contactRoleList = component.get('v.contactRoleWrapperList');
        contactRoleList[crIndex].showActivities = !contactRoleList[crIndex].showActivities;
        component.set('v.contactRoleWrapperList', contactRoleList);
    },
    
    handleCreateContactRole : function(component,event,helper)
    {
        helper.createContactRole(component, event, helper);
    },
    
    /*Task Creation popup*/
    handleCreateTask : function(component,event,helper)
    {
        helper.createTask(component, event, helper, -1);
    },
    
    handleSubmitTask : function(component,event,helper)
    {
        helper.finishEditCreateAction(component,event,helper);
    },
    
    handleCancelTask : function(component,event,helper)
    {
        helper.closeModal(component,event,helper);
    },
    
    /*Delete Confirmation popup*/    
    handleCancelDeletion : function(component, event, helper)
    {
        component.set('v.deleteConfirmation', false);
        component.set('v.crIndexToDelete', -1);
        component.set('v.caIndexToDelete', -1);
        component.set('v.warningTitle', "");
        component.set('v.warningMessage', "");
        
    },
    
    handleConfirmDeletion : function(component, event, helper)
    {
        var crIndex = component.get('v.crIndexToDelete');
        var caIndex = component.get('v.caIndexToDelete');
        if(caIndex < 0)
        {
        	helper.deleteContactRole(component, event, helper, crIndex);
        }
        else
        {
            helper.deleteTask(component, event, helper, crIndex, caIndex)
        }
        component.set('v.deleteConfirmation', false);
        component.set('v.crIndexToDelete', -1);
        component.set('v.caIndexToDelete', -1);
        component.set('v.warningTitle', "");
        component.set('v.warningMessage', "");
    },
	
	/*Updating Opinion of Nokia on contact change*/
    handleContactChange : function(component,event,helper)
    {
        var eventMessage = event.getParam("message");
        var crIndex = event.getParam("indexOnList");
        var contactRoleList = component.get('v.contactRoleWrapperList');
        var contactIdValuesMap = component.get('v.contactIdValuesMap');
        var contactId = contactRoleList[crIndex].contactId;
        if( typeof contactId != 'undefined' && contactId != '' && contactId != null)
        {
            if(typeof contactIdValuesMap[contactId] != 'undefined' && contactIdValuesMap[contactId] != '' && contactIdValuesMap[contactId] != null )
            {
                helper.addDetailsToList(component, event, helper, contactIdValuesMap[contactId], crIndex);
            }
            else
            {
                helper.getContactDetails(component, event, helper,contactId, crIndex);
            }
        }
        else
        {
            contactRoleList[crIndex].contactAttitude = '';
            contactRoleList[crIndex].contactRole = '';
            contactRoleList[crIndex].accName = '';
        	component.set("v.contactRoleWrapperList", contactRoleList);
        }
    }
})