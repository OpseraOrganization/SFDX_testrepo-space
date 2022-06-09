({
    checkRequiredFields: function(component, event, helper) {
        var action = component.get("c.getRequiredFields");
        action.setParams({
            "recordId" : component.get("v.recordId"),
            "requestType" : 'AgrmntFromOppty',
            "objectAPI" : 'Opportunity',
            "objDetails" : ''
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                component.set("v.spinner",false); 
                console.log(''+JSON.stringify(response.getReturnValue()));
                var wrapData = response.getReturnValue();
                if(wrapData.length>0){
                    component.set("v.isOpen",true);
                    component.set("v.reqWrapper",wrapData);
                    
                }else{
                    helper.getRecordDetails(component, event, helper);
                }
                
            }
        });
        $A.enqueueAction(action);
    },
    getRecordDetails: function(component, event, helper) {
        var action = component.get("c.opptCopyToObj");
        action.setParams({
            "recordId" : component.get("v.recordId"),
            "fromObjAPI" : 'Opportunity',
            "toObjAPI" : 'Apttus__APTS_Agreement__c'
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                console.log(''+JSON.stringify(response.getReturnValue()));
                var wrapData = response.getReturnValue();
                
                component.set("v.nameOfAgrmnt",wrapData.objRecd.Name);
                component.set("v.wrapper",wrapData.wrapRecdsList);
                component.set("v.newAgreementRecordType",true);
                component.set("v.showRecordTable",true);
                component.set("v.spinner",false); 
            }
        });
        $A.enqueueAction(action);
    },
    getCloneFieldsData: function(component, event, helper) {
        var action = component.get("c.getDataToClone");
        action.setParams({
            "recordId" : component.get("v.recordId"),
            "objAPI" : 'Apttus__APTS_Agreement__c'
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                var wrapData = response.getReturnValue();
                component.set("v.wrapper",wrapData);
                component.set("v.spinner",false); 
            }
        });
        $A.enqueueAction(action);
    },
    getRecordTypeId: function(component, event, helper) {
        var action = component.get("c.getRecordTypeInfo");
        if(component.get("v.cloneObject") === 'Opportunity'){
            component.set("v.recordTypeVal", 'ContractRequest')
        }
        action.setParams({
            "recrdTypeName" : component.get("v.recordTypeVal"),
            "objectApiName" : 'Apttus__APTS_Agreement__c'
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                component.set("v.recordTypeId",response.getReturnValue());
                component.set("v.spinner",false); 
            }
        });
        $A.enqueueAction(action);
    },
    redirectToSobject: function (component, event, helper, recordId) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": recordId,
            "slideDevName": "Detail"
        });
        navEvt.fire();
    },
    createAgrmntTeamsRecds: function(component, event, helper) {
        var action = component.get("c.createAgrmntTeam");
        
        action.setParams({
            "agrmntId" : component.get("v.newAgrmntId"),
            "parentAgrmntId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
            }
        });
        $A.enqueueAction(action);
    },
    createAgrmntTeamsRecdFromOpty: function(component, event, helper) {
        var action = component.get("c.createAgrmntTeamFromOpty");
        
        action.setParams({
            "agrmntId" : component.get("v.newAgrmntId"),
            "optyId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
            }
        });
        $A.enqueueAction(action);
    },
    showToast : function(component, event, type, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": type,
            "message": message,
            "type":type
        });
        toastEvent.fire();
    }
    
})