({
	navigate : function(component, event) {
        
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:CQ_RebidQuote",
            componentAttributes: {
                quotecreationflag : true,
                recordId : component.get("v.recordId")
            },
            isredirect : true
        });
        $A.get("e.force:closeQuickAction").fire();
        evt.fire();
	}
})