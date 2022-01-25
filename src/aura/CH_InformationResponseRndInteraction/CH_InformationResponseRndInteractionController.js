({
    init: function(component) {
		var outboundRndInteraction = {interfaceName : "PRONTO", interactionType : "Information Response"};
		component.set("v.outboundRndInteraction", outboundRndInteraction);

		var createOutboundRndInteractionComponent = component.find("createOutboundRndInteraction");
		createOutboundRndInteractionComponent.setDefaultOutboundRndInteractionProperties();
	}
})