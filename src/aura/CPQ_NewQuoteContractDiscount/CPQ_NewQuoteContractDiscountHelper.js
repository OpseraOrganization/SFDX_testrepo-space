({
	showToast : function(theTitle, theMessage, theVariant) {
        const event = new ShowToastEvent({
            title: theTitle,
            message: theMessage,
            variant: theVariant
        });
        this.dispatchEvent(event);
	},
	
	getContractualDiscount : function(component, event, helper) {
	
	        var recId = component.get("v.recordId");
			var action3 = component.get('c.getContractualDiscount');
			action3.setParams({ recordId : recId })
			action3.setCallback(this,function(response){
            var state = response.getState();
            console.log(state);
            if(state === 'SUCCESS' || state === 'DRAFT'){
                component.set("v.discountList", response.getReturnValue());
            }
        });
        $A.enqueueAction(action3);
	
	},
	
     getColumnAndAction : function(component, helper) {
		var actions = [
             {label: 'Delete', name: 'delete'}
        ];
        component.set('v.columns', [
            {label: 'QLD/ICD Code', fieldName: 'CPQ_Code__c', type: 'text'},
            {label: 'Description', fieldName: 'CPQ_Description__c', type: 'text'},
            {label: 'Method', fieldName: 'CPQ_Contractual_Disc_Method__c', type: 'text'},
            {label: 'Disc Type', fieldName: 'CPQ_Discount_Type__c', type: 'text'},
            {label: 'Disc Value', fieldName: 'CPQ_Discount_Value__c', type: 'text'},
            {label: 'Sequence', fieldName: 'CPQ_Sequence__c', type: 'text', editable : 'true'},
            {type: 'action', typeAttributes: { rowActions: actions } } 
        ]);
    },
     
    getsavedContractualDiscount : function(component, helper) {
        var action = component.get("c.getSavedQuoteContractualDiscount");
        var recId = component.get("v.recordId"); 
        action.setParams({
			 'recordId' : recId
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resultData = response.getReturnValue();
                component.set("v.data", resultData);
            }
        });
        $A.enqueueAction(action);
    },
     
    deleteRecord : function(component, event) {
        //var action = event.getParam('action');
        var row = event.getParam('row');
        //alert('--->'+row.Id);
        var action = component.get("c.deleteQuoteContractualDiscount");
        action.setParams({
            'qcd': row.Id
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" ) {
                var rows = component.get('v.data');
                var rowIndex = rows.indexOf(row);
                rows.splice(rowIndex, 1);
                component.set('v.data', rows);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Discount successfully deleted.",
                    "type": "success"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
     
})