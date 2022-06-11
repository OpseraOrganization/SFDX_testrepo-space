({
    validateContactForm: function(component) {
        var validContact = true;

        
        // Show error messages if required fields are blank
        var allValid = component.find('contactField').reduce(function (validFields, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validFields && inputCmp.get('v.validity').valid;
        }, true);

        if (allValid) {
        // Verify we have an account to attach it to
        var account = component.get("v.account");
        if($A.util.isEmpty(account)) {
            validContact = false;
            console.log("Quick action context doesn't have a valid account.");
        }

        return(validContact);
	}
    },
    
    validateRequiredFields: function(component) {
        
        var flag = false;
        var errorMessages = 'Required fields are missing: [ ';
        
        if( $A.util.isUndefined(component.find('oppName').get('v.value')) ||
        	$A.util.isEmpty(component.find('oppName').get('v.value')) ){
            	errorMessages += 'Opportunity Name, ';
            	flag = true;
        }
        
        if( $A.util.isUndefined(component.find('opportunity_type').get('v.value')) ||
        	$A.util.isEmpty(component.find('opportunity_type').get('v.value')) ||
          	component.find('opportunity_type').get('v.value') == '--None--'){
            	errorMessages += 'Opportunity Type, ';
            	flag = true;
        }
        
        /*if( $A.util.isUndefined(component.find('campaign_name').get('v.value')) ||
        	$A.util.isEmpty(component.find('campaign_name').get('v.value')) ){
            	errorMessages += 'Campaign Name, ';
            	flag = true;
        }*/
        
        if( $A.util.isUndefined(component.find('contract_signing_entity').get('v.value')) ||
        	$A.util.isEmpty(component.find('contract_signing_entity').get('v.value')) || 
          	component.find('contract_signing_entity').get('v.value') == '--None--'){
            	errorMessages += 'Contract Signing Entity, ';
            	flag = true;
        }
        
        if( $A.util.isUndefined(component.find('opp_amount').get('v.value')) ||
        	$A.util.isEmpty(component.find('opp_amount').get('v.value')) ){
            	errorMessages += 'Unweighted Value, ';
            	flag = true;
        }
        
        if( $A.util.isUndefined(component.find('opportunity_currency').get('v.value')) ||
        	$A.util.isEmpty(component.find('opportunity_currency').get('v.value')) ||
           	component.find('opportunity_currency').get('v.value') == '--None--'){
               errorMessages += 'Opportunity Currency, ';
				flag = true;
        }
        
        /*if( $A.util.isUndefined(component.find('G2PlannedDate').get('v.value')) ||
        	$A.util.isEmpty(component.find('G2PlannedDate').get('v.value')) ){
        	    errorMessages += 'G2 Planned Date, ';
            	flag = true;        
        }*/
        
        if( $A.util.isUndefined(component.find('G3PlannedDate').get('v.value')) ||
        	$A.util.isEmpty(component.find('G3PlannedDate').get('v.value')) ){
       		    errorMessages += 'G3 Planned Date, ';
            	flag = true;
        }
        
        /*if( $A.util.isUndefined(component.find('G4PlannedDate').get('v.value')) ||
        	$A.util.isEmpty(component.find('G4PlannedDate').get('v.value')) ){
        	    errorMessages += 'G4 Planned Date, ';
            	flag = true;
        }*/
        
        if( $A.util.isUndefined(component.find('G5PlannedDate').get('v.value')) ||
        	$A.util.isEmpty(component.find('G5PlannedDate').get('v.value')) ){
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
        
        if(flag == true ){
            component.set("v.errors", err);
        	component.set("v.has_error", true);    
        }
        
    }
})