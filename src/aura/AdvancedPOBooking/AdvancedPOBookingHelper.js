({
    navigateToOpptyHelper : function (component) {
        // it returns only first value of Id
        var sObjectEvent = $A.get("e.force:navigateToSObject");
        sObjectEvent.setParams({
            "recordId": component.get("v.recordId"),
            "slideDevName": "detail"
        });
        sObjectEvent.fire();
    },

})