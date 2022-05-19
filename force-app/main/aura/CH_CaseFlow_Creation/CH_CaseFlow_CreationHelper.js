({
    // Decide to display P20 fields
    checkP20Fields : function(component, stageNumber) { 
        if(stageNumber == 7){
            var entitlement = component.get("v.selectedEntitlement");
            if(component.get('v.selectedServiceType') === 'Internal Support' && entitlement && !component.get("v.unhappyPath")){
                this.action(component, "c.displayP20fields", { "entitlementId" : entitlement.Id}, function(result){
                    if(result) component.set("v.showP20fields", result);
                });
            }
            else component.set("v.showP20fields", false);
        }
	},
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
                    console.error(error);
                    let post = 'Failed to identify a Time Zone and a single Business Hours for Network Element Asset \'' + nea.Name + '\' Id: '+ nea.Id;
                    post += ' Address: \'' +nea.Address__r.Street+(nea.Address__r.City?' '+nea.Address__r.City:'');
                    post += (nea.Address__r.State?' '+nea.Address__r.State:'')+(nea.Address__r.Country?' '+nea.Address__r.Country:'')+'\'';
                    helper.action(component, 'c.postToBHChatterGroup', { post : post }, function(result, error2) { 
                        if(error2) console.error(error2);
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
                console.error(error);
                let post = 'Failed to identify a Time Zone and a single Business Hours for Network Element Asset \'' + nea.Name + '\' Id: '+ nea.Id;
                post += ' Address: N/A';
                helper.action(component, 'c.postToBHChatterGroup', { post : post }, function(result, error2) { 
                    if(error2) console.error(error2);
                });
                component.set('v.timeZoneMissing', true);    
            }
        }
    },
    setCaseBusinessHoursFromCLI : function(component, entitlement) {
        component.set('v.selectedBusinessHours', entitlement.ContractLineItem.CH_BusinessHour__r);
        component.set('v.timeZoneMissing', false);
        this.handleProgressBar(component);
    },
    calculateCaseBusinessHours : function(component, entitlement, timezone, fromNEA) {
        var helper = this,
            businessHourValues = entitlement.ContractLineItem.CH_BusinessHour__r.Name.split(' | ');
        if(businessHourValues.length != 4) {
            helper.setCaseBusinessHoursFromCLI(component);
            console.log("There is something wrong with the Business Hours from the Contract Line Item");
            //Ref: NOKIASC-36332 Replaced Error Message With Custom Label
            return helper.showToast('error', 'Error', $A.get("$Label.c.CH_Wrong_Business_Hours_from_the_Contract_Line_Item"));
        } 
        var businessHourName = entitlement.ContractLineItem.CH_CountryISO2__c + ' | ' + businessHourValues[1] + ' | ' + timezone + ' | ' + businessHourValues[3];
        helper.action(component, "c.getBusinessHours", { 'businessHourName' : businessHourName}, function(result, error){
            if(!error && result) {
                component.set('v.selectedBusinessHours', result);
            }
            else helper.setCaseBusinessHoursFromCLI(component, entitlement);
            if(!fromNEA) component.set('v.stageNumber', 7); 
        });
    },
    setCaseRecordTypeId : function(component, event) {
        this.action(component, "c.getStandardCaseRecordTypeId", null, function(result){
            component.set('v.recordTypeId', result);
        });
    },
    // ProgressBar
    handleProgressBar : function(component) {
        var stageNumber = parseInt(component.get('v.stageNumber')),
            neaStageNumber = parseInt(component.get('v.neaStageNumber')),
            unhappyPath = component.get("v.unhappyPath"),
            entitlement = component.get("v.selectedEntitlement"),
            timeZoneScreen = (!unhappyPath && entitlement && component.get("v.timeZoneMissing")),
            stageTotal = (entitlement && entitlement.NEACount != 0) ? 5 : 4;
        stageNumber -= (timeZoneScreen && stageNumber > 5 ? 2 :0 ) + (unhappyPath && stageNumber > 4 ? 1 :0 );
        stageTotal += (timeZoneScreen ? 1 : 0) + (unhappyPath ? 1 : 0);
        component.set('v.stagePercentage', (neaStageNumber != -1 ? neaStageNumber : stageNumber)*100/stageTotal);
    },
    // Tab
    setTabIcon : function(component) {
        var workspaceAPI = component.find("CreateCaseWorkspace");
        workspaceAPI.getEnclosingTabId().then(function(response) {
            workspaceAPI.setTabLabel({
                tabId: response,
                label: "Create Case", //set label you want to set
                title: "Create Case"
            });
            workspaceAPI.setTabIcon({
                tabId: response,
                icon: "action:new_case", //set icon you want to set
                iconAlt: "Create Case" //set label tooltip you want to set
            });
            workspaceAPI.focusTab({
                tabId : response
            }); 
        })
    },
    openCaseTab : function(component, newCaseURL,caseId) {
        var workspaceAPI = component.find("CreateCaseWorkspace");
        workspaceAPI.openTab({
            url: newCaseURL,
            focus: true
        }).then(function(response) {
            workspaceAPI.openSubtab({
                parentTabId: response,
                recordId: caseId,
                pageReference: {
                    "type": "standard__component",
                    "attributes": {
                        "componentName": "c__CH_CA_Initial_Assignment_Page"
                    },
                    "state": {
                        "uid": "1",
                        "c__recordId": caseId
                    }
                },
                focus: true
            });
        }).then(function(response) {
            var focusedTabId = response;
            workspaceAPI.setTabLabel({
                tabId: focusedTabId,
                label: "Initial Assignment"
            });
        })
        .catch(function(error) {
            console.error(error);
        });
    },
    closeTab : function(component) {
        var workspaceAPI = component.find("CreateCaseWorkspace");        
        workspaceAPI.getEnclosingTabId().then(function(response) {
            workspaceAPI.closeTab({
                tabId : response
            })
            .catch(function(error) {
                console.error(error);
            });
        })
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
                    //console.error(errors && errors[0] && errors[0].message?("Error message: " + errors[0].message):"Unknown error");
                    this.showToast('error', 'Error', errors && errors[0] && errors[0].message?errors[0].message:"Something went wrong");
                }
                callback(null, errors && errors[0] && errors[0].message?errors[0].message:"Something went wrong");
            }
        });
        $A.enqueueAction(action);
    },
    recordEditFormsToObject : function(component, values) {
		let originvalue= component.find("originBox").get("v.value"); //Nokiasc-32568
        let result = {}, fieldsNotFilled= [];
        for(let i = 0; i < values.length; i++){
            let fields = component.find(values[i].id).get("v.body");
            for(let n = 1; n < fields.length; n++){
                if(values[i].required && !fields[n].get('v.value')
                   || values[i].required && fields[n].get('v.value') === ''){
                    fieldsNotFilled = [...fieldsNotFilled, fields[n].get('v.fieldName')];
                    $A.util.addClass(fields[n], 'redOutLine');
                }
                else $A.util.removeClass(fields[n], 'redOutLine');
                result[fields[n].get('v.fieldName')]= fields[n].get('v.value');
            }
        }
        if(fieldsNotFilled.length > 0){
            result= { error : "All required fields must be completed.", fields: fieldsNotFilled.join(', ') };
        }
		if(fieldsNotFilled.length == 0 && originvalue == "S2S"){
            result= { error : "S2S Origin cannot be selected during Creation."};// Nokiasc-32568
        }
        return result;
    },
    validateEmail : function(email) {
        var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        return re.test(String(email).toLowerCase());
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
    },
    //NOKIASC-37147    
    setSiteFromFIRAnswers : function(component, event) {
        let siteSequence = $A.get("$Label.c.CH_FIRQuestionToSiteID");
        let siteQunSeq = siteSequence.split(',');
        let firAnswers = component.get('v.showFIR') ? component.get('v.firAnswers') : [];
        let siteId, nmsId='', neaId='';
        if(firAnswers.length != 0) {
            for(let i = 0, len = firAnswers.length; i < len; i++) {
                if(firAnswers[i].SequenceNumber__c == siteQunSeq[0]&& firAnswers[i].CustomerAnswer__c.length > 0) {
                    nmsId = firAnswers[i].CustomerAnswer__c;
                }
                if(firAnswers[i].SequenceNumber__c == siteQunSeq[1]&& firAnswers[i].CustomerAnswer__c.length > 0) {
                    neaId = firAnswers[i].CustomerAnswer__c;
                }
            }
            if((nmsId !=''&&nmsId !='undefined') && (neaId != ''&&neaId != 'undefined')){
                siteId = nmsId+'.'+neaId;
            }else if((nmsId != ''&&nmsId !='undefined') && (neaId == ''||neaId != 'undefined')){
                siteId = nmsId;
            }else if ((nmsId != ''||nmsId !='undefined') && (neaId == ''&&neaId != 'undefined')){
                siteId = neaId;
            }
        }
        return (siteId!='' && siteId!= 'undefined')?siteId:'';
    },
})