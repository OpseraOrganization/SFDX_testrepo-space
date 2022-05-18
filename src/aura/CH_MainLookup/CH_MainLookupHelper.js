({
    searchHelper : function(component,event) {
        // call the apex class method 
        var action = component.get("c.OdrUnitsdata");
        // set param to method  
        action.setParams({
            'outageId':  component.get("v.recordId"),
            'selectedProduct':  component.get("v.productName"),
            'selectedUnit' : component.get("v.picklistODRUnits")
            
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success Message',
                    message: 'Units field updated Successfully',
                    // messageTemplate: 'Records Created Successfully',
                    duration:'2000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();
            }       
            
            else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error Message',
                    message:'Error:Units field are not updated Successfully',
                    // messageTemplate: 'Error:Records are not inserted Successfully',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
            }
           //  component.set("v.productName", null ); 
           // component.set("v.picklistODRUnits", null ); 
        });
        // enqueue the Action  
        $A.enqueueAction(action);
    }
})