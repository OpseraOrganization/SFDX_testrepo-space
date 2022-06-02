({
    doInit:  function(component, event, helper){
        helper.baseURL(component);
    },
    hasNotifiers: function (cmp, evt) {
        var notifiers = evt.getParam('value');
        if (!notifiers.length) {
            return;
        }
        var headerBanner = cmp.find('headerBanner');
        headerBanner.showNotifiers(notifiers);

        // depending on the notifier type(s) we need to fire an application event(s)
        // notifiers.forEach(function (item) {
        //     var appEvent = $A.get('e.c:NCP_eShowNotifier');
        //     appEvent.setParam('notifierType', item.NCP_Type__c);
        //     appEvent.setParam('notifierDetails', item);
        //     appEvent.fire();
        // });
    }
})