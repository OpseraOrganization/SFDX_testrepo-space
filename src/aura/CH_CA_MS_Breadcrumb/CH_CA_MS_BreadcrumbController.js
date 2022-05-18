({
    init: function (cmp, event, helper) {
        var breadcrumbCollection = [];
        var workgroupId = cmp.get("v.workgroupId");
        var scheduleId = cmp.get("v.scheduleId");
        var action = cmp.get("c.getWorkGroupAndScheduleNames");
        action.setParams({ workgroupId : workgroupId, scheduleId : scheduleId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                if(result[0] && result[0].length > 0){
                    breadcrumbCollection.push(result[0]);
                }
                if(result[1] && result[1].length > 0){
                    breadcrumbCollection.push(result[1]);
                }
                cmp.set('v.breadcrumbCollection', breadcrumbCollection);
            }
        });
        $A.enqueueAction(action);
    },
    navigateTo: function (cmp, event, helper) {
        var navigate = cmp.get('v.navigateFlow');
        try {
  			navigate("BACK");
		}
		catch(err) {
  			//navigation can fail on the fist flow screen
        }

    }
});