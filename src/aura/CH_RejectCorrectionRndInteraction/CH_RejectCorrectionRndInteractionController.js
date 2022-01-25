({
    init: function(component) {
		var outboundRndInteraction = {interfaceName : "PRONTO", interactionType : "Correction Rejected"};
		component.set("v.outboundRndInteraction", outboundRndInteraction);

		var createOutboundRndInteractionComponent = component.find("createOutboundRndInteraction");
		createOutboundRndInteractionComponent.setDefaultOutboundRndInteractionProperties();
	}
})