({
	navigateToComponent : function(component, event, helper) {
        var eventNavigate = $A.get("e.force:navigateToComponent"),
            eventClose = $A.get("e.force:closeQuickAction");
        eventNavigate.setParams({
            componentDef: "c:CH_CreateNEA",
            componentAttributes: {
                recordId : component.get("v.recordId"),
                tabMode : true
            }
        });
        setTimeout(function() {
            eventClose.fire();
            eventNavigate.fire();
        }, 1000);
    }
})