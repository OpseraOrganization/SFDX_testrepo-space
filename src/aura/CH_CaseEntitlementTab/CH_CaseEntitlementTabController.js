/*--********************************************************************************* 
Controller Name: CH_CaseEntitlementTabController

Name            Modified DATE       Comments
Gourisankar		29 June 2019		Added function ShowEntitlementScript as a part of US-22547
********************************************************************************************-->
*/

({
    doInit : function(component, event, helper) {
      
        helper.getInitControllerData(component, event);
        //helper.getAccessRights(component, event);
         
        
    },
    
    saveCase : function(component,event,helper) {
        component.find("caseEditForm").submit();
        $A.get('e.force:refreshView').fire();
    },
    
    updateEntitlement : function (component, event, helper){
        var action = component.get('c.enableReEntitlement');
        action.setParams({ "caseRecordId" : component.get("v.recordId") });
        action.setCallback(this,function(response){
            if (response.getState() === "SUCCESS") {
                if (response.getReturnValue() == '') {
                    helper.openReEntitlement(component, event, helper);
                } else {
                    helper.showToastMessage('Error',response.getReturnValue());  
                }                              
            }
        });
        $A.enqueueAction(action);
    },
    redirectToContractReport : function (component, event, helper){
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef: "c:CH_EntitlementReport",
            componentAttributes:{
                caseId : component.get("v.recordId")
            }            
        });
        evt.fire();
    },
   
    //NOKIASC22547-Show ScriptEvent
   ShowEntitlementScript : function (component, event, helper){  
	   component.set("v.Spinner", true);// Added Spinner as part of NOKIASC-28315   
       var action = component.get('c.updateEntitlementScript');     
        action.setParams({ "recordId" : component.get("v.recordId") });
        action.setCallback(this,function(response){         
            if (response.getState()=== "SUCCESS") {  
					component.set("v.Spinner", false);
                    $A.get('e.force:refreshView').fire();                                          
            }else {
					component.set("v.Spinner", false);
                    helper.showToastMessage('Error',response.getState()); 
                }   
        });
        $A.enqueueAction(action);    
   	 
    },
 
     
    handleSaveSuccess : function(component, event, helper){
    	var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({ "title": "Success!", "message": "The record has been updated successfully.", "type": "success" });
        toastEvent.fire();
    },
    
    handleSaveError: function(component,event,helper){
        var errors = event.getParams();
        console.log(JSON.parse(JSON.stringify(errors)));
        if(errors && errors.output && errors.output.errors && errors.output.errors.length > 0){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({ "title": "Error!", "message": errors.output.errors[0].message , "type": "error" });
            toastEvent.fire();
        }
        else if(errors && errors.output && errors.output.fieldErrors && errors.output.fieldErrors.of_Employees_to_represent_Nokia_CP__c && errors.output.fieldErrors.of_Employees_to_represent_Nokia_CP__c.length > 0){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({ "title": "Error!", "message": errors.output.fieldErrors.of_Employees_to_represent_Nokia_CP__c[0].message , "type": "error" });
            toastEvent.fire();
        }
        else {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({ "title": "Error!", "message": "An error occured while saving this record!" , "type": "error" });
            toastEvent.fire();
        }
            
    }
    
})