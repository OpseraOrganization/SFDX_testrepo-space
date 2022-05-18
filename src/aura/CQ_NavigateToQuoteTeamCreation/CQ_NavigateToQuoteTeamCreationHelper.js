({
	navigate : function(component, event) {
        
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:CQ_QuoteTeamCreation",
            componentAttributes: {
                quoteTeamcreationflag : true,
                recordId : component.get("v.recordId")
            },
            isredirect : true
        });
        $A.get("e.force:closeQuickAction").fire();
        evt.fire();
	}
})