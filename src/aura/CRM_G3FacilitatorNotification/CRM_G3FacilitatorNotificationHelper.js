({
    intervalRecLoader:0,
    firstTimeLoading:true,
    keyDeal:false,

    getFacilitatorInformation : function(component,event,helper){
        var action = component.get("c.initAction");
        action.setParams({
			opportunityId: component.get("v.recordId")
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var facilitatorInfo = response.getReturnValue();
                if(facilitatorInfo != null){
                    component.set("v.facilitatorInfo", facilitatorInfo);
                    if(facilitatorInfo.errorMessage != null && facilitatorInfo.notFound === undefined){
                        helper.dismissWithToast(component,event,helper);
                    }  else {
                        helper.initialize(component,event,helper);
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    //INI - ft358
    getOfferId : function(component,event,helper){
        var action = component.get("c.getOfferId");
        action.setParams({
			opportunityId: component.get("v.recordId")
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var offerID = response.getReturnValue();
                if(offerID != null){
                    component.set("v.offerId", offerID);
                }
            }
        });
        $A.enqueueAction(action);
    },
    //ENd - ft358

    setRiskAssessmentIcon : function(component,event, helper) {
        var g3Prepared = component.get("v.opptyRecord.G3_Prepared__c");
        var icon = component.find("riskAssessIcon");
        if(g3Prepared){
            icon.set("v.iconName", "utility:check");
            icon.set("v.variant", 'success');
            var riskAssessField = component.find("riskAssessIcon");
        	$A.util.removeClass(riskAssessField, "error");
        } else {
            icon.set("v.iconName", "utility:close");
            icon.set("v.variant", 'error');
        }
	},

    setRiskAssessmentButton: function(component,event, helper) {
        var riskLink = component.get("v.opptyRecord.Risk_Assessment__c");
        var button = component.find("riskAssessButton");
        if(helper.isEmpty(riskLink)){
            button.set("v.disabled", true);
            button.set("v.title", 'No Risk Assessment link');
        } else {
            button.set("v.disabled", false);
            button.set("v.title", '');
        }
	},

    setCategory : function(component,event, helper) {
        var thresholdCase = $A.get("$Label.c.G3_Strategy_Submit_Faciliator_Treshold");
        var bigCase = component.get("v.opptyRecord.Unweighted_Amount_EUR__c") >= thresholdCase;
        component.set("v.bigCase", bigCase);
       	var thresholdKeyDeal = $A.get("$Label.c.Opportunity_KeyDeals_Threshold");
        helper.keyDeal = component.get("v.opptyRecord.Unweighted_Amount_EUR__c") >= thresholdKeyDeal;
	},

    initialize : function(component,event,helper){
        var form = component.find("form");
        $A.util.removeClass(form, "hidden_element");
        if(component.get("v.facilitatorInfo.notFound")){
            var notifyButton = component.find("notify_button");
        	notifyButton.set("v.disabled", true);
            notifyButton.set("v.title", "No facilitator to notify");
        }
    },

    commentsStrategyRequired : function(component,event,helper){
        var fields = component.find("requiredField");
        var customerpoints ;
        var criteria ;
        fields.forEach(function (field) {
            if(field.get("v.fieldName") === 'Customer_pain_points_challenges__c'){
                customerpoints = field.get("v.value");
            } else if (field.get("v.fieldName") === 'Selection_Criteria__c') {
                criteria = field.get("v.value");
            }
        });
        if( (!helper.isEmpty(customerpoints) && customerpoints.includes('Other + Comment*')) || (!helper.isEmpty(criteria) && criteria.includes('Other + Comment*') ) ){
            component.set("v.requiredComments", true);
            $A.util.addClass(component.find("Comments_Cust_Req_Nokia_Prop__c"), "requiredField");
        } else {
            component.set("v.requiredComments", false);
            $A.util.removeClass(component.find("Comments_Cust_Req_Nokia_Prop__c"), "requiredField");
        }
    },

    onChangeTypeRequest : function(component,event,helper){
        var orgL4 = component.get("v.opptyRecord.Org_L4__c");
        if((orgL4 === 'Market North America' || orgL4 === 'Market NFS') ){
            helper.showSpinner(component, "spinnerCard", true);
            var opportunity = {'sobjectType':'Opportunity','Id': component.get("v.recordId"), 'Type_of_Request__c':event.getParam("value")};
            var editedFields = ['Type_of_Request__c'];
            var action = component.get("c.recalculateFacilitator");
            action.setParams({
                editedOppty: opportunity,
                editedFields: editedFields
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var facilitatorInfo = response.getReturnValue();
                    if(facilitatorInfo != null){
                        component.set("v.facilitatorInfo", facilitatorInfo);
                        helper.initialize(component,event,helper);
                    }
                }
                helper.showSpinner(component, "spinnerCard", false);
            });
            $A.enqueueAction(action);
        }
    },

    validateForm : function(component,event,helper){
        var isValid = true;
        //required fields
        var fields = component.find("requiredField");
        fields.forEach(function (field) {
            if( helper.isEmpty(field.get("v.value")) ){
                isValid = false;
                $A.util.addClass(field, "slds-has-error");
            }
        });

        //Risk assessment
        var g3Prepared = component.get("v.opptyRecord.G3_Prepared__c");
        if( !g3Prepared ){
            isValid = false;
            var riskAssessField = component.find("riskAssessIcon");
            $A.util.addClass(riskAssessField, "error");
        }

        //if a big case check : comments
        if(component.get("v.bigCase")){
            //comments
            var comments = component.find("Comments_Cust_Req_Nokia_Prop__c");
            if(comments !== undefined && component.get("v.requiredComments") &&  helper.isEmpty(comments.get("v.value")) ){
                isValid = false;
                $A.util.addClass(comments, "slds-has-error");
            }

            //competitors
            var competitors = component.get("v.competitorList") === undefined ? [] : component.get("v.competitorList");
            var nokiaCompetitor = null;
            var selectedOtherOption = false;
            competitors.forEach(function(competitor){
                if(competitor.name === 'Nokia'){
                    nokiaCompetitor = competitor;
                }
                if( competitor.weakness.includes('Other + Comment*') || competitor.strength.includes('Other + Comment*') )
                {
                    selectedOtherOption = true;
                }
            })
            //if key deal then check if Nokia competitor has strength and weakness
            if(helper.keyDeal && ( nokiaCompetitor === null || nokiaCompetitor.strength.length === 0 || nokiaCompetitor.weakness.length ===0 )){
                isValid = false;
                $A.util.removeClass(component.find("competitorError"),"hidden_element" );
            }
            if(selectedOtherOption && helper.isEmpty( component.get("v.competitorComments") ) ){
                isValid = false;
                var competitorAnalysisCMP = component.find("competitorListView");
                $A.util.addClass(competitorAnalysisCMP.find("Comments_Competitive_Analysis__c"), "slds-has-error");
            }
        }

        if( isValid ){
            helper.notifyG3Facilitator(component, event, helper);
        } else {
            helper.showSpinner(component,"spinner",false);
           	helper.showErrorBadge(component);
           	helper.scrollTop();
        }
    },

    dismissWithToast : function(component,event,helper){
        var facilitatorInfo = component.get("v.facilitatorInfo");
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            mode: 'dismissable',
            duration: 30000,
            message: facilitatorInfo.errorMessage,
            type: 'error'
        });
        toastEvent.fire();
        helper.dismiss(component,event,helper);
    },

    dismiss : function(component,event,helper){
        clearInterval(helper.intervalRecLoader);
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.recordId"),
            "slideDevName": "detail"
        });
        navEvt.fire();
    },

    notifyG3Facilitator : function(component,event,helper){
        var fields = event.getParam('fields');
        console.log("fields = " + fields);
        fields['NF_Facilitator_Notified__c'] = true;
        if(component.get('v.facilitatorInfo.queueID') === undefined || component.get('v.facilitatorInfo.queueID') === null) {
            fields['NF_Facilitator_User__c']=component.get('v.facilitatorInfo.facilitator.userId');
            fields['Facilitator_Delegate_1__c']=component.get('v.facilitatorInfo.delegate1.userId');
            fields['Facilitator_Delegate_2__c']=component.get('v.facilitatorInfo.delegate2.userId');
            fields['Facilitator_Delegate_3__c']=component.get('v.facilitatorInfo.delegate3.userId');
        } else {
            fields['Queue_Id__c']=component.get('v.facilitatorInfo.queueID');
            fields['Queue_Name__c']=component.get('v.facilitatorInfo.queueName');
        }
        fields['Comments_Competitive_Analysis__c'] = component.get('v.competitorComments');
        var action = component.get("c.updateOppty");
        action.setParams({
            opptyId: component.get("v.recordId"),
            opptyFields: JSON.stringify(fields)
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var responseMsg = response.getReturnValue();
            if (state === "SUCCESS" && responseMsg === 'SUCCESS') {
                console.log('Success on G3 Facilitator Notification');
                helper.dismiss(component,event,helper);
                component.find('recordEditFormOffer').submit();
            } else {
                var errorMsg;
                if(state === "SUCCESS" ){
                    errorMsg = responseMsg;
                } else {
                    errorMsg = response.getError()[0].message;
                }
                component.find("messages").setError(errorMsg);
                helper.showSpinner(component,"spinner",false);
        		helper.scrollTop();
                console.log('It was not possible to notify the facilitator');
            }
        });
        $A.enqueueAction(action);
    },

    scrollTop : function(){
        var scrollOptions = {
            left: 0,
            top: 0,
            behavior: 'smooth'
        }
        window.scrollTo(scrollOptions);
    },

    showErrorBadge : function(component){
        component.set("v.showError", true);
    },

    removeAllErrorMarkup : function(component){
        component.set("v.showError", false);
        $A.util.removeClass(component.find("riskAssessIcon"), "error");
        var fields = component.find("requiredField");
        fields.forEach(function (field) {
             $A.util.removeClass(field, "slds-has-error");
        });
        $A.util.removeClass(component.find("Comments_Cust_Req_Nokia_Prop__c"), "slds-has-error");
        $A.util.removeClass(component.find("Comments_Competitive_Analysis__c"), "slds-has-error");
        $A.util.addClass(component.find("competitorError"),"hidden_element" );
    },

    showSpinner : function(component,sprinnerId, show){
        var spinner = component.find(sprinnerId);
        if(show){
            $A.util.removeClass(spinner, "hidden_element");
        }else{
            $A.util.addClass(spinner, "hidden_element");
        }
    },

    isEmpty : function(variable){
        return typeof variable === 'undefined' || variable === null || variable === 'undefined' || variable === '';
    }

})