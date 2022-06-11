({
	init : function(component, event, helper) {
        // Set legal account displayed fields
        component.set('v.legalEntityColumns', [
            {label: 'Name', fieldName: 'Name', sortable: 'true', searchable: 'true', type: 'text', typeAttributes: {
                label: { fieldName: 'Name' }
            }},
            {label: 'Country', fieldName: 'Country__c', sortable: 'true', searchable: 'true', type: 'text'},
            {label: 'City', fieldName: 'BillingCity', sortable: 'true', searchable: 'true', type: 'text'},
            {label: 'Street', fieldName: 'BillingStreet', sortable: 'true', searchable: 'true', type: 'text'},
            {label: 'Operational Customer Name', fieldName: 'OperationalCustomerName__c', sortable: 'true', type: 'text'},
            {label: 'Account Number', fieldName: 'AccountNumber', sortable: 'true', searchable: 'true', type: 'text'},
            {label: 'Parent Account', fieldName: 'CH_ParentAccountName__c', sortable: 'true', searchable: 'true', type: 'text'},
            {label: 'Account Name Alias', fieldName: 'CH_Account_Name_Alias__c', searchable: 'true', type: 'hidden'}
        ]);
        // Set Asset displayed fields
        component.set('v.assetColumns', [
            {label: 'Product', fieldName: 'ProductName', sortable: 'true', searchable: 'true', type: 'text', typeAttributes: {
                label: { fieldName: 'ProductName' }
            }},
            {label: 'Solution', fieldName: 'SolutionName', sortable: 'true', searchable: 'true', type: 'text', typeAttributes: {
                label: { fieldName: 'SolutionName' }
            }},
            {label: 'Product Variant', fieldName: 'VariantName', sortable: 'true', searchable: 'true', type: 'text', typeAttributes: {
                label: { fieldName: 'VariantName' }
            }},
            {label: 'Product Release', fieldName: 'ReleaseName', sortable: 'true', searchable: 'true', type: 'text', typeAttributes: {
                label: { fieldName: 'ReleaseName' }
            }},
            {label: 'Country', fieldName: 'CH_CountryISOName__c', sortable: 'true', searchable: 'true', type: 'text'},
            {label: 'Product Description', fieldName: 'ProductDescription', searchable: 'true', type: 'hidden'},
            {label: 'Product Code', fieldName: 'ProductCode', searchable: 'true', type: 'hidden'}
        ]);
        // Set Entitlement displayed fields
        component.set('v.entitlementColumns', [
            {label: 'Entitlement Name', fieldName: 'Name', sortable: 'true', searchable: 'true', type: 'text', typeAttributes: {
                label: { fieldName: 'Name' }
            }},
            {label: 'Contract Name', fieldName: 'ContractName', sortable: 'true', searchable: 'true', type: 'text', typeAttributes: {
                label: { fieldName: 'ContractName' }
            }},
            {label: 'Project', fieldName: 'ProjectName', sortable: 'true', searchable: 'true', type: 'text'},  
            {label: 'NEA Count', fieldName: 'NEACount', sortable: 'true', searchable: 'true', type: 'number'}
        ]);
        // Set Network Element Assets displayed fields
        component.set('v.neaColumns', [
            {label: 'Network Element ID', fieldName: 'CH_NetworkElementID__c', sortable: 'true', searchable: 'true', type: 'text'},
            {label: 'Asset Name', fieldName: 'Name', sortable: 'true', searchable: 'true', type: 'text', typeAttributes: {
                label: { fieldName: 'Name' }
            }},
            {label: 'Product', fieldName: 'ProductName', sortable: 'true', searchable: 'true', type: 'text', typeAttributes: {
                label: { fieldName: 'ProductName' }
            }},
            {label: 'Solution', fieldName: 'SolutionName', sortable: 'true', searchable: 'true', type: 'text', typeAttributes: {
                label: { fieldName: 'SolutionName' }
            }},
            {label: 'Product Variant', fieldName: 'VariantName', sortable: 'true', searchable: 'true', type: 'text', typeAttributes: {
                label: { fieldName: 'VariantName' }
            }},
            {label: 'Product Release', fieldName: 'ReleaseName', sortable: 'true', searchable: 'true', type: 'text', typeAttributes: {
                label: { fieldName: 'ReleaseName' }
            }},
            {label: 'Address', fieldName: 'Address', sortable: 'true', searchable: 'true', type: 'text'},
            {label: 'Lab', fieldName: 'CH_LabEnvironment__c', sortable: 'true', type: 'boolean'},        
            {label: 'Country', fieldName: 'CH_CountryISOName__c', searchable: 'true', type: 'hidden'}
        ]);
        helper.setContactNameAndId(component, event);
        helper.setCaseRecordTypeId(component, event);
        helper.setCaseOwnerId(component, event);
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
            case 'incrementActionCounter':
                helper.incrementActionCounter(component);
                break;
            case 'decrementActionCounter':
                helper.decrementActionCounter(component); 
                break;
            case 'scriptVerification':
                component.set('v.entitlementScriptVerified', event.getParam("object"));
                break;
            case 'notListed':
                break;
            case 'noRecordFound':
                break;
            case 'recordFound':
                break;
            case 'notLinkedToCustomer':
                break;
            case 'scriptVerification':
                break;
            case 'onchange':
                var object = JSON.parse(event.getParam("object") || {});
                if(target === 'FIR') {
                    component.set('v.completedFIR', object.completed);
            		component.set('v.firAnswers', object.answers);
                }
                break;
            default:
                var object = JSON.parse((event.getParam("object")==null?null:event.getParam("object")));
                if(target === 'NEA') {
                   component.set('v.provisoryNEA', object);
                   if(parseInt(component.get("v.neaStageNumber")) == -1)
                       component.set('v.selected'+target.split(' ').join(''), object);
                }
                else component.set('v.selected'+target.split(' ').join(''), object);
                if(target === 'Asset') {
                    let mobileProduct = object && object.Product2 ? object.Product2.CH_Business_Group__c.indexOf('Mobile Networks') != -1 : false,
                        severity = component.get('v.preSeverity');
                    component.set('v.showFIR', mobileProduct && (severity === 'Minor' || severity === 'Major'));
                }
                if(message === 'next') { helper.next(component, null, helper); }
                else helper.handleProgressBar(component);
                break;
        }        
    },
	startCaseCreation : function(component, event, helper) {
        var oCase = helper.recordEditFormsToObject(component, [
                {id: 'descriptionField', recordEditForm: false, required: true},
                {id: 'requiredFields', recordEditForm: true, required: true}
        	]), errorMessage = (oCase.error?oCase.error:(oCase.Severity__c==='Critical'?'*Severity cannot be set to Critical.':''));
        if(errorMessage === '') {
            component.set('v.stageNumber', 1);
            component.set('v.preSeverity', oCase.Severity__c);
            component.set('v.preDescription', oCase.Description);
        }
        component.set('v.save', errorMessage);
    },
    //NOKIASC-33498-Add knowledge article search for article section
    knowledgeSearch : function(component, event, helper) {
        if(event.keyCode == 13){
            helper.getArticles(component, event,helper);
        }	
    },
    //NOKIASC-33498-Add filter in article search section
    filterArticleEntities : function(component, event, helper) {        
        helper.incrementActionCounter(component);            
        let text = component.get("v.FilterText");
        var data = component.get("v.allArticles"), results = data, regex;
        try {
            regex = new RegExp(text, "i");
            results = data.filter(
                row => regex.test(row.Title) || 
                regex.test(row.CH_KB_Products__c) || 
                regex.test(row.Description__c) || 
                regex.test(row.CH_PurposeRequired__c) ||
                regex.test(row.CH_InformationForInternalAudiences__c) ||
                regex.test(row.CH_QuestionOrProductDescription__c) ||
                regex.test(row.CH_AnswerOrResolution__c) ||
                regex.test(row.CH_ProblemDescriptionRequired__c)
            );
        }
        catch(e) { results = data; }
        component.set("v.allFilterArticles", results);
        component.set('v.articleSearchActive', true);
        helper.initializationPagination(component, helper);
        helper.decrementActionCounter(component);        
    },
    //NOKIASC-33498-Article data table pagination next button click
    onNext : function(component, event, helper) {        
        var pageNumber = component.get("v.currentPageNumber");     
        component.set("v.currentPageNumber", pageNumber+1);
        helper.initializationPagination(component, helper);
        component.set("v.PreviousPageNumber",0);                
        
    },
    //NOKIASC-33498-Article data table pagination Previous button click
    onPrev : function(component, event, helper) {        
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber-1);  
        helper.initializationPagination(component, helper);
        if(component.get("v.currentPageNumber") !=component.get("v.totalPages")){
            component.set("v.NextPageNumber",0);
        }              
    }, 
    //NOKIASC-33498-Article data table page size change handle
    onPageSizeChange: function(component, event, helper) {
        component.set("v.currentPageNumber",1);            
        helper.initializationPagination(component, helper);
    },
    //NOKIASC-33498-Article data table pagination First button click
    onFirst : function(component, event, helper) {        
        component.set("v.currentPageNumber", 1);
        helper.initializationPagination(component, helper);
    },
    //NOKIASC-33498-Article data table pagination Last button click
    onLast : function(component, event, helper) {        
        component.set("v.currentPageNumber", component.get("v.totalPages"));
        helper.initializationPagination(component, helper);
        component.set("v.PreviousPageNumber",0);
    },
    next : function(component, event, helper) {
        helper.next(component, event, helper);
	},
	previous : function(component, event, helper) {
        helper.previous(component, event, helper);
    },
    saveCaseHandler : function(component, event, helper) {
        if(!component.get("v.showSpinner")){
            helper.incrementActionCounter(component); // Increment Action Counter
            var newCase = helper.recordEditFormsToObject(component, [
                    {id: 'preCaseDetailFields', recordEditForm: true, required: true},
                    {id: 'reqCaseDetailFields', recordEditForm: true, required: true},
                    {id: 'notReqCaseDetailFields', recordEditForm: true, required: false},
                    {id: 'emailCaseDetailFields', recordEditForm: true, required: false}
                ]),
                errorMessage = (newCase.error?newCase.error:(newCase.Severity__c==='Critical'?'*Severity cannot be set to Critical.':''));
            //Email Verification
            if(newCase.CH_AdditionalContacts__c && newCase.CH_AdditionalContacts__c.length > 0){
                newCase.CH_AdditionalContacts__c = newCase.CH_AdditionalContacts__c.replace(/\s+/g, '');
                newCase.CH_AdditionalContacts__c = newCase.CH_AdditionalContacts__c.replace(/\,/g, ';');
                newCase.CH_AdditionalContacts__c.split(';').forEach( (x) => {
                    if(!helper.validateEmail(x) && x.length != 0) {
                        errorMessage = x+" is not a valid email address.";
                        return false; 
                    }
                });
            }
            //
            if(errorMessage === '') {
				let siteIdFromFIRAnswers = helper.setSiteFromFIRAnswers(component, event);//NOKIASC-37147
                const ndaKey = component.get('v.ndaKey');
                newCase.ContactId = component.get("v.selectedContact").Id;
                newCase.AccountId = component.get("v.selectedLegalEntity").Id;
                newCase.ProductId = component.get("v.selectedAsset").Product2Id;
                newCase.RecordTypeId = component.get("v.recordTypeId");
                newCase.OwnerId = component.get("v.portalOwnerId");
                newCase.Origin= ndaKey ? 'Nokia Digital Assistant' : 'Portal';
                newCase.CH_Outage__c = 'No';
                newCase.BusinessHoursId = component.get("v.selectedBusinessHours") ? component.get("v.selectedBusinessHours").Id : null;
                var entitlement = component.get("v.selectedEntitlement"),
                    asset = component.get("v.selectedAsset"),
                    nea = component.get("v.selectedNEA");
                newCase.AssetId = asset.Id;
                newCase.EntitlementId = entitlement.Id;
                newCase.CH_NetworkElementAsset__c = nea?nea.Id:null;
                newCase.CH_Solution__c = asset.CH_Solution__c ? asset.CH_Solution__c : (nea && nea.CH_Solution__c ? nea.CH_Solution__c : null);
                newCase.CH_ProductVariant__c = asset.CH_ProductVariant__c ? asset.CH_ProductVariant__c : (nea && nea.CH_ProductVariant__c ? nea.CH_ProductVariant__c : null);
                //35156 - assign product related fields
                newCase.CH_Product_Module__c = component.get('v.selectedProductModule')?component.get('v.selectedProductModule').Id:null;
                newCase.CH_SW_Component__c = component.get('v.selectedSWComponent')?component.get('v.selectedSWComponent').Id:null;
                newCase.CH_SW_Release__c = component.get('v.selectedSWRelease')?component.get('v.selectedSWRelease').Id:null;
                newCase.CH_SW_Module__c = component.get('v.selectedSWModule')?component.get('v.selectedSWModule').Id:null;
                newCase.CH_SW_Build__c = component.get('v.selectedSWBuild')?component.get('v.selectedSWBuild').Id:null;
                newCase.CH_HW_Component__c = component.get('v.selectedHWComponent')?component.get('v.selectedHWComponent').Id:null;
                newCase.CH_Site__c = component.get('v.preSite') ? component.get('v.preSite') : siteIdFromFIRAnswers;
                if(entitlement){
                    debugger;
                    console.log("entitlement.ContractScript : "+entitlement.HasScript);
                    console.log("entitlement.LineItemScript : "+entitlement.lineItemScript);
                    if(entitlement.HasScript && entitlement.HasScript.length != 0){
                    // if((entitlement.ContractScript && entitlement.ContractScript.length != 0) || (entitlement.LineItemScript && entitlement.LineItemScript.length != 0)) {
                        newCase.CH_EntitlementException__c = 'Entitlement Script Verification Required';
                    } else {
                        newCase.CH_EntitlementException__c = 'No Exception';
                    }
                }
                helper.action(component, "c.doCase", {operationType: 'insert', oCase: newCase, withoutSharing: true}, function(caseId, error){
                    helper.decrementActionCounter(component);
                    if(error) { errorMessage = error; }
                    else if(!caseId) {
                        console.log("Unknown error");
                        helper.decrementActionCounter(component);
                        helper.showToast('error', 'Error', "Something went wrong");
                    } else if(caseId){
                        helper.action(component, "c.getPortalRoutingCases", { "caseId" : caseId}, (res, err) => (err?console.log(err):null), true);
                        let firAnswers = component.get('v.showFIR') ? component.get('v.firAnswers') : [];
                        if(firAnswers.length != 0) {
                            helper.action(component, "c.submitFIRAnswers", {
                                oFIRAnswers: firAnswers.map((cur) => (cur.Case__c = caseId, cur.Label__c = cur.Name, delete cur.Name, cur))
                            }, (res, err) => { /* Do Nothing */ });
                        }
                        //NOKIASC-35894
                        if(ndaKey) {
                            helper.action(component, "c.sendCaseInfoToNDA", { caseId: caseId, ndaKey: ndaKey }, (res, err) => { /* Do Nothing */ });
                        }
                        var href = window.location.href.split('/');
                        window.location.href = (href.pop(), href.join('/')+'/case/'+caseId);
                        helper.decrementActionCounter(component);
                    }
                });	
            }
            else helper.decrementActionCounter(component);
            component.set("v.save", errorMessage);
        }
	},
    handleBHCalculation : function(component, event, helper) {
        let entitlement = component.get('v.selectedEntitlement');
        if(entitlement != null && entitlement != '') helper.setCaseBusinessHours(component, entitlement);
    },
    handleTimeZoneConfirmation : function(component, event, helper) {
        helper.calculateCaseBusinessHours(component, component.get('v.selectedEntitlement'), component.get("v.selectedTimeZone"));
    },
    cancel : function(component, event, helper) {
        if(confirm('All the entered details will be Discarded . Are you sure you want to cancel?')) {
            var href = window.location.href.split('/')
            href.pop();
            window.location.href= href.join('/');            
        }
        else return false;
    }
})