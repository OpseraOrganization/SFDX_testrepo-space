/*--********************************************************************************* 
Controller Name: CH_CaseEntitlementTabHelper

Name            Modified DATE       Comments
Gourisankar		29 June 2019		Changed getInitControllerData function and passed attribute value of show script as a part of US-22547
Rajeshwari		12 March 2020		NOKIASC-27305
********************************************************************************************-->
*/

({
    openReEntitlement : function(component, event, helper) {
        var evt = $A.get("e.force:navigateToComponent");
        var cUser = component.get("v.currentUser");
        evt.setParams({
            //componentDef: (cUser.Username == 'mahatikrishna.chitta@tcs.com.cchdev' ? "c:CH_ReEntitlement_Prasanth" : (cUser.Username == 'manoj.gahlot@singlecrm.tcs.com.cchdev' ? "c:CH_ReEntitlement_Manoj" : (cUser.Username == 'mboutaleb@salesforce.com.cchdev' ? "c:CH_ReEntitlement_mboutaleb": (cUser.Username == 'tiago.almeida@singlecrm.nokia.com.cchdev' ? "c:CH_ReEntitlement_tiago" : "c:CH_ReEntitlement")))),
            componentDef: "c:CH_ReEntitlement",
            componentAttributes:{
                caseId : component.get("v.recordId")
            }            
        });
        evt.fire();
    },
    showToastMessage: function(messageType, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type" : messageType,
            "mode" : 'sticky',
            "title" : messageType,
            "message" : message
        });
        toastEvent.fire();
    },
    
     
    getInitControllerData : function (component, event, helper){      
        var action = component.get('c.getEntitlementTabData');
         
        action.setParams({ "caseId" : component.get("v.recordId") });
        action.setCallback(this,function(response){
            if (response.getState() === "SUCCESS") {
                var resp = response.getReturnValue();
                console.log('inside getInitControllerData loop'+resp.enableShowScript);
                component.set("v.hasOnlyReadAccess", resp.hasOnlyReadAccess);
                component.set("v.currentUser", resp.currentUser);
                //NOKIASC-27305 Rajeshwari
                component.set("v.hasEditAccess", resp.hasEditAccess);
                component.set("v.caseRecordTypeDevName", resp.recordTypeDevName);
                //NOIKASC-22547 Show Script changes
                component.set("v.showscript", resp.enableShowScript);
            }
        });
        $A.enqueueAction(action);
    },
    getAccessRights : function(component,event,helper)
    {
        var recordId = component.get("v.recordId");
        var action = component.get("c.accessCheck");
        action.setParams({ caseId : recordId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.hasEditAccess",response.getReturnValue());
            }
        });
         $A.enqueueAction(action);
    }
       
	   
    
    
})