({
	initHelper :  function(component, event, helper)
    {
        component.set("v.oppId", component.get("v.recordId"));
        var getListCall = component.get("c.getOppCompetitorsApex");
        getListCall.setParams({
            "oppId": component.get("v.oppId")
        }); 
        getListCall.setCallback(this, function(response){
            console.log(response.getReturnValue());
            if(helper.checkSuccess(component, event, helper, response))
            {
                var orderedWrapperList = helper.reorderWrapperList(component, event, helper, response.getReturnValue().competitorWrapperList);
                component.set("v.competitorWrapperList", orderedWrapperList);
                component.set("v.competitorWrapperListBackup", JSON.parse(JSON.stringify(orderedWrapperList)));
                component.set("v.competitorWeaknessPLV", helper.setMultiPLV(response.getReturnValue().competitorWeaknessPLV));
                component.set("v.competitorStrengthPLV", helper.setMultiPLV(response.getReturnValue().competitorStrengthPLV));
                component.set("v.competitorPLV", helper.setPLV(response.getReturnValue().competitorPLV));
                component.set("v.comments", response.getReturnValue().comments);
            }
        });
        component.set('v.loaded', false);
        $A.enqueueAction(getListCall);
    },
    
    createCompetitor : function(component, event, helper, crIndex) 
    {
        var competitorList = component.get("v.competitorWrapperList");
        var competitorRec = {};
        competitorRec['Id'] = null;
        competitorRec['name'] = null;
        competitorRec['oppId'] = component.get("v.oppId");
        competitorRec['strength'] = null;
        competitorRec['weakness'] = null;
        competitorRec['primary'] = false;
        competitorRec['readMode'] = false;
        competitorRec['nokiaCompetitor'] = false;
        var newcompetitorList = [competitorRec].concat(competitorList);
        component.set("v.competitorWrapperList", helper.reorderWrapperList(component, event, helper, newcompetitorList));
    },
    
    cancelCompetitor : function(component, event, helper, index) 
    {
        var recordList = component.get('v.competitorWrapperList');
        if(recordList[index].Id == null)
        {
            recordList.splice(index,1);
        }
        else
        {
            var backupList = component.get("v.competitorWrapperListBackup");
            recordList[index] = backupList[index];
        	recordList[index].readMode = true;
            
        }
        component.set('v.competitorWrapperList', recordList);
    },
    
    editCompetitor : function(component, event, helper, index) 
    {
        var recordList = component.get('v.competitorWrapperList');
        var record = recordList[index];
        recordList[index].readMode = false;
        component.set('v.competitorWrapperList', recordList);
    },
    
    deleteCompetitor : function(component, event, helper, index) 
    {
        var recordList = component.get('v.competitorWrapperList');
        var record = recordList[index];     
        var deleteCall= component.get("c.deleteCompetitorApex");
        deleteCall.setParams({
            "competitorWrapper": record                 
        });
        deleteCall.setCallback(this, function(response){
            if(helper.checkSuccess(component, event, helper, response))
            { 
                recordList.splice(index, 1);
        		component.set("v.competitorWrapperList", recordList);
        		component.set("v.competitorWrapperListBackup", JSON.parse(JSON.stringify(recordList)));                
            }
            component.set('v.loaded', true);
        }); 
        component.set('v.loaded', false);
        $A.enqueueAction(deleteCall);
    },
    
    saveCompetitor : function(component, event, helper, index) 
    {
        var recordList = component.get('v.competitorWrapperList');
        var record = recordList[index]; 
        
        if(helper.validateCompetitor(component, event, helper, record, 'save'))
        {
            var saveCompCall= component.get("c.saveCompetitorApex");
            saveCompCall.setParams({
                "competitorWrapper": record                 
            });
            saveCompCall.setCallback(this, function(response){
                if(helper.checkSuccess(component, event, helper, response))
                {
                    var newRec = response.getReturnValue();
                    //Logic to uncheck any existing primary competitor if the updated one was checked.
                    var oldRec = recordList[index];
                    if( (newRec['primary'] == true) )
                    {
                        recordList = helper.uncheckCurrPrimary(component, event, helper, recordList);
                    }
                    recordList[index] = newRec;
                    component.set("v.competitorWrapperList", recordList);
                    component.set("v.competitorWrapperListBackup", JSON.parse(JSON.stringify(recordList)));
                }
                component.set('v.loaded', true);
            });
            component.set('v.loaded', false);
            $A.enqueueAction(saveCompCall);
        }
    },
    
    updateComments : function(component, event, helper, oppId, comments) 
    {
        var commentsCall= component.get("c.updateCommentsApex");
        commentsCall.setParams({
            "comments": comments,
            "oppId": oppId     
        });
        commentsCall.setCallback(this, function(response){
            helper.checkSuccess(component, event, helper, response);
            component.set('v.loaded', true);
            component.set('v.readOnlyNotesComp', true);
        }); 
        component.set('v.loaded', false);
        $A.enqueueAction(commentsCall);
    },
    
    confirmDeletionPopup : function(component, event, helper, index)
    {
        component.set('v.deleteConfirmation', true);
        component.set('v.compIndexToDelete', index);
    }, 
    
    uncheckCurrPrimary : function(component, event, helper, recordList)
    {
        for(var i = 0; i < recordList.length;  i++)
        {
            recordList[i].primary = false;
        }
        return recordList;
    },
    
    reorderWrapperList : function(component, event, helper, wrapperToReorder)
    {
        var nokiaCompetitorIndex = -1;
        var nokiaCompetitor = null;
        var orderedList;
        for(var i = 0; i < wrapperToReorder.length; i++)
        {
            if($A.get("$Label.c.CRM_Nokia_Competitor_Name") == wrapperToReorder[i].name )
            {
                nokiaCompetitorIndex = i;
                break;
            }
        }
        if(nokiaCompetitorIndex > -1)
        {
            nokiaCompetitor = JSON.parse(JSON.stringify(wrapperToReorder[nokiaCompetitorIndex]));
            wrapperToReorder.splice(nokiaCompetitorIndex, 1);
            wrapperToReorder = [nokiaCompetitor].concat(wrapperToReorder);
        }
		return wrapperToReorder;
    },
    
    validateCompetitor: function(component, event, helper, competitorRec, action)
    {
        var validSave = true;
        var competitorList = component.get('v.contactRoleWrapperList');
        if(action=='save')
        {
            if( typeof competitorRec.name === 'undefined' || competitorRec.name == '' || competitorRec.name == null)
            {
                helper.showErrorToast(component, event, helper, 'Competitor name is a mandatory field.');
                validSave = false;
            }
            var commentsValue = component.get('v.comments');
            if( (commentsValue == '' || commentsValue == null) && ( ( competitorRec.weakness != null && competitorRec.weakness.includes('Other + Comment*')) || ( competitorRec.strength != null && competitorRec.strength.includes('Other + Comment*')) ) )
            {
                helper.showErrorToast(component, event, helper, 'Please fill "Comments on Competitive Analysis"');
                validSave = false;
                component.set('v.readOnlyNotesComp', false);
            }
        }
        return validSave
    },
    
	checkSuccess : function(component, event, helper, response) 
    {
        var success;
        component.set('v.loaded', true);
        if(typeof response.getReturnValue().errorMessage === 'undefined' || response.getReturnValue().errorMessage == '' || response.getReturnValue().errorMessage == null)
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
    
    showSuccessToast : function(component, event, helper, message)
    {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Successs Message',
            message: message,
            duration:' 3000',
            key: 'info_alt',
            type: 'success',
            mode: 'sticky'
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
        return fieldMap;
    },
    
    setMultiPLV : function(result)
    {
        var fieldMap = [];
        for(var key in result){
            fieldMap.push({label: result[key], value: key});
        }
        return fieldMap;
    }
})