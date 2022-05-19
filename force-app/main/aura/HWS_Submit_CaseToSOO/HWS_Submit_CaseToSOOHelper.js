({
    submitHWSCase : function(component,event,helper) {
        component.set("v.IsSpinner", true);
        var actionCallout = component.get("c.makeSOOCallout");
        var caseId=component.get("v.recordId");   
        var actionCallout=component.get('c.makeSOOCallout');
        actionCallout.setParams({
            parentCaseId : caseId});
        actionCallout.setCallback(this, $A.getCallback(function (response) {
          var state = response.getState();
          component.set("v.ProcessResponse", response.getReturnValue());
          var processResponse=component.get("v.ProcessResponse");
            if (state === "SUCCESS") {
                component.set("v.IsSpinner", false);
                if(processResponse!=null){
                    var statuscode=processResponse.statusCode;
                    var Status=processResponse.Status;
                    if(statuscode==200 && Status!='Fail'){
                        this.showToast('success','Success Message','The Case has been Successfully Submitted to SOO');
                    }
                    else
                    {
                        if(statuscode==200 && Status=='Fail'){
                        	this.showToast('error','Error Message','Cancelled Cases connot be submitted');    
                        }else{
                        	this.showToast('error','Error Message','Case was not submitted to SOO');    
                        }
                        
                    }
                }
                else{
                    this.showToast('error','Error Message','Case was not submitted to SOO');
                }
                $A.get('e.force:refreshView').fire();
                
                
            }
            else if (state === "INCOMPLETE") {
                component.set("v.IsSpinner", false);
            }
                else if (state === "ERROR") {
                    component.set("v.IsSpinner", false);
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            //console.log("Error message: " + 
                                 //       errors[0].message);
                        }
                    } else {
                      //  console.log("Unknown error");
                    }
                }
        }));
        $A.enqueueAction(actionCallout);
        
    },
    
    
    //Helper method to display the error toast message
    showToast : function(type,title,message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : title,
            message: message,
            duration:'5000',
            key: 'info_alt',
            type: type,
            mode: 'dismissible'
        });
        toastEvent.fire();
        
    },
	
	//This is used for checking Customer Purchaser Order Number 
        checkPayPerUse : function(component,event,helper) {
            component.set("v.IsSpinner", true);
        var getCaseId=component.get("v.recordId"); 
        var action=component.get('c.getPayPerUse');
        action.setParams({
            parentCaseId : getCaseId});
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.IsSpinner", false);
               // console.log('response'+response.getReturnValue());
                 if(response.getReturnValue()==='Quotation Error'){
                    this.showToast('error','Error Message','Please populate the Customer Purchase Order Number with details provided by the Warranty & Quotation team.');
                }
                else if(response.getReturnValue()==='PO Error'){
                    this.showToast('error','Error Message','Please enter Customer Purchase Order Number, or escalate to Customer Care Manager.');
                }
                else if(response.getReturnValue()==='WarrantyError'){
                    this.showToast('error','Error Message','Support Ticket cannot be submitted because Warranty Verification required for one or more parts added. Please check Entitlement tab and also the Purchase Order Number is required, please escalate to the Warranty & Quotation team.');
                }
                 else if(response.getReturnValue()==='WarrantyNullError'){
                    this.showToast('error','Error Message','Purchase Order Number is required, please escalate to the Warranty & Quotation team.');
                }
                else{
                    this.checkWarrantyVerification(component,event,helper);
                }
            }
        }));
        $A.enqueueAction(action);     
    },
    
      //This is used for checking checkWarrantyVerification  NOKIASC-32645 
        checkWarrantyVerification : function(component,event,helper) {
            component.set("v.IsSpinner", true);
        var action=component.get('c.checkWarrantyVerification');
        action.setParams({
            parentCaseId : component.get("v.recordId")});
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.IsSpinner", false);
                 if(response.getReturnValue()){
                    this.showToast('error','Error Message','Support Ticket cannot be submitted because Warranty Verification required for one or more parts added. Please check Entitlement tab');
                }              
                else{
                    this.submitHWSCase(component,event,helper);
                }
            }
        }));
        $A.enqueueAction(action);     
    }
    
})