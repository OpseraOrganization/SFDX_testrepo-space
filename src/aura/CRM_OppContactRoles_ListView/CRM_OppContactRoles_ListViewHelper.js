({
    initHelper :  function(component, event, helper, crIndex)
    {
        component.set("v.oppId", component.get("v.recordId"));
        var getListCall = component.get("c.getOppContactRolesApex");
        getListCall.setParams({
            "oppId": component.get("v.oppId")
        }); 
        getListCall.setCallback(this, function(response){
            console.log(response.getReturnValue());
            if(helper.checkSuccess(component, event, helper, response))
            {
                component.set("v.contactRoleWrapperList", response.getReturnValue().contactRoleWrapperList);
                component.set("v.contactRoleWrapperListBackup", JSON.parse(JSON.stringify(response.getReturnValue().contactRoleWrapperList)));
                component.set("v.uncontactActivityList", response.getReturnValue().uncontactActivities);
                component.set("v.accContactList", response.getReturnValue().accContactList);
                component.set("v.accContactListBackup", JSON.parse(JSON.stringify(response.getReturnValue().accContactList)));
                component.set("v.contactIdValuesMap", response.getReturnValue().contactIdValuesMap);
                component.set("v.rolePLV", helper.setPLV(response.getReturnValue().rolePLV));
                component.set("v.opinionPLV", helper.setPLV(response.getReturnValue().opinionPLV));
                component.set("v.engagementPLV", helper.setPLV(response.getReturnValue().engagementPLV));
                component.set("v.taskPriorityPLV", helper.setPLV(response.getReturnValue().taskPriorityPLV));
                component.set("v.taskStatusPLV", helper.setPLV(response.getReturnValue().taskStatusPLV));
       			component.set('v.today', helper.todaysDate());
                if(crIndex >= 0)
                {
                    var contactRoleList = component.get('v.contactRoleWrapperList');
                    contactRoleList[crIndex].showActivities = !contactRoleList[crIndex].showActivities;
                    component.set('v.contactRoleWrapperList', contactRoleList);
                }
            }
        });
        component.set('v.loaded', false);
        $A.enqueueAction(getListCall);
    },
    
    createContactRole : function(component, event, helper, crIndex) 
    {
        var contactRoleList = component.get("v.contactRoleWrapperList");
        var contactRole = {};
        contactRole['Id'] = null;
        contactRole['contactId'] = null;
        contactRole['oppId'] = component.get("v.oppId");
        contactRole['contactName'] = null;
        contactRole['role'] = null;
        contactRole['opinionOfNokia'] = null;
        contactRole['engagementLevel'] = null;
        contactRole['contactRole'];
        contactRole['contactAttitude'];
        contactRole['contactRole'];
        contactRole['contactActivities'] = [];
        contactRole['showActivities'] = false;
        contactRole['readMode'] = false;
        component.set("v.contactRoleWrapperList", [contactRole].concat(contactRoleList));
        return contactRole;
    },
    
    cancelContactRole : function(component, event, helper, crIndex) 
    {
        var contactRoleList = component.get('v.contactRoleWrapperList');
        var contactRoleRec = contactRoleList[crIndex];
        if(contactRoleList[crIndex].Id == null)
        {
            contactRoleList.splice(crIndex,1);
        }
        else
        {
        	contactRoleList[crIndex].readMode = true;
            var backupList = component.get("v.contactRoleWrapperListBackup");
            contactRoleList[crIndex] = JSON.parse(JSON.stringify(backupList[crIndex]));
        }
        component.set('v.contactRoleWrapperList', contactRoleList);
    },
    
    editContactRole : function(component, event, helper, crIndex) 
    {
        var contactRoleList = component.get('v.contactRoleWrapperList');
        var contactRoleRec = contactRoleList[crIndex];
        contactRoleList[crIndex].readMode = false;
        component.set('v.contactRoleWrapperList', contactRoleList);
    },
    
    deleteContactRole : function(component, event, helper, crIndex) 
    {
        var contactRoleList = component.get('v.contactRoleWrapperList');
        var contactRoleRec = contactRoleList[crIndex];
        if(helper.validateContactRole(component, event, helper,contactRoleRec, 'delete'))
        {
            var deleteCRCall= component.get("c.deleteContactRoleApex");
            deleteCRCall.setParams({
                "contactRoleWrapper": contactRoleRec                 
            });
            deleteCRCall.setCallback(this, function(response){
                if(helper.checkSuccess(component, event, helper, response))
            	{ 
                    contactRoleList.splice(crIndex, 1);
                    component.set("v.contactRoleWrapperList", contactRoleList);
                    component.set("v.contactRoleWrapperListBackup", JSON.parse(JSON.stringify(contactRoleList)));  
                }
                component.set('v.loaded', true);
            }); 
            component.set('v.loaded', false);
            $A.enqueueAction(deleteCRCall);
        }
    },
    
    saveContactRole : function(component, event, helper, crIndex) 
    {
        var contactRoleList = component.get('v.contactRoleWrapperList');
        var contactRoleRec = contactRoleList[crIndex]; 
        if(helper.validateContactRole(component, event, helper,contactRoleRec, 'save'))
        {
            var saveCRCall= component.get("c.saveContactRoleApex");
            saveCRCall.setParams({
                "contactRoleWrapper": contactRoleRec                 
            });
            saveCRCall.setCallback(this, function(response){
                if(helper.checkSuccess(component, event, helper, response))
                {
                    contactRoleList[crIndex] = response.getReturnValue();//ReadMode set in the apex controller
                    component.set("v.contactRoleWrapperList", contactRoleList);
                	component.set("v.contactRoleWrapperListBackup", JSON.parse(JSON.stringify(contactRoleList)));
                }
                component.set('v.loaded', true);
            });
            component.set('v.loaded', false);
            $A.enqueueAction(saveCRCall);
        }
    },
    
    createTask : function(component, event, helper, crIndex) 
    {
        var taskRec = {}
        taskRec['Subject'] = '';
        taskRec['OwnerId'] = $A.get("$SObjectType.CurrentUser.Id");
        taskRec['Status'] = 'Open';
        taskRec['ActivityDate'] = null;
        taskRec['Description'] = ''; 
        taskRec['ReminderDateTime'] = null;
        taskRec['IsReminderSet'] = false;
        taskRec['Priority'] = null;
        taskRec['WhatId'] = component.get("v.oppId");
        
        var contactRoleList = component.get('v.contactRoleWrapperList');
        if(crIndex >= 0)//Task for a contact
        {
            var contactRoleRec = contactRoleList[crIndex];
        	taskRec['WhoId'] = contactRoleRec.contactId;
        	taskRec['ContactName'] = contactRoleRec.contactName;
            component.set("v.crIndexToCreateTask", crIndex);
        }
        component.set("v.taskToModal",taskRec);
    },
    
    editTask : function(component, event, helper, crIndex, caIndex) 
    {
        var taskRec;
        if(crIndex >= 0)//Task from a contact
        {
            var contactRoleList = component.get('v.contactRoleWrapperList');
            var contactRoleRec = contactRoleList[crIndex];
            taskRec = contactRoleRec.contactActivities[caIndex];
            component.set("v.crIndexToCreateTask", crIndex);
        }
        else//Task without related contact
        {
            var uncontactActivities = component.get('v.uncontactActivityList');
            taskRec = uncontactActivities[caIndex];
        }
        component.set("v.taskToModal",taskRec);
    },
    
    finishEditCreateAction : function(component, event, helper) 
    {
        var taskToSave = component.get("v.taskToModal");
        var crIndex= component.get("v.crIndexToCreateTask");
        var createEditTaskCall= component.get("c.updateCreateTaskApex");
        if(helper.validateTaskFields(component, event, helper,taskToSave, 'save'))
        {
            createEditTaskCall.setParams({
                "task": taskToSave                 
            });
            createEditTaskCall.setCallback(this, function(response){
                if(helper.checkSuccess(component, event, helper, response))
                {
                    helper.initHelper(component, event, helper, crIndex);
                    helper.closeModal(component, event, helper);
            		component.set("v.crIndexToCreateTask", -1);
                }
            }); 
            component.set('v.loaded', false);
            $A.enqueueAction(createEditTaskCall);
        }
    },
        
    deleteTask : function(component, event, helper, crIndex, caIndex) 
    {
        var contactRoleList = component.get('v.contactRoleWrapperList');
        var uncontactActivities = component.get('v.uncontactActivityList');
        var activityRec;
        if(crIndex < 0)
        {
            activityRec = uncontactActivities[caIndex];
        }
        else
        {
            var contactRoleRec = contactRoleList[crIndex];
            activityRec = contactRoleRec.contactActivities[caIndex];
        }
        if(helper.validateTaskFields(component, event, helper,activityRec, 'delete'))
        {
            var deleteActivityCall= component.get("c.deleteActivityApex");
            deleteActivityCall.setParams({
                "task": activityRec                 
            });
            deleteActivityCall.setCallback(this, function(response){
                if(helper.checkSuccess(component, event, helper, response))
                {
                    if(crIndex < 0)
                    {
                        uncontactActivities.splice(caIndex,1);
                        component.set("v.uncontactActivityList", uncontactActivities);
                    }
                    else
                    {
                        contactRoleList[crIndex].contactActivities.splice(caIndex,1);
                        component.set("v.contactRoleWrapperList", contactRoleList);
                    }
                }
            }); 
            component.set('v.loaded', false);
            $A.enqueueAction(deleteActivityCall); 
        }
    },
	
    confirmDeletionPopup : function(component, event, helper, crIndex, caIndex)
    {
        component.set('v.deleteConfirmation', true);
        component.set('v.crIndexToDelete', crIndex);
        component.set('v.caIndexToDelete', caIndex);
        if(caIndex > -1)//Task
        {
            component.set('v.warningTitle', "Delete Opportunity Task");
            component.set('v.warningMessage', "Are you sure you want to delete this Task?");
        }
        else//Contact Role
        {
            component.set('v.warningTitle', "Delete Opportunity Contact Role");
            component.set('v.warningMessage', "Are you sure you want to delete this opportunity Contact Role?");
        }
    },
    
    closeModal : function(component, event, helper) 
    {
        component.set("v.taskToModal",null);
    },
    
	checkSuccess : function(component, event, helper, response) 
    {
        var success;
        component.set('v.loaded', true);
        if(typeof response.getReturnValue().errorMessage === 'undefined' || typeof response.getReturnValue().errorMessage == '')
        {
            console.log("Success message: " + response.getReturnValue().successMessage);
            helper.showSuccessToast(component, event, helper, response.getReturnValue().successMessage);
            success = true;
        }
        else
        {
            success = false;
            helper.showErrorToast(component, event, helper, response.getReturnValue().errorMessage);
            console.log("Apex error: " + response.getReturnValue().errorMessage);
        }
        return success;
	},
	
    getContactDetails : function(component, event, helper,contactId, wrapperIndex) 
    {
        var apexCall= component.get("c.getContactDetailsApex");
        apexCall.setParams({
            "contactId": contactId                 
        });
        apexCall.setCallback(this, function(response){
            if(helper.checkSuccess(component, event, helper, response))
            {
                var contactRec = response.getReturnValue();
                helper.addDetailsToList(component, event, helper, contactRec, wrapperIndex);
            }
        }); 
        $A.enqueueAction(apexCall);
    },
    
    addDetailsToList : function(component, event, helper, contactRec, wrapperIndex) 
    {
        var contactIdValuesMap = component.get('v.contactIdValuesMap');
        var contactRoleList = component.get('v.contactRoleWrapperList');
        var contactRoleListBackup = component.get('v.contactRoleWrapperListBackup');
        
        contactRoleList[wrapperIndex].contactAttitude = contactRec.Attitude__c;
        contactRoleList[wrapperIndex].contactRole = contactRec.Purchasing_Role_Sales__c;
        contactRoleList[wrapperIndex].accName = contactRec.AccName__c;
        contactRoleList[wrapperIndex].role = contactRec.Purchasing_Role_Sales__c;
        contactRoleList[wrapperIndex].opinionOfNokia = contactRec.Attitude__c;
        component.set('v.contactRoleWrapperList', contactRoleList);
        
        if(contactRoleListBackup.length > 0)
        {
            contactRoleListBackup[wrapperIndex].contactAttitude = contactRec.Attitude__c;
            contactRoleListBackup[wrapperIndex].contactRole = contactRec.Purchasing_Role_Sales__c;
            contactRoleListBackup[wrapperIndex].accName = contactRec.AccName__c;
            component.set("v.contactRoleWrapperListBackup", JSON.parse(JSON.stringify(contactRoleListBackup))); 
        }
        
        var contactId = contactRoleList[wrapperIndex].contactId;
        if(typeof contactIdValuesMap[contactId] != 'undefined' && contactIdValuesMap[contactId] != '' && contactIdValuesMap[contactId] != null )
        {
            contactIdValuesMap[contactId] = contactRec;
        	component.set('v.contactIdValuesMap', contactIdValuesMap);
        } 
    },
        
    showSuccessToast : function(component, event, helper, message)
    {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Successs Message',
            message: message,
            duration:' 3000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester'
        });
        toastEvent.fire();
    },
    
    showErrorToast : function(component, event, helper, message)
    {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Error Message',
            message:message,
            duration:'5000',
            key: 'info_alt',
            type: 'error',
            mode: 'pester'
        });
        toastEvent.fire();
    },
    
    setPLV : function(result)
    {
        var fieldMap = [];
        for(var key in result){
            fieldMap.push({key: key, value: result[key]});
        }
        return fieldMap
    },
        
    todaysDate: function()
    {
        var today = new Date();
        var dd = String(today.getDate()).padStart(2, '0');
        var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
        var yyyy = today.getFullYear();
        today = mm + '/' + dd + '/' + yyyy;
        return today
    },
    
    validateTaskFields: function(component, event, helper, taskToSave, action)
    {
        var validSave = true;
        if(action=='save')
        {
            if(typeof taskToSave['Subject'] === 'undefined' || taskToSave['Subject'] == null ||taskToSave['Subject'] == '' )
            {
                helper.showErrorToast(component, event, helper, 'Subject field is mandatory.');
                validSave = false;
            }
            else if(typeof taskToSave['Description'] === 'undefined' || taskToSave['Description'] == null || taskToSave['Description'] == '' )
            {
                helper.showErrorToast(component, event, helper, 'Comments field is mandatory.');
                validSave = false;
            }
            else if(typeof taskToSave['Status'] === 'undefined' || taskToSave['Status'] == null || taskToSave['Status'] == '' )
            {
                helper.showErrorToast(component, event, helper, 'Status field is mandatory.');
                validSave = false;
            }
            else if(typeof taskToSave['Priority'] === 'undefined' || taskToSave['Priority'] == null || taskToSave['Priority'] == '' )
            {
                helper.showErrorToast(component, event, helper, 'Priority field is mandatory.');
                validSave = false;
            }
            else if(typeof taskToSave['OwnerId'] === 'undefined' || taskToSave['OwnerId'] == null || taskToSave['OwnerId'] == '' )
            {
                helper.showErrorToast(component, event, helper, 'Owner field is mandatory.');
                validSave = false;
            }
        }
        
        if(action=='delete')
        {
            if(taskToSave['OwnerId'] != $A.get("$SObjectType.CurrentUser.Id") )
            {
                helper.showErrorToast(component, event, helper, 'You cannot delete a task if you are not its owner.');
                validSave = false;
            }
        }
        return validSave;
    },

    validateContactRole: function(component, event, helper, contactRoleRec, action)
    {
        var validSave = true;
        if(action=='delete')
        {
            var contactRoleList = component.get('v.contactRoleWrapperList');
            var contactCounter = 0;
            for(var i = 0; i < contactRoleList.length; i++)
            {
                if(contactRoleList[i].contactId == contactRoleRec.contactId)
                {
                    contactCounter++;
                }   
            }
            if(contactCounter == 1)
            {
                var contactActivities = contactRoleRec.contactActivities;
                for(var i = 0; i < contactActivities.length; i++)
                {
                    if(contactActivities[i].Status == 'Open')
                    {
                        validSave = false;
                        helper.showErrorToast(component, event, helper, 'You cannot delete a contact if it relates to any open Task.');
                        break;
                    }
                }                
            }
        }
        return validSave
    }
})