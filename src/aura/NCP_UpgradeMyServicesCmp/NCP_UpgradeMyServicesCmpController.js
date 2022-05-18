({
    doInit: function(cmp, evt, hlp) {
        // first need to check if auth
        hlp.initialiseData(cmp);
    },
    toggleSection: function(component, event) {
        var targetId = event.currentTarget.id;
        component.set('v.' + targetId + 'Open', !component.get('v.' + targetId + 'Open'));
    },
    handleSubmit: function(cmp, evt, hlp) {
        // helper.validateInputs(component);
        var isOther = evt.getSource().getLocalId() === 'other' ? true : false;
        hlp.submitRequest(cmp, isOther);
    },
    otherServicesHandler: function(cmp, evt, hlp) {
        hlp.checkSubmitStatus(cmp, true);
    },
    servicesHandler: function(cmp, evt, hlp) {
        hlp.checkSubmitStatus(cmp);
    }
});