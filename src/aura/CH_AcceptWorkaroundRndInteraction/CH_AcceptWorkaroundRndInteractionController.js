({
    init: function(component) {
		var outboundRndInteraction = {interfaceName : "PRONTO", interactionType : "Workaround Accepted"};
		component.set("v.outboundRndInteraction", outboundRndInteraction);

		var createOutboundRndInteractionComponent = component.find("createOutboundRndInteraction");
		createOutboundRndInteractionComponent.setDefaultOutboundRndInteractionProperties();
	}
})