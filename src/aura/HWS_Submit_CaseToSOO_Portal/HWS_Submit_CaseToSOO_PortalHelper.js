({
    submitHWSCase : function(component,event,helper) {
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
                if(processResponse!=null){
                    var statuscode=processResponse.statusCode;
                    var Status=processResponse.Status;
                    if(statuscode==200 && Status!='Fail'){
                        this.showToast('success','Success Message','Your request is successfully submitted');
                    }
                    else
                    {
                        if(statuscode==200 && Status=='Fail'){
                        	this.showToast('error','Error Message','Cancelled Cases connot be submitted');    
                        }else{
                        	this.showToast('error','Error Message','Your request is Created but not submitted');    
                        }
                        
                    }
                }
                else{
                    this.showToast('error','Error Message','Your request is Created but not submitted');
                }
                $A.get('e.force:refreshView').fire();
                
                
            }
            else if (state === "INCOMPLETE") {
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            //console.log("Error message: " + 
                            //            errors[0].message);
                        }
                    } else {
                       // console.log("Unknown error");
                    }
                }
        }));
        $A.enqueueAction(actionCallout);
        
    },
    getCaseStatus : function(component, event, helper) {        
        var id = component.get("v.recordId");                
        var action =component.get("c.getCasStatus");
        action.setParams({
            caseid: id
        });                
        action.setCallback(this, function(response) {                       
            var caseCaStatus = response.getReturnValue();
            component.set("v.CasStatus",caseCaStatus);            
        });
        $A.enqueueAction(action);
    },
    
    getInternalStatus : function(component, event, helper) {        
        var id = component.get("v.recordId");                
        var action =component.get("c.getInternalStatus");
        action.setParams({
            'caseid': id
        });                
        action.setCallback(this, function(response) { 
            component.set("v.InternalStatus",response.getReturnValue());
                        
        });
        $A.enqueueAction(action);
    },
	getWorkgroup : function(component, event, helper) {        
        var id = component.get("v.recordId");                
        var action =component.get("c.getWorkgroup");
        action.setParams({
            'caseid': id
        });                
        action.setCallback(this, function(response) { 
            component.set("v.isWorkgroup",response.getReturnValue());
                        
        });
        $A.enqueueAction(action);
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
        var getCaseId=component.get("v.recordId"); 
        var action=component.get('c.getPayPerUse');
        action.setParams({
            parentCaseId : getCaseId});
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
               // console.log('response'+response.getReturnValue());
               //  if(response.getReturnValue()==='Quotation Error'){
                //    this.showToast('error','Error Message','Please populate the Customer Purchase Order Number with details provided by the Warranty & Quotation team.');
               // }
                 if(response.getReturnValue()==='PO Error'){
                    this.showToast('error','Error Message','This service requires a valid Purchase Order(PO). Please enter a valid PO in the Customer Purchase Order Number field, or engage your Customer Care Manager to receive a quote.');
                }
		//		else if(response.getReturnValue()==='WarrantyError'){
          //          this.showToast('error','Error Message','Warranty status could not be determined for one or more of the parts. A Nokia representative will be reviewing and updating RMA accordingly');
            //    }
              //   else if(response.getReturnValue()==='WarrantyNullError'){
             //       this.showToast('error','Error Message','Purchase Order Number is required, please escalate to the Warranty & Quotation team.');
              //  }
                else{
                    this.submitHWSCase(component,event,helper);
                }
            }
        }));
        $A.enqueueAction(action);     
    }
	
    
})