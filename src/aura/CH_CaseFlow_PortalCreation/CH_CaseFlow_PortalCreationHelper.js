({
    //NOKIASC-33498-Get Article data on press enter
    getArticles : function(component, event,helper) {
        var searchText=  component.find("descriptionField").get("v.value")
        if(searchText.length>=2){
            this.action(component, "c.getArticles", {withoutSharing : true,searchText:searchText}, function(result){
                if(result){
                    component.set("v.currentPageNumber",1);                
                    component.set("v.totalRecords", result[0].length);
                    component.set('v.allArticles', result[0]);
                    component.set("v.allFilterArticles", result[0]);
                    component.set('v.articleSearchActive', true);
                    helper.initializationPagination(component, helper);
                } 
            });  
        }
        else{
            return helper.showToast('error', 'Error', "Your search term must have 2 or more characters."); 
        }
        
    },
    //NOKIASC-33498- initialize Pagination for article data
    initializationPagination : function(component, helper) {
        var data = [];
        var pageNumber = component.get("v.currentPageNumber");
        var pageSize = component.get("v.pageSize");
        var allData = component.get("v.allFilterArticles");
        var x = (pageNumber-1)*pageSize;
        //creating data-table data
        for(; x<(pageNumber)*pageSize; x++){
            if(allData[x]){
                data.push(allData[x]);
            }
        }
        var count = component.get("v.totalRecords");         
        component.set("v.countofRecords",allData.length);
        if(component.get("v.currentPageNumber")==1){
            component.set("v.PreviousPageNumber",1);
            component.set("v.NextPageNumber",0);
        }
        component.set("v.totalPages", Math.ceil(allData.length/component.get("v.pageSize")));
        console.log('currentPageNumber:'+component.get("v.currentPageNumber")+'totalPages:'+component.get("v.totalPages"));
        if(component.get("v.currentPageNumber") ==component.get("v.totalPages")){
            component.set("v.NextPageNumber",1);
        }
        component.set("v.filteredArticles", data);        
    },
    setContactNameAndId : function(component, event) {
        this.action(component, "c.getCurrentUserContactDetails", null, function(result){
            component.set('v.selectedContact', result);
        });
    },
    setCaseRecordTypeId : function(component, event) {
        this.action(component, "c.getStandardCaseRecordTypeId", null, function(result){
            component.set('v.recordTypeId', result);
        });
    },
    setCaseOwnerId : function(component, event) {
        this.action(component, "c.getVirtualPortalAttendantId", null, function(result){
            component.set('v.portalOwnerId', result);
        });	
    },
    redirectFIR : function(component, firDescription) {
        let preDescription = component.get('v.preDescription');
        const showFIR = component.get("v.showFIR"),
              containsFIR = this.descriptionContainsFIR(component,preDescription),
              blankFIR = this._FIRDescription == null || this._FIRDescription.length == 0;
        if(firDescription && (blankFIR || containsFIR)) {
            let firAnswers = component.get('v.firAnswers'), newFIRDescription = [];
            for(let i = 0, len = firAnswers.length; i < len; i++) {
                if(firAnswers[i].PicklistAnswer__c.length > 0 || firAnswers[i].CustomerAnswer__c.length > 0) {
                    newFIRDescription = [...newFIRDescription, '<p>' + firAnswers[i].Name + (firAnswers[i].PicklistAnswer__c.length > 0?' ' + firAnswers[i].PicklistAnswer__c:'')
                    + (firAnswers[i].CustomerAnswer__c.length > 0?': ' + firAnswers[i].CustomerAnswer__c:'')  + '</p>'];
                }
            }
            if(blankFIR) { preDescription += '<p><br></p><p><br></p>' + newFIRDescription.join('<p><br></p>'); }
            else if(containsFIR) {
                for(let i = 0, len = this._FIRDescription.length; i < len; i++) {
                    preDescription = preDescription.replace(this._FIRDescription[i], newFIRDescription[i]);
                }
            }
            this._FIRDescription = newFIRDescription;
        }
        else if(!showFIR && containsFIR) {
            for(let i = 0, len = this._FIRDescription.length; i < len; i++) {
                preDescription = preDescription.replace(this._FIRDescription[i], '');
            }
            this._FIRDescription = [];
        }
        component.set('v.preDescription', preDescription);
        return (showFIR && firDescription != true ? (this.checkFIRCopy(component,preDescription), 6) : 7);
    },
    descriptionContainsFIR : function(component, description) {
        let res = false;
        if(this._FIRDescription != null && this._FIRDescription.length != 0) {
        	res = true;
            for(let i = 0, len = this._FIRDescription.length; i < len; i++) {
                if(!res) break;
                res = res && description.indexOf(this._FIRDescription[i]) != -1;
            }
        }
        return res;
    },
    checkFIRCopy : function(component, description) {
        component.set('v.disabledFIRCopy', (this._FIRDescription == null || this._FIRDescription.length == 0) ? false : !this.descriptionContainsFIR(component, description));
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
        let helper = this;
        helper.incrementActionCounter(component);
        component.set('v.timeZoneMissing', false);
        this.handleProgressBar(component);
        var fullAddress = {
            address 	: nea.Address__r.Street,
            city 		: nea.Address__r.City,
            postalCode 	: '',
            state 		: nea.Address__r.State,
            country 	: nea.Address__r.Country
        };
        if(fullAddress != '') {
            helper.action(component, 'c.getTimeZone', fullAddress, function(location, error) {
                helper.decrementActionCounter(component);
                if(error || location === null) {
                    console.exception(error);
                    let post = 'Failed to identify a Time Zone and a single Business Hours for Network Element Asset \'' + nea.Name + '\' Id: '+ nea.Id;
                    post += ' Address: \'' +nea.Address__r.Street+(nea.Address__r.City?' '+nea.Address__r.City:'');
                    post += (nea.Address__r.State?' '+nea.Address__r.State:'')+(nea.Address__r.Country?' '+nea.Address__r.Country:'')+'\'';
                    helper.action(component, 'c.postToBHChatterGroup', { post : post }, function(result, error2) { 
                        if(error2) console.exception(error2);
                    });
                    return helper.setCaseBusinessHoursFromCLI(component, entitlement);                 
                }
                //
                helper.calculateCaseBusinessHours(component, entitlement, location['timezone'], true);
            }, true);
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
            return helper.showToast('error', 'Error', "There is something wrong with the Business Hours from the Contract Line Item");
        } 
        var businessHourName = entitlement.ContractLineItem.CH_CountryISO2__c + ' | ' + businessHourValues[1] + ' | ' + timezone + ' | ' + businessHourValues[3];
        helper.action(component, "c.getBusinessHours", { 'businessHourName' : businessHourName}, function(result, error){
            if(!error && result) {
                component.set('v.selectedBusinessHours', result);
            }
            else helper.setCaseBusinessHoursFromCLI(component, entitlement);
            if(!fromNEA) component.set('v.stageNumber', 6);
        });
    },
    // ProgressBar
    handleProgressBar : function(component) {
        var stageNumber = parseInt(component.get('v.stageNumber')),
            neaStageNumber = parseInt(component.get('v.neaStageNumber')),
            entitlement = component.get("v.selectedEntitlement"),
            timeZoneScreen = (entitlement && component.get("v.timeZoneMissing")),
            stageTotal = (entitlement && entitlement.NEACount != 0) ? 5 : 4;
        stageNumber -= (timeZoneScreen && entitlement.NEACount == 0 && stageNumber >= 5 ? 1 : 0);
        stageTotal += (timeZoneScreen ? 1 : 0);
        if(component.get('v.showFIR')) {
            stageTotal++;
            if(stageNumber >= 6) { stageNumber-=2; }
        }
        component.set('v.stagePercentage', (neaStageNumber != -1 ? neaStageNumber : stageNumber)*100/stageTotal);
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
                    console.error(method +' : '+(errors && errors[0] && errors[0].message?("Error message: " + errors[0].message):"Unknown error"));
                    this.showToast('error', 'Error', errors && errors[0] && errors[0].message?errors[0].message:"Something went wrong");
                }
                callback(null, errors && errors[0] && errors[0].message?errors[0].message:"Something went wrong");
            }
        });
        $A.enqueueAction(action);
    },
    recordEditFormsToObject : function(component, values) {
        let result = {}, fieldsNotFilled= [];
        for(let i = 0; i < values.length; i++){
            if(values[i].recordEditForm){
                let fields = component.find(values[i].id).get("v.body");
                for(let n = 0; n < fields.length; n++){
                    if(values[i].required && !fields[n].get('v.value')
                       || values[i].required && fields[n].get('v.value') === ''){
                        fieldsNotFilled = [...fieldsNotFilled, fields[n].get('v.fieldName')];
                        $A.util.addClass(fields[n], 'redOutLine');
                    }
                    else $A.util.removeClass(fields[n], 'redOutLine');
                    result[fields[n].get('v.fieldName')]= fields[n].get('v.value');
                }                
            }
            else {
                let field = component.find(values[i].id);
                if(values[i].required && !field.get('v.value')
                   || values[i].required && field.get('v.value') === '') {
                        fieldsNotFilled = [...fieldsNotFilled, field.get('v.name')];
                        $A.util.addClass(field, 'redOutLine');
                } 
                else $A.util.removeClass(field, 'redOutLine');
                result[field.get('v.name')]= field.get('v.value');
            }
        }
        if(fieldsNotFilled.length > 0){
            result= { error : "*All required fields must be completed.", fields: fieldsNotFilled.join(', ') };
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
    }
})