({
	doInit : function(component, event, helper){
        //helper.getProductStatusResult(component, event, helper);
    },
    handleCancel: function(component, event, helper){
        helper.cancelAction(component, event, helper);
    },
    handleProceed: function(component, event, helper){
        console.log('>>>>>'+$A.get("e.c:CPQ_Evt_ProceedForExport"));
        helper.fireApplicationEvent(component, event, helper);
        //$A.get("e.force:refreshView").fire();
    },
    // intiate product status check
    handleCPQ_Evt_ToCallStatusCheck : function(component, event, helper){
        var orderExportName = event.getParam("orderExportName");
        $A.get("e.force:refreshView").fire();
        console.log('handleCPQ_Evt_ToCallStatusCheck>>>orderExportName>>>'+orderExportName);
        console.log('Record Id>>>'+component.get("v.recordId"));
        component.set('v.orderExportName', orderExportName);
        //component.set('v.displayModel', true);
        helper.getProductStatusResult(component, event, helper);
    },
    
})