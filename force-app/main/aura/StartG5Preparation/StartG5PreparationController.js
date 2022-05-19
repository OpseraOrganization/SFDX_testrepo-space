({ 
    init : function(component, event, helper) {
        var pageRef = component.get("v.pageReference");
        if(pageRef !== undefined && pageRef !== null && pageRef.state !== undefined && pageRef.state !== null){
            var id = pageRef.state.c__id;
            component.set("v.recordId", id);
        }
    },
    
    
    handleLoad: function (component, event, helper) {
        var record = event.getParam("recordUi");
        if(record != null){
            var stageName = record.record.fields.StageName.value;
			var phaseStatus = record.record.fields.Phase_Status__c.value;
            if( ! (stageName === "Win the Case (Negotiate)" && phaseStatus === "Offer Submitted to Customer (Manual)") ) {
                component.find('notifLib').showNotice({
                    "variant": "error",
                    "header": "Error",
                    "message": "'Start G5 Preparation' allowed only when the Phase Status is 'Offer Submitted to Customer'",
                });
                $A.get("e.force:closeQuickAction").fire();
            }
            var g5Trigger = record.record.fields.G5_Trigger__c.value;
            if( g5Trigger === "Contract with changes vs G4"){
                component.set("v.reqCom", true);
            }
        }
    },
    
    handleCancel : function(component, event, helper) {
        $A.util.toggleClass(component.find("spinner"), "slds-hide");
        component.find('cancelButton').set("v.disabled", true);
        component.find('saveButton').set("v.disabled", true);
		$A.get("e.force:closeQuickAction").fire();
	},
    
    handleOnError : function(component, event, helper) {
		var errors = event.getParam("error");
        $A.util.toggleClass(component.find("spinner"), "slds-hide");
        component.find('cancelButton').set("v.disabled", false);
        component.find('saveButton').set("v.disabled", false);
	},
    
    handleSuccess : function(component, event, helper) {
		var record = event.getParam("response");
        var fields = record.fields;
        var pageRef = component.get("v.pageReference");
        if(pageRef !== undefined && pageRef !== null && pageRef.state !== undefined && pageRef.state !== null){
            window.close();
        } 
        $A.get("e.force:closeQuickAction").fire();
        $A.get("e.force:refreshView").fire();         
    },
    
    handleFormSubmit: function(component, event, helper) {
        event.preventDefault();       
        var fields = event.getParam('fields');
        var g5trigger = fields.G5_Trigger__c;
        if( g5trigger === null || g5trigger === ""){
            $A.util.addClass(component.find("g5trigger"), "slds-has-error");
            $A.util.removeClass(component.find("error"), "slds-hide");
        } else {
            $A.util.toggleClass(component.find("spinner"), "slds-hide");
            component.find('cancelButton').set("v.disabled", true);
            component.find('saveButton').set("v.disabled", true);
            component.find('recordForm').submit(fields);
        }
    },
    
    handleChangeTrigger : function(component, event, helper) {
		let fieldName = event.getSource().get("v.fieldName") ; 
        let newValue =  event.getSource().get("v.value") ; 
        
        if( newValue === "Contract with changes vs G4"){
           component.set("v.reqCom", true);
        } else {
            component.set("v.reqCom", false);
        }
		$A.util.removeClass(component.find("g5trigger"), "slds-has-error");
        $A.util.addClass(component.find("error"), "slds-hide");        
        if( newValue === ""){
            $A.util.addClass(component.find("g5trigger"), "slds-has-error");
            $A.util.removeClass(component.find("error"), "slds-hide");
        }
    },
})