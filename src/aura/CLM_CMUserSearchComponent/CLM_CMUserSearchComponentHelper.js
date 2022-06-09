({
    getUsersList : function(component, event, helper) {
        var action = component.get("c.getCMUsersLst");
        action.setParams({
            "accId" : component.get("v.accountId"),
            "recId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                var userLst = response.getReturnValue();
                if(userLst.length > 0){
                    component.set("v.usersLst",response.getReturnValue());
                    component.set("v.spinner",false);
                    
                }else{
                    component.set("v.isOpen",true);
                    component.set("v.spinner",false);
                    component.set("v.messageInModal","There are no L&C CMs or Counsel in the Account's Territory");
                }
            }
        });
        $A.enqueueAction(action);
    },
    createAgreementTeam : function(component, event, helper) {
        var action = component.get("c.createAgreementTeamRecd");
        var userData = component.get("v.userRecd");
        var userId;
        for(var r in userData){
            userId = userData[r].Id;
        }
        action.setParams({
            "userId" : userId,
            "recordId" : component.get("v.recordId") 
            
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                var teamRec = response.getReturnValue();
                if(teamRec.message =="SUCCESS"){
                    console.log('=====39===='+JSON.stringify(teamRec));
                    if(teamRec.opportunityTeamRec !== undefined){
                        sforce.one.navigateToSObject(teamRec.opportunityTeamRec.Id);
                    }else if(teamRec.agrmentTeamRec !== undefined){
                        sforce.one.navigateToSObject(teamRec.agrmentTeamRec.Id);
                    }
                    
                }else{
                    component.set("v.spinner",false);
                    component.set("v.isOpen",true);
                    component.set("v.messageInModal",teamRec.message);
                }
                //window.location.href='/' + teamRec.Id;
            }else{
                var errors = response.getError(); 
                component.set("v.spinner",false);
                component.set("v.showError",true);
                component.set("v.errorMessage",errors[0].message);
            }
        });
        $A.enqueueAction(action);
    },
    
})