({
    doInit: function(component, event, helper) {
        var typeofL2D = component.get("v.L2DType");
        if(typeofL2D == 'NonL2d'){
            component.set("v.showNonL2Dinput",false);
        }  
        helper.getNonL2DTriggerAnswers(component, event, helper);
        helper.getL2DTriggerAnswers(component, event, helper);
        component.set('v.columns', [
            {label: 'G4 Approval Ask (Answer)', fieldName: 'Answer__c', type: 'text'},
            {label: 'Help', fieldName: 'Help__c', type: 'textArea'},
            {label: 'Level', fieldName: 'Level__c', type: 'text'}
        ]);
        
    },
    selectAnswer: function (component, event) {
        var selectedRows = event.getParam('selectedRows');
        component.set("v.trgAnswer",selectedRows[0]);//
        component.set("v.enableButton",false);
        component.set("v.selectedHelp",selectedRows[0].Help__c);
        
    },
    saveAnswer: function (component, event, helper) {
        helper.saveAnswer(component, event, helper);
    },
    saveNonL2DAnswer: function (component, event, helper) {
        var ans = component.get("v.nonL2DAnswer");
        if((ans == undefined) || (ans == '')){
            sforce.one.showToast({
                "title": "Warning!",
                "message": "Please Enter Answer."
            });  
        }else{
            helper.saveNonL2DAnswer(component, event, helper); 
        }
        
    },
    cancel: function (component, event) {
        sforce.one.back(true);
        sforce.one.navigateToSObject(component.get("v.recordId"));
        
    },
})