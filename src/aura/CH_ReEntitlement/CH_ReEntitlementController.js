({
    init: function(component, event, helper) {
        helper.incrementActionCounter(component);
        helper.setTabIcon(component);
        helper.action(component, "c.getCase", { caseId: component.get("v.caseId") }, function(oCase) {
            if (oCase) {
                let contact = oCase.Contact;
                component.set("v.selectedContact", contact);
                delete oCase.Contact;
                delete oCase.ContactId;
                component.set("v.selectedServiceType", oCase.CH_ServiceType__c);
                component.set("v.case", oCase);
                helper.action( component, "c.permissionToChangeServiceType", null, function(permission) {
                    helper.incrementActionCounter(component);
                    //Check Screen
                    if (permission) {
                        component.set("v.stageNumber", contact.CH_ContactType__c === "Nokia Employee" ? 0 : 1);
                        component.set("v.redirectStageNumber",contact.CH_ContactType__c === "Nokia Employee" ? 0 : 1);
                        helper.handleProgressBar(component);
                    } else component.set("v.selectedLegalEntity", oCase.Account);
                    //Get Internal Account
                    helper.action(component, "c.getInternalAccount", null, function(result){
                        helper.decrementActionCounter(component);
                        component.set("v.internalAccount", result);
                    });
                    //Check Auth
                    helper.action(component, "c.contactIsInternalAuthorized", { "contactId" : contact.Id}, function(result) {
                        helper.decrementActionCounter(component);
                        component.set("v.contactAuth", result?true:false);
                    });
                });
            }
        });
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
                   //35156 - passing product related fields
                    component.set("v.assetProductFields", {
                        'country' : asset && asset.CH_CountryISOName__c?asset.CH_CountryISOName__c:null,
                        'product' : asset && asset.Product2?asset.Product2:null,
                        'productRelease' : asset && asset.CH_ProductRelease__r?asset.CH_ProductRelease__r:null,
                        'productVariant' : asset && asset.CH_ProductVariant__r?asset.CH_ProductVariant__r:null,
                        'solution' : asset && asset.CH_Solution__r?asset.CH_Solution__r:null,
                        'productModule' : component.get('v.selectedProductModule')?component.get('v.selectedProductModule'):null,
                        'swComponent' : component.get('v.selectedSWComponent')?component.get('v.selectedSWComponent'):null,
                        'swRelease' : component.get('v.selectedSWRelease')?component.get('v.selectedSWRelease'):null,
                        'swModule' : component.get('v.selectedSWModule')?component.get('v.selectedSWModule'):null,
                        'swBuild' : component.get('v.selectedSWBuild')?component.get('v.selectedSWBuild'):null,
                        'hwComponen' : component.get('v.selectedHWComponent')?component.get('v.selectedHWComponent'):null
                    });
                    component.set("v.selectedCountry", asset && asset.CH_CountryISOName__c?asset.CH_CountryISOName__c:null);
                    component.set("v.selectedProduct", asset && asset.Product2?asset.Product2:null);
                    component.set("v.selectedProductRelease", asset && asset.CH_ProductRelease__r?asset.CH_ProductRelease__r:null);
                    component.set("v.selectedProductVariant", asset && asset.CH_ProductVariant__r?asset.CH_ProductVariant__r:null);
                    component.set("v.selectedSolution", asset && asset.CH_Solution__r?asset.CH_Solution__r:null);
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
                    else component.set('v.stageNumber',  6);
                    break;
                case 4:
                    let neaStageNumber = parseInt(component.get("v.neaStageNumber"));
                    if(neaStageNumber != -1) {
                        component.set('v.selectedNEA', component.get('v.provisoryNEA'));
                        component.set('v.stageNumber', neaStageNumber);
                        component.set("v.neaStageNumber", -1);                   
                    }
                    else component.set('v.stageNumber',  6);
                    break;
                default:
                    component.set('v.stageNumber', stageNumber+1);
                    break;
            }
            helper.handleProgressBar(component);
        }
	},
	previous : function(component, event, helper) {
        if(!event.getSource().get("v.disabled")) {
            var stageNumber = parseInt(component.get('v.stageNumber'));
            switch(stageNumber){
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
        helper.saveCase(component, helper);	
    },
    handleBHCalculation : function(component, event, helper) {
        let entitlement = component.get('v.selectedEntitlement');
        if(entitlement != null && entitlement != '') helper.setCaseBusinessHours(component, entitlement);
    },
    handleTimeZoneConfirmation : function(component, event, helper) {
        helper.calculateCaseBusinessHours(component, component.get('v.selectedEntitlement'), component.get("v.selectedTimeZone"));
    },
    cancel : function(component, event, helper) { //Added for NOKIASC-23918: Suniti
        helper.closeTab(component);
    }
})