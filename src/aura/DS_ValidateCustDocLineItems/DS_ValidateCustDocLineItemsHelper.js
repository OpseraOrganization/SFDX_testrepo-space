({
	fetchPickListVal: function(component, fieldName, elementId) {
        var action = component.get("c.getselectOptions");
        action.setParams({
            "objObject": component.get("v.objInfo"),
            "fld": fieldName
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
 
                if (allValues != undefined && allValues.length > 0) {
                    opts.push({
                        class: "optionClass",
                        label: "--- None ---",
                        value: ""
                    });
                }
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                component.find(elementId).set("v.options", opts);
            }
        });
        $A.enqueueAction(action);
    },    
    
    
    updateParentRecord: function(component, event,changedStatus) {
        // call apex method for fetch child records list.
        var action = component.get('c.checkValidation');
        action.setParams({recID : component.get("v.recordId"),
                          cdstatus : changedStatus});
        action.setCallback(this, function(actionResult) {
            var state = actionResult.getState();
            if (state === 'SUCCESS') {
                //set response value in ChildRecordList attribute on component.
                component.set('v.result', actionResult.getReturnValue());
                //alert('Parent items');
                 $A.get("e.force:closeQuickAction").fire();  
                var toastEvent = $A.get("e.force:showToast");  
                
                var message = actionResult.getReturnValue();
                //alert(message);
                if(message == ''){
                     toastEvent.setParams({ 
                    "type":"Success",
                    "title": "Success!!", 
                    "message": "Status updated successfully"
                }); 
                }else{
                     toastEvent.setParams({ 
                    "type":"error",
                    "title": "error!!",              
                    "mode" : "sticky",
                    "message": message
                }); 
                }
               
              toastEvent.fire();  
                //if(message == ''){
                  //  location.reload();   
				$A.get("e.force:refreshView").fire(); 
               // }
                
            }
        });
        $A.enqueueAction(action);
    },
})