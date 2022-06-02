({
	getAgreementInvoicingMilestones: function(component, event) {
		if (event.getParam("type") === "error") {
			//to avoid recurrence of page load on errors
			return;
		}
		var action = component.get("c.getAgreementInvoicingMilestones");
		action.setParams({
			"agreementId" : component.get("v.recordId")
		});
		action.setCallback(this, function(response) {
			component.set('v.isSpinnerVisible', false);
			var state = response.getState();
			if (state === "SUCCESS") {
				var result = JSON.parse(response.getReturnValue());
				component.set("v.agreementInvoicingMilestones", result.aims);
				component.set("v.hasEditAccessAgreement", result.isAgreementUpdateable);
				component.set("v.hasEditAccessAIM", result.isAIMUpdateable);
			} else if (state === "ERROR") {
				var errors = action.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						this.showToast("Unable to fetch Agreement Invoicing Milestone records", "error", errors[0].message, "sticky");
					}
				}
			} else if (state === "INCOMPLETE") {
				this.showToast("", "error", "No response from server or client is offline.", "sticky");
			}
		});
		component.set('v.isSpinnerVisible', true);
		$A.enqueueAction(action);
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