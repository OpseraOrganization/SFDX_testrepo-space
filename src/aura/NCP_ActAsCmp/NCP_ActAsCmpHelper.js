({
    actAs: function (component) {

        var recordId = component.get('v.recordId');
        
        var action = component.get("c.setPortalSSOSession");
        action.setParams({
            "recordId": recordId
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('state: ' + state);
            if (state === "SUCCESS") {
                //self.navigateToUrl('/servlet/servlet.su?oid=' + MyAccountId + '&retURL=' + CustomerAccountId + '&sunetworkid=' + setupId + '&sunetworkuserid=' + userId);
                $A.get("e.force:closeQuickAction").fire();
                window.open(response.getReturnValue());
            }
            else {
                $A.get("e.force:closeQuickAction").fire();
                console.log("ERROR From server: " + response.getReturnValue());
            }
        });

        $A.enqueueAction(action);
    }

})