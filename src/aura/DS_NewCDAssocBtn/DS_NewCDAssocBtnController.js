({
	handleAssociateButton : function(component, event, helper) {
		event.preventDefault();

		var action = component.get("c.getQuoteProposalRecord");
		action.setParams({
			"quoteIdStr": component.find("quoteProposalId").get("v.value")
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var quoteProposalRecord = response.getReturnValue();
				if (quoteProposalRecord.Nokia_Customer_Document_ID__c != null) {
					/* open a confirmation pop-up */
					component.set('v.quoteProposalRecord', quoteProposalRecord)
					component.set('v.showConfirmDialog', true);
				} else {
					/* update the Quote/Proposal record if there was no association created yet */
					helper.updateQuoteProposalRecord(component, event, helper);
				}
			} else if (state === "ERROR"){
				var errors = action.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						helper.showToast('Error', 'error', errors[0].message, 'dismissible');
					}
				}
			} else if (state === "INCOMPLETE") {
				alert("No response from server or client is offline.");
			}
		});
		$A.enqueueAction(action);

		//var payload = event.getParams();
		//alert(JSON.stringify(payload));
		//$A.get("e.force:closeQuickAction").fire();
	},
	handleCloseButton : function(component, event, helper) {
		$A.get("e.force:closeQuickAction").fire();
	},
	handleConfirmButton : function(component, event, helper) {
		/* update Quote/Proposal record if the replacement is confirmed */
		helper.updateQuoteProposalRecord(component, event, helper);
	},
	handleCloseConfirmButton : function(component, event, helper) {
		component.set('v.showConfirmDialog', false);
	}
})