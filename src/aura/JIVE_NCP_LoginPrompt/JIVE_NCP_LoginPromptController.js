({
    doInit: function(cmp, evt, hlp) {
        hlp.setData(cmp);
    },
    hideSelf: function(cmp) {
        cmp.destroy();
    },
    itemSelected: function(cmp, evt) {
        if (evt) {
            evt.preventDefault();
            evt.stopPropagation();
        }

        var value = evt.target.dataset.menuItemValue;
        if (value) {
            var urlEvent = $A.get('e.force:navigateToURL');
            urlEvent.setParams({
                url: '/' + value
            });
            urlEvent.fire();
        }
    }
});