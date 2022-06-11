({
    doInit: function(cmp, evt, hlp) {
        hlp.initialiseData(cmp);
        hlp.setRecord(cmp);
        hlp.getProductStatus(cmp);
    },
    removeFromFavourites: function(cmp, evt, hlp) {
        hlp.makeFavourite(cmp, false);
    },
    addToFavourites: function(cmp, evt, hlp) {
        hlp.makeFavourite(cmp, true);
    },
    navigateTo: function(cmp, evt, hlp) {
        evt.preventDefault();
        var name = evt.getSource().get('v.name');
        if (name === 'product-list-view') {
            var urlEvent = $A.get('e.force:navigateToURL');
            urlEvent.setParams({
                'url': '/' + name
            });
            urlEvent.fire();
        }
    }
});