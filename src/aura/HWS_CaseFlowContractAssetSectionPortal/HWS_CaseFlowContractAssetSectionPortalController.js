({
	getAssets : function(component, event, helper) {
		helper.getSellableItems(component, event, helper);
	},

//Method to Filter Assests
    filterAssets: function(component, event, helper) {
        var action = component.get("v.AllAssets"),
            AssetFilter = component.get("v.assetFilterText"),
            results = action,
            regex;
        try {
            regex = new RegExp(AssetFilter, "i");
            // filter checks each row, constructs new array where function returns true
            results = action.filter(
                row =>
                regex.test(row.HWS_Service_Type__c) ||
                regex.test(row.HWS_ServiceItemCode__c) ||
                regex.test(row.HWS_ServiceItemDescription__c) ||
                regex.test(row.HWS_ContractLeadTimeUnit__c) ||
                regex.test(row.HWS_ContractLeadTimeDuration__c) ||
                regex.test(row.HWS_Service_Contract_Number__c) ||
				regex.test(row.HWS_SpecifiedDeliveryTargetTime__c) ||
                regex.test(row.HWS_High_Level_Product_Name__c) ||
                regex.test(row.HWS_Part_Code__c) ||
                regex.test(row.HWS_Currency__c) ||
                regex.test(row.HWS_Price__c) ||
                regex.test(row.HWS_Product_Name__c)
            );
        } catch (e) {
            // invalid regex, use full list
        }
        component.set("v.Assets", results);
    }, 
    
    processSelectedAsset: function (component, event, helper) {
        var selectedRows = event.getParam('selectedRows');  
        component.set("v.selectedAssets", selectedRows);
        var Assets = component.get("v.selectedAssets"); 
        var searchKeyword = component.get("v.searchKeyword"); 
        var searchCriteria = component.get("v.searchCriteria"); 
        var cmpEvent = component.getEvent("HWS_CaseFlowEventPortal");
        var showassets = component.get("v.Assets");
        cmpEvent.setParams({
            "searchKeyword"  : searchKeyword,
            "showassets"     : showassets,
            "searchCriteria" : searchCriteria,
            "selectedAssetForContractNumber"  : Assets[0],              
            "showSection" : 25
        });
        cmpEvent.fire(); 
    },
    
    clearSelection : function (component, event, helper) {
                            component.find("assetTable1").set("v.selectedRows", new Array());  
        var cmpEvent = component.getEvent("HWS_CaseFlowEventPortal");            
        cmpEvent.setParams({                       
            "showSection" : 50,
            "selectedAssetForContractNumber" : undefined,
			"enableButton" : 5,
        });
        cmpEvent.fire();
	},
		componentRefresh : function(component, event, helper) {          
        component.set("v.Assets", null);
        component.set("v.selectedAssets", null);             
        component.set("v.assetFilterText", null);       
    }
	
	
})