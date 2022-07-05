({
     
    /*handleSaveRecord: function(component, event, helper) {
        component.find("recordEditor").saveRecord($A.getCallback(function(saveResult) {
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                console.log("Save completed successfully.");
            } else if (saveResult.state === "INCOMPLETE") {
                console.log("User is offline, device doesn't support drafts.");
            } else if (saveResult.state === "ERROR") {
                console.log('Problem saving record, error: ' + 
                           JSON.stringify(saveResult.error));
            } else {
                console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
            }
        }));}*/
    handleSuccess : function(component, event, helper) {
        console.log(event.getParams().response);
        for (let key of Object.keys(event.getParams().response)) {
            console.log(key + event.getParams().response[key]);
          }
        console.log(event.getParams().response.id);
        //console.log(component.find("name").get("v.value"));
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The record has been updated successfully.",
            "type": "success"
        });
        toastEvent.fire();
    },

    handleSubmit : function(component, event, helper) {
        console.log('Submit Event' + JSON.stringify(event.getParams()));
        console.log(component.find("CH_SuspectedDataBreach__c"));
        //The following is useful if you want to overwrite.Notice you need to specify both the values.This also assumes you have aura:id on the company field.
        //component.find("company").set("v.fieldName","Company");
        //component.find("company").set("v.value","value");
    },

    handleOnload : function(component, event, helper) {
        console.log('Load Event' + JSON.stringify(event.getParams()));
    },
    update : function(component,event,helper) {
   component.find("recordEditForm").submit();
}
})