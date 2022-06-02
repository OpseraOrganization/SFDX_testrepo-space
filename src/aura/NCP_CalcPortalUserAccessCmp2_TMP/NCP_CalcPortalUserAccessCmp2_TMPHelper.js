({
    getData: function (component, event, helper) {
        var action = component.get("c.fetchData");
        action.setCallback(this, function (response) {
            debugger;
            if (response.getState() === 'SUCCESS') {
                var data = response.getReturnValue();
                component.set("v.sharedRows", data);
                var a = component.get("v.sharedRows");
            }
        });
        $A.enqueueAction(action);
    }
})