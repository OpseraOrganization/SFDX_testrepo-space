({
    
    repriceCart: function(component, helper, cartId) {
        console.log('repiricing cart');
        var action = component.get("c.repriceCart");
        action.setParams({
            cartId: cartId
        });
        // set call back 
        action.setCallback(this, function(response) {
            var responseValue = response.getReturnValue();
            var state = response.getState();
            console.log('responseValue--' + JSON.stringify(responseValue));
            if (state === "SUCCESS") {
                if(responseValue){
                    helper.repriceCart(component, helper, cartId); //if responseValue(IsPricePending) is true, reprice the cart again for the pending line items
                } else {
                    helper.redirectToCart(component, helper);
                }
            } else if (state === "INCOMPLETE") {
                helper.showMessage(component, 'error', "From server: " + response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        helper.showMessage(component, 'error', "Error message: " + errors[0].message);
                    }
                } else {
                    helper.showMessage(component, 'error', "Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    redirectToCart: function(component, helper) {
        /*
        var confgId_CPQTempObj = component.get("v.confgId_CPQTempObj");
        var cartId = component.get("v.cartId");
        var flow = component.get("v.flow");
        
        var url = document.referrer + 'apex/Cart?configRequestId=' + confgId_CPQTempObj + '&cartStatus=New&id=' + cartId + '&flow=' + flow + '#!/cartgrid';

        window.open(url, '_self');
        */
        window.history.back();
    },

    showMessage : function(component, type, msg) {
        component.set("v.showLoadingSpinner", false);
        component.set("v.errMsg", msg);
    },
})