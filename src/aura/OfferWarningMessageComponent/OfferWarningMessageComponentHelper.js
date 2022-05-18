({
	displayWarningMessage: function(component, event, helper) {

		var currentUrl = window.location.href; // Get current url
		var action = component.get("c.getOfferId");
		action.setParams({
			recordId: component.get("v.recordId"),
			url: currentUrl
		});

		action.setCallback(this, function(response) {
			var state = response.getState();
			if (component.isValid() && state === "SUCCESS") {

				var showToast = $A.get('e.force:showToast');
				showToast.setParams({
					'message': response.getReturnValue(),
					'type': 'warning',
					'duration': 10000
				});

				//fire the event
				showToast.fire();
			} else {
				console.info('No warning message to display');
			}
		});
		$A.enqueueAction(action);
	},

	verifyOfferTeam : function(component, event, helper) {

		var action = component.get("c.verifyOfferTeamTricornRoles");
		action.setParams({
			recordId: component.get("v.recordId")
		});

		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS" && response.getReturnValue() != null) {

				var showToast = $A.get('e.force:showToast');
				showToast.setParams({
					'message': response.getReturnValue(),
					'type': 'warning',
					'duration': 200000
				});

				//fire the event
				showToast.fire();
			} else {
				console.info('No warning message to display');
			}
		});
		$A.enqueueAction(action);
	}
})