({
    doInit : function(component, event, helper) {
    	console.log("Inside doinit");
		var recordId = component.get("v.recordId");
        console.info('in do init opptyId'+recordId);
        var action=component.get("c.getOpptyGateInfo");
        action.setParams({
            currentRecordId : component.get("v.recordId"),
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            var result = response.getReturnValue();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                //if(result === "Only users with the role CO Market Sales Ops can confirm Advanced PO Booking")
                 if(result === $A.get("$Label.c.Advanced_PO_Booking_By_CO_Market_Sales_Ops"))    
                {
                    component.set("v.IsSpinner",true);
                    toastEvent.setParams({
                    message: result,
                    type: 'error',
                    duration: 10000
                	});
                    $A.get("e.force:closeQuickAction").fire();
                }
                else if(result ===  $A.get("$Label.c.AdvanedPOBooking_Error"))  
                {
                    component.set("v.IsSpinner",true);
                    toastEvent.setParams({
                    message: result,
                    type: 'error',
                    duration: 10000
                	});
                    $A.get("e.force:closeQuickAction").fire();
                }
                else if (result ===  $A.get("$Label.c.AdvanedPOBooking_Confirmation"))  
                {
                    component.set("v.IsSpinner",true);
                    toastEvent.setParams({
                    message: result,
                    type: 'info',
                    duration: 10000
                	});
                    $A.get("e.force:closeQuickAction").fire();
                }else if(result === "To Display.")
                {  component.set("v.poComponent",true);
                }
                toastEvent.fire();            
            }
        });
        $A.enqueueAction(action);        
	},
        
    navigateToOppty : function (component, event, helper) {
        helper.navigateToOpptyHelper(component);
    },
    
    confirmPOBooking : function (component, event, helper) {
        var poReference = component.get("v.opportunity.PO_Reference__c");
         var accountName = component.get("v.account.Name");

        var action = component.get("c.confirmPOBookingCtrl");
        console.log('poReference>>'+poReference);
        
        action.setParams({
            poReference: poReference,
            currentRecordId : component.get("v.recordId")
        });
        
        action.setCallback(this,function(response){
           
            var state = response.getState();
            var result = response.getReturnValue();
             console.log('state>>'+state);
            console.log('result>>'+result);
            var toastEvent1 = $A.get("e.force:showToast");
            if (state === "SUCCESS") {
                if(result=== "Opportunity updated Successfully")
                {
                    helper.navigateToOpptyHelper(component);
                	toastEvent1.setParams({
                    message: result,
                    type: 'Success',
                    duration: 10000
                	});  
                }
                else
                {
                    $A.get("e.force:closeQuickAction").fire();
                    toastEvent1.setParams({
                    message: result,
                    type: 'Error',
                    duration: 10000
                	});
                }
            }
            toastEvent1.fire();
            $A.get('e.force:refreshView').fire();
        });
        $A.enqueueAction(action);
    } 
})