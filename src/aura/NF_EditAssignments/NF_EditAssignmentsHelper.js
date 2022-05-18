({
    getL1Territories : function(component) {
        var action = component.get("c.returnL1Territories"); 
        action.setCallback(this, function(response) {             
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
            }            
            component.set("v.TerritoryL_1", storeResponse);
            if(storeResponse.length > 0)
            {
                component.set("v.showRecalculateAssignments", true);
            }
        });
        $A.enqueueAction(action);
    },
    
    getL2ToL7Territories : function(component) {
        var action = component.get("c.returnL2toL7Territories"); 
        action.setCallback(this, function(response) {             
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
            }            
            component.set("v.TerritoryL2ToL7", storeResponse);            
        });
        $A.enqueueAction(action);
    },
    
    getPermissionset : function(component) {
        var action = component.get("c.getPermissionset");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                var storeResponse = response.getReturnValue();
            }
            
            component.set("v.permission", storeResponse);
        });
        $A.enqueueAction(action);
    },
    
    checkPSRObuttonAccess : function(component) {
        var action = component.get("c.checkAccessToRunPSROBatch");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                var response = response.getReturnValue();
            	component.set("v.showRecalculatePSROPSA", response);
            }
        });
        $A.enqueueAction(action);
    },
    
    getChildTerritoryHelper : function(component,event) {
        var territoryParentId =  event.getSource().get("v.value");               
        var cmpAttribute =  event.getSource().get("v.label"); 
        var parentAttribute = cmpAttribute.concat("Parent");                       
        component.set(parentAttribute,territoryParentId);   
        var territoryL2toL7List = component.get("v.TerritoryL2ToL7");
        
        var directChildTerritoryList = [];
        
        for(var territory = 0; territory < territoryL2toL7List.length; territory++)
        {
            if(territoryL2toL7List[territory].ParentTerritory2Id == territoryParentId)
            {
                directChildTerritoryList.push(territoryL2toL7List[territory]);
            }                
        }
        directChildTerritoryList.sort(function(a, b){
            var nameA=a.Name.toLowerCase(), nameB=b.Name.toLowerCase()
            if (nameA < nameB) 
                return -1 
                if (nameA > nameB)
                    return 1
                    return 0 
        })
        
        component.set(cmpAttribute,directChildTerritoryList);
    },
    clearChildTerritoryHelper : function(component,event) {
        var emptyArray = [];
        var cmpAttribute =  event.getSource().get("v.label");
        var splitLevel=cmpAttribute.split("_");
        for(var level=splitLevel[1];level<7; level++)
        {
            component.set("v.TerritoryL_"+[level],emptyArray);
        }
        
    },
    
    
    
    /*  getHistoryList: function(component) {
        var action = component.get('c.getDetails');
        
        var self = this;
        action.setCallback(this, function(actionResult) {
            component.set('v.histories', actionResult.getReturnValue());
            
        });
        $A.enqueueAction(action);
    },*/
    DisableButton_event: function(component,event) 
    {
              var UnAssign_salesRoleList=[];
        var AssignsalesRoleList = component.get("v.Assign_salesRoleList");
        
        if(AssignsalesRoleList!=null && AssignsalesRoleList!=undefined && AssignsalesRoleList!='')
        {
            for (var indexVr = 0; indexVr < AssignsalesRoleList.length; indexVr++) {
                if(AssignsalesRoleList[indexVr].usercheck==null ||(AssignsalesRoleList[indexVr].usercheck!=null&&AssignsalesRoleList[indexVr].SalesRoleObj.User__c!=AssignsalesRoleList[indexVr].usercheck.Id))
                {
                    UnAssign_salesRoleList.push( AssignsalesRoleList[indexVr] );
                }
            }
        }
        
        if(UnAssign_salesRoleList==null || UnAssign_salesRoleList==undefined|| UnAssign_salesRoleList=='')
        {
          var  UnAssign_salesRole = component.get("v.UnAssign_salesRoleList");
             if(UnAssign_salesRole!=null && UnAssign_salesRole!=undefined&& UnAssign_salesRole!='')

            {
                        for (var indexr = 0; indexr < UnAssign_salesRole.length; indexr++) {
                         
                               if((UnAssign_salesRole[indexr].usercheck!=null&&UnAssign_salesRole[indexr].SalesRoleObj!=null&&UnAssign_salesRole[indexr].SalesRoleObj.User__c!=UnAssign_salesRole[indexr].usercheck.Id)|| (UnAssign_salesRole[indexr].usercheck==null&&UnAssign_salesRole[indexr].SalesRoleObj!=null) || (UnAssign_salesRole[indexr].usercheck!=null&&UnAssign_salesRole[indexr].SalesRoleObj==null)) 
                               {
                                   UnAssign_salesRoleList.push(UnAssign_salesRole[indexr])
                               }
                        }
            }

        }
        
        if(UnAssign_salesRoleList!=null&&UnAssign_salesRoleList!=undefined&&UnAssign_salesRoleList!='')
        {
                                  component.set('v.Disable_Edit',false);
        }
        else{
             component.set('v.Disable_Edit',true);  
        }
        
        return UnAssign_salesRoleList;
    },
   
    FrozenUserCheck : function(component) {
        var action = component.get("c.FrozenUSerCheck");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                var storeResponse = response.getReturnValue();
            }
            component.set("v.ISfrozenusercheck", storeResponse);
        });
        $A.enqueueAction(action);
    },
     onchangeAS_Select: function(component, event) {  
        var source=event.getSource();
        var auraId = source.getLocalId(); 
        if(auraId == 'Select_ASvalue'){
            var childCmp = component.find("Selectedrolevalue");
            childCmp.clearRole(); 
        }
        if(auraId == 'Select_AS_value'){
             var childCmp = component.find("SelectedRole_NAme");
             if(childCmp!=null&&childCmp!=undefined&&childCmp!='')
        {
            
            for (var i = 0; i < childCmp.length; i++) {
                  childCmp[i].clearRole();
            }
            if(childCmp.length==undefined)childCmp.clearRole();
        }
        }
        component.set('v.SelectedASVAlue',source.get("v.value"));
    },
    Assign_Salesrole : function(component,event) 
    {
        var  SalesroleData = component.get("v.salesroleUserList_type");
        var userNameobject = component.get("v.selectedUserLookUpRecord");
        var isfrozen;
        if(userNameobject!=null ||userNameobject!=undefined)
            {
              var userisactive=userNameobject.IsActive;
             var  ISfrozenusercheck = component.get("v.ISfrozenusercheck");
             isfrozen= ISfrozenusercheck[userNameobject.Id];
            }
        if(userisactive==false ||isfrozen==true)
        {
            
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "warning",
                "title": "warning",
                "duration":"5000",
                "message": "Selected User "+userNameobject.Name+" is Inactive/frozen ",
                "mode":"dismissible",
            });
            toastEvent.fire();
            
        }
        var save_true = component.get("v.Save_new");
        component.set("v.IsSpinner",true);
        var action = component.get("c.savesales_roleUser");
        action.setParams({
            "savesales_role": SalesroleData,
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set("v.IsSpinner",false);
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "Success",
                    "title": "Success",
                    "duration":"5000",
                    "message": "The record has been created successfully.",
                    "mode":"dismissible",
                });
                toastEvent.fire();
                component.set('v.assignModalFlag',false);  
                var emptyArray = [];
                var Salesroleorg='';
                if(save_true==true)Salesroleorg=SalesroleData.Organisation__c;
                var newsalesrole={'sobjectType': 'Sales_Role__c',
                                  'BG__c': '',
                                  'User__c': '',
                                  'Role_Name__c': '',
                                  'Organisation__c':Salesroleorg,
                                 };
                 component.set ("v.selectedUserLookUpRecord",null);
                component.set ("v.salesroleUserList_type", newsalesrole);
                component.set ("v.SelectedBglist", emptyArray);
                component.set('v.requiredbg',false);
                component.set('v.disabledBg',true);
                component.set('v.SelectedASVAlue','');
                component.set('v.assignModalFlag',save_true);
               
                
                
            }
            else if(state === "ERROR"){
                var   errors = response.getError();
                var errorpgmsg=[];
                errorpgmsg=errors[0].pageErrors[0].message;
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "error",
                    "title": "Error",
                    "duration":"5000",
                    "message": errorpgmsg,
                    "mode":"dismissible",
                });
                toastEvent.fire();
                component.set('v.assignModalFlag',true);
            }
        });
        $A.enqueueAction(action);
    },
    
    Assign_Bgattribute : function(component,event) 
    {
        var selectedroleNameFromEvent = event.getParam("selectedroleName");
        var selectedterritoryFromEvent = event.getParam("selectedterritory");
        var selectedBg=selectedroleNameFromEvent.BG_Attribute__c ;
        
        if(selectedBg!=null)
        {   var splitbg=selectedBg.split(";");
         component.set('v.SelectedBglist',splitbg);
         component.set('v.disabledBg',false);
         component.set('v.requiredbg',true);
        }
        else{    
            var empty=[]; 
            component.set('v.requiredbg',false);
            component.set('v.disabledBg',true);
            component.set('v.SelectedBglist',empty);
            component.set('v.bg_empty','');
            component.set('v.salesroleUserList_type.BG__c','');
        }
    },
    
  
    getSalesRoleUserInfo : function(component,event, helper, page, recordToDisply) 
    {            
        component.set('v.Disable_Edit',true);
        component.set("v.Coloringval",false);
        var empty=[];
        var userName=null;
        var roleName=null;
        var assignCheck = component.get("v.assignCheck");
        var selectedOrg = component.find("salesroleorganisation").get('v.value');
        var selected_AS = component.find("Select_ASvalue").get('v.value');
        var roleNameobject = component.get("v.selectLookUpRec");
        if(roleNameobject!=null &&roleNameobject!=undefined)roleName=roleNameobject.Role_name__c;
        if(assignCheck==true)var userNameobject = component.get("v.selectedUserLookUpRecord");
        if(userNameobject!=null &&userNameobject!=undefined)userName=userNameobject.Name;
        var bg = component.get("v.bg_empty");
        var levelCheck = component.get("v.currentLevel");
        var permssionCheck = component.get("v.permission");
        if(selected_AS=="")selected_AS=null;
        
        component.set("v.IsSpinner",true);
        component.set ("v.UnAssign_salesRoleDUP", empty);
        component.set ("v.listItems", empty);
        
        if(roleName == undefined) bg = '';
        
        var self = this;

        var action = component.get("c.returnsaleroleuser_Info");
        action.setParams({
            'pageNumber':page,
            'recordToDisply':recordToDisply,
            "assigned" : assignCheck,
            "org": selectedOrg,
            "userName": userName,
            "BG": bg,
            "Rolename": roleName,
            "level": levelCheck,
            "ASValue": selected_AS,
            
        });
        window.setTimeout(function() {
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            component.set("v.IsSpinner",false);
            if (state === "SUCCESS") {
                
                if(levelCheck==true)component.set('v.Alllevel',true);
                if(levelCheck==false)component.set('v.Alllevel',false);
                
                var result = response.getReturnValue();
                if(assignCheck==true)
                {
                    component.set('v.UnAssign_salesRoleList',empty);
                    if(result!=null &&result!=undefined &&result!='')
                    {
                        if(result.SalesRolewrapperlist!=null &&result.SalesRolewrapperlist!=undefined&&result.SalesRolewrapperlist!=''){
                            component.set('v.H_Level_L2',result.l2);
                             component.set('v.H_Level_L3',result.l3);
                             component.set('v.H_Level_L4',result.l4);
                             component.set('v.H_Level_L5',result.l5);
                             component.set('v.H_Level_L6',result.l6);
                             component.set('v.H_Level_L7',result.l7);
                            component.set('v.Assign_true',true);
                            component.set("v.page", result.page);
                            component.set("v.total", result.total);
                            component.set("v.pages", Math.ceil(result.total / recordToDisply));
                            component.set('v.Assign_salesRoleList',result.SalesRolewrapperlist); 
                            component.set('v.disableUser',false);
                            component.set("v.Coloringval",true);

                        }
                    }
                } 
                if(assignCheck==false)
                {  
                   //alert('results.SalesRolewrapperlist++>'+result.SalesRolewrapperlist.length);

                    component.set('v.Assign_salesRoleList',empty);
                    if(result!=null &&result!=undefined &&result!='')
                    {  
                        if(result.SalesRolewrapperlist!=null &&result.SalesRolewrapperlist!=undefined&&result.SalesRolewrapperlist!=''){
                             component.set('v.H_Level_L2',result.l2);
                             component.set('v.H_Level_L3',result.l3);
                             component.set('v.H_Level_L4',result.l4);
                             component.set('v.H_Level_L5',result.l5);
                             component.set('v.H_Level_L6',result.l6);
                             component.set('v.H_Level_L7',result.l7);
                             //alert('result.SalesRolewrapperlist++>'+result.SalesRolewrapperlist.length);
                            component.set ("v.UnAssign_salesRoleDUP", result.wrapper_list);
                            component.set('v.Unassign_true',true);
                            component.set("v.Least_level_Hierarchy", result.LeastLevel);
                            component.set("v.UnAssign_salesmaP", result.Salesrolemap);
                           // component.set('v.ISfrozenusercheck',result.isFrozenuser);
                            component.set("v.page", result.page);
                            component.set("v.total", result.total);
                            component.set("v.pages", Math.ceil(result.total / recordToDisply));
                            component.set('v.UnAssign_salesRoleList',result.SalesRolewrapperlist);
                            component.set('v.disableUser',true);
                            component.set("v.Coloringval",true);
                           self.coloring_Listfind(component,event);
                        }
                    }
                }
            }
            else if(state === "ERROR"){
                var   errors = response.getError();
                var errorpgmsg=[];
                errorpgmsg=errors[0].pageErrors[0].message;
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "error",
                    "title": "Error",
                    "duration":"5000",
                    "message": errorpgmsg,
                    "mode":"dismissible",
                });
                toastEvent.fire();
                component.set('v.roleViewModalFlag',true);
            }
        });

        }),5000
        $A.enqueueAction(action);

    },
    
     coloring_Listfind : function(component,event) 
    {  
        var  User_AssigenedList=[];
        var  User_AssigenedListval=[];
        var  UnAssign_salesRoleList = component.get("v.UnAssign_salesRoleList");
        var  UnAssign_salesmaP = component.get("v.UnAssign_salesmaP");
        var  ISfrozenusercheck = component.get("v.ISfrozenusercheck");
        var  UnAssign_salesmainlist = component.get("v.UnAssign_salesRoleDUP");
        var  Least_level = component.get("v.Least_level_Hierarchy");
        var selectedwrap = event.getParam("wrapperObject");

        if(selectedwrap!=null){
        for (var indexVvr = 0; indexVvr < UnAssign_salesmainlist.length; indexVvr++) {
            if(selectedwrap.Organisation==UnAssign_salesmainlist[indexVvr].Organisation)
            {
                UnAssign_salesmainlist.splice( indexVvr, 1 );
                UnAssign_salesmainlist.splice( indexVvr, 0,selectedwrap );  
            }
        } 
        }
        
        for (var indexVar = 0; indexVar <UnAssign_salesRoleList.length; indexVar++) {	
            if(UnAssign_salesRoleList[indexVar].IWAFlag.A_S__c==true){
                if (UnAssign_salesRoleList[indexVar].usercheck!=null) 
                {    var isfrozen= ISfrozenusercheck[UnAssign_salesRoleList[indexVar].usercheck.Id];
                    if(isfrozen==undefined&&UnAssign_salesRoleList[indexVar].usercheck.IsActive==true&&((!UnAssign_salesRoleList[indexVar].Organisation.includes('NSA')) ||(UnAssign_salesRoleList[indexVar].Organisation.includes('NSA')&&UnAssign_salesRoleList[indexVar].usercheck.NSA_Compliant__c==true)))
                    {
                        User_AssigenedList.push(UnAssign_salesRoleList[indexVar].Organisation)
                    }
                }}}
        
        
        for (var indexVvar = 0; indexVvar < UnAssign_salesmainlist.length; indexVvar++) {
            if(UnAssign_salesmainlist[indexVvar].IWAFlag.A_S__c==true){
                if (UnAssign_salesmainlist[indexVvar].usercheck!=null) 
                { 
                    var isfrozen= ISfrozenusercheck[UnAssign_salesmainlist[indexVvar].usercheck.Id];
                    if(isfrozen==undefined&&UnAssign_salesmainlist[indexVvar].usercheck.IsActive==true&&((!UnAssign_salesmainlist[indexVvar].Organisation.includes('NSA')) ||(UnAssign_salesmainlist[indexVvar].Organisation.includes('NSA')&&UnAssign_salesmainlist[indexVvar].usercheck.NSA_Compliant__c==true)))
                    {
                        User_AssigenedList.push(UnAssign_salesmainlist[indexVvar].Organisation)
                    }
                }
              var Coloringg_org = UnAssign_salesmaP[UnAssign_salesmainlist[indexVvar].Organisation];  
              if(Coloringg_org!=null&&Coloringg_org!=undefined&&Coloringg_org!='')
                    {
                        if(Coloringg_org.Hierarchy_Level__c == Least_level)
                        {   
                      if(!User_AssigenedListval.includes(Coloringg_org))User_AssigenedListval.push(Coloringg_org)
                        }
                    }
        }
        }     
        
        var OrgColorSet=[];
        if(User_AssigenedListval!=null&&User_AssigenedListval!=undefined&&User_AssigenedListval!='')
        {
           for (var indexVr = 0; indexVr < User_AssigenedListval.length; indexVr++) {	
                        if(User_AssigenedListval[indexVr].Hierarchy_Level__c == Least_level)
                        {
                            if(User_AssigenedListval[indexVr].Hierarchy_Level__c=='L2'||User_AssigenedListval[indexVr].Hierarchy_Level__c=='L3' ||User_AssigenedListval[indexVr].Hierarchy_Level__c=='L4' ||User_AssigenedListval[indexVr].Hierarchy_Level__c=='L5' ||User_AssigenedListval[indexVr].Hierarchy_Level__c=='L6'||User_AssigenedListval[indexVr].Hierarchy_Level__c=='L7')
                                var OrgNAme= User_AssigenedListval[indexVr].Name; 
                            
                            if(User_AssigenedListval[indexVr].Hierarchy_Level__c=='L3' ||User_AssigenedListval[indexVr].Hierarchy_Level__c=='L4' ||User_AssigenedListval[indexVr].Hierarchy_Level__c=='L5' ||User_AssigenedListval[indexVr].Hierarchy_Level__c=='L6'||User_AssigenedListval[indexVr].Hierarchy_Level__c=='L7')
                                var Org_par_NAme= User_AssigenedListval[indexVr].ParentTerritory2.Name; 
                            
                            if(User_AssigenedListval[indexVr].Hierarchy_Level__c=='L4' ||User_AssigenedListval[indexVr].Hierarchy_Level__c=='L5' ||User_AssigenedListval[indexVr].Hierarchy_Level__c=='L6'||User_AssigenedListval[indexVr].Hierarchy_Level__c=='L7')
                                var Org_par_par_NAme= User_AssigenedListval[indexVr].ParentTerritory2.ParentTerritory2.Name; 
                            
                            if(User_AssigenedListval[indexVr].Hierarchy_Level__c=='L5' ||User_AssigenedListval[indexVr].Hierarchy_Level__c=='L6'||User_AssigenedListval[indexVr].Hierarchy_Level__c=='L7')
                                var Org_par_par_parNAme= User_AssigenedListval[indexVr].ParentTerritory2.ParentTerritory2.ParentTerritory2.Name; 
                           
                            if(!(User_AssigenedList.includes(OrgNAme) || User_AssigenedList.includes(Org_par_NAme) || User_AssigenedList.includes(Org_par_par_NAme) || User_AssigenedList.includes(Org_par_par_parNAme)))
                            {   
                                if(OrgNAme!=null&&OrgNAme!=undefined&&OrgNAme!=''&&!OrgColorSet.includes(OrgNAme))OrgColorSet.push(OrgNAme);
                                if(Org_par_NAme!=null&&Org_par_NAme!=undefined&&Org_par_NAme!=''&&!OrgColorSet.includes(Org_par_NAme))OrgColorSet.push(Org_par_NAme);
                                if(Org_par_par_NAme!=null&&Org_par_par_NAme!=undefined&&Org_par_par_NAme!=''&&!OrgColorSet.includes(Org_par_par_NAme))OrgColorSet.push(Org_par_par_NAme);
                                if(Org_par_par_parNAme!=null&&Org_par_par_parNAme!=undefined&&Org_par_par_parNAme!=''&&!OrgColorSet.includes(Org_par_par_parNAme))OrgColorSet.push(Org_par_par_parNAme);
                            }
                        }}
          //alert('OrgColorSet++>'+JSON.stringify(OrgColorSet));
            component.set('v.listItems',OrgColorSet);
        }
        
        var childCmp = component.find("AUraifvaluecontains");
        if(childCmp!=null&&childCmp!=undefined&&childCmp!='')
        {
            
            for (var i = 0; i < childCmp.length; i++) {
                  childCmp[i].Againif();
            }
            if(childCmp.length==undefined)childCmp.Againif();
        }
    },
   validateRoleUser : function(component, event) 
    {
        var userName='user';
        var assignCheck = component.get("v.assignCheck");
        var isValid = true;
        var roleName = null;
		var errormessage=null;
		 var Store_NullValue=[];
		 var userNamedup = component.get("v.Searchval_user");
		var roleNamedup = component.get("v.Searchval_Rolename");
        var roleNameobject = component.get("v.selectLookUpRec");
		 var SalesroleData = component.get("v.salesroleUserList_type");
         var levelCheck = component.get("v.currentLevel");
         var BgValue = component.get("v.SelectedBglist");
         var assignModalFlag = component.get("v.assignModalFlag");
         var roleViewModalFlag = component.get("v.roleViewModalFlag");
        var AssignsalesRoleList = component.get("v.Assign_salesRoleList");
    
        if(roleNameobject!=null ||roleNameobject!=undefined)roleName=roleNameobject.Role_name__c;
        if(assignCheck==true)userName = component.get("v.selectedUserLookUpRecord");
        else
            userName='user';
        
       
        var BgValues='' ;
       
        if (BgValue === undefined || BgValue.length == 0)
        {   
            BgValues='emptyvalue';
        }
        else{
            if(roleViewModalFlag==true)BgValues=component.get("v.bg_empty");
			if(assignModalFlag==true) BgValues=SalesroleData.BG__c;
        }
		 
        if(errormessage==null || errormessage==undefined || errormessage=='')
        {   
            var setofusers=[];
            if(AssignsalesRoleList==null || AssignsalesRoleList==undefined || AssignsalesRoleList=='')
            {
                AssignsalesRoleList= component.get("v.UnAssign_salesRoleList");
            }
        if(AssignsalesRoleList!=null && AssignsalesRoleList!=undefined && AssignsalesRoleList!='')
                 {
                   for (var indexVr = 0; indexVr < AssignsalesRoleList.length; indexVr++) {	
                        if(AssignsalesRoleList[indexVr].usersearch!=null)
                               {
                                  setofusers.push(AssignsalesRoleList[indexVr].Organisation); 
                               }
                           }
                   }
     if(setofusers!=null && setofusers!=undefined && setofusers!='')
         {
       if(setofusers.length==1) 
            errormessage="Invalid username is entered  ";
             else
             errormessage="Invalid usernames are entered";
         }
    }

        
        if(errormessage==null || errormessage==undefined || errormessage=='')
		{
		 if(userNamedup!=null &&userNamedup!=undefined &&userNamedup!='')Store_NullValue.push("UserName "+"'"+userNamedup+"'");
         if(roleNamedup!=null &&roleNamedup!=undefined &&roleNamedup!='')Store_NullValue.push("RoleName "+"'"+roleNamedup+"'");
		 if(Store_NullValue!=null && Store_NullValue!=undefined && Store_NullValue!='')errormessage='Invalid type '+Store_NullValue +' is entered';
       }
        
        if(assignModalFlag==true){
		if(errormessage==null || errormessage==undefined || errormessage=='')  {
        if (SalesroleData.Role_Name__c=='' || SalesroleData.User__c==''|| BgValues=='' ||BgValues=='empty')
        {  
            if(SalesroleData.Role_Name__c=='')Store_NullValue.push("RoleName");
            if(SalesroleData.User__c=='')Store_NullValue.push("User");
            if(BgValues==''|| BgValues=='empty')Store_NullValue.push("BgAttribute");
        if(Store_NullValue!=null && Store_NullValue!=undefined && Store_NullValue!='') errormessage= "Required fields are missing : "+Store_NullValue;
        }}}
		
         if(roleViewModalFlag==true){
		if(errormessage==null || errormessage==undefined || errormessage=='')
		{
        if((roleName == null&& userName =='user')  || BgValues=='' || BgValues=='empty' )
        {
            if(roleName==null &&userName=='user')Store_NullValue.push("RoleName");
            if(BgValues==''|| BgValues=='empty')Store_NullValue.push("BG Attribute");
            errormessage= Store_NullValue+" field cannot be blank";
        }}}
        
        
		if(errormessage!=null&&errormessage!=undefined&&errormessage!=''){
			isValid = false;
		 var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "duration":"5000",
                "message":errormessage,
                "mode":"dismissible",
            });
            toastEvent.fire();
	}
        return isValid;
    },
    
    nsaCheck : function(component, event) 
    {
        var nsa = event.getSource().get("v.value");
        if(nsa.includes("NSA")) 
        {
            component.set("v.nsa_check",true);
        }
    },
})