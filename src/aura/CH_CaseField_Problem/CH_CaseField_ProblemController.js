({
    
    doInit: function(component,event,helper) {
        
        helper.myAction(component,event,helper);
        helper.doInit(component,event,helper);
        
    },
    
    createProblem : function (component,event,helper) {
        
        helper.createProblem(component,event,helper);
        
    },
    
    disassociateProblem : function (component,event,helper) {
        
        helper.disassociateProblem(component,event,helper);
        
    },
    
    postToProblem : function (component,event,helper) { 
        
        helper.postToProblem(component,event,helper);
        
    },
    
    handleSaveSuccess : function(component, event, helper) {
        console.log('#handleSaveSuccess');
        component.set("v.toggleSpinner", false);
        helper.showToastMessage('Success', "The record has been updated successfully.");
        
        
        
        if(component.find('CH_Problem__c').get('v.value')){
            component.set("v.incidentHasProblem", true);
        }else{
            component.set("v.incidentHasProblem", false);
            component.set("v.theProblem.Subject", "");
        }
        component.set("v.toggleSpinner", false);
        component.set("v.errorlogo", false); // Close the PopOver on save success-NOKIASC-23321
        
        
        
    },
    
    update : function(component,event,helper) {
        console.log('#update');
        //event.preventDefault();
        component.set("v.toggleSpinner", true);
        //Group all the fields aura ids 
        var controlAuraIds = [{"Name":"CH_Problem__c","Label":"Problem"}];
        var fieldLevelErrors=[];          
        //reducer function iterates over the array and return false if any of the field is invalid otherwise true.
        let isAllValid = controlAuraIds.reduce(function(isValidSoFar, controlAuraId){
            //fetches the component details from the auraId
            var inputCmp = component.find(controlAuraId.Name);
            //displays the error messages associated with field 
            isValidSoFar= inputCmp.reportValidity();
            if(!isValidSoFar){
                fieldLevelErrors.push({"fieldLabel":controlAuraId.Label});
            }
            //form will be invalid if any of the field's valid property value is false.
            return isValidSoFar ;
        },true);
        //check if the input value is valid if yes the proceed to save/edit
        if(isAllValid){
            component.find("recordEditForm").submit();
        }
        else{
            component.set("v.errorlogo", true);   
            component.set("v.fieldLevelErrors",fieldLevelErrors);    
            component.set("v.closePopupBtn",false);
            component.set("v.toggleSpinner", false);
        }
        
    },
    
    handleLoad: function(component,event,helper){
        console.log('handleLoad');
        component.set("v.toggleSpinner", false);
        /*
    	console.log('#handleLoad>' + component.find('CH_Problem__c').get('v.value'));
    	
    	if(component.find('CH_Problem__c').get('v.value')){
    		component.set("v.incidentHasProblem", true);
    	}else{
    		component.set("v.incidentHasProblem", false);
    		component.set("v.theProblem.Subject", "");
    	}
    	component.set("v.toggleSpinner", false);
		*/
        
    },
    
    handleSaveError: function(component,event,helper){
        event.preventDefault();
        console.log('An error ...');
        component.set("v.toggleSpinner", false);
        
        try{
            component.set("v.errorlogo", true);      
            
            var errors = event.getParams();
            console.log("response", JSON.stringify(errors));
            var error= errors.output.errors;           
            var fieldError=[];
            var fieldErrors= errors.output.fieldErrors;
            var keyList=Object.keys(fieldErrors);
            keyList.forEach(function(item) {   
                var itemList=fieldErrors[item]; 
                fieldError.push(itemList);     
                
            });             
            var pageLevelErrors=[];
            var fieldLevelErrors=[];
            error.forEach(function(item) {
                if(!$A.util.isEmpty(item.message)){
                    pageLevelErrors.push(item);
                }
                if(!$A.util.isEmpty(item.fieldLabel)){
                    fieldLevelErrors.push(item);
                }
            });    
            
            fieldError.forEach(function(item) {
                item.forEach(function(row) {
                    /* If we want Field Label Error Texts to be displayed in Popover
                 * Uncomment this section
                    if(!$A.util.isEmpty(row.message)){
                        pageLevelErrors.push(row);
                    }
               */
                    if(!$A.util.isEmpty(row.fieldLabel)){
                        fieldLevelErrors.push(row);
                    }
                });  
            });  
            component.set("v.pageLevelErrors",pageLevelErrors);
            component.set("v.fieldLevelErrors",fieldLevelErrors);    
            component.set("v.closePopupBtn",false);
            
        } catch (e) {
            // Handle Exception error
            console.error(e);                    
        } 
        
        
    },
    // This function will close the PopOver -NOKIASC-23321
    closePopup : function(component, event, helper) {
        component.set("v.closePopupBtn",true); 
        
    },
    // This function will Open the PopOver -NOKIASC-23321
    openPopup : function(component, event, helper) {
        component.set("v.closePopupBtn",false);
        
        
    },
    
    updateEntitlement : function (component, event, helper){
        var action = component.get('c.enableReEntitlement');
        action.setParams({ "caseRecordId" : component.get("v.recordId") });
        action.setCallback(this,function(response){
            if (response.getState() === "SUCCESS") {
                if (response.getReturnValue() == '') {
                    var evt = $A.get("e.force:navigateToComponent");
                    evt.setParams({
                        componentDef: "c:CH_ReEntitlement",
                        componentAttributes:{
                            caseId : component.get("v.recordId")
                        }            
                    });
                    evt.fire();
                } else {
                    helper.showToastMessage('Error',response.getReturnValue()); 
                }                              
            }
        });
        $A.enqueueAction(action);
    },
    
    openProductPulldown : function(component, event, helper) {
        var action = component.get('c.hasCaseEditAcess');
        action.setParams({ "caseRecordId" : component.get("v.recordId"), fields : [
            'ProductId', 'CH_Product_Release__c', 'CH_Product_Module__c', 'CH_ProductVariant__c', 
            'CH_Solution__c', 'CH_SW_Component__c', 'CH_SW_Release__c', 'CH_SW_Module__c',
            'CH_SW_Build__c', 'CH_HW_Component__c'
        ]});
        action.setCallback(this,function(response){
            if (response.getState() === "SUCCESS") {
                let result = response.getReturnValue();
                if(result === '' || result === 'Entitlement related details cannot be modified once Restore, Temporary Solution or Solution Provided events have been completed.') {
                    var evt = $A.get("e.force:navigateToComponent");
                    evt.setParams({
                        componentDef: "c:CH_ProductPulldown",
                        componentAttributes:{
                            id : component.get("v.recordId"),
                            object : 'Case',
                            type : 'CompleteMinimalLocked'
                        }            
                    });
                    evt.fire();
                }
                else {
                    helper.showToastMessage('Error',result); 
                }
            }
        });
        $A.enqueueAction(action);
    },
})