({
    getAssets: function(component, contact, account, netElemAsset) {
        let helper = this;
        if(!contact || !account) return helper.reset(component);
        helper.incrementActionCounter(component);
        helper.action(component, "c.getContactAuthorizedAssets",{
            withoutSharing: component.get("v.withoutSharing"), 
            accountId: account.Id, 
            contactId: contact.Id, 
            netElemAsset: netElemAsset,
            serviceType : component.get("v.serviceType"),
            swMaintenance : component.get("v.swMaintenance")
        }, function(assetList, error){
            helper.decrementActionCounter(component);
            if(error || assetList.length == 0) {
                component.set("v.assets", []);
                if(error) console.log(error);
                else helper.emit(component, 'noRecordFound');
                return helper.reset(component);
            }
            var selected = false;
            for(var i = 0; i < assetList.length; i++) {
                assetList[i].ProductName = assetList[i].Product2?assetList[i].Product2.Description:'';
                assetList[i] = helper.setObjectNameUrl(assetList[i], 'Product2', 'Product');
                assetList[i] = helper.setObjectNameUrl(assetList[i], 'CH_Solution__r', 'Solution');
                assetList[i] = helper.setObjectNameUrl(assetList[i], 'CH_ProductVariant__r', 'Variant');
                assetList[i] = helper.setObjectNameUrl(assetList[i], 'CH_ProductRelease__r', 'Release');
                if(assetList[i].Id === component.get("v.selected")) {
                    selected = true;
                    component.find("assetTable").setSelectedRows(new Array(assetList[i].Id));
                    component.set('v.productDescription', component.get('v.showDescription') && assetList[i].ProductDescription?assetList[i].ProductDescription:'');
                }
            }
            if(assetList.length == 1 && !selected) helper.select(component, assetList[0], component.get("v.autoNext"), true);
            component.set("v.assets", assetList);
        });
    },
    reset : function(component) {
        component.find("assetTable").setSelectedRows(new Array());
        this.select(component, null);
    },
    select : function(component, object, nextOverride, selectInTable) {
        this.emit(component, nextOverride?'next':'select', object);
        component.set('v.selected', object ? object.Id : null);
        component.set('v.productDescription', component.get('v.showDescription') && object && object.ProductDescription?object.ProductDescription:'');
        if(selectInTable && object) component.find("assetTable").setSelectedRows(new Array(object.Id));
    },
    // Set Object Name and URL
    setObjectNameUrl: function(entry, object, key) {
        entry[key+'URL'] = (entry[object] != null)?('/one/one.app?#/sObject/' + entry[object].Id + '/view'):'';
        entry[key+'Name'] = (entry[object] != null)?entry[object].Name:'';
        return entry;
    },
    emit: function(component, event, args) {
        component.getEvent("onEvent").setParams({
            message	: event,
            target	: 'Asset',
            object	: JSON.stringify(args)
        }).fire();
    },
    //
    action : function(component, method, args, callback) {
        let action = component.get(method);
        if(args) action.setParams(args);
        action.setCallback(this,function(response) { 
            var state = response.getState();
            if (state === "SUCCESS") {
                callback(response.getReturnValue(), null);
            } else if (state === "INCOMPLETE") {
                callback(null, 'Incomplete');
            } else if (state === "ERROR") {
                var errors = response.getError();
                callback(null, errors && errors[0] && errors[0].message?("Error message: " + errors[0].message):"Unknown error");
            }
        });
        $A.enqueueAction(action);
    },
    incrementActionCounter: function(component) {        
        component.getEvent("onEvent").setParams({
            message: 'incrementActionCounter'
        }).fire();
    },
    decrementActionCounter: function(component) {
        component.getEvent("onEvent").setParams({
            message: 'decrementActionCounter'
        }).fire();
    }
})