({
    myAction2 : function(component, event, helper) {
        var self = this;
        var recordId = component.get("v.recordId");
        var checkTCA = component.get("c.checkTCAReady");
        checkTCA.setParams({
            fieldId : recordId
        });
        checkTCA.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var test = response.getReturnValue();
                if(test==true)
                {
                    //  let buttonWrite = component.find('disablebuttonidwrite');
                  //  buttonWrite.set('v.disabled',false);
                    component.set('v.disableButtongencar',false);
                    
                }
                else
                {
                   // let buttonWrite = component.find('disablebuttonidwrite');
                    //buttonWrite.set('v.disabled',true);  
                    component.set('v.disableButtongencar',true);  
                }
            }
        });
        $A.enqueueAction(checkTCA);
    },
    myAction1 : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var action = component.get("c.accessCheck");
        action.setParams({ caseId : recordId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                component.set("v.edit",response.getReturnValue());
                this.editValue = response.getReturnValue();
            }
        });
        $A.enqueueAction(action);
    },
    myAction3 : function(component, event, helper) {
       var recordId = component.get("v.recordId");
         var action3 = component.get("c.disablesetissueresolved");
        action3.setParams({ caseId: recordId });
        action3.setCallback(this, function(response) {
            var state = response.getState();
            //component.set('v.SIRRender',false);
            var test = response.getReturnValue();
                if(test==true)
                {
                    component.set('v.disableissueresolve',true);
                   // component.set('v.SIRRender',true);
                }
                else
                {
                    component.set('v.disableissueresolve',false);
                    //component.set('v.SIRRender',true);
                }
        });
        $A.enqueueAction(action3);
    },
     statusval : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var action = component.get("c.statusValue");
        action.setParams({ caseId : recordId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var statusCheck = response.getReturnValue(); 
                var buttonRead = component.find('disablebuttonid');
                buttonRead.set('v.disabled',statusCheck);                
            }
        });
        $A.enqueueAction(action);
    },
    
    
   generatesdrval : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var action = component.get("c.disablebuttoncheckGenerateSDR");
        action.setParams({ caseId : recordId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var statusCheck = response.getReturnValue(); 
                console.log("statuscheck",statusCheck);
                if(statusCheck == true)
                {
                        component.set('v.disableButtongensdr',true);
                }
                else
                {
                        component.set('v.disableButtongensdr',false);
                }
            }
        });
        $A.enqueueAction(action);
    } 
})