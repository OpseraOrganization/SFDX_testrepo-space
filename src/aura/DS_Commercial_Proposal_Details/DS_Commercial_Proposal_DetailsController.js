({
    doInit : function(component, event, helper) {
        helper.getExtraInformation(component);
        helper.getHelpTextMap(component);
        helper.getLoggedInUserDetails(component);
    }
})