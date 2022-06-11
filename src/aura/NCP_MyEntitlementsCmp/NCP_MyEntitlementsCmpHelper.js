({
    setListViews : function(cmp,listView) {
        var action = cmp.get('c.getListViews');
        action.setStorable();
        action.setBackground();
        action.setParams({scIds : listView});
        action.setCallback(this,function(response){
            var state = response.getState();
            if (state === 'SUCCESS') {
                var listViewArray = response.getReturnValue();
                var targetIdx, allContractsItem;
                // remove the all contacts item from the array
                listViewArray.forEach(function(item, idx) {
                    if (!item.Id) {
                        // its the all contracts item
                        targetIdx = idx;
                    }
                });
                allContractsItem = listViewArray.splice(targetIdx, 1)[0];
                listViewArray.sort(function (a, b) {
                    if (a.Name < b.Name) {
                        return -1;
                    }
                    if (a.Name > b.Name) {
                        return 1;
                    }
                    return 0;
                });
                // put the allContractsItem back
                listViewArray.unshift(allContractsItem);

                cmp.set('v.listViews', listViewArray);
            }
        });
        $A.enqueueAction(action);
    },

    setAllMyEntitlements : function(cmp) {
        var action = cmp.get('c.getAllMyEntitlements');
        action.setStorable();
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === 'SUCCESS') {
                var allEntitlements = response.getReturnValue();
                allEntitlements.sort(function (a, b) {
                    if (a.sContract.Name < b.sContract.Name) {
                        return -1;
                    }
                    if (a.sContract.Name > b.sContract.Name) {
                        return 1;
                    }
                    return 0;
                });
                cmp.set('v.myEntitlements', allEntitlements);
                var listViewIds = [];
                for (var ent in allEntitlements){
                    listViewIds.push(allEntitlements[ent].sContract.Id);
                }
                this.setListViews(cmp, listViewIds);
            }
        });
        $A.enqueueAction(action);
    },
    setMyEntitlements : function(cmp) {
        var action = cmp.get('c.getMyEntitlements');
        action.setStorable();
        action.setParams({contractId : cmp.get('v.recordId')});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === 'SUCCESS') {
                cmp.set('v.myEntitlements',response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
})