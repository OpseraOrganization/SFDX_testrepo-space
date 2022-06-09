({
    setProducts : function(cmp, page) {
        var action = cmp.get('c.getProductsListView');
        var pageSize = cmp.get('v.pageSize');
        var params = {
            'listView': cmp.get('v.listViewName'),
            'pageSize': pageSize,
            'pageNumber': page || 1
        }
        action.setParams(params);
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            // debugger;
            cmp.set('v.productList', result.products);
            cmp.set('v.page', result.page);
            cmp.set('v.totalItems', result.total);
            cmp.set('v.pages', Math.ceil(result.total/pageSize));
            // show the results
            cmp.set('v.isLoadingProducts', false);
        });
        $A.enqueueAction(action);
    },
    // setListName : function(cmp) {
    //     var action = cmp.get('c.getListViewFilter');
    //     action.setStorable();
    //     if (!cmp.get('v.listViewName')) {
    //         // check the session storage to see if it is a DNL
    //         var dnlListName = sessionStorage.getItem('dnlListName');
    //         if (dnlListName) {
    //             cmp.set('v.listViewName', dnlListName);
    //             sessionStorage.removeItem('dnlListName');
    //         }
    //     }
    //     action.setParams({
    //         listName : cmp.get('v.listViewName')
    //     });
    //     action.setCallback(this, function(response) {
    //         var state = response.getState();
    //         if(state === 'SUCCESS'){
    //             cmp.set('v.listViewName',response.getReturnValue());
    //             this.setProducts(cmp, 1);
    //         }
    //     });
    //     $A.enqueueAction(action);
    // },
    // setListViews : function(cmp){
    //     var action = cmp.get('c.getListViews');
    //     action.setStorable();
    //     action.setCallback(this,function(response){
    //         var state = response.getState();
    //         if(state === 'SUCCESS'){
    //             cmp.set('v.listViews',response.getReturnValue());
    //         }
    //     });
    //     $A.enqueueAction(action);
    // },
    getAllListViewInfo: function(cmp) {
        var action = cmp.get('c.getListViewInfo');
        // action.setStorable();
        if (!cmp.get('v.listViewName')) {
            // check the session storage to see if it is a DNL
            var dnlListName = sessionStorage.getItem('dnlListName');
            if (dnlListName) {
                cmp.set('v.listViewName', dnlListName);
                sessionStorage.removeItem('dnlListName');
            }
        }
        var params = {
            listName: cmp.get('v.listViewName') || ''
        };
        action.setParams(params);
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var result = response.getReturnValue();
                cmp.set('v.listViewName', result.activeListView);
                cmp.set('v.listViews', result.allListViews);
                this.setProducts(cmp, 1);
            }
        });
        $A.enqueueAction(action);
    }
})