({
    doInit : function(component, event, helper) {
  console.log("In printData");
        var recordId = component.get("v.recordId");
        var fieldSetName = component.get("v.fieldSetName");
        var sObjectTypeName = component.get("v.sObjectTypeName");
        console.log("fieldSetName::::", fieldSetName);
        console.log("sObjectTypeName::::", sObjectTypeName);
        
        var action = component.get("c.getFieldSet");
        action.setParams({
            fieldSetName : fieldSetName,
            sObjectName : sObjectTypeName
        });
        action.setCallback(this, function(response) {
            console.log("In printData call back");
            var state = response.getState();
            console.log("state::::", state);
            if(state === 'SUCCESS' || state === 'DRAFT') {
                var result = response.getReturnValue();
                console.log("fieldSet::::", result);
                component.set("v.fieldSet", result);
                                
                console.log("fields::::", JSON.stringify(result));
                var myList = result;
                var jsonString = "";
                for(var i = 0; i < myList.length; i++) {
                    if(jsonString === '')
                        jsonString = myList[i];
                    else
      jsonString = jsonString +','+myList[i];
                }
                var newString = jsonString;
                console.log("newString::::", newString);
                component.set("v.render", true);
            }
        });
        $A.enqueueAction(action);
    },
})