({
	verifyUserEditAccess : function(component,event,helper) {
		var action = component.get("c.allowedUserToEdit");
        action.setParams({
            recordId : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var result = response.getReturnValue();
            if(response.getState()==='SUCCESS' && result != null)
            {
                var editButton = component.find("editSections_button");
                if(!result)
                	$A.util.addClass(editButton, "hidden_element");
            }
        })
        $A.enqueueAction(action);
	},

    setRiskAssessmentButton : function(component,event,helper) {
        var riskAssessmentLink = component.get("v.opptyRecord.Risk_Assessment__c");
        var riskAssessButton = component.find("riskAssessment_button");
        if( helper.isEmpty(riskAssessmentLink) ){
            $A.util.addClass(riskAssessButton,"hidden_element");
        } else {
          	$A.util.removeClass(riskAssessButton,"hidden_element");
        }
    },

    openRiskAssessment: function(component, event) {
        var riskLink = component.get("v.opptyRecord.Risk_Assessment__c");
        window.open(riskLink,'_blank');
    },


    commentsStrategyRequired : function(component,event,helper){
        var customerpoints = component.find("Customer_pain_points_challenges__c").get("v.value");
        var criteria = component.find("Selection_Criteria__c").get("v.value");
        if( (!helper.isEmpty(customerpoints) && customerpoints.includes('Other + Comment*')) || (!helper.isEmpty(criteria) && criteria.includes('Other + Comment*') ) ){
            component.set("v.requiredCommentStrategy", true);
        } else {
            component.set("v.requiredCommentStrategy", false);
        }
    },

    validateStrategyForm : function(component,event,helper){
        var comments = component.find("Comments_Cust_Req_Nokia_Prop__c");
        if(component.get("v.requiredCommentStrategy") && helper.isEmpty(comments.get("v.value")) ){
            helper.showSpinner(component,'spinner', false);
            $A.util.addClass(comments,"slds-has-error");
            component.find("messages").setError('Please fill "Comments on Cust Req & Nokia Prop"' );
            helper.scrollTop(component);
            return ;
        }
        component.find("custReqNokiaProp_Form").submit();
        component.find("commRes_Form").submit();
    },

    removeErrorMarkup : function(component,event,helper){
        var commentsfield = component.find("Comments_Cust_Req_Nokia_Prop__c");
        $A.util.removeClass(commentsfield,"slds-has-error");
        component.find("messages").setError('');
    },

    scrollTop : function(component){
        var header = component.find("header");
        var headerSet = header.getElements()[0].getBoundingClientRect();
        var top = headerSet.y+window.scrollY-276;
		scrollTo({top:top, behavior: "smooth"});
    },

    showSpinner : function(component, spinnerId, show){
        var spinner = component.find(spinnerId);
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