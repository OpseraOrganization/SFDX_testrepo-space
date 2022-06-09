({
    init : function(component, event, helper){
        helper.verifyUserEditAccess(component, event, helper);
    },

    handleRecordDataUpdated: function(component, event, helper) {
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED" || eventParams.changeType === "CHANGED") {
            helper.setRiskAssessmentButton(component, event, helper);
        } else if(eventParams.changeType === "ERROR") {
            console.log(component.get("v.recordLoadError"));
        }
    },

    handleRecordEditLoad : function(component, event, helper) {
         helper.commentsStrategyRequired(component, event, helper);
    },

    handleRiskAssessBtn  : function(component,event,helper){
        helper.openRiskAssessment(component,event);
    },

    handleEditSecBtn : function(component,event,helper){
    	component.set("v.readOnlySection", false);
        component.find('editSections_button').set("v.disabled", true);
        component.find('export_button').set("v.disabled", true);
	},

    handleExportBtn : function(component,event,helper){
    	var recordId = component.get("v.recordId");
        $A.get("e.force:navigateToURL").setParams({"url": "/apex/CRM_WinPlanExport?&recordId="+recordId}).fire();
	},

    checkCommentStrategyRequired: function(component, event, helper) {
        helper.commentsStrategyRequired(component, event, helper);
    },

    handleCommentStrategy : function(component,event,helper){
        var commentsVal = event.getParam("value");
        if( !component.get("v.requiredCommentStrategy") || commentsVal != null ){
            helper.removeErrorMarkup(component,event,helper);
        }
    },

    handleSaveForm : function(component,event,helper){
        helper.removeErrorMarkup(component,event,helper);
        helper.showSpinner(component,'spinner', true);
        helper.validateStrategyForm(component,event,helper);
    },

    handleDismissForm : function(component,event,helper){
        helper.removeErrorMarkup(component,event,helper);
     	component.set("v.readOnlySection", true);
        component.find('editSections_button').set("v.disabled", false);
        component.find('export_button').set("v.disabled", false);
        helper.showSpinner(component,'spinner',false);
       // helper.scrollTop(component);
    },

    handleFormError : function(component,event,helper){
        helper.showSpinner(component,'spinner', false);
     	helper.scrollTop(component);
    },

});