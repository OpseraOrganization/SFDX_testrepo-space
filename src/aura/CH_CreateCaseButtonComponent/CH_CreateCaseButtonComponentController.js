({
    // Function for visibility of the lightning component if return type is empty.
    doInit : function(component, event, helper) {
        helper.checkCreateCaseButtonVisibility(component, event, helper);
        helper.getPicklistValues(component, event);
        //NOKIASC-37118:Check user bulk upload permission
        helper.checkBulkUploadPermissionLoginUSer(component, event, helper);
    },    
    
    // Function for action after button click - Case Creation or Toast message.
    handleClick : function (component, event, helper) {
        var action = component.get('c.redirectToCreateCaseFlow');
        var serviceType = component.get("v.selectedServiceType"); 
        console.log('I am not able to understand' + serviceType);
        action.setParams({ "contactId" : component.get("v.recordId") , serviceType : serviceType});
        action.setCallback(this,function(response){
            if (response.getState() === "SUCCESS") {
                if (response.getReturnValue() == '') {
                    helper.getCaseCreation(component, event, helper);
                } else if(response.getReturnValue() == 'contactDetails'){
                    component.set("v.contactDetails", "true");
                    component.set("v.CreateCase", "false");
                } else {
                    helper.showToastMessage('Error',response.getReturnValue()); 
                }                              
            }
        });
        $A.enqueueAction(action);
    },
    goBack : function (component, event, helper) {
        component.set("v.contactDetails", "false");
        component.set("v.CreateCase", "true");
    },
    submitContact : function (component, event, helper) {
        var phoneValue = component.get("v.phone"); 
        var mobileValue = component.get("v.mobile");
		var timezonevalue = component.get("v.timezone");
        if(phoneValue == null && mobileValue == null) {
            helper.showToastMessage('Error','Case cannot be created without Mobile or Phone details');
        } 
		else{
            helper.sendEmail(component, event, helper);            
        }
    },
    
})