({
    updateQuoteProposalRecord : function(component, event, helper) {
		var actionUpdate = component.get("c.addAssociationToQuoteProposal");
		//alert(component.find("quoteProposalId").get("v.value"));
		actionUpdate.setParams({
			"quoteIdStr": component.find("quoteProposalId").get("v.value"),
			"customerDocumentIdStr": component.get("v.recordId")
		});
		actionUpdate.setCallback(this, function(responseUpdate) {
			var stateUpdate = responseUpdate.getState();
			if (stateUpdate === "SUCCESS") {
				$A.get("e.force:closeQuickAction").fire();
				$A.get('e.force:refreshView').fire();
				this.showToast('', 'success', 'The association is created successfully.', 'dismissible');
				component.set('v.isSpinnerVisible', false);
			} else if (stateUpdate === "ERROR") {
				var errorsUpdate = actionUpdate.getError();
				if (errorsUpdate) {
					if (errorsUpdate[0] && errorsUpdate[0].message) {
						this.showToast('Error', 'error', errorsUpdate[0].message, 'sticky');
					}
				}
				component.set('v.isSpinnerVisible', false);
			} else if (stateUpdate === "INCOMPLETE") {
				alert("No response from server or client is offline.");
				component.set('v.isSpinnerVisible', false);
			}
		});
		component.set('v.isSpinnerVisible', true);
		$A.enqueueAction(actionUpdate);
	},
	// Generic Toast Message
	showToast: function(title, type, message, mode) {
		$A.get("e.force:showToast").setParams({
			"title": title,
			"type": type,
			"message": message,
			"mode": mode
		}).fire();
	}
})