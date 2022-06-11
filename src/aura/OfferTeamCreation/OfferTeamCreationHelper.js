({
    // fetch picklist values dynamic from apex controller 
    fetchPickListVal: function(component) {
        var actionTeamMemberRole = component.get("c.getAllTeamMemberRole");
        
        //console.log('Checking Team member Roles......');  
        actionTeamMemberRole.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                
                var teamMembers = [];
                var teammemberList = [];
                teamMembers = response.getReturnValue();
                teammemberList.push({ "class": "optionClass", label: "--None--", value: "--None--" });
                //teammemberList.push({value:'--None--', key:'--None--'});
                for (var key in teamMembers ) {
                    teammemberList.push({"class": "optionClass",label:key, value:teamMembers[key]});
                }
                component.set("v.teamMemberRoles", teammemberList);
                
            } else {
                console.log('Problem getting Team member Roles, response state: ' + state);
            }
        });
        $A.enqueueAction(actionTeamMemberRole);
        
		
		 var actionTeamMemberRoleMap = component.get("c.getAllTeamMemberRoleMap");
        
        //console.log('Checking Team member Roles......');  
        actionTeamMemberRoleMap.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.teamRoleMap", response.getReturnValue());
                
            } else {
                console.log('Problem getting Team member Roles, response state: ' + state);
            }
        });
        $A.enqueueAction(actionTeamMemberRoleMap);
		
        //get lead BG
        var actionLeadBG = component.get("c.getAllLeadBGOfOfferTeam");
        
        //console.log('Checking Team member Roles......');  
        actionLeadBG.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var bgs = [];               
                var bgList = [];
                bgs = response.getReturnValue();
                bgList.push({value:'--None--', key:'--None--'});
                for (var key in bgs ) {
                    bgList.push({value:bgs[key], key:key});
                }
                component.set("v.leadBGs", bgList);
                
            } else {
                console.log('Problem getting Team member Roles, response state: ' + state);
            }
        });
        $A.enqueueAction(actionLeadBG);
        
        var actionAdditionalTeamMemberRole = component.get("c.getAllAdditionalTeamMemberRole");      
        //console.log('Checking Team member Roles......');  
        actionAdditionalTeamMemberRole.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var alreadySelected  = component.get("v.singleRec.additionalTeamRole");
                
                var additionalTeamMembers = [];
                var additionalTeamMemberList = [];
                var test1 = [];
                additionalTeamMembers = response.getReturnValue();
                //console.log('additionalTeamMembers--------------: '+ JSON.stringify(additionalTeamMembers));
                //additionalTeamMemberList.push({value:'--None--', label:'--None--'});
                test1.push({value:'--None--', selected:false});
                for (var key in additionalTeamMembers ) {
                    additionalTeamMemberList.push({value:additionalTeamMembers[key], label:key});
                    //additionalTeamMemberList.push(additionalTeamMembers[key]);
                    //test1.push({value:additionalTeamMembers[key], selected:false});
                    /*console.log('alreadySelected'+alreadySelected);
                    if(alreadySelected != undefined && alreadySelected != null && alreadySelected != ''){
                        if(alreadySelected.includes(additionalTeamMembers[key]))
                            {
                                console.log('alreadySelected includes'+additionalTeamMembers[key]);
                                test1.push({value:additionalTeamMembers[key], selected:true});
                            }else
                               test1.push({value:additionalTeamMembers[key], selected:false}); 
                	}else
                        test1.push({value:additionalTeamMembers[key], selected:false});*/
                }
                component.set("v.additionalTeamMemberRoles", additionalTeamMemberList);
                //console.log('*@*@*@*@',component.get("v.singleRec.additionalTeamRole"));
                var temp ;
                var temp1 = [];
                temp = component.get("v.singleRec.additionalTeamRole");
                if(temp != undefined && temp != null && temp != ''){
                    console.log('temp'+temp);
                    temp1 = temp.split(';');
                    //console.log('temp1'+temp1);                   
                    
                    component.set("v.selectedAdditionalTeamMemberRoles",temp1);
                }
                //component.set("v.test", test1);
            } else {
                console.log('Problem getting Additional Team member Roles, response state: ' + state);
            }
        });
        $A.enqueueAction(actionAdditionalTeamMemberRole);
        //console.log("@@@@@@@additional role"+component.get("v.singleRec.additionalTeamRole"));
        
        var actionAccessLevel = component.get("c.getAllAccessLevel");      
        console.log('Checking Offer Access......');  
        actionAccessLevel.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                
                var access = [];
                var accessList = [];
                access = response.getReturnValue();
                //console.log('access--------------: '+ JSON.stringify(access));
                accessList.push({value:'--None--', key:'--None--'});
                for (var key in access ) {
                    accessList.push({value:access[key], key:key});
                }
                component.set("v.accessLevels", accessList);
            } else {
                console.log('Problem getting Access levels, response state: ' + state);
            }
        });
        $A.enqueueAction(actionAccessLevel);
        //var selectedSkills = $('[id$=picklist]').select2("val");
        //component.set("v.objAcc.Skills__c",selectedSkills);
        //$('#picklist').select2("val",component.get("v.singleRec.additionTeamRole"));
        //
        var usr = component.get("v.singleRec.userId");
        if(usr != undefined && usr != null && usr != ''){
            //console.log('usrrrrrrrrrr'+usr);
            var userAction =  component.get("c.getUser");
            userAction.setParams({
                "userId":usr
            });
            userAction.setCallback(this, function(response) {
                var state = response.getState();
                if(state === "SUCCESS") {
                    var userInfo = response.getReturnValue();
                    component.set("v.selectedRecord",userInfo);
                    var forclose = component.find("lookup-pill");
                    $A.util.addClass(forclose, 'slds-show');
                    $A.util.removeClass(forclose, 'slds-hide');
                    
                    var forclose = component.find("searchRes");
                    $A.util.addClass(forclose, 'slds-is-close');
                    $A.util.removeClass(forclose, 'slds-is-open');
                    
                    var lookUpTarget = component.find("lookupField");
                    $A.util.addClass(lookUpTarget, 'slds-hide');
                    $A.util.removeClass(lookUpTarget, 'slds-show'); 
                } else {
                    console.log('Problem getting user, response state: ' + state);
                }
            });
            $A.enqueueAction(userAction);
            // get the selected record from list  
            //var getSelectRecord = component.get("v.userRecord");
            // call the event   
            //var compEvent = component.getEvent("oSelectedRecordEvent");
            // set the Selected sObject Record to the event attribute.  
            //compEvent.setParams({"recordByEvent" : getSelectRecord });  
            // fire the event  
            //compEvent.fire();
        }
        
        
    },
    getUserList : function(component){
        var action = component.get("c.getAllUserList");
        action.setParams({"keyWord": component.get("v.singleRec.userName")});        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                console.log("response.getReturnValue()"+response.getReturnValue());
                component.set("v.listOfSearchRecords"+response.getReturnValue());
                
            } else {
                console.log('Problem getting Team member Roles, response state: ' + state);
            }
        });
        $A.enqueueAction(action);
    },
    
    searchHelper : function(component,event,getInputkeyWord) {
        // call the apex class method 
        var action = component.get("c.getAllUserList");
        // set param to method  
        action.setParams({
            "keyWord":  getInputkeyWord
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", '');
                }
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecords", storeResponse);   
            }
        });
        // enqueue the Action  
        $A.enqueueAction(action);
    },
})