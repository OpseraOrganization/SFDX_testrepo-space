({
    init: function(component) {
		var outboundRndInteraction = {interfaceName : "PRONTO", interactionType : "Workaround Rejected", subject : "Reject Workaround"};
		component.set("v.outboundRndInteraction", outboundRndInteraction);

		var createOutboundRndInteractionComponent = component.find("createOutboundRndInteraction");
		createOutboundRndInteractionComponent.setDefaultOutboundRndInteractionProperties();
	}
})