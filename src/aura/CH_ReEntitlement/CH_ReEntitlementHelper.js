({
    // Compute Business Hours
    setCaseBusinessHours : function(component, entitlement) {
        var helper= this;
        if( entitlement.ContractLineItem.CH_EquipmentLocationBasedTZCoverage__c === '1' ) {
            helper.action(component, "c.countryIsMultiTimezone", { countryName: entitlement.ContractLineItem.CH_CountryISOName__c }, function(result){
                if(result && entitlement.ContractLineItem.CH_BusinessHour__r.Name !== '24x7') {
					let nea = component.get('v.selectedNEA');
                    if(nea == null || nea === '') {
                        component.set('v.timeZoneMissing', true);
                        helper.handleProgressBar(component);
                    }
                    else helper.getTimeZonefromNEA(component, entitlement, nea);
                }
                else helper.setCaseBusinessHoursFromCLI(component, entitlement);
            });            
        }
        else helper.setCaseBusinessHoursFromCLI(component, entitlement);
    },
    // Get TimeZone from NEA
    getTimeZonefromNEA : function(component, entitlement, nea) {
        console.log('nea1: ' + nea);
        console.log('nea2: ' + JSON.stringify(nea));
        let helper = this;
        helper.incrementActionCounter(component);
        component.set('v.timeZoneMissing', false);
        this.handleProgressBar(component);
        if(nea.Address != 'N/A' && nea.Address != ''){
            var fullAddress = {
                address 	: nea.Address__r.Street,
                city 		: nea.Address__r.City,
                postalCode 	: '',
                state 		: nea.Address__r.State,
                country 	: nea.Address__r.Country
            };            
        }
        console.log('fullAddress: ' + JSON.stringify(fullAddress));
        if(fullAddress != undefined) {
            helper.action(component, 'c.getTimeZone', fullAddress, function(location, error) {
                helper.decrementActionCounter(component);
                console.log('location1: ' + location);
                console.log('location2: ' + JSON.stringify(location));
                console.log('error: ' + error);
                if(error || location === null) {
                    console.log('error: ' + error);
                    console.exception(error);
                    let post = 'Failed to identify a Time Zone and a single Business Hours for Network Element Asset \'' + nea.Name + '\' Id: '+ nea.Id;
                    post += ' Address: \'' +nea.Address__r.Street+(nea.Address__r.City?' '+nea.Address__r.City:'');
                    post += (nea.Address__r.State?' '+nea.Address__r.State:'')+(nea.Address__r.Country?' '+nea.Address__r.Country:'')+'\'';
                    helper.action(component, 'c.postToBHChatterGroup', { post : post }, function(result, error2) { 
                        if(error2) console.exception(error2);
                    });
                    if(fullAddress.Country != '' && (fullAddress.Street == '' || fullAddress.Street == undefined) && (fullAddress.City == '' || fullAddress.City == undefined) && (fullAddress.State == '' || fullAddress.State == undefined) && (fullAddress.postalCode == '' || fullAddress.postalCode == undefined)){
                        component.set('v.timeZoneMissing', true); 
                        return;
                    } else {
                        return helper.setCaseBusinessHoursFromCLI(component, entitlement);                 
                    }                
                }
                helper.calculateCaseBusinessHours(component, entitlement, location['timezone'], true);
            }, true);
        } else {
            helper.decrementActionCounter(component);
            let error = 'No Location found!';
            let location = null;
            if(error || location === null) {
                console.log('error: ' + error);
                console.exception(error);
                let post = 'Failed to identify a Time Zone and a single Business Hours for Network Element Asset \'' + nea.Name + '\' Id: '+ nea.Id;
                post += ' Address: N/A';
                helper.action(component, 'c.postToBHChatterGroup', { post : post }, function(result, error2) { 
                    if(error2) console.exception(error2);
                });
                return helper.setCaseBusinessHoursFromCLI(component, entitlement);    
            }
        }
    },
    setCaseBusinessHoursFromCLI : function(component, entitlement) {
        component.set('v.selectedBusinessHours', entitlement.ContractLineItem.CH_BusinessHour__r);
        component.set('v.timeZoneMissing', false);
        this.handleProgressBar(component);
    },
    calculateCaseBusinessHours : function(component, entitlement, timezone) {
        var helper = this,
            businessHourValues = entitlement.ContractLineItem.CH_BusinessHour__r.Name.split(' | ');
        if(businessHourValues.length != 4) {
            helper.setCaseBusinessHoursFromCLI(component, entitlement);
            console.log("There is something wrong with the Business Hours from the Contract Line Item");
            //Ref: NOKIASC-36332 Replaced Error Message With Custom Label
            return helper.showToast('error', 'Error', $A.get("$Label.c.CH_Wrong_Business_Hours_from_the_Contract_Line_Item"));
        } 
        var businessHourName = entitlement.ContractLineItem.CH_CountryISO2__c + ' | ' + businessHourValues[1] + ' | ' + timezone + ' | ' + businessHourValues[3];
        helper.action(component, "c.getBusinessHours", { 'businessHourName' : businessHourName}, function(result, error){
            if(!error && result) {
                component.set('v.selectedBusinessHours', result);     
                helper.saveCase(component, helper);
            }
            else helper.setCaseBusinessHoursFromCLI(component, entitlement);
        });
    },
    saveCase : function(component, helper) {
        if(!component.get("v.showSpinner")) {
            helper.incrementActionCounter(component);
            //Case Details
            let oCase = {Id : component.get('v.caseId')};
            // Related Fields
            oCase.CH_ServiceType__c = component.get("v.selectedServiceType");
            oCase.AccountId = component.get("v.notLinkedToCustomer")?component.get("v.internalAccount").Id:component.get("v.selectedLegalEntity").Id;
            oCase.ContactId = component.get("v.selectedContact").Id;
            oCase.CH_EntitlementScriptVerificationComplete__c = component.get("v.entitlementScriptVerified");
            oCase.CH_EntitlementException__c = component.get("v.entitlementExceptionValue");
            oCase.CH_EntitlementStatus__c = null;
            //35156 - assign product related fields
            oCase.CH_Product_Module__c = component.get('v.selectedProductModule')?component.get('v.selectedProductModule').Id:null;
            oCase.CH_SW_Component__c = component.get('v.selectedSWComponent')?component.get('v.selectedSWComponent').Id:null;
            oCase.CH_SW_Release__c = component.get('v.selectedSWRelease')?component.get('v.selectedSWRelease').Id:null;
            oCase.CH_SW_Module__c = component.get('v.selectedSWModule')?component.get('v.selectedSWModule').Id:null;
            oCase.CH_SW_Build__c = component.get('v.selectedSWBuild')?component.get('v.selectedSWBuild').Id:null;
            oCase.CH_HW_Component__c = component.get('v.selectedHWComponent')?component.get('v.selectedHWComponent').Id:null;
            if(component.get("v.unhappyPath")) {
                oCase.AssetId = null;
                oCase.EntitlementId = null;
                oCase.BusinessHoursId = null;
                oCase.CH_NetworkElementAsset__c = null;
                oCase.ProductId = component.get("v.selectedProduct").Id;
                oCase.Country__c = component.get("v.selectedCountry");
                oCase.CH_Solution__c = component.get('v.selectedSolution')?component.get('v.selectedSolution').Id:null;
                oCase.CH_ProductVariant__c = component.get('v.selectedProductVariant')?component.get('v.selectedProductVariant').Id:null;
                oCase.CH_Product_Release__c = component.get('v.selectedProductRelease')?component.get('v.selectedProductRelease').Id:null;
				//35156
				/*oCase.CH_SW_Component__c=null;
                oCase.CH_SW_Release__c=null;
                oCase.CH_SW_Module__c=null;
                oCase.CH_SW_Build__c=null;
                oCase.CH_HW_Component__c=null;
				 oCase.CH_Product_Module__c=null;*/
            }
            else {
                var entitlement = component.get("v.selectedEntitlement"),
                    asset = component.get("v.selectedAsset"),
                    nea = component.get("v.selectedNEA");
                oCase.AssetId = asset.Id;
                oCase.ProductId = asset.Product2Id;
                oCase.EntitlementId = entitlement.Id;
                oCase.BusinessHoursId = component.get("v.selectedBusinessHours") ? component.get("v.selectedBusinessHours").Id : null;
                oCase.CH_NetworkElementAsset__c = nea ? nea.Id : null;
                oCase.CH_Solution__c = asset.CH_Solution__c ? asset.CH_Solution__c : (nea && nea.CH_Solution__c ? nea.CH_Solution__c : null);
                oCase.CH_ProductVariant__c = asset.CH_ProductVariant__c ? asset.CH_ProductVariant__c : (nea && nea.CH_ProductVariant__c ? nea.CH_ProductVariant__c : null);
				//35156
				/*oCase.CH_SW_Component__c=null;
                oCase.CH_SW_Release__c=null;
                oCase.CH_SW_Module__c=null;
                oCase.CH_SW_Build__c=null;
                oCase.CH_HW_Component__c=null;
				 oCase.CH_Product_Module__c=null;*/
				
                if(entitlement) {
                    oCase.CH_EntitlementException__c = entitlement.HasScript?
                        (oCase.CH_EntitlementScriptVerificationComplete__c?
                         'Entitlement Script Verified Manually':
                         'Entitlement Script Verification Required'):
                    'No Exception';
                }
            }
            helper.action(component, "c.doCase", {operationType: 'update', oCase: oCase, withoutSharing: true}, function(result){      
                helper.decrementActionCounter(component);
                if(result) {
                    helper.closeTab(component);
                } 
            });
        } 
    },
    // ProgressBar
    handleProgressBar : function(component) {
        var stageNumber = parseInt(component.get('v.stageNumber')),
            neaStageNumber = parseInt(component.get('v.neaStageNumber')),
            unhappyPath = component.get("v.unhappyPath"),
            entitlement = component.get("v.selectedEntitlement"),
            timeZoneScreen = (!unhappyPath && entitlement && component.get("v.timeZoneMissing")),
            stageTotal = (entitlement && entitlement.NEACount != 0) ? 4 : 3;
        stageNumber -= (timeZoneScreen && stageNumber > 5 ? 2 :0 ) + (unhappyPath && stageNumber > 4 ? 1 :0 );
        stageTotal += (timeZoneScreen ? 1 : 0) + (unhappyPath ? 1 : 0);
        component.set('v.stagePercentage', (neaStageNumber != -1 ? neaStageNumber : stageNumber)*100/stageTotal);
    },
    // Tab
    setTabIcon : function(component) {
        var workspaceAPI = component.find("ReentitlementWorkspace");
        workspaceAPI.getEnclosingTabId().then(function(response) {
            workspaceAPI.setTabLabel({
                tabId: response,
                label: "Re-Entitlement", //set label you want to set
                title: "Re-Entitlement"
            });
            workspaceAPI.setTabIcon({
                tabId: response,
                icon: "action:new_case", //set icon you want to set
                iconAlt: "Re-Entitlement" //set label tooltip you want to set
            });
            workspaceAPI.focusTab({
                tabId : response
            }); 
        })
    },
    closeTab : function(component) {
        var workspaceAPI = component.find("ReentitlementWorkspace");      
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            workspaceAPI.refreshTab({
                tabId: response.parentTabId,
                includeAllSubtabs: true
             });
            workspaceAPI.closeTab({tabId: response.tabId});
            setTimeout(() => $A.get('e.force:refreshView').fire(), 100);
        })
        .catch(function(error) {
            console.exception(error);
        });
    },    
    //
    action : function(component, method, args, callback, handleError) {
        this.incrementActionCounter(component);
        let action = component.get(method);
        if(args) action.setParams(args);
        action.setCallback(this,function(response) { 
            this.decrementActionCounter(component);
            var state = response.getState();
            if (state === "SUCCESS") {
                callback(response.getReturnValue(), null);
            } else if (state === "INCOMPLETE") {
                if(!handleError) console.warn(null, 'Incomplete');
                callback(errors);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if(!handleError){
                    console.exception(errors && errors[0] && errors[0].message?("Error message: " + errors[0].message):"Unknown error");
                    this.showToast('error', 'Error', errors && errors[0] && errors[0].message?errors[0].message:"Something went wrong");
                }
                callback(null, errors && errors[0] && errors[0].message?errors[0].message:"Something went wrong");
            }
        });
        $A.enqueueAction(action);
    },
    incrementActionCounter : function(component) {        
        var counter = component.get("v.actionCounter") + 1;
        if(counter === 1) {
            component.set("v.showSpinner", true);
        }
        component.set("v.actionCounter", counter);   
    },
    decrementActionCounter : function(component) {
        var counter = component.get("v.actionCounter") - 1;
        if(counter === 0) {
            component.set("v.showSpinner", false);
        }
        component.set("v.actionCounter", counter);  
    },
    // Generic Toast Message
    showToast: function(sType, title, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": sType
        });
        toastEvent.fire();
    }
})