({
	init : function(component, event, helper) {
        helper.incrementActionCounter(component);
        let contactId= component.get("v.contactId");
        helper.setTabIcon(component);
        helper.action(component, "c.getCurrentDateTime", null, function(result){
            if(result) component.set("v.incidentInitiationDateTime", result);
        });
        helper.action(component, "c.getContactName", { "contactId" : contactId}, function(result){
            if(result) component.set("v.selectedContact", {Id: contactId, Name: result});
        });	
        if(component.get('v.selectedServiceType') === 'Internal Support'){
        	helper.incrementActionCounter(component);
            helper.action(component, "c.getInternalAccount", null, function(result){
                helper.decrementActionCounter(component);
                component.set("v.internalAccount", result);
            });
            helper.action(component, "c.contactIsInternalAuthorized", { "contactId" : contactId}, function(result) {
                helper.decrementActionCounter(component);
                component.set("v.contactAuth", result?true:false);
            });
        } else helper.decrementActionCounter(component);
	},
    eventHandler : function(component, event, helper) {
        var message = event.getParam("message"), stageNumber = component.get('v.stageNumber'), target = event.getParam("target");
        switch(message){
            case 'neaSelection':
                var stageNumber = parseInt(component.get('v.stageNumber'));
                component.set("v.neaStageNumber", stageNumber);
                component.set('v.stageNumber', 4);
                break;
            case 'clearNEA':
                component.set('v.selectedNEA', null);
                component.set('v.provisoryNEA', null);
                component.find('neaSelection').resetSelection();
                break;
            case 'notListed':
                var stageNumber = parseInt(component.get('v.stageNumber'));
                component.set("v.unhappyStageNumber", stageNumber);
                component.set("v.unhappyPath", true);
                switch(stageNumber) {
                    case 2: component.set("v.entitlementExceptionValue", "Covered Product Asset Not Listed"); break;
                    case 3: component.set("v.entitlementExceptionValue", "Entitlement Not Listed"); break;
                    case 4: component.set("v.entitlementExceptionValue", "Covered Network Element Asset Not Listed"); break;
                }
                var asset = component.get("v.selectedAsset");
                if(asset != null && asset != ""){
                    component.set("v.assetProductFields", {
                        'country' : asset && asset.CH_CountryISOName__c?asset.CH_CountryISOName__c:null,
                        'product' : asset && asset.Product2?asset.Product2:null
                    });
                    component.set("v.selectedCountry", asset && asset.CH_CountryISOName__c?asset.CH_CountryISOName__c:null);
                    component.set("v.selectedProduct", asset && asset.Product2?asset.Product2:null);
                }
                component.set('v.stageNumber', 5);
                break;
            case 'incrementActionCounter':
                helper.incrementActionCounter(component);
                break;
            case 'decrementActionCounter':
                helper.decrementActionCounter(component); 
                break;
            case 'noRecordFound':
                if(target === 'LegalEntity') {
                    component.set("v.entitlementExceptionValue", "Account Not Listed");
                    component.set("v.legalEntityNotFound", true);
                }
                break;
            case 'recordFound':
                if(target === 'LegalEntity') {
                    component.set("v.entitlementExceptionValue", "");
                    component.set("v.legalEntityNotFound", false);
                }
                break;
            case 'notLinkedToCustomer':
                if(target === 'LegalEntity') {
                    let object = event.getParam("object");
                    component.set('v.selectedLegalEntity', null);
                    component.set('v.notLinkedToCustomer', object?true:false);
                }
                break;
            case 'scriptVerification':
                component.set('v.entitlementScriptVerified', event.getParam("object"));
                break;
            default:
                let object = JSON.parse((event.getParam("object")==null?null:event.getParam("object")));
                if(target === 'NEA') {
                   component.set('v.provisoryNEA', object);
                   if(parseInt(component.get("v.neaStageNumber")) == -1)
                       component.set('v.selected'+target.split(' ').join(''), object);
                }
                else component.set('v.selected'+target.split(' ').join(''), object);
                component.set('v.stageNumber', message==='next'?(stageNumber+1):stageNumber);
                helper.handleProgressBar(component);
                break;
        }        
    },
    next : function(component, event, helper) {
        if(!event.getSource().get("v.disabled")) {
            var stageNumber = parseInt(component.get('v.stageNumber'));
            switch(stageNumber){
                case 1:
                    var internalAuthorized = (component.get('v.selectedServiceType') === 'Customer Support' || component.get('v.contactAuth'));
                    if(component.get('v.legalEntityNotFound') || !internalAuthorized) {
                        component.set('v.stageNumber', 5);
                        component.set("v.entitlementExceptionValue", "Account Not Listed");
                        component.set("v.unhappyPath", true);
                        component.set("v.unhappyStageNumber", stageNumber);
                    }
                    else component.set('v.stageNumber', 2);
                    break;
                case 3:
                    if(component.get('v.selectedEntitlement').NEACount != 0 && component.get('v.selectedNEA') == null) {
                    	component.set('v.stageNumber',  4);                        
                    }
                    else component.set('v.stageNumber', component.get("v.timeZoneMissing") ? 6 : 7);
                    break;
                case 4:
                    let neaStageNumber = parseInt(component.get("v.neaStageNumber"));
                    if(neaStageNumber != -1) {
                        component.set('v.selectedNEA', component.get('v.provisoryNEA'));
                        component.set('v.stageNumber', neaStageNumber);
                        component.set("v.neaStageNumber", -1);                   
                    }
                    else component.set('v.stageNumber', component.get("v.timeZoneMissing") ? 6 : 7);
                    break;
                case 5:
                    component.set('v.stageNumber', 7);
                    break;
                default:
                    component.set('v.stageNumber', stageNumber+1);
                    break;
            }
            helper.handleProgressBar(component);
            helper.checkP20Fields(component, component.get('v.stageNumber'));
        }
	},
	previous : function(component, event, helper) {
        if(!event.getSource().get("v.disabled")) {
            var stageNumber = parseInt(component.get('v.stageNumber'));
            switch(stageNumber){
                case 7:
                    component.set('v.stageNumber', component.get('v.unhappyPath') ? 5 : (component.get('v.selectedNEA') != null ? 4 : 3));
                    break;
                case 6:
                    component.set('v.stageNumber', component.get('v.selectedNEA') != null ? 4 : 3);
                    break;
                case 5:
                    component.set('v.stageNumber', parseInt(component.get('v.unhappyStageNumber')));
                    component.set("v.unhappyStageNumber", -1);
                    component.set("v.entitlementExceptionValue",'');
                    component.set("v.unhappyPath", false);
                    break;
                case 4:
                    let neaStageNumber = parseInt(component.get("v.neaStageNumber"));
                    if(neaStageNumber != -1) {
                        component.find("neaSelection").resetSelection();
                        component.set("v.neaStageNumber", -1);
                        component.set('v.stageNumber', neaStageNumber);             
                    }
                    else component.set('v.stageNumber', 3);
                    break;
                default:
                    component.set('v.stageNumber', stageNumber-1);
                    break;
            }
            helper.handleProgressBar(component);
        }
    },
    saveCaseHandler : function(component, event, helper) {
        if(!component.get("v.showSpinner")) {
            helper.incrementActionCounter(component);
            //Case Details
            let newCase = (component.get('v.showP20fields') == true) ? helper.recordEditFormsToObject(component, [{id: 'requiredFields', required: true},{id: 'optionalFields', required: false},{id: 'orderFields', required: false}]) : helper.recordEditFormsToObject(component, [{id: 'requiredFields', required: true},{id: 'optionalFields', required: false}]);
            //Email Verification
            if(newCase.CH_AdditionalContacts__c && newCase.CH_AdditionalContacts__c.length > 0){
                newCase.CH_AdditionalContacts__c = newCase.CH_AdditionalContacts__c.replace(/\s+/g, '');
                newCase.CH_AdditionalContacts__c = newCase.CH_AdditionalContacts__c.replace(/\,/g, ';');
                newCase.CH_AdditionalContacts__c.split(';').forEach( (x) => {
                    if(!helper.validateEmail(x) && x.length != 0) {
                        newCase.error = x+" is not a valid email address.";
                        return false; 
                    }
                });
            }
			// Related Fields
            if(!newCase.error) {
                newCase.CH_ServiceType__c = component.get("v.selectedServiceType");
                newCase.CH_CaseInitiationDate__c = component.get("v.incidentInitiationDateTime");
                newCase.AccountId = component.get("v.notLinkedToCustomer")?component.get("v.internalAccount").Id:component.get("v.selectedLegalEntity").Id;
                newCase.ContactId = component.get("v.selectedContact").Id;
                newCase.CH_EntitlementScriptVerificationComplete__c = component.get("v.entitlementScriptVerified");
                newCase.CH_EntitlementException__c = component.get("v.entitlementExceptionValue");
                if(component.get("v.unhappyPath")) {
                    newCase.ProductId = component.get("v.selectedProduct").Id;
                    newCase.Country__c = component.get("v.selectedCountry");
                    newCase.CH_Solution__c = component.get('v.selectedSolution')?component.get('v.selectedSolution').Id:null;
                    newCase.CH_ProductVariant__c = component.get('v.selectedProductVariant')?component.get('v.selectedProductVariant').Id:null;
                    newCase.CH_Product_Release__c = component.get('v.selectedProductRelease')?component.get('v.selectedProductRelease').Id:null;
                }
                else {
                    var entitlement = component.get("v.selectedEntitlement"),
                        asset = component.get("v.selectedAsset"),
                        nea = component.get("v.selectedNEA");
                    newCase.AssetId = asset.Id;
                    newCase.ProductId = asset.Product2Id;
                    newCase.EntitlementId = entitlement.Id;
                    newCase.BusinessHoursId = component.get("v.selectedBusinessHours") ? component.get("v.selectedBusinessHours").Id : null;
                    newCase.CH_NetworkElementAsset__c = nea ? nea.Id : null;
                    newCase.CH_Solution__c = asset.CH_Solution__c ? asset.CH_Solution__c : (nea && nea.CH_Solution__c ? nea.CH_Solution__c : null);
                    newCase.CH_ProductVariant__c = asset.CH_ProductVariant__c ? asset.CH_ProductVariant__c : (nea && nea.CH_ProductVariant__c ? nea.CH_ProductVariant__c : null);
                    if(entitlement) {
                        newCase.CH_EntitlementException__c = entitlement.HasScript?
                                                                (newCase.CH_EntitlementScriptVerificationComplete__c?
                                                                    'Entitlement Script Verified Manually':
                                                                    'Entitlement Script Verification Required'):
                                                                'No Exception';
                    }
                }    
                helper.action(component, "c.doCase", {operationType: 'insert', oCase: newCase, withoutSharing: true}, function(result){  
                    component.set("v.save", 'true');
                    if(result) {
                        helper.openCaseTab(component, '/one/one.app?#/sObject/' + result + '/view',result);
                        helper.closeTab(component); 
                    } 
                });
                helper.decrementActionCounter(component);
            }
            else {
                helper.decrementActionCounter(component);
                component.set("v.save", newCase.error?newCase.error:'');
            }
        }
    },
		  
    /***31153 */
    onchangeSeverity : function(component,event,helper) {
        
       var sevValue = component.find("oSeverity").get("v.value");
        if(sevValue == "Minor" || sevValue == "Information Request"){
            component.find("oOutage").set("v.value", "No");
		}
		else if(sevValue == "Critical" || sevValue == "Major"){
			component.find("oOutage").set("v.value", "");
		}
    },
    /*31153 */
    handleBHCalculation : function(component, event, helper) {
        let entitlement = component.get('v.selectedEntitlement');
        if(entitlement != null && entitlement != '') helper.setCaseBusinessHours(component, entitlement);
    },
    handleTimeZoneConfirmation : function(component, event, helper) {
        helper.calculateCaseBusinessHours(component, component.get('v.selectedEntitlement'), component.get("v.selectedTimeZone"));
    },
    clearError : function(component, event, helper) {
        component.set("v.save", '');
    },
    cancel : function(component, event, helper) { //Added for NOKIASC-23918: Suniti
        helper.closeTab(component);
    }
})