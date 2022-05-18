({
    doInit : function(component, event, helper) {
        var getWgId = component.get("v.wgId");
        component.set('v.newMember.CH_Workgroup__c',getWgId);
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.setTabLabel({
                tabId: focusedTabId,
                label: "New User"
            });
        })
        .catch(function(error) {
            console.log(error);
        });
    },
    createUserMember : function(component, event, helper) {
        var getWgId = helper.getJsonFromUrl().id;
        component.set('v.newMember.CH_Workgroup__c',getWgId);
        var allValid = component.find('memberform').reduce(function (validSoFar, inputCmp) {
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
        }, true);
        if (allValid) {
            var newHotlineMember = component.get("v.newMember");
            var action = component.get("c.saveHotlineMember");
            action.setParams({ 
                "hotlineMember": newHotlineMember
            });
            action.setCallback(this, function(a) {
                var state = a.getState();
                if (state === "SUCCESS") {
                    helper.showSuccessToast(component, event, helper);
                    helper.closeFocusedTab(component, event, helper);
                }
                else if (state=="ERROR") {
                    var errorMsg = action.getError()[0].message;
                    console.log(errorMsg);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "type":"error",
                        "message": errorMsg
                    });
                    toastEvent.fire();
                }
            });
            $A.enqueueAction(action)
        } else {
            helper.showErrorToast(component, event, helper);
        }
    },
    showSuccessToast : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "type":"Success",
            "message": "User has been created successfully."
        });
        toastEvent.fire();
    },
    showErrorToast : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "type":"error",
            "message": "User has not been created. Please Check the validations"
        });
        toastEvent.fire();
    },
    getJsonFromUrl : function () {
        var query = location.search.substr(1);
        var result = {};
        query.split("&").forEach(function(part) {
            var item = part.split("=");
            result[item[0]] = decodeURIComponent(item[1]);
        });
        return result;
    },
    closeFocusedTab : function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
        })
        .catch(function(error) {
            console.log(error);
        });
    }
})