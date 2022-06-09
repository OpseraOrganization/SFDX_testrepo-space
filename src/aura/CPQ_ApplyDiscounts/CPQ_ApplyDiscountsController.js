({
    init: function (component, event, helper) {
        //get eligible standalone products & ICD products
        //get quote header condition
        //get quote header discount children ordered by sequence
        //if discounts_applied flag is false, prepopulate QLD&ICD checboxes
        //if discounts_applied flag is true, prepopulate the QLD&ICD checkboxes based on exisintg line level values.
        //if discounts_applied flag is false, prepopulate Condition dropdown with quote condition value
        //if discounts_applied flag is true, prepopulate Condition dropdown with line level exisintg value


        const cartId = component.get("v.cartId");
        const lineItemHeader = ['#', 'Product Code', 'Product', 'Condition', 'Discounts'];
        component.set('v.lineItemHeader', lineItemHeader);
        let action = component.get("c.initializePage");
        action.setParams({
            cartId: cartId
        });

        // set call back 
        action.setCallback(this, function(response) {
            
            const result = response.getReturnValue();
            const state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.lineItemData', result.lineItemData);
                component.set('v.lineItemDataUpdated', result.lineItemData);
                component.set('v.contractualDiscounts', result.contractualDiscounts);
                component.set('v.contractualDiscountsWithId', result.contractualDiscountsWithId);
                component.set('v.eligibleConditions', result.eligibleConditions);
                component.set('v.masterCondition', result.masterCondition);
                component.set('v.showLoadingSpinner', false);
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
    
    

    applyDiscount: function(component, event, helper) {
        const quoteId = component.get("v.quoteId");
        const cartId = component.get("v.cartId");
        const lineItemData = component.get("v.lineItemData");
        let lineItemDataUpdated = component.get("v.lineItemDataUpdated");

        lineItemDataUpdated.forEach((item) => {
            if(item.discounts != undefined || item.discounts != '') {
                item.discounts = item.discounts + ';'
            }
        });
        let action = component.get("c.applyDiscounts");
        action.setParams({
            quoteId: quoteId,
            cartId: cartId,
            lineItemData: JSON.stringify(lineItemDataUpdated)
        });
        console.log('apply discounts: ' + JSON.stringify(lineItemDataUpdated));
        component.set("v.showLoadingSpinner", true);
        // set call back 
        action.setCallback(this, function(response) {
            const result = response.getReturnValue();
            const state = response.getState();
            
            if (state === "SUCCESS") {
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

    //onchange condition dropdown data update
    handleConditionChange: function(component, event, helper) {
        const sourceElement = event.currentTarget;
        const lineItemId = sourceElement.getAttribute('id');
        const selectedCondition = sourceElement.value;

        const lineItemDataUpdated = component.get("v.lineItemDataUpdated");
        const eligibleConditions = component.get("v.eligibleConditions");

        lineItemDataUpdated.forEach((item) => {
            if(item.id === lineItemId) {
                if(selectedCondition === '' || selectedCondition === null) {
                    item.conditionCode = null;
                    item.conditionDescription = null;
                } else {
                    item.conditionCode = selectedCondition;
                    item.conditionDescription = eligibleConditions.find((item) => {
                        return item.key === selectedCondition;
                    }).value;
                }
            }
        });
        component.set("v.lineItemDataUpdated", lineItemDataUpdated);
    },

    //onchange checkboxes data update on line levels
    handleDiscountChanges: function(component, event, helper) {
        // const sourceElement = event.currentTarget;
        // const lineItemId = sourceElement.dataset.id;
        // const selectedDiscount = sourceElement.dataset.val;
        const lineItemId = event.getParam("lineItemId");
        const selectedDiscount = event.getParam("selectedDiscount");
        const sequence = event.getParam("sequence");

        const lineItemDataUpdated = component.get("v.lineItemDataUpdated");
        const masterDiscounts = component.get("v.contractualDiscounts");
        const masterDiscountLength = masterDiscounts.length;
        console.log('lineItemDataUpdated: before: ' + JSON.stringify(lineItemDataUpdated));
        lineItemDataUpdated.forEach((item) => {
            let lineItemDiscounts = [];
            if(item.discounts != undefined && item.discounts != '') {
                lineItemDiscounts = item.discounts.replace(/\;$/, '').split(';');
                // slice(0, -1)
            }
            if(item.id === lineItemId) {
                console.log('sequence: ' + sequence);
                console.log('selectedDiscount: ' + selectedDiscount);
                console.log('lineItemDiscounts::', lineItemDiscounts);
                if(lineItemDiscounts.indexOf(selectedDiscount, sequence) == sequence) {
                    console.log('if 1');
                    lineItemDiscounts.splice(sequence, 1, '::');
                    
                } else {
                    console.log('else 1');
                    lineItemDiscounts.splice(sequence, 1, selectedDiscount);
                }
                console.log('lineItemDiscounts::', lineItemDiscounts);
                /*
                if(lineItemDiscounts != undefined && lineItemDiscounts.includes(selectedDiscount)) {
                    item.discounts = lineItemDiscounts.replace(selectedDiscount,' ');
                } else {
                    let changedLineItemDiscounts = '';
                    masterDiscounts.forEach((item) => {
                        if(lineItemDiscounts != undefined && lineItemDiscounts.includes(item) || item === selectedDiscount) {
                            changedLineItemDiscounts = changedLineItemDiscounts + item + ';';
                        } else {
                            changedLineItemDiscounts = changedLineItemDiscounts + ' ' + ';';
                        }
                    });
                    item.discounts = changedLineItemDiscounts;
                }
                */
                // let finalDiscounts = lineItemDiscounts.toString().replaceAll(',',';').replaceAll('==', ' ');
                let finalDiscounts = lineItemDiscounts.toString().replaceAll(',',';');
                console.log('masterDiscountLength - 1: ', masterDiscountLength - 1);
                console.log('finalDiscounts[masterDiscountLength - 1]: ', finalDiscounts[masterDiscountLength - 1]);
                // if(lineItemDiscounts[masterDiscountLength - 1] == ' ' || lineItemDiscounts[masterDiscountLength - 1] == '') {
                //     finalDiscounts =  finalDiscounts + ' ' + ';';
                // }

                console.log('finalDiscounts::', finalDiscounts);
                /*
                if(finalDiscounts.replaceAll(';', '').trim() === '') {
                    item.discounts = '';
                } else {
                    item.discounts = finalDiscounts;
                }
                */
                item.discounts = finalDiscounts;
            }
        });
        component.set("v.lineItemDataUpdated: ", lineItemDataUpdated);
        console.log('lineItemDataUpdated: after: ' + JSON.stringify(lineItemDataUpdated));
    },
    
    closeModel: function(component, event, helper) {
        window.history.back();
    }
})