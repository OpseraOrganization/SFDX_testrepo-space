({
    
    onPageReferenceChanged: function(cmp, event, helper) {
        $A.get('e.force:refreshView').fire(); //to help clean up cache for last visit
    },
    
	init : function(component, event, helper) {
        var pageRef = component.get("v.pageReference");
        var id = pageRef.state.c__recordId;
        component.set("v.recordId", id);
        helper.firstTimeLoading = true;
        helper.keyDeal = false;        
        component.find("recordLoader").reloadRecord();
        helper.intervalRecLoader = setInterval(
            $A.getCallback(function() {
                var recordLoader = component.find("recordLoader");
                if(recordLoader !== undefined && recordLoader !== null)
                	recordLoader.reloadRecord();
            }), 
            10000
        );
        helper.getFacilitatorInformation(component, event, helper);
        helper.getOfferId(component, event, helper);
    },
    
    handleRecordUpdated: function(component, event, helper) {
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED") {
            if(helper.firstTimeLoading ) {
             	helper.firstTimeLoading = false;
                helper.setRiskAssessmentButton(component,event, helper);
        		helper.setCategory(component,event, helper);
            } 
            helper.setRiskAssessmentIcon(component,event, helper);
        } else if(eventParams.changeType === "ERROR") {
            console.log(component.get("v.recordError"));
        }
    },
    
    openRiskAssessment: function(component, event, helper) {
        var riskLink = component.get("v.opptyRecord.Risk_Assessment__c");
        window.open(riskLink,'_blank');
    },
    
    checkCommentsRequired: function(component, event, helper) {
        helper.commentsStrategyRequired(component, event, helper);
    },
    
    onChangeTypeRequest : function(component, event, helper) {
        helper.onChangeTypeRequest(component, event, helper);
    },
    
    handleRecordEditLoad : function(component, event, helper) {
        helper.commentsStrategyRequired(component, event, helper);
    },
    
    handleRecordEditSubmit: function(component, event, helper) {
        event.preventDefault();       
        helper.showSpinner(component,"spinner",true);
        helper.removeAllErrorMarkup(component);
        helper.validateForm(component,event,helper);
    },
   
    handleRecordEditSuccess: function(component, event, helper) {
        helper.dismiss(component,event,helper);
    },

    handleRecordEditError: function(component, event, helper) {
        helper.showSpinner(component,false);
        helper.scrollTop(); 
    },
	
    saveOpportunity : function(component,event,helper){
        helper.showSpinner(component,"spinner", true);
        component.find('recordEditForm').submit();
        component.find('recordEditFormOffer').submit();
    },
    
    dismiss : function(component,event,helper){
        helper.showSpinner(component,"spinner", true);
      	helper.dismiss(component,event,helper);
    },
})