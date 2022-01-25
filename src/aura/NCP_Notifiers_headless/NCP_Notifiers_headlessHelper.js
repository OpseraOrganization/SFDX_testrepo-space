({
    fetchNotifiers : function(cmp) {
        var action = cmp.get('c.getBannerNews');
        // action.setParams({ 'type': cmp.get('v.type') });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                cmp.set('v.notifications', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
})