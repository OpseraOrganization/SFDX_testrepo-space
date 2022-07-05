({
	doInit : function(component, event, helper) {
		helper.verifyOfferTeam(component, event, helper);
		helper.displayWarningMessage(component, event, helper);
	},

	doRefresh : function(component, event, helper) {
		helper.verifyOfferTeam(component, event, helper);
		helper.displayWarningMessage(component, event, helper);
	},

	destroyCmp : function(component, event, helper){
		component.destroy();
	}
})