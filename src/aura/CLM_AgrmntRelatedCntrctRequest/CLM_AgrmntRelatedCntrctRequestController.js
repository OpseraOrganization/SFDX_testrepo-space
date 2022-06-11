({
    doInit : function(component, event, helper) {
        component.set("v.spinner",true);
        component.set("v.showForm",true);
        if(component.get("v.cloneObject") === 'Opportunity'){
            //helper.getRecordDetails(component, event, helper);
            helper.checkRequiredFields(component, event, helper);
        }else{
            helper.getCloneFieldsData(component, event, helper);
        }
        helper.getRecordTypeId(component, event, helper);
    },
    handleOnLoad : function(component, event, helper) {
        
    },
    cancel : function(component, event, helper) {
        if(component.get("v.cloneObject") === 'Opportunity'){
            sforce.one.navigateToSObject(component.get("v.recordId")); 
        }else{
            helper.redirectToSobject(component, event, helper, component.get("v.recordId"));  
        }
    },
    
    handleOnSubmit : function(component, event, helper) {
        component.set("v.spinner",true);
        event.preventDefault(); 
        var eventFields = event.getParam("fields");
        console.log('===eventFields==='+JSON.stringify(eventFields));
        if(component.get("v.cloneObject") !== 'Opportunity'){
            eventFields["CLM_Related_Contract_Request__c"] = component.get("v.recordId");
        }else{
            eventFields["CLM_Contract_Category__c"] = 'Transactional (SSA, Care, etc.)';
        }
        component.find('agreementForm').submit(eventFields);
    },
    
    handleOnSuccess : function(component, event, helper) {
        var record = event.getParam("response");
        var apiName = record.apiName;
        var myRecordId = record.id;
        component.set("v.newAgrmntId",myRecordId);
        component.set("v.spinner",false);
        if(component.get("v.cloneObject") === 'Opportunity'){
            sforce.one.navigateToSObject(myRecordId);
            helper.createAgrmntTeamsRecdFromOpty(component, event, helper);
        }else{
            helper.createAgrmntTeamsRecds(component, event, helper);
            helper.redirectToSobject(component, event, helper, myRecordId);
        }
    },
    handleOnError : function(component, event, helper) {
        component.set("v.spinner",false);
        var error = event.getParams();
        var errorMessage = event.getParam("message");
        var outlst = event.getParam("output");
        console.log('===53==='+JSON.stringify(outlst));
        var message = '';
        if((outlst.errors !== undefined && outlst.errors[0] !== undefined) || (outlst.errors !== undefined && outlst.fieldErrors !== undefined)){
            if(outlst.errors[0] !== undefined){
                message = outlst.errors[0].message;
            }else{
                message = '1.Error Code :'+outlst.fieldErrors.Agreement_Description__c[0].errorCode+'\n  2.Field :'+outlst.fieldErrors.Agreement_Description__c[0].field; 
            }
            if(component.get("v.cloneObject") === 'Opportunity'){
                sforce.one.showToast({
                    "title": "Warning!",
                    "message":message
                }); 
            }else{
                helper.showToast(component, event, 'Warning', message);
            }
        }
    },
    
    handleChange: function (component, event, helper) {
        var changeValue = event.getParam("value");
        component.set("v.nextEnable", false);
        
    },
    closeModal: function(component, event, helper) {
        component.set("v.newAgreementRecordType", false);
        sforce.one.navigateToSObject(component.get("v.recordId"));
    },
    
})