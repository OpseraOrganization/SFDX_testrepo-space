({
    doInit : function(component, event, helper) {
        console.log('In NavigateToOfferCreation');
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:OfferCreation",
            componentAttributes: {
                offerCreationFlag : true,
                opptyId : component.get("v.recordId")
            },
            isredirect : true
        });
        evt.fire();
        $A.get("e.force:closeQuickAction").fire();
        //component.destroy();
    }
})