({ 
    //Initialize component when first load or refresh
    init: function (component,event,helper) {
        helper.init(component,event,helper);
        component.set("v.instructionMsg","Please click on Split to split the Parent Case or Click on Validate & Submit Button");
        
    },
    retry :function(component,event,helper) {
        helper.retryHelper(component,event,helper);
        
    },
    
    //NOKIASC-34261 start
    handleSelectedRow: function(component, event, helper){
        var selectedRows = event.getParam('selectedRows');
        var selectedChildCases = [];
        for (var i = 0; i < selectedRows.length; i++){
            selectedChildCases.push(selectedRows[i]);
            //alert(JSON.stringify(selectedRows[i]));
        }
        component.set("v.selectedRowDetails", selectedChildCases );
    },
    split: function (component,event,helper) {
        var recs = component.get("v.selectedRowDetails");
        if( recs =='' ||recs == null || recs == undefined){
            helper.showToast('error', 'Error', "Please select at least one child case");        
        }
        else{
			    let isAllNotHoldStatus = recs.some(e => e.Status!='On Hold' );
                if(isAllNotHoldStatus) return helper.showToast('error', 'Error', 'Split is applicable only for On Hold Case Status.');
            helper.cloneAllCases(component, event, helper);
        }
    },
    //NOKIASC-34261 end 
    
    //sorting funtion for data table
    updateColumnSorting: function (component, event, helper) {
        component.set('v.isSpinner', true);
        // We use the setTimeout method here to simulate the async
        // process of the sorting data, so that user will see the
        // spinner loading when the data is being sorted.
        setTimeout($A.getCallback(function() {
            var tableId=event.getSource().getLocalId();
            var fieldName = event.getParam('fieldName');
            var sortDirection = event.getParam('sortDirection');
            component.set("v.sortedByValue", fieldName);
            component.set("v.sortedDirectionUser", sortDirection);
            helper.sortData(component,helper, fieldName, sortDirection,tableId);
            component.set('v.isSpinner', false);
        }), 0);        
    },    
    
    //Handle row action ,this method will called whenever we click any button inside datatable
    handleRowAction : function(component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        component.set("v.selectedRow",row);
        switch (action.name) {            
            case 'View_Action':
                helper.getWarrantyStatus(component, event, helper, row);
                break;
            case 'editExceptionStatus':
                helper.getRecordValues(component,event);
                break;
            default:
                break;
        }
    },    
    
    
    closeModel: function(component, event){
        component.set("v.editExceptionStatus",false);
    },
    
    handleSubmit : function(component, event, helper) {
        component.set("v.isSpinner",true);        
        var selectedRow=[...component.get("v.selectedRow")];        
        var entitlementException =component.find("entitlementException").get("v.value");
        var status = component.find("status").get("v.value");
        var serialNumber = component.find("serialNumber").get("v.value");        
        if (selectedRow[0].CH_EntitlementStatus__c != status &&  
            selectedRow[0].HWS_Faulty_Serial_Number__c != serialNumber && 
            selectedRow[0].HWS_Faulty_Serial_Number__c != undefined && selectedRow[0].CH_EntitlementStatus__c !=
            undefined && status != null && serialNumber != null) 
        {
            component.set("v.isSpinner",false);            
            helper.showToast('error', 'Error', "Serial Number and Entitlement Status cannot be changed at the same time");   
        } else {
            if(selectedRow[0].CH_EntitlementStatus__c != status){
                if(status =='Entitled (Manually Verified)' 
                   || status =='Management Override' 
                   || status =='Pending Warranty Verification'){
                    selectedRow[0].Status ='Draft';
                } else if(status =='Service Declined'){
                    selectedRow[0].Status ='Cancelled';
                }else if(status =='Pending CAPM Review' 
                         || status =='Pending Quotation Team Review'){
                    selectedRow[0].Status ='On Hold';
                }
                selectedRow[0].CH_EntitlementStatus__c=status;
                selectedRow[0].HWS_Faulty_Serial_Number__c=serialNumber;
                selectedRow[0].CH_EntitlementException__c=entitlementException;            
                helper.updateCaseValues(component, event, helper,selectedRow) 
                
            }
            else if( selectedRow[0].HWS_Faulty_Serial_Number__c != serialNumber){
                if(status =='Entitled (Manually Verified)' 
                   || status =='Management Override' 
                   || status =='Pending Warranty Verification'){
                    selectedRow[0].Status ='Draft';
                } else if(status =='Service Declined'){
                    selectedRow[0].Status ='Cancelled';
                }else if(status =='Pending CAPM Review' 
                         || status =='Pending Quotation Team Review'){
                    selectedRow[0].Status ='On Hold';
                }
                selectedRow[0].CH_EntitlementStatus__c=status;
                selectedRow[0].HWS_Faulty_Serial_Number__c=serialNumber;
                selectedRow[0].CH_EntitlementException__c=entitlementException;            
                helper.updateCaseValues(component, event, helper,selectedRow) 
                helper.getWarrantyStatus(component, event, helper, selectedRow[0]); // NOKIASC-35984 | 13-May-2021             
            }
                else{
                    component.set("v.editExceptionStatus",false);
                    component.set("v.isSpinner",false);
                }
        }
    },
    
    handleSuccess : function(component, event, helper) {
        
    },
    
    handleError : function(component, event, helper) {
        component.set("v.isSpinner",false);
        var error = event.getParam("error");
        helper.showToast('error', 'Error', error && error.message?error.message:"Something went wrong");        
    },
    
    handleSave : function(component, event, helper) {
        component.set("v.isSpinner",true);
        helper.saveTableValues(component, event, helper);
    },
    entStatusChangeHandler: function(cmp, evt) {
        //console.log("numItems has changed");
        //console.log("old value: " + evt.getParam("oldValue"));
        //console.log("current value: " + evt.getParam("value"));
    },
    validateandSubmit: function(component, event, helper) {
        helper.checkPayPerUse(component,event,helper); 
    },
    // NOKIASC-34877:Action on click of Accept Quote/ Reject Quote
    clickAccetRejectQuoteDate: function(component, event, helper) {
        var buttonClickID=null;
        buttonClickID =event.getSource().getLocalId();
        var selectedRowDetails= component.get("v.selectedRowDetails");
        if(selectedRowDetails.length>0){
            var childSet = selectedRowDetails.map(function(value,index) { if(value["Id"] != undefined){return value["Id"];} });                 
            helper.clickAccetRejectQuoteDate(component,event,helper,childSet,buttonClickID); 
        }
        else{
            var buttonLabel=(buttonClickID=='acceptQuote'?'Accept Quote':'Reject Quote');
            helper.showToast('error','Error',"Please select at least one RMA prior to selecting " + buttonLabel + ".");
        }
        
    },
    //NOKIASC-36696:UAT3.3 QCRM3: Handle Warranty Manager/Quotation
    onControllerFieldChange: function(component, event, helper) {   
        var controllerValueKey = event.getSource().get("v.value"); // get selected controller field value
        if (component.get("v.entitlementException")!=null)
            controllerValueKey=component.get("v.entitlementException");
        var depnedentFieldMap = component.get("v.depnedentFieldMap");
        
        if (controllerValueKey != '--None--') {
            var ListOfDependentFields = depnedentFieldMap[controllerValueKey];
            
            if(ListOfDependentFields.length > 0){
                component.set("v.bDisabledDependentFld" , false);  
                helper.fetchDepValues(component, ListOfDependentFields);    
            }else{
                component.set("v.bDisabledDependentFld" , true); 
                component.set("v.listDependingValues", ['--None--']);
            }  
        } else {
            component.set("v.listDependingValues", ['--None--']);
            component.set("v.bDisabledDependentFld" , true);
        }
    }
})