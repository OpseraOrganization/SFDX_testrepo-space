({
    click: function (component, event, helper) {
        helper.deactivatePortalUser(component);
    },
    closeWindow: function (component) {
        $A.get("e.force:closeQuickAction").fire();
    }
})