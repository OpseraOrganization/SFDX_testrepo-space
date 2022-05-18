({
    fetchQuote: function (component, event) {
        component.set("v.IsSpinner", true);
        var recordId = component.get("v.recordId");
        var action = component.get("c.rebidQuote");
        action.setParams({ "quoteId1": recordId });
		
       
        action.setCallback(this, function (response) {
            var state = response.getState();
            var quo = response.getReturnValue();
            if (state === "SUCCESS") {
           
                if (quo === "Maximum revision reached for the Quote") {                    
                    this.showToast({
                        'message': quo,
                        'type': 'error',
                        'duration': 10000
                    });
                    $A.get("e.force:closeQuickAction").fire();
                    component.set("v.IsSpinner", false);
                    var urlEvt = $A.get("e.force:navigateToURL");
                    urlEvt.setParams({
                        "url": '/' + component.get("v.recordId")
                    });
                    urlEvt.fire();
                    component.destroy();
                } else if (quo.includes(' ')) {  
                    
                    this.showToast({
                        'message': quo,
                        'type': 'error',
                        'duration': 10000
                    });
                    $A.get("e.force:closeQuickAction").fire();                    
                    var urlEvt = $A.get("e.force:navigateToURL");
                    urlEvt.setParams({
                        "url": '/' + component.get("v.recordId")
                    });
                    urlEvt.fire();
                    component.destroy();
                } else {                    
                    this.showToast({
                        'message': 'Quote Rebid Successful',
                        'type': 'success',
                        'duration': 10000
                    });                    
                    component.set("v.IsSpinner", false);
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": quo,
                        "slideDevName": "related"
                    });
                    navEvt.fire();
                }

            } else {
                component.set("v.IsSpinner", false);
                this.showToast({
                    'message': quo,
                    'type': 'error',
                    'duration': 10000
                });
                var urlEvt = $A.get("e.force:navigateToURL");
                urlEvt.setParams({
                    "url": '/' + component.get("v.recordId")
                });
               urlEvt.fire();
               component.destroy();            
              }
        });
        $A.enqueueAction(action);
    },
    showToast: function (params) {
        var toastEvent = $A.get("e.force:showToast");
        if (toastEvent) {
            toastEvent.setParams(params);
            toastEvent.fire();
        }
        else
            console.log('Error in toast');
    }
})