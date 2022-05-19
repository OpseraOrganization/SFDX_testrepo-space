({
    validateProfile : function(component,helper){
        var action = component.get("c.validateFieldsAccessibility");
        action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var fields = response.getReturnValue();
				if(fields !== null && fields !== ''){
					component.set("v.fields", fields);
				}
			}
		});
		$A.enqueueAction(action);
    },

	//F1784 - method to reload repeatly the record and if there is a change in the OIF
	reloadingRecord : function(component, helper){

        var isClosed = component.get("v.simpleRecord.IsClosed");
        //set to reload the record every x seconds
        setInterval(
            $A.getCallback(function() {
                var loader = component.find("recordLoader");
                if(loader !== undefined){
                    loader.reloadRecord(true, $A.getCallback(function() {
                        var newLastRefresh = component.get("v.simpleRecord.Last_Refresh_OIF__c");
                        var oldLastRefresh = component.get("v.lastRefreshOIFs");
                        var newOIFLines = component.get("v.simpleRecord.OIF_Lines__c");
                        var oldOIFLines = component.get("v.oifLines");
                        var newCaraRenewal = component.get("v.simpleRecord.Care_Renewal__c");
                        var oldCaraRenewal = component.get("v.careRenewalFlag");
                        if( ((newLastRefresh != null && newLastRefresh !== oldLastRefresh) || (newOIFLines != null && newOIFLines != oldOIFLines)) && !isClosed ){
                            component.set("v.lastRefreshOIFs", component.get("v.simpleRecord.Last_Refresh_OIF__c"));
                            component.set("v.oifLines", component.get("v.simpleRecord.OIF_Lines__c"));
                            helper.checkOIFChanges(component);
                            helper.validateRiskUpsideThresholds(component, null,helper);
                        }
                        if((newLastRefresh != null && newLastRefresh !== oldLastRefresh) || (newOIFLines != null && newOIFLines != oldOIFLines) || (newCaraRenewal != null && newCaraRenewal && !oldCaraRenewal) )
                        {
                            component.set("v.careRenewalFlag", component.get("v.simpleRecord.Care_Renewal__c"));
                            helper.fetchCareOIFLines(component, helper);//ft-241
                        }
                        if( (newCaraRenewal != null && !newCaraRenewal && oldCaraRenewal) )
                        {
                            component.set("v.careRenewalFlag", component.get("v.simpleRecord.Care_Renewal__c"));
                            component.set("v.oifList", null);
                        }
                    }))
                }}), 6000
        );
	},

	//F1784 - check if there are any date changes and if there is a proposed new G5 Plan Date
	checkOIFChanges : function(component) {

		var action = component.get("c.checkMinPlanDateOIF");

		action.setParams({
			recordId: component.get("v.recordId")
		});

		action.setCallback(this, function(response) {

			var state = response.getState();

			if (state === "SUCCESS") {
				var newWDPlanDate = response.getReturnValue();
				if(newWDPlanDate != null){
					component.set("v.newWDPlanDate", newWDPlanDate);
					component.set("v.modal_WDDate", true);
				}
			}
		});
		$A.enqueueAction(action);
	},

	//F1784 - Save the new Win Declaration plan date on the opportunity
	submitNewDecisionPlanDate : function(component){

		var action = component.get("c.overrideDecisionPlanDate");

		action.setParams({
			recordId: component.get("v.recordId"),
			newWDPlanDate: component.get("v.newWDPlanDate")
		});

		action.setCallback(this, function(response) {

			var state = response.getState();

			if (state === "SUCCESS") {

				var resultsToast = $A.get("e.force:showToast");
				resultsToast.setParams({
					"title": "Win Declaration Plan Date",
					"message": "The Win Declaration Plan Date was successfully updated.",
					"type": "info",
					"mode":"pester",
					"duration":10000
				});
				resultsToast.fire();
				$A.get('e.force:refreshView').fire();

			} else if(state === "ERROR") {
				var errors = response.getError();
				var message = "There was a problem and it was not possible to update the Win Declaration Plan Date. Go to Opportunity Detail page to confirm planning.";
				if(errors.length  > 0 && errors[0].pageErrors){
					for(var i = 0; i < errors[0].pageErrors.length ; i++){
						if(errors[0].pageErrors[i].statusCode == "FIELD_CUSTOM_VALIDATION_EXCEPTION" && errors[0].pageErrors[i].message.includes("The Gate Planned Date entered is either blank")){
							message = "The update of the Win Declaration Planned Date was not possible due to inconsistency with dates of preceding gates. Please go to Detail tab and thoroughly rework the opportunity planned dates.";
							break;
						}
					}
				}

				var resultsToast = $A.get("e.force:showToast");
				resultsToast.setParams({
					"title": "Win Declaration Plan Date",
					"message": message,
					"type": "error",
					"mode":"pester",
					"duration":10000
				});
				resultsToast.fire();
			}
		});
		$A.enqueueAction(action);
	},

	checkOpttyStageParams : function(component) {

		var action = component.get("c.checkOpttyStageParams");

		action.setParams({ recordId: component.get("v.recordId")});
		action.setCallback(this, function(response){
			if(response.getReturnValue() ===1)
			{
				var resultsToast = $A.get("e.force:showToast");
				resultsToast.setParams({
					"title": "Please Note",
					"message": "Main Reason 1 : \"Value is pre-populated to Sales and Customer Engagement\"\n Main Reason 2 : \"Value is pre-populated to Commercial\"\n Main Reason 3 : \"Value is pre-populated to Mistake/Redundant/Merged\" ",
					"type": "info",
					"mode":"sticky"
				});
				resultsToast.fire();
			 }

		});
		$A.enqueueAction(action);
	},

	displayWarningMessage: function(component) {

		var currentUrl = window.location.href; // Get current url

		var action = component.get("c.findOffer");

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

    showWarningIndirect : function(component, event, helper) {
        var action=component.get("c.getOpptyInfo");

        action.setParams({
            currentRecordId : component.get("v.recordId"),
        });

        action.setCallback(this,function(response){
            var state = response.getState();
            var result = response.getReturnValue();
            if (state === "SUCCESS" && result ) {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    message: 'This is Warning Toast...!!!',
                    messageTemplate: 'Indirect opportunities require ACAF questionnaires to be in line with the {0}. Please verify that a valid Company Profile Questionnaire (CPQ) and ACAF are in place for the related third party and opportunity and if not, please initiate these questionnaires now in the {1} in order avoid delays in the process. Any questions, you can reach out to your Ethics & Compliance leaders {2}.',
                    messageTemplateData: [
                        { url: 'https://nokia.sharepoint.com/sites/policies/Controlled%20Documents/SOPs/SOP%20on%20Third%20Party%20Risk%20Management.pdf',
                         label: 'SOP on Third Parties'
                        },
                        {url: 'https://nokia.compliancedesktop.com/',
                         label: 'Compliance Desktop Tool',},
                        {url: 'https://nokia.sharepoint.com/sites/ethics_compliance/Shared%20Documents/Forms/AllItems.aspx?id=%2Fsites%2Fethics%5Fcompliance%2FShared%20Documents%2FCompliance%20Leaders%20list%2Epdf&parent=%2Fsites%2Fethics%5Fcompliance%2FShared%20Documents',
                         label: 'here',}
                    ],
                    duration:' 60000',
                    type: 'warning'
                });
                toastEvent.fire();
           }
        });
        $A.enqueueAction(action);
    },

    validateRiskUpsideThresholds : function(component, event, helper) {
        var opptyType = component.get("v.simpleRecord.Type");
        var thresholdVal = opptyType === 'ENT' ? Number($A.get("$Label.c.OIF_Upside_and_Risk_Threshold_for_ENT_Opportunities")) : Number($A.get("$Label.c.OIF_Upside_and_Risk_Threshold"));
        var upsidesVal = component.get("v.simpleRecord.Upside_Subtotal__c") === null ? 0 : component.get("v.simpleRecord.Upside_Subtotal__c");
        var risksVal = component.get("v.simpleRecord.Risk_Subtotal__c") === null ? 0 : component.get("v.simpleRecord.Risk_Subtotal__c");
        var checkRiskSection = component.get("v.simpleRecord.Risk_Categories__c") === null || component.get("v.simpleRecord.Risk_Rating__c") === null || component.get("v.simpleRecord.Risk_type__c") === null;
        var checkUpsideSection = component.get("v.simpleRecord.Upside_Categories__c") === null || component.get("v.simpleRecord.Upside_Rating__c") === null ;
        if( ( upsidesVal >= thresholdVal  && checkUpsideSection) || (risksVal >= thresholdVal && checkRiskSection) ){
            component.set("v.warnRiskUpside", true);
        }
    },


	//ft-241  - Create Renewal Opportunity
	submitCareRenewalOpp : function(component){

		var action = component.get("c.createCareRenewalOpp");
		action.setParams({
			recordId: component.get("v.recordId"),
			renewalYears: parseInt(component.find("renewalYearsInput").get("v.value"))
		});
		action.setCallback(this, function(response) {
    		component.set("v.disableCareRenBtn", false);
			var state = response.getState();
			if (state === "SUCCESS")
            {
                var returned = response.getReturnValue();
                var resultsToast = $A.get("e.force:showToast");
                if(returned.includes(' '))
                {
                    resultsToast.setParams({
                        "title": "Automatic Care Renewal",
                        "message": returned,
                        "type": "info",
                        "mode":"pester",
                        "duration":10000
                    });
                    resultsToast.fire();
                    $A.get('e.force:refreshView').fire();
                }
                else
                {
                    var linkToOriginal = window.location.origin + '/' + returned;
                    resultsToast.setParams({
                        "title": "Automatic Care Renewal",
                        "message": "The Care Renewal Opportunity was successfully created: ",
                        "messageTemplate": "The {0} was successfully created: ",
                        "messageTemplateData": [{ "url": linkToOriginal,
                                                  "label": "Care Renewal Opportunity" }],
                        "type": "success",
                        "mode":"pester",
                        "duration":10000
                    });
                    resultsToast.fire();
                    $A.get('e.force:refreshView').fire();
                }
			}
            else if(state === "ERROR")
            {
				var errors = response.getError();
				var message = "There was a problem creating the Renewal Opportunity. Please proceed with a manual creation.";
				var resultsToast = $A.get("e.force:showToast");
				resultsToast.setParams({
					"title": "Automatic Renewal Opportunity",
					"message": message,
					"type": "error",
					"mode":"pester",
					"duration":10000
				});
				resultsToast.fire();
			}
            component.set("v.modal_Care_OIF_Booked", false);
            component.set("v.careRenewalNotConfirmed", true);
		});
        component.set("v.disableCareRenBtn", true);
		$A.enqueueAction(action);
	},

    //ft-241
    fetchCareOIFLines : function(component)
    {
        var action = component.get("c.fetchCareOIFLinesApex");
        action.setParams({recordId: component.get("v.recordId")});
        action.setCallback(this, function(response, helper) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(Object.keys(response.getReturnValue()).length === 0){
                    console.log("Opportunity is not Care Renewal or does not have any Care Renewal OIF Line.");
                }else if(component.get("v.oifList") == null){
                    component.set("v.oifList", response.getReturnValue());
                }else{
                    var oldOIFs = component.get("v.oifList");
                    var newOIFs = response.getReturnValue();
                    if(this.checkForBookedOIF(oldOIFs, newOIFs))
                    {
                        this.openModalCareOIFBooked(component);
                    }
                    component.set("v.oifList", newOIFs);//update  OIF list
                    component.set("v.careRenewalFlag", newOIFs);//update  OIF list
                }
            }
            else
            {
                var message = "There was a problem fetching the OIF lines for this opoortunity. Automatic Care Renewal functionality may not work.";
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Automatic Renewal Opportunity",
                    "message": message,
                    "type": "error",
                    "mode":"pester",
                    "duration":10000
                });
                resultsToast.fire();
            }
        });
        $A.enqueueAction(action);
    },

    //ft-241
    openModalCareOIFBooked: function(component)
    {
		component.set("v.modal_Care_OIF_Booked", true);
		component.set("v.careRenewalNotConfirmed", true);
	},

    checkForBookedOIF: function(oldOIFs, newOIFs)
    {
        var numberOIFLines = Object.keys(newOIFs).length;
        var bookedOIFs = false;
        for(var i = 0; i < numberOIFLines; i++)
        {
            var oifId = Object.keys(newOIFs)[i];
            var newForecastCat = newOIFs[oifId].Forecast_Category__c;
            var updatingUserId = newOIFs[oifId].LastModifiedById;
            if( ((typeof oldOIFs[oifId] === "undefined" && newForecastCat == 'Booked') || (typeof oldOIFs[oifId] != "undefined" && newForecastCat != oldOIFs[oifId].Forecast_Category__c && newForecastCat == 'Booked')) && updatingUserId == $A.get("$SObjectType.CurrentUser.Id") )
            {
                bookedOIFs = true;
            }
        }
		return bookedOIFs;
    }
})