({
    doInit : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var action = component.get("c.isAccessEnabled");
        action.setParams({ caseId : recordId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                if(response.getReturnValue() === true){
                    var recordId = component.get("v.recordId");
                    var action = component.get("c.getPrivateFeedRecord");
                    action.setParams({ caseId : recordId });
                    action.setCallback(this, function(response) {
                        var state = response.getState();
                        if (state == "SUCCESS") {
                             var returnValue=response.getReturnValue(); 
                            component.set("v.getPrivateFeedId", returnValue[0].Id);
                            component.set("v.privateNotes", returnValue[0].CH_PrivateNotes__c);
                            component.set("v.targetRelease", returnValue[0].CH_TargetRelease__c);
                            if ((returnValue[0].CH_TargetRelease__c !== '' && returnValue[0].CH_TargetRelease__c !== undefined)
                                || (returnValue[0].CH_TargetReleaseDate__c !== '' && returnValue[0].CH_TargetReleaseDate__c !== undefined)){
                                component.set("v.isUpdateEnabled", false);
                            } else { component.set("v.isUpdateEnabled", true);  }
                            component.set("v.targetReleaseDate", returnValue[0].CH_TargetReleaseDate__c);
                            component.set("v.isAccessEnabled", true);
                        }
                    });
                    $A.enqueueAction(action);
                    
                } 
            }
        });
        $A.enqueueAction(action);
    },
	
	handleClick:function(component,event,helper){
        var privateNote = component.find("privateNotes").get("v.value");
        var targetRelase = component.find("targetRelease").get("v.value");
        var targetRelaseDate= component.find("targetReleaseDate").get("v.value");
        var action = component.get('c.savePrivateFeed');
        action.setParams({ privateFeedId: component.get("v.getPrivateFeedId"),
                          privateNotes: privateNote,targetRelease: targetRelase,targetReleaseDate: targetRelaseDate });        
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnValue=response.getReturnValue();
                component.set("v.isSaveEnabled", true);
                helper.showToast('success',"Success"," Data saved successfully.") ;
            }
            else {
                var errors = response.getError();                
                helper.showToast('error', 'Error',errors && errors[0] && errors[0].message?errors[0].message:"Something went wrong");
            }
        })
        $A.enqueueAction(action);         
    },
    
    onChange:function(component,event,helper){
        component.set("v.isSaveEnabled", false);
    },
    
    handleCase:function(component,event,helper){
        var targetRelase = component.find("targetRelease").get("v.value");
        var targetRelaseDate= component.find("targetReleaseDate").get("v.value");
        var action = component.get('c.updateProblemRecord');
        action.setParams({ caseId: component.get("v.recordId"),
                          targetRelease: targetRelase,targetReleaseDate: targetRelaseDate });        
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnValue=response.getReturnValue();
                component.set("v.isSaveEnabled", true);
                helper.showToast('success',"Success"," Data saved successfully.") ;
                $A.get('e.force:refreshView').fire();
            }
            else {
                var errors = response.getError();                
                helper.showToast('error', 'Error',errors && errors[0] && errors[0].message?errors[0].message:"Something went wrong");
            }
        })
        $A.enqueueAction(action);         
    },
    
   
})