({
   //Initialize method for component
    doInit : function(component, event, helper) {  
       //NOKIASC-34093
       helper.callInit(component, event, helper);
    },
    refresh : function(component, event, helper) {
        helper.checkWarrantyQuotationCondition(component,event,helper)
        .then(function(result){ 
            component.set("v.CaseList", result.listofCases);
            $A.get('e.force:refreshView').fire()
        });    
    },
    //This method will fire when click on validate and Submit button 
    validateandSubmit: function(component, event, helper) {
        helper.checkPayPerUse(component,event,helper);  
    }, 
    
    okButtonClick :function(component, event, helper) {
        //NOKIASC-34093  --> If-logic
        if(component.get("v.fewWUorQRTrue")){
            helper.cloneAllCases(component, event, helper);
        }
        else{
            if(component.get("v.LabelList")[0] == 'HWS_PO_MISSING'|| component.get("v.LabelList")[0]=='HWS_WCheck_UnKnowns' ){
                var message = $A.get("$Label.c.HWS_WCheck_UnKnowns_Escalated")
                component.set("v.instructionMsg",  message);
                component.set("v.isDisableOkButton",true);
                //update the case picklist
                component.set("v.isSpinner", true);
                helper.updateParentCaseStatusWarrantyQuote(component,event,helper)
                .then(function(result){ 
                    component.set("v.isSpinner", false);   
                })
            }
        }
    },
})