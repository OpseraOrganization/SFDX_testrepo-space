({
    doInit : function(component, event, helper) {
        if(component.get("v.objectName") == 'Contact'){
            helper.getSalutationPickListValues(component, event);
        }
        if(component.get("v.objectName") == 'Account'){
            var controllingFieldAPI = component.get("v.controllingFieldAPI");
            var dependingFieldAPI = component.get("v.dependingFieldAPI");
            var objDetails  = component.get("v.objDetail");
            helper.fetchPicklistValues(component,objDetails ,controllingFieldAPI, dependingFieldAPI);
            //NOKIASC-35956:Add Toggle button with a specific name for Ad hoc ship to address creation  
            helper.isTranslateRequired(component);
            var country=component.get("v.shippingCountry");
            if(country==null){
                component.set("v.shippingCountry",null);
                component.find("countryCodeId").set("v.disabled",false);    
            }
        }
        // component.controllerFieldChange();
    },
    //Spinner Code Start
    showWaiting:function(cmp){
        cmp.set("v.IsSpinner",true);
    },
    hideWaiting:function(cmp){
        cmp.set("v.IsSpinner",false);  
        
    },
    //Spinner Code Ends
    openModel: function(component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        component.set("v.isOpen", true);
    },
    closeModel : function(component, event, helper) {
        
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open');
        $A.util.removeClass(cmpBack,'slds-fade-in-open');
        var cmpEvent = component.getEvent("HWS_createNewRecordEvent");
        cmpEvent.setParams({
            "ParentRecordName" : 'canceled',
        });
        cmpEvent.fire();
    },
    
    save : function(component, event, helper) {
        var contactRecord = component.get('v.contact');
        var action = component.get('c.createContact');
        var validation = helper.getValidation(component, event);
        
        if(validation){
            action.setParams({
                accountRecId : component.get("v.AccountDetails"),
                contactRecord : contactRecord,
                
            });
            action.setCallback(this, $A.getCallback(function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var untitleProject = response.getReturnValue();
                    var cmpTarget = component.find('Modalbox');
                    var cmpBack = component.find('Modalbackdrop');
                    $A.util.removeClass(cmpBack,'slds-backdrop');
                    $A.util.removeClass(cmpTarget, 'slds-fade-in-open');
                    $A.util.removeClass(cmpBack,'slds-fade-in-open');
                    var cmpEvent = component.getEvent("HWS_createNewRecordEvent");
                    cmpEvent.setParams({
                        "ParentRecordId" : untitleProject.currentworkingTitleId,
                        "ParentRecordName" : untitleProject.currentworkingTitleName,
                        "Objectname" : 'Contact'
                    });
                    cmpEvent.fire();
                } 
                //Display Error msg for Customer Reference number field
                else {
                    var toastEvent = $A.get("e.force:showToast");
                    var message = '';
                    if (state === "INCOMPLETE") {
                        message = 'Server could not be reached. Check your internet connection.';
                    } else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors) {
                            for(var i=0; i < errors.length; i++) {
                                for(var j=0; errors[i].pageErrors && j < errors[i].pageErrors.length; j++) {
                                    message += (message.length > 0 ? '\n' : '') + errors[i].pageErrors[j].message;
                                }
                                if(errors[i].fieldErrors) {
                                    for(var fieldError in errors[i].fieldErrors) {
                                        var thisFieldError = errors[i].fieldErrors[fieldError];
                                        for(var j=0; j < thisFieldError.length; j++) {
                                            message += (message.length > 0 ? '\n' : '') + thisFieldError[j].message;
                                        }
                                    }
                                }
                                if(errors[i].message) {
                                    message += (message.length > 0 ? '\n' : '') + errors[i].message;
                                }
                            }
                        } else {
                            message += (message.length > 0 ? '\n' : '') + 'Unknown error';
                        }
                    }
                    toastEvent.setParams({
                        title: 'Error',
                        type: 'error',
                        message: message
                    });
                    toastEvent.fire();
                }//Error code ends 
            }));
            $A.enqueueAction(action);
        } 
    },
    
    saveShiptoParty : function(component, event, helper) {
        var SelectedAsset = component.get('v.SelectedAsset');
        var selectedAccRec = component.get('v.passingAccount');
        var jsonAcc = JSON.stringify(selectedAccRec);
        var accountRecord = component.get('v.Account');
        var shippingcounrystate = component.get("v.objDetail");
        
        var translationRequiredTo = component.get("v.translationRequiredTo");
        accountRecord.BillingCountry=component.find('countryCodeId').get("v.value");
        accountRecord.BillingState=component.find('stateCodeId').get("v.value");
        var addline1 =component.find('addressLine1').get("v.value");
        var addline2 =component.find('addressLine2').get("v.value");
        var addline3 =component.find('addressLine3').get("v.value");
        accountRecord.BillingStreet = addline1+ "," +addline2+ "," +addline3 ;
        var Name = accountRecord.Name;
        var cityStateCountry = accountRecord.BillingCity+","+shippingcounrystate.BillingStatecode+","+shippingcounrystate.BillingCountrycode+","+accountRecord.BillingPostalCode;
        var action = component.get('c.updatetoParentCase');
        var validation = helper.getShiptoPartyValidation(component, event);
        if(validation && !component.get("v.isInputWrong")){
			component.set("v.IsSpinner", true);
            component.set("v.saveDisable",true);
            action.setParams({
                selectedAccRec : jsonAcc,
                "accountRecord" : accountRecord,
                "selectedAsset" : SelectedAsset,
                "translationRequiredTo" :translationRequiredTo,
                "addline1" : addline1,
                "addline2" :addline2,
                "addline3" :addline3,
				"accName": Name
            });
            
            
            
            action.setCallback(this, $A.getCallback(function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
					component.set("v.IsSpinner", false);
                    component.set("v.saveDisable",false);
                    var untitleProject = response.getReturnValue();
                    var cmpTarget = component.find('Modalbox');
                    var cmpBack = component.find('Modalbackdrop');
                    $A.util.removeClass(cmpBack,'slds-backdrop');
                    $A.util.removeClass(cmpTarget, 'slds-fade-in-open');
                    $A.util.removeClass(cmpBack,'slds-fade-in-open');
                    var cmpEvent = component.getEvent("HWS_createNewRecordEvent"); 
                    cmpEvent.setParams({
                        "ParentRecordId" : untitleProject.currentworkingTitleId,
                        "ParentRecordName" : untitleProject.currentworkingTitleName,
                        "shipToPartyAccount" : untitleProject.shipToPartyAccount,
                        "Objectname" : 'Account',
                        "AddrLine1" : addline1,
                        "AddrLine2" : addline2,
                        "AddrLine3" : addline3,
                        "CityStateCountry" : cityStateCountry,
                        "isChecked" :component.get('v.latinInput'),
                        "translationRequired" : component.get('v.isTranslationRequired')
                    });
                    cmpEvent.fire();
                    
                } 
                //Display Error msg for Customer Reference number field
                else {
                    component.set("v.saveDisable",false);
					component.set("v.IsSpinner", false);
                    var toastEvent = $A.get("e.force:showToast");
                    var message = '';
                    if (state === "INCOMPLETE") {
                        message = 'Server could not be reached. Check your internet connection.';
                    } else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors) {
                            for(var i=0; i < errors.length; i++) {
                                for(var j=0; errors[i].pageErrors && j < errors[i].pageErrors.length; j++) {
                                    message += (message.length > 0 ? '\n' : '') + errors[i].pageErrors[j].message;
                                }
                                if(errors[i].fieldErrors) {
                                    for(var fieldError in errors[i].fieldErrors) {
                                        var thisFieldError = errors[i].fieldErrors[fieldError];
                                        for(var j=0; j < thisFieldError.length; j++) {
                                            message += (message.length > 0 ? '\n' : '') + thisFieldError[j].message;
                                        }
                                    }
                                }
                                if(errors[i].message) {
                                    message += (message.length > 0 ? '\n' : '') + errors[i].message;
                                }
                            }
                        } else {
                            message += (message.length > 0 ? '\n' : '') + 'Unknown error';
                        }
                    }
                    toastEvent.setParams({
                        title: 'Error',
                        type: 'error',
                        message: message
                    });
                    toastEvent.fire();
                }//Error code ends 
            }));
            $A.enqueueAction(action);
        } 
    },
    onControllerFieldChange: function(component, event, helper) {   
        var controllerValueKey = event.getSource().get("v.value"); // get selected controller field value
        if (component.get("v.shippingCountry")!=null)
            controllerValueKey=component.get("v.shippingCountry");
        var depnedentFieldMap = component.get("v.depnedentFieldMap");
        
        if (controllerValueKey != '--None--') {
            var ListOfDependentFields = depnedentFieldMap[controllerValueKey];
            
            if(ListOfDependentFields.length > 0){
                component.set("v.bDisabledDependentFld" , false);  
                helper.fetchDepValues(component, ListOfDependentFields);    
            }else{
                component.set("v.bDisabledDependentFld" , true); 
                component.set("v.listDependingValues", ['--None--']);
            }  
        } else {
            component.set("v.listDependingValues", ['--None--']);
            component.set("v.bDisabledDependentFld" , true);
        }
    },
    //NOKIASC-35956:Add Toggle button with a specific name for Ad hoc ship to address creation
    handlelatinInputChange: function(component, event, helper) {        
        var translationRequiredTo=component.get('v.latinInput')?'Local':'Latin';
        component.set("v.translationRequiredTo" , translationRequiredTo);
        helper.HandleAddressChange(component, event);
    },
    HandleAddressChange: function(component, event, helper) {
        helper.HandleAddressChange(component, event);  
    }
})