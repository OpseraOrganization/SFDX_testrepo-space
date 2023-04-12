({
    doInit : function(component, event, helper) {
        //document.body.setAttribute('style', 'overflow: hidden;');
        helper.init(component, event, helper); 
    },
    handleLoad : function(component, event, helper) {
        helper.onLoadHandler(component, event, helper); 
    },
	
    onRecordSubmit : function(component, event, helper) {
        helper.recordSubmit(component, event, helper); 
    },
    handleSuccess : function(component, event, helper) {
        helper.success(component, event, helper); 
    },
    handleCancel : function(component, event, helper) {
        helper.cancel(component, event, helper); 
    },
    handleFieldVisibility : function(component, event, helper) {
        helper.fieldVisibility(component, event, helper); 
    },
    handleError : function(component, event, helper) {
        helper.errorHandler(component, event, helper); 
    },
    fetchContracts : function(component, event, helper) {
        helper.fetchExistingContracts(component, event, helper); 
    },
    handleContractChange : function(component, event, helper) {
        helper.contractChange(component, event, helper); 
    },
    onRender : function(component, event, helper) {
        helper.render(component, event, helper); 
    }
   
})