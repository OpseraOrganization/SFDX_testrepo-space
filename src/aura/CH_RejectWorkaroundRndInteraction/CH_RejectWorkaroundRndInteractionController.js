({
    init: function(component) {
    	var action = component.get("c.getRNDInterface");
        action.setParams({ rndId : component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                if(result == "PRONTO"){
                	var outboundRndInteraction = {interfaceName : "PRONTO", interactionType : "Workaround Rejected", subject : "Reject Workaround"};
                    component.set("v.outboundRndInteraction", outboundRndInteraction);
            
                    var createOutboundRndInteractionComponent = component.find("createOutboundRndInteraction");
                    createOutboundRndInteractionComponent.setDefaultOutboundRndInteractionProperties();
                } else if(result == "JIRA"){
                    var outboundRndInteraction = {interfaceName : "JIRA", interactionType : "Workaround Rejected", subject : "Reject Workaround"};
                    component.set("v.outboundRndInteraction", outboundRndInteraction);
                
                    var createOutboundRndInteractionComponent = component.find("createOutboundRndInteraction");
                    createOutboundRndInteractionComponent.setDefaultOutboundRndInteractionProperties();
				}
            }
        });
        $A.enqueueAction(action);  
	}
})