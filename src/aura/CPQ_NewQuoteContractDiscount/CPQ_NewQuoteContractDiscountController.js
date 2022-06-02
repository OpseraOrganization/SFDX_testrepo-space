({
    doInit : function(component, event, helper) {

		 helper.getContractualDiscount(component, event, helper);
		 helper.getColumnAndAction(component, helper);
         helper.getsavedContractualDiscount(component, helper);
    },
    
    handleSave : function(component, event, helper) {
        component.set("v.isLoading", 'true');
        
        var recId = component.get("v.recordId");
        var discRecId = component.get("v.discountVal");
        var seq = component.get("v.sequenceNoVal");
        
        var action3 = component.get('c.createQuoteContractualDiscount');
        action3.setParams({ quoteId : recId, discId : discRecId, seqNo : seq })
        action3.setCallback(this,function(response){
            component.set("v.isLoading", 'false');
            var state = response.getState();
            if(state === 'SUCCESS' || state === 'DRAFT'){
                helper.getsavedContractualDiscount(component, helper);
                $A.get('e.force:refreshView').fire();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Discount successfully created.",
                    "type": "success"
                });
                toastEvent.fire();
                component.set("v.discountVal","");
                component.set("v.sequenceNoVal","");
            }
        });
        $A.enqueueAction(action3);
    },
	
     
    handleNext : function(component, event, helper) { 
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber+1);
        helper.getsavedContractualDiscount(component, helper);
    },
     
    handlePrev : function(component, event, helper) {        
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber-1);
        helper.getsavedContractualDiscount(component, helper);
    },
 
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        //alert('--->'+action.name);
        if(action.name === 'delete') {
            helper.deleteRecord(component, event);
        }
    },
    
     handleSaveEdition: function (component, event, helper) {
        var draftValues = event.getParam('draftValues');
        console.log(draftValues);
        var action = component.get("c.updateQuoteContractualDiscount");
        action.setParams({"qcdList" : draftValues});
        action.setCallback(this, function(response) {
            var state = response.getState();
             if(state === 'SUCCESS' || state === 'DRAFT'){
                helper.getsavedContractualDiscount(component, helper);
                $A.get('e.force:refreshView').fire();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Discount successfully updated.",
                    "type": "success"
                });
                toastEvent.fire();
            }
            
        });
        $A.enqueueAction(action);
        
    },
})