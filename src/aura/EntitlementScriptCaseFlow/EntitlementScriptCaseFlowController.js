({
    sectionOne : function(component, event, helper) {
       helper.helperFun(component,event,'articleOne');
    },
    
   sectionTwo : function(component, event, helper) {
      helper.helperFun(component,event,'articleTwo');
    },
    
    doInit : function(component, event, helper){
        var action = component.get('c.getEntitlementscript');
        var rcrdId = component.get('v.recordId');
      	console.log('caseid value ####'+component.get("v.recordId"));
        action.setParams({
            caseId  : component.get("v.recordId")
        })
        action.setCallback(this,function(response){
            if(response.getState()=="SUCCESS"){
                component.set("v.ScriptMap" , response.getReturnValue());
                console.log('success ####'+ JSON.stringify(response.getReturnValue()));
            }
            else if (response.getState() === "ERROR") {
                $A.log("Errors", response.getError());
                 console.log('Failure ####'+ response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
})