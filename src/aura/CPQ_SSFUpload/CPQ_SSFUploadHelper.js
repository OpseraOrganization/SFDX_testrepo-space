({
    uploadSSFHelper: function(component, event, helper) {
        component.set("v.showLoadingSpinner", true);
        var fileInput = component.find("fileId").get("v.files");
        var file = fileInput[0];
        var self = this;
        
        // create a FileReader object 
        var objFileReader = new FileReader();
        objFileReader.onload = $A.getCallback(function() {
            var fileContents = objFileReader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
            fileContents = fileContents.substring(dataStart);
            
            self.uploadSSFData(component, helper, file, fileContents);
        });
        objFileReader.readAsDataURL(file);
    },
    
    uploadSSFData: function(component, helper, file, fileContents) {
        var action = component.get("c.uploadSSF");
        action.setParams({
            base64Data: encodeURIComponent(fileContents),
            configId: component.get("v.cartId")
        });
        console.log('config id: ', component.get("v.cartId"));
        // set call back 
        action.setCallback(this, function(response) {
            var wrapper = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('====wrapper=======',wrapper);
                component.set("v.csvData", wrapper.csvData);
                component.set("v.csvCol", wrapper.csvCol);
                component.set("v.csvQuoteData", wrapper.csvQuoteData);
                component.set("v.csvQuoteCol", wrapper.csvQuoteCol);
                
                var isValidate = true;
                for(var cmp in wrapper.csvData) {
                    if(wrapper.csvData[cmp].status != 'Success'){
                        isValidate = false;
                    }
                }
                
                if(isValidate){
                    component.set("v.fileName", 'Data Validated Successfully!');
                    component.set("v.showLoadingSpinner", false);
                    component.set("v.errMsg", '');
                    component.set("v.cartVisible", true);
                }else{
                    helper.showMessage(component, 'success', 'Data Validation Failed!');
                }
                
            } else if (state === "INCOMPLETE") {
                component.set("v.cartVisible", false);
                helper.showMessage(component, 'error', "From server: " + response.getReturnValue());
            } else if (state === "ERROR") {
                component.set("v.cartVisible", false);
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
    
    showMessage : function(component, type, msg) {
        component.set("v.showLoadingSpinner", false);
        component.set("v.errMsg", msg);
    },
    
    addToCart : function(component, helper) {
        component.set("v.showLoadingSpinner", true);
        var confgId_CPQTempObj = component.get("v.confgId_CPQTempObj");
        var cartId = component.get("v.cartId");
        var flow = component.get("v.flow");
        
        var url = document.referrer + 'apex/Cart?configRequestId=' + confgId_CPQTempObj + '&cartStatus=New&id=' + cartId + '&flow=' + flow + '#!/cartgrid';
        console.log('===85===',component.get("v.csvQuoteData"));
        var action = component.get("c.addProductsToCart");
        action.setParams({
            configId: cartId,
            productsToAddJsn: JSON.stringify(component.get("v.csvData")),
            quoteDataJsn: JSON.stringify(component.get("v.csvQuoteData"))
        });
        
        // set call back 
        action.setCallback(this, function(response) {
            var wrapper = response.getReturnValue();
            var state = response.getState();
            
            if (state === "SUCCESS") {
                //helper.redirectToCart(component, helper);
                helper.repriceCart(component, helper, cartId);
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
        var confgId_CPQTempObj = component.get("v.confgId_CPQTempObj");
        var cartId = component.get("v.cartId");
        var flow = component.get("v.flow");
        
        var url = document.referrer + 'apex/Cart?configRequestId=' + confgId_CPQTempObj + '&cartStatus=New&id=' + cartId + '&flow=' + flow + '#!/cartgrid';

        window.open(url, '_self');
    }
})