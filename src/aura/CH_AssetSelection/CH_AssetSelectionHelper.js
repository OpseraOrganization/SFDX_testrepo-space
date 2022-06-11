({
    getAssets: function(component, contact, account, netElemAsset) {
        let helper = this;
        if(!contact || !account) return helper.reset(component);
		// Start of NOKIASC-38809 changes to check logged-in user from Community or Not
        var communityFlag= false;
        var actionCommunityCheck = component.get("c.isCommunity"); 
        actionCommunityCheck.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                communityFlag = response.getReturnValue();
            }
        });
        $A.enqueueAction(actionCommunityCheck);
        // End of NOKIASC-38809 changes
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
                if(assetList[i].Product2) {
                    assetList[i].ProductCode = assetList[i].Product2.NCP_Nokia_Product_Id__c;
                    // Start of NOKIASC-38809 changes showing NCP_Marketing_Text__c field value only for Community User
                    if(communityFlag){
                        assetList[i].ProductDescription = assetList[i].Product2.NCP_Marketing_Text__c;                   	
                    }else{
                    	assetList[i].ProductDescription= assetList[i].Product2.Description;
                    }
                    // End of NOKIASC-38809 changes
                }
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
        //35156
        component.set("v.assetProductFields", {
            'product' : object && object.Product2?object.Product2:null,
            'productRelease' : object && object.CH_ProductRelease__r?object.CH_ProductRelease__r:null,
            'productVariant' : object && object.CH_ProductVariant__r?object.CH_ProductVariant__r:null,
            'solution' : object && object.CH_Solution__r?object.CH_Solution__r:null
        });
        //to collapse section
        component.set("v.activeSectionName", null);
        component.set('v.productDescription', component.get('v.showDescription') && object && object.ProductDescription?object.ProductDescription:'');
        if(selectInTable && object)component.find("assetTable").setSelectedRows(new Array(object.Id));
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