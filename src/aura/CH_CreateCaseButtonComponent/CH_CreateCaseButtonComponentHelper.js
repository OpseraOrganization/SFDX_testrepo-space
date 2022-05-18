({
    // Function for action after button click - Case Creation.
    getCaseCreation : function (component, event, helper) {
        var selectedServiceType = component.get("v.selectedServiceType");
        var evt = $A.get("e.force:navigateToComponent");
        // HWS - Start
        // Modified as partof HWS HWST-3196 & 3198 user stories Sprint 1917
        if(selectedServiceType === 'Customer Support' || selectedServiceType === 'Internal Support'){
            evt.setParams({
                componentDef: "c:CH_CaseFlow_Creation",
                componentAttributes:{
                    selectedServiceType : component.get("v.selectedServiceType"),
                    contactId : component.get("v.recordId")
                }            
            });
        }else if(selectedServiceType === 'Hardware Services' ){
            //NOKIASC-37118:Redirect to page as per request type selection |Start
            var requestValue=component.get("v.requestValue");
            if(requestValue==='singleRequest'){
                evt.setParams({
                    componentDef: "c:HWS_CaseFlow",
                    componentAttributes:{
                        recordId : component.get("v.recordId")
                    }            
                });
            }
            else{
                evt.setParams({
                    componentDef: "c:HWS_CaseFlow_Portal_MainComponent",
                    componentAttributes:{
                        consoleContactId : component.get("v.recordId")
                    }            
                });   
            }          
            //NOKIASC-37118:Redirect to page as per request type selection |End
        }
        // HWS - End
        evt.fire();		
    },
    
    // Function for action after button click - Toast message.
    showToastMessage: function(messageType, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type" : messageType,
            "mode" : 'sticky',
            "title" : messageType,
            "message" : message
        });
        toastEvent.fire();
    },
    
    // Function for getting service type values based on contact type.
    getPicklistValues : function (component, event) {
        var action = component.get('c.getPickListValuesBasedOnContactType');
        action.setParams({ "contactId" : component.get("v.recordId")});
        action.setCallback(this,function(response) {
            if (response.getState() == "SUCCESS") {
                component.set("v.options", response.getReturnValue());
                component.set("v.defaultValue", response.getReturnValue()[0]) ;               
            } else {
                console.log(response.getReturnValue());
            } 
        });
        $A.enqueueAction(action);
    },
    // NOKIASC-37118:Check if user has bulk upload permission |Start
    checkBulkUploadPermissionLoginUSer : function (component, event, helper) {
        var action = component.get('c.checkBulkUploadPermission');
        action.setCallback(this,function(response){
            if (response.getState() === "SUCCESS") {
                component.set('v.bulkUploadPermission', response.getReturnValue());  
            } 
            else {
                console.log(response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    // NOKIASC-37118:Check if user has bulk upload permission |Start
    // Function for getting check Create Case Button Visibility.
    checkCreateCaseButtonVisibility : function (component, event, helper) {
        var action = component.get('c.checkCreateCaseButtonVisibility');
        action.setParams({ "contactId" : component.get("v.recordId")});
        action.setCallback(this,function(response){
            if (response.getState() === "SUCCESS") {
                if(response.getReturnValue() == ''){
                    component.set('v.CreateCase', 'true');
                } else {
                    component.set('v.CreateCase', 'false');
                } 
            } 
            else {
                console.log(response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    sendEmail : function (component, event, helper) {
        var action = component.get('c.updateContactDetails');
        var phoneValue = component.get("v.phone"); 
        var mobileValue = component.get("v.mobile");
        action.setParams({ 
            mobile : mobileValue,
            phone : phoneValue,
            contactId : component.get("v.recordId")
        });
        action.setCallback(this,function(response){
            if (response.getState() === "SUCCESS") {
                console.log('I m here and status is :' + response.getState());
                if (response.getReturnValue() == 'sendMail') {
                    console.log('I m here and status is*************** :' + response.getReturnValue());
                    this.showToastMessage('Success','Contact details have been sent to Agent, will be updated soon');
                    this.getCaseCreation(component, event, helper);  
                    component.set("v.contactDetails", "false");
                    component.set("v.CreateCase", "true"); 
                } else{
                    console.log('Sad here and status is*************** :' + response.getReturnValue());
                    
                }
                
                
            } 
            else {
                console.log(response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
})