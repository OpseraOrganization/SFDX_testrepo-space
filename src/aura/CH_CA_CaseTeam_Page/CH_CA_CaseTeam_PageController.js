({
    init: function(component, event, helper) {
        var myPageRef = component.get("v.pageReference");
        var name = myPageRef && myPageRef.state ? myPageRef.state.c__recordId : "";
        component.set("v.recordId", name);
        component.set("v.refresh", true);
        
    },
    handlePageChange: function(component, event, helper) {
        var myPageRef = component.get("v.pageReference");
        var name = myPageRef && myPageRef.state ? myPageRef.state.c__recordId : "";
        component.set("v.recordId", name);
        component.set("v.refresh", true);
    }
})