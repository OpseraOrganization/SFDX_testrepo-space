({
    doInit : function(component, event, helper) {
        component.set("v.spinner",true);
        var myPageRef = component.get("v.pageReference");
        var id = myPageRef.state.c__recordId;
        component.set("v.recordId", id);
        helper.getRecordDetails(component, event, helper);
    },
    closeModal: function(component, event, helper) {
        component.set("v.spinner",true);
        window.location='/lightning/r/Apttus__APTS_Agreement__c/'+component.get("v.recordId")+'/view';
        
    },
    handleOnSuccess : function(component, event, helper) {
        component.set("v.spinner",true);
        var agrmntRec = component.get("v.agrmntObject");
        if(agrmntRec.RecordType.Name === 'Non-Transactional Agreement'){
            helper.getReqFields(component, event, helper, 'ActivateFrameRequest');
        }else{
            helper.getReqFields(component, event, helper, 'ActivateRequest');
        }
    },
    activateRequest : function(component, event, helper) {
        component.set("v.spinner",true);
        component.set("v.buttonLabel",event.getSource().get("v.label"));
        component.find('agreementForm').submit();
    },
    updateRequest : function(component, event, helper) {
        component.set("v.spinner",true);
        component.set("v.buttonLabel",event.getSource().get("v.label"));
        component.find("agreementForm").submit();
    },
    handleSubmit : function(component, event, helper) {
    },
    handleOnError : function(component, event, helper) {
        component.set("v.spinner",false);
        var error = event.getParams();
        var errorMessage = event.getParam("message");
        var outlst = event.getParam("output");
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
            }
        }
    },
    
})