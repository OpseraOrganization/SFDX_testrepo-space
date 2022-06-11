({
    doInit: function(cmp, evt, hlp) {
        hlp.initialiseData(cmp);
    },
    tabClick: function(cmp, evt) {
        var targetEl = evt.target;
        while (!targetEl.id) {
            targetEl = targetEl.parentElement;
        }
        cmp.set('v.currentTab', targetEl.id);
    },
    toggleSection: function(cmp, evt, hlp) {
        var targetId = evt.currentTarget.id;
        hlp.toggleCategory(cmp, targetId);
    },
    editFavoriteProduct: function(cmp, evt, hlp) {
        sessionStorage.setItem('dnlListName', 'My Entitled Products');
        hlp.goToProductsListView();
    },
    seeAllFavoriteProduct: function(cmp, evt, hlp) {
        sessionStorage.setItem('dnlListName', 'Favorite Products');
        hlp.goToProductsListView();
    },
    itemSelected: function(cmp, evt) {
        var targetUrl = evt.target.dataset.itemUrl;
        if (targetUrl) {
            var navEvent = $A.get('e.force:navigateToURL');
            navEvent.setParams({
                'url': targetUrl
            });
            navEvent.fire();
        }
    }
});