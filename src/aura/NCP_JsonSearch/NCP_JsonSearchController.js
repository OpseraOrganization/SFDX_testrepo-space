/**
 * Created by tweinberger on 2019-04-02.
 */
({
    loadJquery : function(component, event, helper) {
        helper.initSearch(component, event, helper);
    },
    onFocus: function(cmp, evt, hlp) {
        hlp.resultsListElement = cmp.find('ncp_productSearchResults').getElement();
    },
    onChange: function(cmp, evt, hlp) {
        hlp.showSpinner(cmp);
        var timer = cmp.get('v.inputTimer');
        // console.log(timer);
        clearTimeout(timer);

        timer = setTimeout(function () {
            // hlp.getSearchResults(cmp, event);
            hlp.searchTermChange(cmp);
            clearTimeout(timer);
            cmp.set('v.inputTimer', null);
            hlp.hideSpinner(cmp);
        }, 500);

        cmp.set('v.inputTimer', timer);
    },
    onKeyDown: function(cmp, evt, hlp) {
        hlp.keyPress(cmp, evt);
    },
    // automatically call when the cmp is done waiting for a response to a server request.
    hideSpinner: function(cmp, evt, hlp) {
        hlp.hideSpinner(cmp);
    },
    // automatically call when the cmp is waiting for a response to a server request.
    showSpinner: function(cmp, evt, hlp) {
        hlp.showSpinner(cmp);
    },
    showProductPage: function(cmp, evt, hlp) {
        if (cmp.get('v.isDeepLinking')) {
            hlp.showProductPage(cmp, evt.currentTarget.dataset.productId);
        } else {
            hlp.addItemToSelectedItems(cmp, evt.currentTarget.dataset.productId);
        }
    },
    removeItemFromSelectedItems: function(cmp, evt, hlp) {
        var itemIdx = evt.getParam('index');
        hlp.removeItemFromSelectedItems(cmp, itemIdx);
    },
    showErrorState: function(cmp) {
        cmp.set('v.isInErrorState', true);
    },
    checkErrorState: function(cmp) {
        var selectedItems = cmp.get('v.selectedItems');
        if (selectedItems.length > 0) {
            cmp.set('v.isInErrorState', false);
        }
    }


})