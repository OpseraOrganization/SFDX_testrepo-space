({
    deactivatePortalUser: function (component) {
        var spinner = component.find("submitActSpinner");

        // disable button
        component.set("v.disableButton", true);
        $A.util.toggleClass(spinner, "slds-hide");

        var recordId = component.get('v.recordId');

        var action = component.get("c.disableUser");
        action.setParams({
            "recordId": recordId
        });

        action.setCallback(this, function (response) {

            // enable button
            component.set("v.disableButton", false);
            $A.util.toggleClass(spinner, "slds-hide");
            //$A.get("e.force:closeQuickAction").fire();
            $A.get("e.force:refreshView").fire();
            var state = response.getState();
            var storeResponse = response.getReturnValue();
            var state = response.getState();
            if (state === "ERROR" || storeResponse.startsWith("Failure")) {
				component.set("v.response", storeResponse);
            	//alert("Failed ...."+storeResponse);
            }else {
                $A.get("e.force:closeQuickAction").fire();
            }
        });

        $A.enqueueAction(action);
    }
})