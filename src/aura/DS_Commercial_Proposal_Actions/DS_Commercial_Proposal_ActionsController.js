({
	handleExport : function(component, event, helper) {
        var Id = component.get("v.recordId");
        var url = location.href;  // entire url including querystring - also: window.location.href;
   		var baseURL = url.substring(0, url.indexOf('/', 14));

        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": baseURL+"/digitalsalesportal/apex/XauthorIntermediatePage?selectedRecordId="+Id+"&appName=Download Offer&mode=touchless&outputType=EXCEL",
        });
        urlEvent.fire();
	},
    acceptDialog : function(component, event, helper) {
		var commercialProposalRecord = component.get("v.record");
        component.set("v.isAcceptPressed", true);

/*        switch (commercialProposalRecord.Proposal_Recommendation_Type__c) {
            case 'SW Recommendation':
            case 'HW Recommendation':*/
                if (commercialProposalRecord.PO_Required__c) {
                    /* are the PO Number and PO Date filled? */
                    if (commercialProposalRecord.Apttus_QPConfig__PONumber__c != null && commercialProposalRecord.Apttus_QPConfig__PODate__c != null) {
                        var action = component.get("c.hasUploadedDocument");
                        action.setParams({
                            "recordId" : component.get("v.recordId")
                        });
                        action.setCallback(this, function(response) {
                            var state = response.getState();
                            if (state === 'SUCCESS') {
                                if(response.getReturnValue()) {
                                    component.set("v.modalText", "By accepting this binding Proposal you enclosed a signed&nbsp;<b>Purchase Order " + commercialProposalRecord.Apttus_QPConfig__PONumber__c  + "</b>&nbsp;in line with the terms of your supply agreement.");
                                    helper.showHide(component);
                                } else {
                                    /* error - missing PO document */
                                    component.find('notifLib').showToast({
                                        "title": "Missing document",
                                        "variant": "error",
                                        "message": "You can't proceed this action without uploaded signed Contract Document, please attach the document first.",
                                        "mode": "sticky"
                                    });
                                }
                            }
                        });
                        $A.enqueueAction(action);
                    } else {
                        /* error - missing PO Number */
                        component.find('notifLib').showToast({
                            "title": "Missing data",
                            "variant": "error",
                            "message": "You can't proceed this action without providing a Purchase Order Number and Date and uploading the purchase order first.",
                            "mode": "sticky"
                        });
                    }
                } else {
                    /* No PO Number is required */
                    component.set("v.modalText", "By accepting this binding Proposal, you are agreeing to activate the actual software features proposed in the Proposal.");
                    helper.showHide(component);
                }
                //break;
            /*default:
                component.set("v.modalText", "By accepting this Proposal you are agreeing to provide to Nokia a Purchase Order at your earliest before the expiry date of this existing Agreement. The Purchase Order will be issued under the Terms and Conditions of  relevant Supply/Care Agreement " + commercialProposalRecord.Name + ".");
                helper.showHide(component);
        }*/
    },
    rejectDialog : function(component, event, helper) {
        component.set("v.isAcceptPressed", false);
        component.set("v.modalText", "By cancelling this Proposal you are indicating that you don't wish to proceed with this offer, and understand the Proposal will be marked as 'Rejected'. If you wish to reverse this decision you will need to contact your Account Team.<br/><br/>If you wish to continue and reject the Proposal, please leave a reason for rejection in the Comment field.");
        helper.showHide(component);
    },
    handleAcceptReject : function(component, event, helper) {
        var rejectionReason = "";
        if (component.find('rejectionReason') != undefined) {
            if (component.find("rejectionReason").get("v.value") == undefined) {
            	component.find('rejectionReason').reportValidity();
                return;
            }
            rejectionReason = component.find("rejectionReason").get("v.value");
        }

        var action = component.get("c.updateStage");
        action.setParams({
            "recordId" : component.get("v.recordId"),
            "approvalStage" : component.find("acceptRejectButton").get("v.value"),
            "rejectionReason" : rejectionReason
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                component.find('notifLib').showToast({
                    "title": component.find("acceptRejectButton").get("v.label") + " Commercial Proposal",
                    "variant": "success",
                    "message": "The record has been successfully updated.",
                    "mode": "pester"
                });
            } else if (state === "ERROR"){
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        component.find('notifLib').showToast({
                            "title": component.find("acceptRejectButton").get("v.label") + ": Commercial Proposal",
                            "variant": "error",
                            "message": errors[0].message,
                            "mode": "sticky"
                        });
                    }
                }
            } else if (state === "INCOMPLETE") {
                component.find('notifLib').showToast({
                    "title": component.find("acceptRejectButton").get("v.label") + ": Commercial Proposal",
                    "variant": "error",
                    "message": "No response from server or client is offline.",
                    "mode": "sticky"
                });
            }
            // reload commercial proposal record to update the stage displayed in view
            component.find("record").reloadRecord(true);
            component.set("v.isSpinnerVisible", false);

        });
        $A.enqueueAction(action);
		helper.showHide(component);
        component.set("v.isSpinnerVisible", true);
    },
    handleIntermediateStageChange : function(component, event, helper) {
        var newStage = event.getSource().get("v.value");

        // change stage in the Customer Facing Attributes table
        var actionIntermediateStage = component.get("c.updateIntermediateStage");
        actionIntermediateStage.setParams({
            "recordId" : component.get("v.recordId"),
            "approvalStage" : newStage
        });
        actionIntermediateStage.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                // change stage in the Quote/Proposal table
                var actionQuoteStage = component.get("c.updateStage");
                actionQuoteStage.setParams({
                    "recordId" : component.get("v.recordId"),
                    "approvalStage" : newStage,
                    "rejectionReason" : null
                });
                actionQuoteStage.setCallback(this, function(responseQuoteStage) {
                    var stateQuoteStage = responseQuoteStage.getState();
                    if (stateQuoteStage === 'SUCCESS') {
                        component.find('notifLib').showToast({
                            "title": newStage + ": Commercial Proposal",
                            "variant": "success",
                            "message": "The record has been successfully updated.",
                            "mode": "pester"
                        });
                    } else if (stateQuoteStage === "ERROR"){
                        var errorsQuoteStage = actionQuoteStage.getError();
                        if (errorsQuoteStage) {
                            if (errorsQuoteStage[0] && errorsQuoteStage[0].message) {
                                component.find('notifLib').showToast({
                                    "title": newStage + ": Commercial Proposal",
                                    "variant": "error",
                                    "message": errorsQuoteStage[0].message,
                                    "mode": "sticky"
                                });
                            }
                        }
                    } else if (stateQuoteStage === "INCOMPLETE") {
                        component.find('notifLib').showToast({
                            "title": newStage + ": Commercial Proposal",
                            "variant": "error",
                            "message": "No response from server or client is offline.",
                            "mode": "sticky"
                        });
                    }
                    // reload commercial proposal record to update  the stage displayed in view
                    component.find("record").reloadRecord(true);
                    component.set("v.isSpinnerVisible", false);
                });
                $A.enqueueAction(actionQuoteStage);
            } else if (state === "ERROR"){
                var errors = actionIntermediateStage.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        component.find('notifLib').showToast({
                            "title": newStage + ": Commercial Proposal",
                            "variant": "error",
                            "message": errors[0].message,
                            "mode": "sticky"
                        });
                    }
                }
                component.set("v.isSpinnerVisible", false);
            } else if (state === "INCOMPLETE") {
                component.find('notifLib').showToast({
                    "title": newStage + ": Commercial Proposal",
                    "variant": "error",
                    "message": "No response from server or client is offline.",
                    "mode": "sticky"
                });
                component.set("v.isSpinnerVisible", false);
            }
        });
        $A.enqueueAction(actionIntermediateStage);
        component.set("v.isSpinnerVisible", true);
    },
    handleClose : function(component, event, helper) {
        helper.showHide(component);
    },
    editRecord: function (component, event) {
        var rectarget = event.currentTarget;
        var editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
            "recordId": component.get("v.recordId")
        });
        editRecordEvent.fire();
    }
})