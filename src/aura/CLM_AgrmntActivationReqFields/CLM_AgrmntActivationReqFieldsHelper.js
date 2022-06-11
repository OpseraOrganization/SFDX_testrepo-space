({
    getRecordDetails: function(component, event, helper) {
        var action = component.get("c.getRecordData");
        action.setParams({
            "recordId" : component.get("v.recordId") 
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                component.set("v.agrmntObject",response.getReturnValue());
                var agrmntRec = component.get("v.agrmntObject");
                if((agrmntRec.RecordType.Name !== 'Contract Request')
                   && (agrmntRec.RecordType.Name !== 'General')
                   && (agrmntRec.RecordType.Name !== 'Legacy')
                   && (agrmntRec.RecordType.Name !== 'NDA')){
                    if(agrmntRec.RecordType.Name === 'Non-Transactional Agreement'){
                        this.getReqFields(component, event, helper, 'ActivateFrameRequest');
                    }else{
                        this.getReqFields(component, event, helper, 'ActivateRequest');
                    }
                }else{
                    window.location='/lightning/r/Apttus__APTS_Agreement__c/'+component.get("v.recordId")+'/view';
                    
                }
            }
        });
        $A.enqueueAction(action);
    },
    getReqFields: function(component, event, helper, requestType) {
        var action = component.get("c.getRequiredFields");
        action.setParams({
            "recordId" : component.get("v.recordId"),
            "requestType" : requestType,
            "objectAPI" : "Apttus__APTS_Agreement__c",
            "objDetails" : JSON.stringify(component.get("v.agrmntObject"))
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                console.log('====39==='+JSON.stringify(response.getReturnValue()));
               var buttonLabel =  component.get("v.buttonLabel");
                if(response.getReturnValue().length > 0){
                    component.set("v.spinner",false);
                    var accRecd = component.get("v.agrmntObject");
                    if(buttonLabel === 'Activate'){
                        var wrapInfo = response.getReturnValue();
                        var reqFlds = '';
                        for(var r in wrapInfo){
                            if(wrapInfo[r].fieldValue === undefined){
                                reqFlds += (wrapInfo[r].fieldLabel) +'; ';
                            }
                        }
                        console.log('====52==='+JSON.stringify(reqFlds));
                        if(reqFlds.length >0 ){ 
                            reqFlds = reqFlds.substring(0, reqFlds.length - 2);
                            component.find('mandtryMessage').setError('These fields are required for activation"'+ reqFlds +'"');
							component.set("v.isOpen",true);                            
                            return;
                        }else{
                            this.getSessionDetails(component, event, helper);
                        }
                    }else if(buttonLabel === 'Save'){
                        component.find('mandtryMessage').setError('');
                        this.showToast(component, event, "Success",'The values entered are saved to the agreement');
                    }else{
                        component.set("v.wrapper",response.getReturnValue());
                        component.set("v.isOpen",true);
                    }
                    
                }else{
                    if(buttonLabel === 'Activate'){
                        
                        this.getSessionDetails(component, event, helper);
                    }
                    if(buttonLabel === 'Save'){
                        window.location='/lightning/r/Apttus__APTS_Agreement__c/'+component.get("v.recordId")+'/view';
                        
                    }
                }
            }else{
                console.error("fail:" + response.getError()[0].message);
            }
        });
        $A.enqueueAction(action);
    },
    getSessionDetails: function(component, event, helper) {
        var action = component.get("c.getSessionAndBaseUrl");
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                var res = response.getReturnValue();
                var urlForActivation = res.baseUrl+'/lightning/cmp/Apttus__ActivateAgreementContainer?Apttus__agreementId='+component.get("v.recordId");
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url":urlForActivation
                });
                urlEvent.fire();
            }else{
                console.error("fail:" + response.getError()[0].message);
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
    },
})