({
	showToast : function(theTitle, theMessage, theVariant) {
        const event = new ShowToastEvent({
            title: theTitle,
            message: theMessage,
            variant: theVariant
        });
        this.dispatchEvent(event);
	},
     pricingPoolHelper: function(component, event, helper,wrapData) {
        var oppId = component.get("v.opportunityId");
        var ppValue = component.get("v.pricingPoolValPick");
        console.log('Helper ppValue:: ', ppValue);
        var res = ppValue.split("---");
        console.log('Helper wrapData ', wrapData);
        
        component.set("v.pricingPoolVal", res[0]);
        
        var action3 = component.get('c.getPricingConditions');
        
        action3.setParams({ recordId : oppId, ppId : wrapData })
        action3.setCallback(this,function(response){
            var state = response.getState();
            if(state === 'SUCCESS' || state === 'DRAFT'){
                var priceConList = response.getReturnValue();
                console.log("helper priceConLists ",priceConList[0].CPQ_Description__c);
                component.set("v.priceConList", priceConList);
            }
        });
        $A.enqueueAction(action3);
    }
})