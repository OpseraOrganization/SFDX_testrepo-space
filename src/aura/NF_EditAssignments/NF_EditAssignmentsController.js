({
    doInit : function(component, event, helper) {
        helper.getL1Territories(component);
        helper.getL2ToL7Territories(component);
        helper.getPermissionset(component);
        helper.checkPSRObuttonAccess(component);
    },
    
    
    gotoListView : function (component, event, helper) {
        
        console.log('gotoListView');
        var navEvent = $A.get("$Label.c.ChangeHistoryURL");
        
        window.open(navEvent,"_blank");
        
    },
   	
    recalculatePSROAssignments : function (component, event, helper) 
    {
        var action = component.get("c.runBatchForAssignments"); 
        action.setCallback(this, function(response) { 
			console.log('inside...');            
            var state = response.getState();
            var message;
            if (state === "SUCCESS") {
				console.log('success...');         
                message = 'Batch to recalculate PSRO cost visibilities permission set assignment is running. You will be notified once the job is completed.';     
            }
            else
            {
				console.log('error...');  
                message = 'An error has occured'
            }
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "warning",
                "title": "INFO:",
                "duration":"10000",
                "message": message,
                "mode":"dismissible",
            });
            toastEvent.fire();
        });
        $A.enqueueAction(action);
    },
    
    getChildTerritory : function(component, event, helper) { 
        var source=event.getSource();
        
        if(source.get("v.title") === 'false')
        {  
            var idval= event.getSource().getLocalId();
            var getAllId = component.find(idval);
            
            for (var i = 0; i < getAllId.length; i++) {
                if (getAllId[i].get("v.title") == 'true') 
                {
                    getAllId[i].set("v.title",'false');
                }
            }
            helper.getChildTerritoryHelper(component, event); 
            source.set('v.title','true');             
        }        
        else
        {
            helper.clearChildTerritoryHelper(component, event);
            source.set('v.title','false'); 
        }
    },

    assignController :  function(component, event, helper) {
        component.set('v.assignModalFlag',true);
        component.set('v.salesroleUserList_type.Organisation__c', event.getSource().get("v.value"));
        helper.FrozenUserCheck(component, event);
    },

    ClosesalesroleModal:  function(component, event, helper) {
        component.set('v.assignModalFlag',false);
        var emptyArray = [];
        var newsalesrole={'sobjectType': 'Sales_Role__c',
                          'BG__c': '',
                          'User__c': '',
                          'Role_Name__c': '',
                          'Organisation__c':'',};
        component.set ("v.salesroleUserList_type", newsalesrole);
        component.set ("v.SelectedBglist", emptyArray);
        component.set('v.requiredbg',false);
        component.set('v.disabledBg',true);
        component.set('v.SelectedASVAlue','');
        component.set ("v.selectedUserLookUpRecord",null);
        component.set ("v.Searchval_user", null);
        component.set ("v.Searchval_Rolename", null);
        

    },
    
    save_and_new_salesrole :  function(component, event, helper) {
        
        if (helper.validateRoleUser(component, event)){
            component.set('v.Save_new',true);
            helper.Assign_Salesrole(component, event); 
        }
    },
    save_salesrole :  function(component, event, helper) {
        if (helper.validateRoleUser(component, event)){
            component.set('v.Save_new',false);
            helper.Assign_Salesrole(component, event); 
        }
    },
    Bgatrributechange :  function(component, event, helper) {
        helper.Assign_Bgattribute(component, event); 
    },
    
    
    onchangeASValue : function(component,event,helper)
    {   
        helper.onchangeAS_Select(component, event);
    },
    RoleView : function(component,event,helper)
    {
        //alert('Edit Assignmentss');
        component.set('v.roleViewModalFlag',true);
        component.set('v.SelectedOrg', event.getSource().get("v.value"));
        helper.nsaCheck(component, event);
             helper.FrozenUserCheck(component, event);

    },
    closeviewmodal :  function(component,event,helper)
    {
        // alert('Close Assignments');
        var empty=[];
        component.set('v.roleViewModalFlag',false);
        component.set('v.salesRoleList',empty);
        component.set ("v.selectedUserLookUpRecord",null);
        component.set ("v.selectLookUpRec", null);
        component.set ("v.SelectedBglist", empty);
        component.set ("v.Assign_salesRoleList", empty);
        component.set ("v.UnAssign_salesRoleList", empty);
        component.set ("v.UnAssign_salesRoleDUP", empty);
        component.set ("v.Searchval_user", null);
        component.set ("v.Searchval_Rolename", null);
        component.set('v.currentLevel',true);
        component.set('v.assignCheck',true);
        component.set('v.bg_empty','empty');
        component.set('v.disableUser',false);
        component.set('v.Disable_Edit',true);
        component.set('v.Assign_true',false);
        component.set('v.Alllevel',true);
        component.set('v.Unassign_true',false);
        component.set("v.nsa_check",false);
        component.set("v.Coloringval",false);
        component.set('v.Recordvalue',"100");
       component.set('v.SelectedASVAlue','');  
    },
    onSearch : function(component,event,helper){
        var emptyArray = [];
        component.set('v.Disable_Edit',true);
        component.set('v.UnAssign_salesRoleList',emptyArray);
        component.set('v.Assign_salesRoleList',emptyArray);
        component.set('v.Unassign_true',false);
        component.set('v.Assign_true',false);
        if(helper.validateRoleUser(component, event)){
                var page = 1;
                var recordToDisply = component.get("v.Recordvalue");
                helper.getSalesRoleUserInfo(component,event, helper, page,recordToDisply);
        }
    },
    
    navigate: function(component, event, helper) {
        var emptyArray = [];
        var page = component.get("v.page") || 1;
        var direction = event.getSource().get("v.label");
        var recordToDisply =component.get("v.Recordvalue");
        page = direction === "Previous Page |" ? (page - 1) : (page + 1);
        component.set('v.Assign_salesRoleList',emptyArray); 
        component.set('v.UnAssign_salesRoleList',emptyArray); 
         component.set ("v.UnAssign_salesRoleDUP", emptyArray);
         component.set ("v.listItems", emptyArray);
         component.set('v.Assign_true',false);
        component.set('v.Unassign_true',false);
         component.set('v.Disable_Edit',true);
         if(helper.validateRoleUser(component, event)){
        helper.getSalesRoleUserInfo(component,event, helper, page, recordToDisply);
         }
    },
    onSelectChange: function(component, event, helper) {
        var emptyArray = [];
        var page = 1
        var recordToDisply =component.get("v.Recordvalue");
         if(helper.validateRoleUser(component, event)){
        helper.getSalesRoleUserInfo(component,event, helper, page, recordToDisply);
         }
        component.set('v.UnAssign_salesRoleList',emptyArray); 
        component.set('v.Assign_salesRoleList',emptyArray); 
         component.set ("v.UnAssign_salesRoleDUP", emptyArray);
         component.set ("v.listItems", emptyArray);
    },
    assignClicked : function(component,event,helper)
    {
        component.set('v.assignCheck',true);
        component.set('v.disableUser',false);
        component.set('v.Recordvalue',"100");
        
    },
    
    unAssignClicked : function(component,event,helper)
    {
        component.set('v.Recordvalue',"50");
        component.set ("v.selectedUserLookUpRecord",null);
        component.set('v.assignCheck',false);
        var childCmp = component.find("userlookup");
        childCmp.clearuser(); 
        component.set('v.disableUser',true);
    },
    currentLevel : function(component,event,helper)
    {
        component.set('v.currentLevel',true);
    },
    allLevel : function(component,event,helper)
    {
        component.set('v.currentLevel',false);
    },
    ColoringList : function(component,event,helper)
    {
     var Coloringval = component.get("v.Coloringval");
       if(Coloringval==true)
        {
        var assignCheck = component.get("v.assignCheck");
       helper.DisableButton_event(component, event)
   if(assignCheck==false)helper.coloring_Listfind(component, event);
        }
    },
    
   
    saveModalCheck : function(component,event,helper)
    {
        var assignCheck = component.get("v.assignCheck");
        var UnAssign_salesRoleList=[];
     if(helper.validateRoleUser(component, event)){
         UnAssign_salesRoleList=helper.DisableButton_event(component, event);
     }
        var Inactive_User=[];
        var  ISfrozenusercheck = component.get("v.ISfrozenusercheck");
        if(UnAssign_salesRoleList!=null&&UnAssign_salesRoleList!=undefined&&UnAssign_salesRoleList!='')
        {
            for (var indexVar = 0; indexVar < UnAssign_salesRoleList.length; indexVar++) {
                
                if (UnAssign_salesRoleList[indexVar].usercheck!=null)
                {
                   var  isfrozen= ISfrozenusercheck[UnAssign_salesRoleList[indexVar].usercheck.Id];
                    if(isfrozen==true&&!Inactive_User.includes((UnAssign_salesRoleList[indexVar].usercheck.Name))){
                                                    Inactive_User.push(UnAssign_salesRoleList[indexVar].usercheck.Name)
                    }
                    if (UnAssign_salesRoleList[indexVar].usercheck.IsActive==false&& !Inactive_User.includes((UnAssign_salesRoleList[indexVar].usercheck.Name)))
                    {
                        if((UnAssign_salesRoleList[indexVar].SalesRoleObj!=null&&UnAssign_salesRoleList[indexVar].SalesRoleObj.User__c!=UnAssign_salesRoleList[indexVar].usercheck.Id) || UnAssign_salesRoleList[indexVar].SalesRoleObj==null)
                        {
                            Inactive_User.push(UnAssign_salesRoleList[indexVar].usercheck.Name)
                        }
                        
                    }
                }  
            } 
        }
        
        if(Inactive_User!=null&&Inactive_User!='')
       {           
           var Message='';
            if(Inactive_User.length==1) 
            Message="The selected user "+Inactive_User+" is inactive/frozen";
             else
             Message="The selected users "+Inactive_User+" are inactive/frozen";
        
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "warning",
                "title": "warning",
                "duration":"5000",
                "message": Message,
                "mode":"dismissible",
            });
            toastEvent.fire();
        } 
        
        if(UnAssign_salesRoleList!=null&&UnAssign_salesRoleList!=undefined&&UnAssign_salesRoleList!='')
        { 
            var action = component.get("c.saveListsalesroleUser");
            action.setParams({
                "ListsalesroleUser":  JSON.stringify(UnAssign_salesRoleList),
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                var emptyArray = [];
                if (state === "SUCCESS") {
                    component.set("v.Assign_salesRoleList",emptyArray);
                    component.set("v.UnAssign_salesRoleList",emptyArray);
                    component.set('v.Unassign_true',false);
                    component.set('v.Assign_true',false);
                      component.set('v.Disable_Edit',true);
                    var assignCheck = component.get("v.assignCheck");
                    if(assignCheck=true)component.set('v.disableUser',false);
                    if(assignCheck=false)component.set('v.disableUser',true);
                    
                        var page = component.get("v.page") || 1;
                        var recordToDisply = component.get("v.Recordvalue");  
                    if(helper.validateRoleUser(component, event)){
                        helper.getSalesRoleUserInfo(component,event, helper, page,recordToDisply);
                    }
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "Success",
                        "title": "Success",
                        "duration":"5000",
                        "message": "The record has been created/updated/deleted successfully.",
                        "mode":"dismissible",
                    });
                    toastEvent.fire();
                 
                    //component.set('v.Disable_Edit',true);
                  //  component.set('v.Disable_delete',false);
                   // component.set('v.DeletedUserlist',emptyArray);
                }
                else if(state === "ERROR"){
                    var   errors = response.getError();
                    var errorpgmsg=[];
                    errorpgmsg=errors[0].pageErrors[0].message;
                    if(errorpgmsg.includes('entity is deleted'))
                   errorpgmsg='The current salesrole list has been modified by another user. Please refresh the current list.';
                        
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "error",
                        "title": "Error",
                        "duration":"5000",
                        "message": errorpgmsg,
                        "mode":"dismissible",
                    });
                    toastEvent.fire();
                    if(assignCheck==false)component.set('v.disableUser',true);
                    if(assignCheck==true)component.set('v.disableUser',false);
                    component.set('v.roleViewModalFlag',true);
                }
            });
            $A.enqueueAction(action);
            
        }
        
    },
    
    cancelModalCheck : function(component,event,helper)
    {   
          var emptyArray=[];
                  component.set("v.Assign_salesRoleList",emptyArray);
                    component.set("v.UnAssign_salesRoleList",emptyArray);
                    component.set('v.Unassign_true',false);
                    component.set('v.Assign_true',false);
                     component.set('v.Disable_Edit',true);
                     var assignCheck = component.get("v.assignCheck");
                    if(assignCheck=true)component.set('v.disableUser',false);
                    if(assignCheck=false)component.set('v.disableUser',true);
                    
                        var page = component.get("v.page") || 1;
                        var recordToDisply = component.get("v.Recordvalue");
         if(helper.validateRoleUser(component, event)){
                          helper.getSalesRoleUserInfo(component,event, helper, page, recordToDisply);
         }
        
    },
    
})