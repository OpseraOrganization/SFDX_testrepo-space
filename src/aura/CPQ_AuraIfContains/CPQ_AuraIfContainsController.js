({
    doInit: function(component, event, helper) {
        var sequence = component.get('v.sequence');
        var lineItemDiscounts = component.get('v.lineItemDiscounts');
        var masterDiscount = component.get('v.masterDiscount');
        
        var masterDiscountId,masterDiscountCode;
        if (masterDiscount !== undefined && masterDiscount !== '') {
            var masterDiscountsSplit = masterDiscount.split('::');
            if(masterDiscountsSplit.length == 2) {
                masterDiscountCode = masterDiscountsSplit[0];
                masterDiscountId = masterDiscountsSplit[1];
                component.set('v.masterDiscountCode', masterDiscountCode);
                component.set('v.masterDiscountId', masterDiscountId);
            }
        }
        
        if(masterDiscountCode === undefined || masterDiscountCode === '' || lineItemDiscounts === undefined || lineItemDiscounts === '') {
            component.set('v.condition', false);
        } else {
            var lineItemDiscluntsList = lineItemDiscounts.split(';');
            if(lineItemDiscluntsList.indexOf(masterDiscountCode, sequence) == sequence) {
                component.set('v.condition', true);
            } else {
                component.set('v.condition', false);
            }
        }
        
    },
    handleDiscountChangesEvent : function(cmp, event,helper) { 
        //Get the event using registerEvent name. 
        var cmpEvent = cmp.getEvent("handleDiscountChangesEvent");
        const sourceElement = event.currentTarget;
        //Set event attribute value
        cmpEvent.setParams({"lineItemId" : sourceElement.dataset.id, "selectedDiscount" : sourceElement.dataset.val, "sequence" : sourceElement.dataset.sequence});
        cmpEvent.fire(); 
    }
})