({
    
    getEntitlements: function(component, account, contact, asset, netElemAsset) {
        let helper = this;
		if(!account || !contact || !asset) return helper.reset(component);
        helper.incrementActionCounter(component);
        helper.action(component, "c.getContactAuthorizedEntitlements",{
            withoutSharing: component.get("v.withoutSharing"), 
            accountId: account.Id,
            assetId : asset.Id, 
            contactId : contact.Id, 
            netElemAsset : netElemAsset,
            serviceType : component.get("v.serviceType"),
            swMaintenance : component.get("v.swMaintenance")
        }, function(entitlementList, error){
            helper.decrementActionCounter(component);
            if(error || entitlementList.length == 0) {
                component.set("v.entitlements", []);
                if(error) console.log(error);
                else helper.emit(component, 'noRecordFound');
                return helper.reset(component);
            }
            var selected = false;
            for(let i = 0; i < entitlementList.length; i++) {
                entitlementList[i].EntitlementURL = '/one/one.app?#/sObject/' + entitlementList[i].Id + '/view';
                entitlementList[i] = helper.setObjectNameUrl(entitlementList[i], 'ServiceContract', 'Contract');
                entitlementList[i].CustomerContractNumber = entitlementList[i].ServiceContract?entitlementList[i].ServiceContract.CH_CustomerContractNumber__c:'';
                entitlementList[i].ProjectName = entitlementList[i].ServiceContract?entitlementList[i].ServiceContract.CH_Project__c:'';
                entitlementList[i].LineItemURL = entitlementList[i].ContractLineItem?('/one/one.app?#/sObject/' + entitlementList[i].ContractLineItem.Id + '/view'):'';
                entitlementList[i].LineItemNumber = entitlementList[i].ContractLineItem?entitlementList[i].ContractLineItem.LineItemNumber:'';
                entitlementList[i].BusinessHour = entitlementList[i].ContractLineItem && entitlementList[i].ContractLineItem.CH_BusinessHour__r?entitlementList[i].ContractLineItem.CH_BusinessHour__r.Name:'';
                entitlementList[i].HasScript = ( helper.valid(entitlementList[i].ContractLineItem.CH_LineItemEntitlementScript__c) || helper.valid(entitlementList[i].ServiceContract.CH_EntitlementScript__c));
                entitlementList[i].NEACount = entitlementList[i].ContractLineItem?entitlementList[i].ContractLineItem.CH_QtyCoveredNetworkElementAssets__c : 0;
                if(entitlementList[i].Id === component.get("v.selected")) {
                    selected = true;
                    component.find("entitlementTable").setSelectedRows(new Array(entitlementList[i].Id));
                }
            }
            if(entitlementList.length == 1 && !selected) helper.select(component, entitlementList[0], component.get("v.autoNext"), true);
            component.set("v.entitlements", entitlementList);
        });
    },
    reset : function(component) {
        component.find("entitlementTable").setSelectedRows(new Array());
        this.select(component, null);
    },
    select : function(component, object, nextOverride, selectInTable) {
        this.emit(component, nextOverride?'next':'select', object);
        component.set('v.selected', object ? object.Id : null);
        if(selectInTable && object) component.find("entitlementTable").setSelectedRows(new Array(object.Id));
        if(object != null) {
            if(component.get('v.showScripts') && object){
                component.set('v.contractScript', object.ServiceContract && object.ServiceContract.CH_EntitlementScript__c?object.ServiceContract.CH_EntitlementScript__c:'');
                component.set('v.lineItemScript', object.ContractLineItem && object.ContractLineItem.CH_LineItemEntitlementScript__c?object.ContractLineItem.CH_LineItemEntitlementScript__c:'');
            }            
        }
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
            target	: 'Entitlement',
            object	: JSON.stringify(args)
        }).fire();
    },
    //
    valid: function(object) {
        return object != null && object != '';
    },
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
    },
    showToast: function(type,title,message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : title,
            message: message,
            duration:'1000',
            key: 'info_alt',
            type: type,
            mode: 'dismissible'
        });
        toastEvent.fire(); 
    }
})