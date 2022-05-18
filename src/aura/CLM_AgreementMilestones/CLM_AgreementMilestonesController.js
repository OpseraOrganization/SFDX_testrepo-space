({
	doInit : function(component, event, helper) {
		helper.getAgreementInvoicingMilestones(component, event);
	},

	editAIMRecord : function(component, event, helper) {
		var rectarget = event.currentTarget;
		var editRecordEvent = $A.get("e.force:editRecord");
		editRecordEvent.setParams({
			"recordId": event.getSource().get("v.value")
		});
		editRecordEvent.fire();
	},

	editAgreementRecord : function(component, event, helper) {
		component.set("v.edit", true);
	},

	handleSuccess : function(component, event, helper) {
		helper.showToast("Edit Other Milestones", "success", "The record has been updated successfully!", "pester");
		component.set("v.edit", false);
	},

	handleCancel : function(component, event, helper) {
		component.set("v.edit", false);
	},
})