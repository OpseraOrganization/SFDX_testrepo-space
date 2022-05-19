({
    saveIndirectOppFromAccount: function(component, event, helper)
    {
        component.set('v.loading', true);
        var btn = event.getSource();
        btn.set("v.disabled",true);
        component.set("v.has_error", false);
        helper.validateRequiredFields( component );
        
        if(component.get("v.has_error") == true )
        {
            document.getElementById('scrollable_div').scrollTop = 0;
            btn.set("v.disabled",false);
            return;
        }
        
        // Prepare the action to create the new Opportunity
        var opp = component.get("v.newOpporunity");
        console.log('New Opportunity to display: '+ JSON.stringify(opp));
        if(opp['Account_Role__c'] == '--None--')
        {
            opp['Account_Role__c'] = '';
        }
        if(opp['Multiple_or_Unknown_EC_Activity_Sector__c'] == '--None--')
        {
            opp['Multiple_or_Unknown_EC_Activity_Sector__c'] = '';
        }
        if(opp['Multiple_or_Unknown_EC_Country__c'] == '--None--')
        {
            opp['Multiple_or_Unknown_EC_Country__c'] = '';
        }
        if(opp['Multiple_or_Unknown_EC_Market_Segment__c'] == '--None--')
        {
            opp['Multiple_or_Unknown_EC_Market_Segment__c'] = '';
        }
        
        var accId = component.get("v.accountId");
        console.log('New Account to display: '+ JSON.stringify(accId));
        
        var endCustomer = component.get("v.selectedLookUpRecordAccount");
        console.log('Lookup Id: '+ JSON.stringify(endCustomer));
        var saveOpportunityAction = component.get("c.saveIndirectOpportunityWithAccount");
		saveOpportunityAction.setParams({
            "oppty": component.get("v.newOpporunity"),
            "accountId": accId,
            "endCustomerLEId": endCustomer.Id
        });
        
        // Configure the response handler for the action
        saveOpportunityAction.setCallback(this, function(response) 
        {
            var state = response.getState();
            if(state === "SUCCESS") 
            {
                // Prepare a toast UI message
                var oppyItem = response.getReturnValue();
                var resultsToast = $A.get("e.force:showToast");
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
            else if (state === "ERROR")
            {
                component.set("v.has_error", true);
                var errorMessages = [];
                var errors = response.getError();
                
                var fieldErrors = errors[0].fieldErrors;
                for(var fieldIndex in fieldErrors)
                {
                    var fieldError = fieldErrors[fieldIndex];
                    for(var msgIndex in fieldError)
                    {
                        errorMessages.push(fieldError[msgIndex].message);
                    }
                }
                
                var pageErrors = errors[0].pageErrors;
                for(var pageIndex in pageErrors)
                {
                    errorMessages.push(pageErrors[pageIndex].message);
                }
                component.set("v.errors", errorMessages);
                document.getElementById('scrollable_div').scrollTop = 0;
                console.log('All Error Messages =============: ' + JSON.stringify(errorMessages));
                btn.set("v.disabled",false); 
            }
            else 
            {
                console.log('Unknown problem, response state: ' + state);
                btn.set("v.disabled",false);
			}
        	component.set('v.loading', false);
        });
        $A.enqueueAction(saveOpportunityAction);
    },
    
    checkECInformationChange: function(component, event, helper){
    	var controllerValueKey = event.getSource().get("v.value"); 
        if(controllerValueKey != component.get("v.mktSegInitialValue")){
        	component.set("v.enableInitialEC" , false);
        } else{
            component.set("v.enableInitialEC" , true);
            var mouECMS = component.find("multiple_or_unknown_ec_market_segment");
            var mouECC = component.find("multiple_or_unknown_ec_country");
            mouECMS.set("v.value", ['--None--']);
            mouECC.set("v.value", ['--None--']);
            component.set("v.bDisabledDependentFld", true); 
            component.set("v.listDependingValues", ['--None--']);
        }
	},
    
    checkECMktSegChange: function(component, event, helper){
    	var controllerValueKey = event.getSource().get("v.value");
        var depnedentFieldMap = component.get("v.depnedentFieldMap");
        if (controllerValueKey != '--None--') {
            var ListOfDependentFields = depnedentFieldMap[controllerValueKey];
            if(ListOfDependentFields.length > 0){
                component.set("v.bDisabledDependentFld" , false);  
                var dependentFields = [];
                    for (var i = 0; i < ListOfDependentFields.length; i++) {
                        dependentFields.push(ListOfDependentFields[i]);
                    }
                	component.set("v.listDependingValues", dependentFields);
            }else{
                component.set("v.bDisabledDependentFld" , true); 
                component.set("v.listDependingValues", ['--None--']);
            }  
        } else {
            component.set("v.listDependingValues", ['--None--']);
            component.set("v.bDisabledDependentFld" , true);
        }
        
	},
    
    saveIndirectOppFromContact: function(component, event, helper) {
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
        	if(opp['Account_Role__c'] == '--None--')
            {
                opp['Account_Role__c'] = '';
            }
        	if(opp['Multiple_or_Unknown_EC_Activity_Sector__c'] == '--None--')
            {
                opp['Multiple_or_Unknown_EC_Activity_Sector__c'] = '';
            }
            if(opp['Multiple_or_Unknown_EC_Country__c'] == '--None--')
            {
                opp['Multiple_or_Unknown_EC_Country__c'] = '';
            }
            if(opp['Multiple_or_Unknown_EC_Market_Segment__c'] == '--None--')
            {
                opp['Multiple_or_Unknown_EC_Market_Segment__c'] = '';
            }
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
    
    validateContactForm: function(component) 
    {
        var validContact = true;
        // Show error messages if required fields are blank
        var allValid = component.find('contactField').reduce(function (validFields, inputCmp)
        {
            inputCmp.showHelpMessageIfInvalid();
            return validFields && inputCmp.get('v.validity').valid;
        }, true);
        
        if (allValid)
        {
            // Verify we have an account to attach it to
            var account = component.get("v.account");
            if($A.util.isEmpty(account))
            {
                validContact = false;
                console.log("Quick action context doesn't have a valid account.");
            }
            return(validContact);
        }
    },
    
    validateRequiredFields: function(component)
    {
        var flag = false;
        var errorMessages = 'Required fields are missing : [ ';
        /*if(component.find('end_customer_information').get('v.value') != component.get("v.mktSegInitialValue")){
            if(component.find('multiple_or_unknown_ec_market_segment').get('v.value')=='--None--'){
                errorMessages += 'Multiple or Unknown EC Market Segment, ';
                flag = true;
            }
            if(component.find('multiple_or_unknown_ec_activity_sector').get('v.value')=='--None--'){
                errorMessages += 'Multiple or Unknown EC Activity Sector, ';
                flag = true;
            }
            if(component.find('multiple_or_unknown_ec_country').get('v.value')=='--None--'){
                errorMessages += 'Multiple or Unknown EC Country, ';
                flag = true;
            }
        }else{
            if( $A.util.isUndefined(component.get("v.selectedLookUpRecordAccount").Id ) )
            {
                    errorMessages += 'End Customer, ';
                    flag = true;
            }
        }*/
        if( $A.util.isUndefined(component.find('oppName').get('v.value')) ||
        	$A.util.isEmpty(component.find('oppName').get('v.value')) )
        {
            	errorMessages += 'Opportunity Name, ';
            	flag = true;
        }
        /*
        if( $A.util.isUndefined(component.find('campaign_name').get('v.value')) ||
        	$A.util.isEmpty(component.find('campaign_name').get('v.value')) ){
            	errorMessages += 'Campaign Name, ';
            	flag = true;
        }
        */
        if( $A.util.isUndefined(component.find('opportunity_type').get('v.value')) ||
        	$A.util.isEmpty(component.find('opportunity_type').get('v.value')) ||
          	component.find('opportunity_type').get('v.value') == '--None--')
        {
            	errorMessages += 'Opportunity Type, ';
            	flag = true;
        }
        
        if( $A.util.isUndefined(component.find('contract_signing_entity').get('v.value')) ||
        	$A.util.isEmpty(component.find('contract_signing_entity').get('v.value')) || 
          	component.find('contract_signing_entity').get('v.value') == '--None--')
        {
            	errorMessages += 'Contract Signing Entity, ';
            	flag = true;
        }
        
        if( $A.util.isUndefined(component.find('opp_amount').get('v.value')) ||
        	$A.util.isEmpty(component.find('opp_amount').get('v.value')) )
        {
            	errorMessages += 'Unweighted Value, ';
            	flag = true;
        }
        
        if( $A.util.isUndefined(component.find('opportunity_currency').get('v.value')) ||
        	$A.util.isEmpty(component.find('opportunity_currency').get('v.value')) ||
           	component.find('opportunity_currency').get('v.value') == '--None--')
        {
               errorMessages += 'Opportunity Currency, ';
				flag = true;
        }
        
        /*if( $A.util.isUndefined(component.find('G2PlannedDate').get('v.value')) ||
        	$A.util.isEmpty(component.find('G2PlannedDate').get('v.value')) ){
        	    errorMessages += 'G2 Planned Date, ';
            	flag = true;        
        }*/
        
        if( $A.util.isUndefined(component.find('G3PlannedDate').get('v.value')) ||
        	$A.util.isEmpty(component.find('G3PlannedDate').get('v.value')) )
        {
       		    errorMessages += 'G3 Planned Date, ';
            	flag = true;
        }
        
        /*if( $A.util.isUndefined(component.find('G4PlannedDate').get('v.value')) ||
        	$A.util.isEmpty(component.find('G4PlannedDate').get('v.value')) ){
        	    errorMessages += 'G4 Planned Date, ';
            	flag = true;
        }*/
        
        if( $A.util.isUndefined(component.find('G5PlannedDate').get('v.value')) ||
        	$A.util.isEmpty(component.find('G5PlannedDate').get('v.value')) )
        {
        	    errorMessages += 'G5 Planned Date, ';
            	flag = true;
        }
        
        /*if( $A.util.isUndefined(component.find('G6PlannedDate').get('v.value')) ||
        	$A.util.isEmpty(component.find('G6PlannedDate').get('v.value')) ){
        	    errorMessages += 'G6 Planned Date, ';
            	flag = true;
        }*/
        
        errorMessages += ' ]';
        var err= [] 
        err.push(errorMessages);
        if(flag == true )
        {
        	component.set('v.loading', false);
            component.set("v.errors", err);
        	component.set("v.has_error", true);    
        }
    }
})