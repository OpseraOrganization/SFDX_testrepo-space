({
    matchCDToQuote : function(component, event) {

        var action = component.get("c.validate");
        action.setParams({ cdId : component.get("v.recordId") });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.differences", JSON.parse(response.getReturnValue()));
                console.log("f: ", component.get("v.differences"));
                $A.get('e.force:refreshView').fire();
            }
            else if (state === "INCOMPLETE") {
                    console.log("Incomplete action");
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });

        $A.enqueueAction(action);

    }
})