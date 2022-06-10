({
	//Spinner Code Start
    showWaiting:function(cmp){
       cmp.set("v.IsSpinner",true);
    },
    hideWaiting:function(cmp){
        cmp.set("v.IsSpinner",false);  
    },
    //Spinner Code Ends
    cancelHwsCase : function(component, event, helper) {
		//NOKIASC - 31890 changes
        var cancelReason = component.get('v.cancelledCase.Cancellation_Reason__c');
        var reasonForCancellation = component.get('v.cancelledCase.CH_ReasonForCancellation__c');        
        if(cancelReason == '--None--' || cancelReason == null || cancelReason == '' || cancelReason == undefined){            
            var field = component.find("cancelReasonId");
            component.set('v.showError',true);
            component.set("v.requriedFieldStyleforCancellationReason", 'requiredOverRide');
            //document.getElementById("errorOnCancel").innerHTML = 'Please select Cancellation Reason';
        } else{
            var field = component.find("cancelReasonId");
            component.set('v.showError',false);
            component.set("v.requriedFieldStyleforCancellationReason", '');
            //document.getElementById("errorOnCancel").innerHTML = '';
        }
        if(cancelReason != null && cancelReason == 'Other' && (reasonForCancellation == null || reasonForCancellation == '' || reasonForCancellation == undefined)){
            var field = component.find("reasonForCancellationId");
            component.set('v.showErrorReason',true);            
            component.set("v.requriedFieldStyleforReason", 'requiredOverRide');            
            //document.getElementById("errorOnReason").innerHTML = 'Please enter Reason For Cancellation';
        }else{
            var field = component.find("reasonForCancellationId");
            component.set('v.showErrorReason',false);
            component.set("v.requriedFieldStyleforReason", ''); 
            //document.getElementById("errorOnReason").innerHTML = '';
        }
        if(component.get('v.showErrorReason') === false && (cancelReason != null && cancelReason != '' && cancelReason != undefined)){
			helper.cancelHwsCaseHelper(component,event);
        }
	},
    openCancelCase : function(component, event, helper) {
		component.set('v.isOpen',true);
	},
    closeModel : function(component, event, helper) {
		component.set('v.isOpen',false);
	}
})