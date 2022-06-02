({
	getNetworkElementAssets : function(component, account, asset, entitlement, product, preselection, callback) {
        var helper = this;
        if(!account) return helper.reset(component);
        helper.incrementActionCounter(component);
        helper.action(component, "c.getAccountRelatedNetworkElementAssets",{
            withoutSharing: component.get("v.withoutSharing"), 
            accountId: account.Id,
            asset: asset,
            entitlement: entitlement,
            product: product
        }, function(neaList, error){
            helper.decrementActionCounter(component);
            if(error || neaList.length == 0) {
                component.set("v.netElemAssets", []);
                if(error) console.log(error);
                else helper.emit(component, 'noRecordFound');
                return helper.reset(component);
            }
            let selected = 'none', match = null;
            const preKeys = Object.keys(preselection || {});
            for(var i = 0; i < neaList.length; i++) {
                neaList[i].URL = '/one/one.app?#/sObject/' + neaList[i].Id + '/view';
                neaList[i].Address = neaList[i].Address__r?neaList[i].Address__r.CH_AddressDetails__c :'N/A';
                neaList[i] = helper.setObjectNameUrl(neaList[i], 'Product2', 'Product');
                neaList[i] = helper.setObjectNameUrl(neaList[i], 'CH_Solution__r', 'Solution');
                neaList[i] = helper.setObjectNameUrl(neaList[i], 'CH_ProductVariant__r', 'Variant');
                neaList[i] = helper.setObjectNameUrl(neaList[i], 'CH_ProductRelease__r', 'Release');
                //
                for(let n = 0, keyLen = preKeys.length, curMatch = true; n < keyLen; n++) {
                    curMatch = curMatch && (
                        typeof preselection[preKeys[n]] === "string" ?
                        preselection[preKeys[n]].toLowerCase() === neaList[i][preKeys[n]].toLowerCase() :
                        preselection[preKeys[n]] === neaList[i][preKeys[n]]
                    )
                    if((1+n) == keyLen && curMatch) {
                        if(selected === 'none' || selected === 'auto') {
                        	selected = 'preselection';
                            match = i;
                        }
                        else if(selected === 'preselection') { selected = 'preselection-multiple'; }
                    }
                }
                if(neaList[i].Id === component.get("v.selected") && selected === 'none') {
                    selected = 'auto';
                    component.find("neaTable").setSelectedRows(new Array(neaList[i].Id));
                }
            }
            if(match != null && selected === 'preselection') {
                component.find("neaTable").setSelectedRows(new Array(neaList[match].Id));
                helper.select(component, neaList[match], true, true);               
            }
            component.set("v.netElemAssets", neaList);
            if(callback) { callback(selected); }
        });
	},
    reset : function(component) {
        component.find("neaTable").setSelectedRows(new Array());
        this.select(component, null);
    },
    select : function(component, object, nextOverride, selectInTable) {
        this.emit(component, nextOverride?'next':'select', object);
        component.set('v.selected', object ? object.Id : null);
        if(selectInTable && object) component.find("neaTable").setSelectedRows(new Array(object.Id));
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
            target	:'NEA',
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