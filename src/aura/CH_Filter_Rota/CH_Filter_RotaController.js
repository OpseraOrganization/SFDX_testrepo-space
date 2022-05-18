({
    doInit : function(component, event, helper)
    {
        component.set('v.showCalender', false);

        // Get the userid
        var action = component.get("c.getUserName");
        action.setCallback(this, function(response) {
            var state = response.getState();
            var rules = response.getReturnValue();
            if (state === "SUCCESS") {
                var user = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'ROTA Search',
                    message: 'Displaying ROTAs for ' + user.recordValue + ' that will end in the future. Displaying max 50 ROTAs',
                    type : 'info',
                    mode: 'dismissible',
                    duration: '5000'
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
        
        // Get all rotas for the current user
        //component.find("endDate").set('v.value', helper.getDate()); 
        var action = component.get("c.getMyWorkgroupRota");
        action.setCallback(this, function(response) {
            var state = response.getState();
            var rules = response.getReturnValue();
            if (state === "SUCCESS") {
                component.set('v.workgroupRota', response.getReturnValue());
                component.set('v.showCalender', true);
            }
        });
        $A.enqueueAction(action);        
    },   
    Search : function(component, event, helper){
        component.set('v.showCalender', false);
        var action = component.get("c.getWorkgroupRota");
        var workgroup2 = component.find("searchWorkgroup").get("v.selectedRecord");
        var workgroupId = (workgroup2 == null) ? null : workgroup2.recordId;
        var workgroupMember2 = component.find("searchWorkgroupMember").get("v.selectedRecord");
        var workgroupMemberId = (workgroupMember2 == null) ? null : workgroupMember2.recordId;
        var startDate = component.find("startDate").get("v.value");
        var endDate = component.find("endDate").get("v.value");
        action.setParams({workgroupId : workgroupId, workgroupMemberId : workgroupMemberId, 
                          startDateString : startDate, endDateString : endDate});
        action.setCallback(this, function(response) {
            var state = response.getState();
            var rules = response.getReturnValue();
            if (state === "SUCCESS") {
                component.set('v.workgroupRota', response.getReturnValue());
                component.set('v.showCalender', true);
            }
        });
        $A.enqueueAction(action);
    },
    Clear : function(cmp,event) {
        $A.get('e.force:refreshView').fire();
    }
})