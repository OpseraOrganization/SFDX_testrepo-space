({
    init: function(component, event, helper) {
        var myPageRef = component.get("v.pageReference");
        var name = myPageRef && myPageRef.state ? myPageRef.state.c__recordId : "";
        component.set("v.recordId", name);
        var action = component.get("c.getWorkgroupDetails");
        action.setParams({ caseId : component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.refresh", true);
                var workgroupInstructionsComponent = component.find("WorkgroupInstructions");
                workgroupInstructionsComponent.displayworkgroupInstructionsModal(response.getReturnValue().CH_Workgroup__c,response.getReturnValue().CH_Workgroup__r.Name,name, "reAssignment");
           		
            }
        });
        $A.enqueueAction(action);
    },
    handlePageChange: function(component, event, helper) {
        var myPageRef = component.get("v.pageReference");
        var name = myPageRef && myPageRef.state ? myPageRef.state.c__recordId : "";
        component.set("v.recordId", name);
        component.set("v.refresh", true);
    }
})