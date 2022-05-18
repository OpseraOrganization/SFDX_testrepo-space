({
    doInit : function(component, event, helper) {
       
        // Prepare the action to load account record
        var action = component.get("c.getContact");
        action.setParams({"contactId": component.get("v.recordId")});

        // Configure response handler
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") { 
                component.set("v.con", response.getReturnValue());
                console.log('contact data: ' + JSON.stringify(response.getReturnValue()));
                component.set("v.accountId",response.getReturnValue().AccountId);
                component.set("v.defaultAccountRole",response.getReturnValue().AccountId);
                helper.setDefaultAccountRole(component, response.getReturnValue().Account.BusinessPartnerRole__c);////ft-128
            } else {
                console.log('Problem getting account, response state: ' + state);
            }
        });
        $A.enqueueAction(action);
        
        var actionCampaign = component.get("c.getCampaign");
        actionCampaign.setParams({"contactId": component.get("v.recordId")});
        console.log('Checking......');  
        actionCampaign.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                console.log('Campaign Data: '+ JSON.stringify(response.getReturnValue()));
                var campdata = response.getReturnValue();
                component.set("v.cmpg", response.getReturnValue());
                if(campdata != null){
                    component.set("v.has_camp",true);
                }
            } else {
                console.log('Problem getting account, response state: ' + state);
            }
        });
        $A.enqueueAction(actionCampaign);
        
        var actionCurrencies = component.get("c.getAllCurrencyValues");
        console.log('Checking......');  
        actionCurrencies.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                
                var currencies = [];
                var currencyList = response.getReturnValue();
                console.log('currencyValues--------------: '+ JSON.stringify(currencyList));
                for (var key in currencyList ) {
                    currencies.push({value:currencyList[key], key:key});
                }
                component.set("v.currencyValues", currencies);
                console.log('currencies--------------: '+ JSON.stringify(currencies));
                
               //component.set("v.currencyValues", response.getReturnValue());
            } else {
                console.log('Problem getting account, response state: ' + state);
            }
        });
        $A.enqueueAction(actionCurrencies);

		var actionOppTypes = component.get("c.getAllOppTypesValues");
        console.log('Checking actionOppTypes......');  
        actionOppTypes.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                
                var oppTypes = [];
                var oppTypeList = response.getReturnValue();
                console.log('oppTypeList--------------: '+ JSON.stringify(oppTypeList));
                for (var key in oppTypeList ) {
                    oppTypes.push({value:oppTypeList[key], key:key});
                }
                component.set("v.oppTypes", oppTypes);
                var oppyTypeCmp = component.find("opportunity_type");
                oppyTypeCmp.set("v.value",oppTypes[0].value);
                console.log('oppTypes--------------: '+ JSON.stringify(oppTypes));
                
               //component.set("v.currencyValues", response.getReturnValue());
            } else {
                console.log('Problem getting account, response state: ' + state);
            }
        });
        $A.enqueueAction(actionOppTypes);
        
        var actionContractSigns = component.get("c.getAllContractSigningValues");
        console.log('Checking actionContractSigns......');  
        actionContractSigns.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                
                var contractSigningValues = [];
                var contractSigningEntities = response.getReturnValue();
                console.log('contractSigningEntities--------------: '+ JSON.stringify(contractSigningEntities));
                for (var key in contractSigningEntities ) {
                    contractSigningValues.push({value:contractSigningEntities[key], key:key});
                }
                component.set("v.contractSigningValues", contractSigningValues);
                console.log('contractSigningValues--------------: '+ JSON.stringify(contractSigningValues));
                
               //component.set("v.currencyValues", response.getReturnValue());
            } else {
                console.log('Problem getting account, response state: ' + state);
            }
        });
        $A.enqueueAction(actionContractSigns);
        
        var actionAccountRoleValues = component.get("c.getAllAccountRoleValues");
        console.log('Checking actionAccountRoles......');  
        actionAccountRoleValues.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                
                var accountRoleValues = [];
                var accountRoles = response.getReturnValue();
                console.log('accountRoles--------------: '+ JSON.stringify(accountRoles));
                for (var key in accountRoles ) {
                    accountRoleValues.push({value:accountRoles[key], key:key});
                }
                component.set("v.accountRoleValues", accountRoleValues);
                console.log('accountRoleValues--------------: '+ JSON.stringify(accountRoleValues));
                component.set("v.accountRoleMap", response.getReturnValue());
            } else {
                console.log('Problem getting account, response state: ' + state);
            }
        });
        $A.enqueueAction(actionAccountRoleValues);
        
        var actionGetIsoCode = component.get("c.getCurrentUserISOCode");
        
        actionGetIsoCode.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                //var oppyItem = component.get("v.newOpporunity");
                var currencyCmp = component.find("opportunity_currency");
                currencyCmp.set("v.value",response.getReturnValue());
            } else {
                console.log('Problem getting currencyIsoCode, response state: ' + state);
            }
        });
        $A.enqueueAction(actionGetIsoCode);
    },
    
    saveIndirectOpportunity: function(component, event, helper) {
        	var btn = event.getSource();
			btn.set("v.disabled",true);
        	helper.validateRequiredFields( component );
        	
            if(component.get("v.has_error") == true ){
                document.getElementById('scrollable_div').scrollTop = 0;
                window.setTimeout(
                    $A.getCallback(function() {
                        component.set("v.has_error", false);
                    }), 10000
                );
                btn.set("v.disabled",false);
                return;
                
            }
        
        	 
            // Prepare the action to create the new Opportunity
            var opp = component.get("v.newOpporunity");
        	console.log('New Opportunity to display: '+ JSON.stringify(opp));
        	
        	var con = component.get("v.con");
        	console.log('New Contact to display: '+ JSON.stringify(con));
        
        	var accId = component.get("v.accountId");
        	console.log('New Account to display: '+ JSON.stringify(accId));
        
        	var endCustomer = component.get("v.selectedLookUpRecordAccount");
       		console.log('Lookup Id: '+ JSON.stringify(endCustomer));
        
        	
	    	
        	var saveOpportunityAction = component.get("c.saveIndirectOpportunityWithContact");
            saveOpportunityAction.setParams({
                "oppty": component.get("v.newOpporunity"),
                "contactId": component.get("v.recordId"),
                "campaignId": component.get("v.cmpg") != null?component.get("v.cmpg").Id:null,
                "accountId": accId,
                "endCustomerLEId": endCustomer.Id,
                "contactRole": component.get("v.con").Purchasing_Role__c,
            });

            // Configure the response handler for the action
            saveOpportunityAction.setCallback(this, function(response) {
                var state = response.getState();
                if(state === "SUCCESS") {

                    // Prepare a toast UI message
                    var oppyItem = response.getReturnValue();
                    var resultsToast = $A.get("e.force:showToast");
                    /*
                    resultsToast.setParams({
                        "title": "Opportunity Saved",
                        "message": "The new Opportunity was created."
                    });
					*/
                    resultsToast.setParams({
                        type:'success',
                        message:'This is a required message',
                        messageTemplate:'Opportunity {0} was created.',
                        messageTemplateData:[{url:'/'+oppyItem.Id,
                                              label:oppyItem.Name
                                             }]

                    });
                    // Update the UI: close panel, show toast, refresh Contact page
                    $A.get("e.force:closeQuickAction").fire();
                    resultsToast.fire();
                    $A.get("e.force:refreshView").fire();
                }
                else if (state === "ERROR") {
                    
                    component.set("v.has_error", true);
                    var errorMessages = [];
                    var errors = response.getError();
                    
                    var fieldErrors = errors[0].fieldErrors;
                    for(var fieldIndex in fieldErrors){
                        var fieldError = fieldErrors[fieldIndex];
                        for(var msgIndex in fieldError){
                            errorMessages.push(fieldError[msgIndex].message);
                        }
                    }
                    
                    
                    var pageErrors = errors[0].pageErrors;
                    for(var pageIndex in pageErrors){
                        errorMessages.push(pageErrors[pageIndex].message);
                    }
                    component.set("v.errors", errorMessages);
                   
                    document.getElementById('scrollable_div').scrollTop = 0;
                    
                    console.log('All Error Messages =============: ' + JSON.stringify(errorMessages));
                    
                    window.setTimeout(
                        $A.getCallback(function() {
                            component.set("v.has_error", false);
                        }), 10000
                    );
                    btn.set("v.disabled",false); 
                }
                else {
                    console.log('Unknown problem, response state: ' + state);
                     btn.set("v.disabled",false);
                }
            });

            // Send the request to create the new contact
            $A.enqueueAction(saveOpportunityAction);
       
        
    },

	handleCancel: function(component, event, helper) {
	    $A.get("e.force:closeQuickAction").fire();
    },
    
})