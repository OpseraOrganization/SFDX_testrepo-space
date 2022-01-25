({
    getExtraInformation : function(component) {
        var action = component.get("c.getExtraInformationForQuoteId");
        action.setParams({
            "recordId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if( state === "SUCCESS") {
                component.set("v.extraInformationList", response.getReturnValue());
            } else {
                alert('Failed to fetch Extra Information!' + JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    getHelpTextMap : function(component) {
        var action = component.get("c.getHelpTextForQuote");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if( state === "SUCCESS") {
                component.set("v.helpTextMap", response.getReturnValue());
            } else {
                alert('Failed to fetch Help Text!' + JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    getLoggedInUserDetails : function(component) {
        var action = component.get("c.isDSCustomerProfile");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if( state === "SUCCESS") {
                component.set("v.isCustomerUserLoggedIn", response.getReturnValue());
            } else {
                alert('Failed to fetch user details!' + JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    }
})