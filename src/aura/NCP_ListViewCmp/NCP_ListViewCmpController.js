({

    doInit : function(cmp, evt, hlp) {
        // var eventType = event.getType();
        // if oldvalue === '' it means it's initialising, ignore
        // var oldValue = event.getParam('oldValue');
        // if ((eventType === 'aura:valueInit') || (eventType === 'aura:valueChange' && oldValue)) {
            // hlp.setListName(cmp);
            // hlp.setListViews(cmp);
            hlp.getAllListViewInfo(cmp);
            // hlp.setProducts(cmp);
        // }
    },
    onPagePrevious: function(cmp, evt, hlp) {
        var page = cmp.get('v.page') || 1;
        page = page - 1;
        hlp.setProducts(cmp, page);
    },

    onPageNext: function(cmp, evt, hlp) {
        var page = cmp.get('v.page') || 1;
        page = page + 1;
        hlp.setProducts(cmp, page);
    },
    toggleVisibility : function(cmp){
        if (cmp.get('v.listViews').length !== 0) {
            var ddDiv = cmp.find('ncp-listViewMenu');
            $A.util.toggleClass(ddDiv,'slds-is-open');
        }
    },
    setListView : function(cmp, evt, hlp) {
        var selectedItem = evt.currentTarget;
        var currentViewLabel = selectedItem.dataset.name;
        cmp.set('v.listViewName', currentViewLabel);
        hlp.setProducts(cmp);
    }
})