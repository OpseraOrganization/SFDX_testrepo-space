({
	doInit : function(component, event, helper) {
        helper.validateProfile(component,helper);
		helper.displayWarningMessage(component);
        helper.showWarningIndirect(component, event, helper);
	},

	doRefresh : function(component, event, helper) {
		helper.displayWarningMessage(component);
	},

	handleRecordUpdated: function(component, event, helper) {
		var eventParams = event.getParams();
		//F1784
        if(eventParams.changeType === "LOADED" && component.get("v.firstTimeLoading") ) {
            component.set("v.lastRefreshOIFs", component.get("v.simpleRecord.Last_Refresh_OIF__c"));
            component.set("v.oifLines", component.get("v.simpleRecord.OIF_Lines__c"));
            component.set("v.firstTimeLoading", false);
            helper.reloadingRecord(component, helper);
            helper.checkOpttyStageParams(component);
            helper.validateRiskUpsideThresholds(component, event, helper);
        } else if (eventParams.changeType === "CHANGED") {
            helper.checkOpttyStageParams(component);
        }
	},

	//F1784
	closeModalWDPlanDate: function(component, event, helper) {
		component.set("v.modal_WDDate", false);
	},

	//F1784
	submitModalWDPlanDate: function(component, event, helper) {
		helper.submitNewDecisionPlanDate(component);
		component.set("v.modal_WDDate", false);
	},

    closeWarningRU: function(component, event, helper) {
		component.set("v.warnRiskUpside", false);
	},


    //ft-241
    closeModalCareOIFBooked: function(component, event, helper) {
		component.set("v.modal_Care_OIF_Booked", false);
		component.set("v.careRenewalNotConfirmed", true);
	},

    confirmCareRenewal: function(component, event, helper) {
		component.set("v.careRenewalNotConfirmed", false);
	},

	submitCareRenewal: function(component, event, helper) {
        console.log("Submitting Automatica Care Renewal JTR");
		helper.submitCareRenewalOpp(component);
		component.set("v.modal_Care_OIF_Booked", false);
		component.set("v.careRenewalNotConfirmed", true);
	}
})