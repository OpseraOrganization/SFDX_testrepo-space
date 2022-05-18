({
    // showNotifier: function(cmp, evt, hlp) {
    //     hlp.createNotifier(cmp, evt);
    // },
    showNotifiers: function(cmp, evt, hlp) {
        var params = evt.getParam('arguments');
        if (params) {
            hlp.setNotifiers(cmp, params.notifiers);
        }
    },

})