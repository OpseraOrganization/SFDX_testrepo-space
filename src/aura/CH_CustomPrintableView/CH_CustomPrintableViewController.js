({
    doInit : function(component, event, helper) {        
        var isRelatedList = component.get("v.isRelatedList");
        if(isRelatedList) {
            var recId = component.get("v.recordId");
            var action = component.get("c.getRelatedRecords");
            action.setParams({
                childObjectName : component.get("v.childObjectName"),
                referenceFieldName : component.get("v.referenceFieldName"),
                referenceFieldValue : recId,
                selectedDate : component.get("v.selectedDate")
                
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if(state === 'SUCCESS' || state === 'DRAFT') {
                    var result = response.getReturnValue();                   
                    
                    if (component.get("v.childObjectName") == 'EmailMessage'){
                       var messageList= [];
                        var emaillengthLabel = $A.get("$Label.c.CH_Printviewemaillenghth");
                       result.forEach(function(row) {                 
                           row.TextBody=row.TextBody.substring(0,emaillengthLabel);
                           messageList.push(row);
                            });
                        component.set("v.relatedList", messageList);                        
                    }
                    
                    else{
                        component.set("v.relatedList", result);
                    }
                    
                    console.log("relatedList::::", JSON.stringify(result));
                    helper.doInit(component, event, helper);
                }
            });
            $A.enqueueAction(action);
            helper.doInit(component, event, helper);
        }
        else {
            helper.doInit(component, event, helper);
        }       
    }    
})