({
    init : function(component, event, helper){

        console.log("v.viewMode -- "+component.get("v.viewMode"));
        console.log("v.userAllowed -- "+component.get("v.userAllowed"));

        var action = component.get("c.allowedUserToEdit");

        action.setParams({
            recordId : component.get("v.recordId")
        });


        action.setCallback(this, function(response){
            var result = response.getReturnValue();
            if(response.getState()==='SUCCESS' && result != null)
            {
                component.set("v.userAllowed",result);
                console.log('v.userAllowedINIT --> '+result);
            }
        })
        $A.enqueueAction(action);
    },
    edit: function(component, event){
        component.set("v.viewMode",false);
    },
    cancel: function(component, event, helper){
        component.set("v.viewMode",true);
    },
    handleSave : function(component, event, helper) {
        component.find("form1").submit();
        component.find("form2").submit();
        component.find("form3").submit();
        component.set("v.viewMode",true);
        $A.get('e.force:refreshView').fire();
    },
    toggleSection1: function(component, event) {
        var section1 = component.find('section1');
        if(component.get("v.viewMode")==true)
            $A.util.toggleClass(section1, 'slds-is-open');
        else
            $A.util.addClass(section1, 'slds-is-open');
    },
    toggleSection2: function(component, event) {
        var section2 = component.find('section2');
        if(component.get("v.viewMode")==true)
        {
            $A.util.toggleClass(section2, 'slds-is-open');
        }
        else
            $A.util.addClass(section2, 'slds-is-open');
    },
    toggleSection3: function(component, event) {
        var section3 = component.find('section3');
        if(component.get("v.viewMode")==true)
        {
            $A.util.toggleClass(section3,'slds-is-open');
        }
        else
            $A.util.addClass(section3,'slds-is-open');
    },
    toggleSection4: function(component, event) {
        var section4 = component.find('section4');
        $A.util.toggleClass(section4, 'slds-is-open');
    },

    handleRecordUpdated: function(component, event, helper) {
        var eventParams = event.getParams();
        component.set("v.riskLink",false);
        if(eventParams.changeType === "LOADED") {
            var riskAssessmentLink = component.get("v.opptyRecord.Risk_Assessment__c");
            if(riskAssessmentLink != null){
               component.set("v.riskLink",true);
            }
        } else if(eventParams.changeType === "CHANGED") {
            var riskAssessmentLink = component.get("v.opptyRecord.Risk_Assessment__c");
            if(riskAssessmentLink != null){
                component.set("v.riskLink",true);
            }
        } else if(eventParams.changeType === "ERROR") {
            console.log('error loading the record');
        }
    },

    openRiskAssessment: function(component, event) {
        var riskAssessmentLink = component.get("v.opptyRecord.Risk_Assessment__c");
       	window.open(riskAssessmentLink);
    }
});