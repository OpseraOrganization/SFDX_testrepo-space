({
    validateGate : function(component,event,helper) {
        var buttonLabel = '';
        var buttonLabel_bypass = '';
        var showButton = false;
        var showBypassButton = false;
        var showActions = false;
        var oppty = component.get('v.opptyRecord');
        var gate = '';
        
        if(helper.isNullOrBlank(oppty.Business_Type__c)){
            return;
        }
        if(oppty.StageName === 'Develop Opportunity' && !oppty.Gate_3_Bypass_no_offer_support__c ){
            if(oppty.Phase_Status__c === 'Opportunity in Progress'){
                buttonLabel = 'Submit for G3 Approval';
                showButton = true;
            } else if(oppty.Apttus_Approval__Approval_Status__c === 'Pending Approval') {
                showActions = true;
            }
            gate = 'g3';
        }
        if(oppty.StageName === 'Create Offer (Bid)' && oppty.NF_LoA_Bypass__c === 0 && !oppty.Gate_3_Bypass_no_offer_support__c){
            if(oppty.Phase_Status__c == 'Offer in Progress' ){
                buttonLabel = 'Submit for G4 Approval';
                showButton = true;
            } else if(oppty.Apttus_Approval__Approval_Status__c === 'Pending Approval') {
                showActions = true;
            }
            gate = 'g4';
        }
        if(oppty.StageName === 'Win the Case (Negotiate)' &&  oppty.Blanket_Approval_Condition__c === null && oppty.NF_LoA_Bypass__c === 0 ){
            if(oppty.Phase_Status__c === 'Offer Submitted to Customer (Manual)'){
                buttonLabel = 'Submit for G5 Approval';
                showButton = true;
            } else if (oppty.Phase_Status__c === 'Submitted for G5 Approval' && oppty.Apttus_Approval__Approval_Status__c === 'Pending Approval') {
                showActions = true;
            }
            gate = 'g5';
        }
        if(oppty.StageName === 'Handover (Prepare for Delivery)' &&  oppty.Blanket_Approval_Condition__c === null ) { 
            if(oppty.Phase_Status__c === 'PTA (PROJECT TARGET AGREEMENT) HANDOVER TO DELIVERY/OPERATIONS' ){
                if( !oppty.Gate_6_Bypass_No_Execute_needed__c ){
                	buttonLabel = 'Submit for G6 Approval';
                    showButton = true;
                }  
                buttonLabel_bypass = 'G6 Bypass';
                showBypassButton = true;
            } else if (oppty.Phase_Status__c === 'Submitted for G6 Approval' && oppty.Apttus_Approval__Approval_Status__c === 'Pending Approval') {
                showActions = true;
            }
            gate = 'g6';
        }
        
        component.set("v.buttonLabel", buttonLabel);
        component.set("v.buttonLabel_bypass", buttonLabel_bypass);
        component.set("v.showButton", showButton);
        component.set("v.showBypassButton", showBypassButton);
        component.set("v.showActions", showActions);
        component.set("v.gate", gate);
        helper.enableButtons(component,event,helper);
    },
    
    buttonAction : function(component,event,helper) {
        var oppty = component.get('v.opptyRecord');
        var offer = component.get('v.offerRecord');
        var action = event.getSource().get('v.label');
        var bypass = false;
        var errorMsg = '';
        
        if(action === 'Submit for G3 Approval'){
            if(oppty.OIF_Lines__c === 0){
                errorMsg = 'Cannot submit for approval until created an Order Intake Forecast.';
            } else if ( !oppty.NF_Facilitator_Notified__c && oppty.NF_Facilitator_User__c === null && oppty.Queue_Id__c === null){
                errorMsg = 'Cannot submit for approval until the G3 Facilitator is notified.';
            } 
        } else if (action === 'Submit for G4 Approval'){
            if( oppty.count_offer__c === 0 ){
                errorMsg = 'To proceed please create an offer for real G4/G5 approval or with G4/G5 bypass condition.';
            } else if (offer !== null && offer.G4_Approval_Date__c !== null){
                errorMsg = 'The offer is already G4 approved, create a new active offer for next G4.';
            }
        } else if (action === 'Submit for G5 Approval'){
            if(oppty.G5_Trigger__c === null){
                errorMsg = 'Cannot submit for approval until G5 Preparation has been concluded.';
            }
        } else if (action === 'G6 Bypass'){
           	bypass = true;
        }
        
        if(errorMsg !== '') {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "mode": 'pester',
                "type": 'error',
                "message": errorMsg
            });
            toastEvent.fire();
            helper.enableButtons(component,event,helper);
        } else if (bypass) {
            helper.submitBypass(component,event,helper);
        } else {
            helper.submitApproval(component,event,helper);
        }
    },
    
    submitApproval : function(component,event,helper) {
        var message = '';
        var gate = component.get('v.gate');
        if(gate === 'g3'){
            component.set("v.opptyRecord.Phase_Status__c", 'Submitted for G3 Approval');
            component.set("v.opptyRecord.Apttus_Approval__Approval_Status__c", 'Pending Approval');
            component.set("v.opptyRecord.G3_Submission_Date__c", $A.localizationService.formatDate(new Date(),'YYYY-MM-DD',$A.get("$Locale.language")));
            message = 'Opportunity is now Submitted for G3 Approval';
        } else if (gate === 'g4'){
            if( ! component.get("v.paramChecked") ) {
                component.set("v.simulateInfo", true);
                return;
            }
            component.set("v.opptyRecord.Phase_Status__c", 'Submitted for G4 Approval');
            component.set("v.opptyRecord.Apttus_Approval__Approval_Status__c", 'Pending Approval');
            component.set("v.opptyRecord.G4_Submission_Date__c", $A.localizationService.formatDate(new Date(),'YYYY-MM-DD',$A.get("$Locale.language")));
            var approvalLevel = component.find("approvalLevel").get("v.value");
            component.set("v.opptyRecord.LOA_Level__c", approvalLevel);
            component.set("v.offerRecord.LoA_Approval_Level__c", approvalLevel);
            message = 'Opportunity is now Submitted for G4 Approval';
        } else if (gate === 'g5'){
            component.set("v.opptyRecord.Phase_Status__c", 'Submitted for G5 Approval');
            component.set("v.opptyRecord.Apttus_Approval__Approval_Status__c", 'Pending Approval');
            component.set("v.opptyRecord.G5_Submission_Date__c",$A.localizationService.formatDate(new Date(),'YYYY-MM-DD',$A.get("$Locale.language")));
            component.set("v.opptyRecord.Sales_Outcome__c", 'Won (Requested)');
            message = 'Opportunity is now Submitted for Gate 5 Contract Approval';
        } else {
            component.set("v.opptyRecord.Phase_Status__c", 'Submitted for G6 Approval');
            component.set("v.opptyRecord.Apttus_Approval__Approval_Status__c", 'Pending Approval');
            component.set("v.opptyRecord.G6_Submission_Date__c",$A.localizationService.formatDate(new Date(),'YYYY-MM-DD',$A.get("$Locale.language")));
            message = 'Opportunity is now Submitted for G6 Approval';
        }
        component.set("v.toastMessage", message)
        helper.handleSaveRecord(component,event,helper);
    },
    
    recallApproval : function(component,event,helper) {
        var message = '';
        var gate = component.get('v.gate');
        if(gate === 'g3'){
            component.set("v.opptyRecord.Phase_Status__c", 'Opportunity in Progress');
            component.set("v.opptyRecord.Apttus_Approval__Approval_Status__c", 'Not Submitted');
            component.set("v.opptyRecord.G3_Submission_Date__c", null);
            message = 'Opportunity has been recall to "Develop Opportunity"';
        } else if (gate === 'g4'){
            component.set("v.opptyRecord.Phase_Status__c", 'Offer in Progress');
            component.set("v.opptyRecord.Apttus_Approval__Approval_Status__c", 'Not Submitted');
            component.set("v.opptyRecord.G4_Submission_Date__c", null);
            message = 'Opportunity has been recall to "Offer in Progress"';
        } else if (gate === 'g5'){
            component.set("v.opptyRecord.Phase_Status__c", 'Offer Submitted to Customer (Manual)');
            component.set("v.opptyRecord.Apttus_Approval__Approval_Status__c", 'Not Submitted');
            component.set("v.opptyRecord.G5_Submission_Date__c", null);
            component.set("v.opptyRecord.Sales_Outcome__c", null);
            message = 'Opportunity has been recall to "Offer Submitted to Customer (Manual)"';
        } else {
            component.set("v.opptyRecord.Phase_Status__c", 'PTA (PROJECT TARGET AGREEMENT) HANDOVER TO DELIVERY/OPERATIONS');
            component.set("v.opptyRecord.Apttus_Approval__Approval_Status__c", 'Not Submitted');
            component.set("v.opptyRecord.G6_Submission_Date__c", null);
            message = 'Opportunity has been recall to "PTA (PROJECT TARGET AGREEMENT) HANDOVER TO DELIVERY/OPERATIONS"';
        }
       
         component.set("v.toastMessage", message)
        helper.handleSaveRecord(component,event,helper);
    },
    
    approveApproval : function(component,event,helper) {
        var message = '';
        var gate = component.get('v.gate');
        if(gate === 'g3'){
            component.set("v.opptyRecord.StageName", 'Create Offer (Bid)');
            component.set("v.opptyRecord.Phase_Status__c", 'Offer in Progress');
            component.set("v.opptyRecord.Apttus_Approval__Approval_Status__c", 'Approved');
            component.set("v.opptyRecord.Approvals_Current_Status__c", 'Approved G3');
            component.set("v.opptyRecord.ApprovalStatusTechField__c", 'Approved G2,Approved G3');
            component.set("v.opptyRecord.G3_Approval_Date__c", $A.localizationService.formatDateTime(new Date() ,'yyyy-MM-ddTHH:mm:ss.SSSZ' ,$A.get("$Locale.language")));
            component.set("v.opptyRecord.G3_Approver__c", component.get("v.currentUser.Name"));
            message = 'Opportunity has been approved and moved to "Create Offer (Bid)"';
        } else if (gate === 'g4'){
            component.set("v.opptyRecord.StageName", 'Win the Case (Negotiate)');
            component.set("v.opptyRecord.Phase_Status__c", 'Offer Submitted to Customer (Manual)');
            component.set("v.opptyRecord.Apttus_Approval__Approval_Status__c", 'Approved');
            component.set("v.opptyRecord.Approvals_Current_Status__c", 'Approved G4');
            component.set("v.opptyRecord.ApprovalStatusTechField__c", 'Approved G2,Approved G3,Approved G4');
            component.set("v.opptyRecord.G4_Approval_Date__c", $A.localizationService.formatDateTime(new Date(),'yyyy-MM-ddTHH:mm:ss.SSSZ',$A.get("$Locale.language")));
            component.set("v.opptyRecord.G4_Approver__c", component.get("v.currentUser.Name"));
            component.set("v.offerRecord.G4_Approval_Date__c", $A.localizationService.formatDateTime(new Date(),'yyyy-MM-ddTHH:mm:ss.SSSZ',$A.get("$Locale.language")));
            component.set("v.offerRecord.G4_Approver__c", component.get("v.currentUser.Name"));
            message = 'Opportunity has been approved and moved to "Win the Case (Negotiate)"';
        } else if (gate === 'g5'){
            component.set("v.opptyRecord.Phase_Status__c", 'Pending Win/Loss Declaration');
            component.set("v.opptyRecord.Apttus_Approval__Approval_Status__c", 'Approved');
            component.set("v.opptyRecord.Approvals_Current_Status__c", 'Approved G5 Contract');
            component.set("v.opptyRecord.G5_Contract_Approval_Date__c",$A.localizationService.formatDateTime(new Date(),'yyyy-MM-ddTHH:mm:ss.SSSZ',$A.get("$Locale.langLocale")));
            component.set("v.opptyRecord.G5_Approver__c", component.get("v.currentUser.Name"));
            component.set("v.opptyRecord.Sales_Outcome__c", 'Won (Requested)');
            message = 'Opportunity has been approved and moved to "Pending Win/Loss Declaration"';
        } else {
            component.set("v.opptyRecord.StageName", 'Execute (Start Delivery)');
            component.set("v.opptyRecord.Phase_Status__c", 'In Execution');
            component.set("v.opptyRecord.Apttus_Approval__Approval_Status__c", 'Approved');
            component.set("v.opptyRecord.Approvals_Current_Status__c", 'Approved G6');
             component.set("v.opptyRecord.ApprovalStatusTechField__c", 'Approved G2,Approved G3,Approved G4,Approved G5,Approved G6');
            component.set("v.opptyRecord.G6_Approval_Date__c",$A.localizationService.formatDateTime(new Date(),'yyyy-MM-ddTHH:mm:ss.SSSZ',$A.get("$Locale.langLocale")));
            component.set("v.opptyRecord.G6_Approver__c", component.get("v.currentUser.Name"));
            message = 'Opportunity has been approved and moved to "Execute (Start Delivery)"';
        }
        component.set("v.toastMessage", message)
        helper.handleSaveRecord(component,event,helper);
    },
    
    rejectApproval : function(component,event,helper) {
        var message = '';
        var gate = component.get('v.gate');
        if(gate === 'g3'){
            component.set("v.opptyRecord.Phase_Status__c", 'Opportunity in Progress');
            component.set("v.opptyRecord.Apttus_Approval__Approval_Status__c", 'Rejected');
            component.set("v.opptyRecord.Approvals_Current_Status__c", 'Rejected G3');
            component.set("v.opptyRecord.G3_Submission_Date__c", null);
            message = 'Opportunity has been rejected and moved to "Develop Opportunity"';
        } else if (gate === 'g4'){
            component.set("v.opptyRecord.Phase_Status__c", 'Offer in Progress');
            component.set("v.opptyRecord.Apttus_Approval__Approval_Status__c", 'Rejected');
            component.set("v.opptyRecord.Approvals_Current_Status__c", 'Rejected G4');
            component.set("v.opptyRecord.G4_Submission_Date__c", null);
            message = 'Opportunity has been rejected and moved to "Offer in Progress"';
        } else if (gate === 'g5'){
            component.set("v.opptyRecord.Phase_Status__c", 'Offer Submitted to Customer (Manual)');
            component.set("v.opptyRecord.Apttus_Approval__Approval_Status__c", 'Rejected');
            component.set("v.opptyRecord.Approvals_Current_Status__c", 'Rejected G5 Contract');
            component.set("v.opptyRecord.G5_Submission_Date__c", null);
            component.set("v.opptyRecord.Sales_Outcome__c", null);
            message = 'Opportunity has been rejected and moved to "Offer Submitted to Customer (Manual)"';
        } else {
            component.set("v.opptyRecord.Phase_Status__c", 'PTA (PROJECT TARGET AGREEMENT) HANDOVER TO DELIVERY/OPERATIONS');
            component.set("v.opptyRecord.Apttus_Approval__Approval_Status__c", 'Rejected');
            component.set("v.opptyRecord.G6_Submission_Date__c", null);
            component.set("v.opptyRecord.Approvals_Current_Status__c", 'Rejected G6');
            message = 'Opportunity has been rejected and moved to "PTA (PROJECT TARGET AGREEMENT) HANDOVER TO DELIVERY/OPERATIONS"';
        }
        component.set("v.toastMessage", message)
        helper.handleSaveRecord(component,event,helper);
    },
    
    submitBypass: function(component,event,helper) {
        var message = '';
        var gate = component.get('v.gate');
        if( gate === 'g6'){
            component.set("v.opptyRecord.Gate_6_Bypass_No_Execute_needed__c", true);
            component.set("v.opptyRecord.StageName", 'Execute (Start Delivery)');
            component.set("v.opptyRecord.Phase_Status__c", 'In Execution');
            component.set("v.opptyRecord.Apttus_Approval__Approval_Status__c", 'Approved');
            component.set("v.opptyRecord.ApprovalStatusTechField__c", 'Approved G2,Approved G3,Approved G4,Approved G5,Approved G6');
            component.set("v.opptyRecord.G6_Approval_Date__c",$A.localizationService.formatDateTime(new Date(),'yyyy-MM-ddTHH:mm:ss.SSSZ',$A.get("$Locale.langLocale")));
            message = 'Opportunity has been bypassed to "Execute (Start Delivery)"';
        }
        component.set("v.toastMessage", message)
        helper.handleSaveRecord(component,event,helper);
    },
    
    handleSaveRecord: function(component,event,helper) {
        component.find("recordLoader").saveRecord($A.getCallback(function(saveResult) {
            var toastType = '';
            var message = component.get("v.toastMessage");
            if (saveResult.state === "SUCCESS" ) {
                toastType = 'success';
                if(component.get('v.gate') === 'g4' && ( component.get("v.offerRecord.G4_Approval_Date__c") !== null || component.get("v.offerRecord.LoA_Approval_Level__c") !== null) ){
                    helper.handleSaveOfferRecord(component,event,helper);
                }
            } else {
                toastType = 'error';
                message = 'Not possible to update the Opportunity. Please try again or contact support.';
            } 
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "mode": 'pester',
                "type": toastType,
                "message": message
            });
            toastEvent.fire();
            helper.enableButtons(component,event,helper);
        }));
    },
    
    handleSaveOfferRecord: function(component,event,helper) {
        component.find("recordLoaderOffer").saveRecord($A.getCallback(function(saveResult) {
            if (saveResult.state === "SUCCESS" ) {
                console.log('offer updated with success');
            }
        }));
    },
    
    enableButtons : function(component,event,helper){
        component.set("v.loading", false);
        if( component.find("recallButton") !== undefined) component.find("recallButton").set('v.disabled',false);
        if( component.find("approveButton") !== undefined) component.find("approveButton").set('v.disabled',false);
        if( component.find("rejectButton") !== undefined) component.find("rejectButton").set('v.disabled',false);
        if( component.find("submitButton") !== undefined) component.find("submitButton").set('v.disabled',false);
        if( component.find("bypassButton") !== undefined) component.find("bypassButton").set('v.disabled',false);
    },
    
    disableButtons : function(component,event,helper){
        component.set("v.loading", true);
        if( component.find("recallButton") !== undefined) component.find("recallButton").set('v.disabled',true);
        if( component.find("approveButton") !== undefined) component.find("approveButton").set('v.disabled',true);
        if( component.find("rejectButton") !== undefined) component.find("rejectButton").set('v.disabled',true);
         if( component.find("submitButton") !== undefined) component.find("submitButton").set('v.disabled',true);
        if( component.find("bypassButton") !== undefined) component.find("bypassButton").set('v.disabled',true);
    },
    
    isNullOrBlank : function(variable) {
        if(typeof variable === 'undefined' || variable == null || variable == '' )
            return true;
        else
            return false;
    },
})