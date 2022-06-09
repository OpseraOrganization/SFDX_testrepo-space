({
    getAccountDetails : function(component, event, helper) {
        var acc= component.get('v.passingAccount');
        component.set("v.Account", acc);
    },
    
    closeModel: function(component, event, helper){
        component.set("v.isEditButtonClicked", false);
        var cmpTarget = component.find('ModalboxT');
        var cmpBack = component.find('ModalbackdropT');
        $A.util.removeClass(cmpBack,'slds-backdrop');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open');
        $A.util.removeClass(cmpBack,'slds-fade-in-open');
        
        
    },
    collapseSec: function(component, event, sectionId){
        try{
            var section = component.find(sectionId);
            for(var info in section){           
                $A.util.toggleClass(section[info], 'slds-show');  
                $A.util.toggleClass(section[info], 'slds-hide');
            }
        } catch (err) {
            console.log('ERROR: ' + err + ' ** MESSAGE: ' + err.message + ' ** STACK: ' + err.stack);
        }
    },
    
    updateDetails: function(component, event, helper){
        try{
            component.set("v.IsSpinner",true);
            var action = component.get("c.updateAccountValues");
            action.setParams({obAccount:component.get("v.Account")});
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    helper.showToast(component, event, helper,'Success!','The record has been updated successfully.','success' );
                    component.set("v.IsSpinner",false); 
                    helper.closeModel(component, event, helper); 
                }
                else{
                    let errors = response.getError();
                    let message = 'Unknown error';
                    // Retrieve the error message sent by the server
                    if (errors && Array.isArray(errors) && errors.length > 0) {
                        message = errors[0].message;
                    }
                    helper.showToast(component, event, helper,'Error!',message,'error' );
                    component.set("v.IsSpinner",false);
                }
            });
            $A.enqueueAction(action);
        }catch (err) {
            console.log('ERROR: ' + err + ' ** MESSAGE: ' + err.message + ' ** STACK: ' + err.stack);
        }
    },
    showToast : function(component, event, helper,title,message,type ) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type":type
        });
        toastEvent.fire();
    },
     getShiptoPartyValidation : function(component, event){
        var validation = true;
        var addressLine = component.find('addressLine1').get("v.value");
        var billingCity = component.find('BillingCity').get("v.value");
        var localAddress = component.find('localaddressLine1').get("v.value");
        var shippingCity = component.find('ShippingCity').get("v.value");
         var shippingAddress = component.find('ShipToAddress').get("v.value");
         var localshippingAddress = component.find('localShipToAddress').get("v.value");
        if(addressLine == null || addressLine == '' || addressLine == undefined){
            validation = false;
            component.find('addressLine1').showHelpMessageIfInvalid();
        }
        if(billingCity == null || billingCity == '' || billingCity == undefined){
            validation = false;
            component.find('BillingCity').showHelpMessageIfInvalid();
        }
        if(localAddress == null || localAddress == '' || localAddress == undefined){
            validation = false;
            component.find('localaddressLine1').showHelpMessageIfInvalid();
        }
        if(shippingCity == null || shippingCity == '' || shippingCity == undefined){
            validation = false;
            component.find('ShippingCity').showHelpMessageIfInvalid();  
        }
         if(localshippingAddress == null || localshippingAddress == '' || localshippingAddress == undefined){
            validation = false;
            component.find('ShipToAddress').showHelpMessageIfInvalid();  
        }
         if(shippingCity == null || shippingCity == '' || shippingCity == undefined){
            validation = false;
            component.find('localShipToAddress').showHelpMessageIfInvalid();  
        }
            
        return validation;
    }, 
   
    
})