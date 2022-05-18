({
    //Spinner Code Start
    showWaiting:function(cmp){
        cmp.set("v.IsSpinner",true);
    },
    hideWaiting:function(cmp){
        cmp.set("v.IsSpinner",false);  
    },
    //Spinner Code Ends
    doInit : function(component, event, helper) {        
        if(component.get("v.selectedAssetCheckUpfrontNEA")){	
            component.set("v.Assets", component.get("v.assetsUpfrontNEASelection"));	
        }       
    },
	componentRefreshFromMainComponent : function(component, event, helper) {		
        component.set("v.Assets", null);		
        component.set("v.clis", null);		
        component.set("v.searchKeyword", null);		
        component.set("v.selectedContraId",null);		
    },
    componentRefresh : function(component, event, helper) {
           
        component.set("v.selectedclis", null);
        component.set("v.Assets", null);
        component.set("v.showAssets", false);
        component.set("v.contractAssetStage", true);
        //component.set("v.serviceType", null);
		component.set("v.contractAssetStageButton", true);
        component.set("v.selectedContraId", null);
        component.set("v.searchKeyword", null);
        component.set("v.clis", null);
        component.set("v.selectedclis", null);
        component.set("v.showClis", false);
        component.set("v.displayAssets", false);
        component.set("v.selectedAssets", null);
        component.set("v.selectedContractLineItems", null);
        component.set("v.addPartCheckAsset", true); 
        component.set("v.addPartPreviousDisable", true); 
        component.set("v.CLISFilterText", null); 
        component.set("v.assetFilterText", null); 
		component.set("v.enableSelectNEA" , true);
    },
	clearFiltersSTage2:function(component, event, helper){
        component.set("v.assetFilterText", '');
        component.set("v.Assets",component.get("v.AllAssets"));
    },
        
    //get list of contract line items
    search: function(component, event, helper){
		component.set("v.assetFilterText",'');
        component.set("v.CLISFilterText",'');
        console.log('Search in Controller'+component.get("v.contractAssetStage"));        
        helper.getServiceContracts(component, event);       
    },
    processSelectedAsset: function (component, event, helper) {
        var selectedRows = event.getParam('selectedRows'); 
        

        var selAsset;
        var nea;
        if(selectedRows != null && selectedRows != '' && selectedRows != undefined){
             selAsset=JSON.parse(JSON.stringify(selectedRows[0])); 
             nea = selectedRows[0].HWS_ContractLineItem__r.CH_QtyCoveredNetworkElementAssets__c ; 
        }
        if (nea == 0) {
            component.set("v.enableSelectNEA" , true);
        }
        else{
            component.set("v.enableSelectNEA" , false);
        }
         component.set("v.selectedAssets", selectedRows);
        var Assets = component.get("v.selectedAssets"); 
        var searchKeyword = component.get("v.searchKeyword"); 
        var searchCriteria = component.get("v.searchCriteria"); 
        var cmpEvent = component.getEvent("HWS_CaseFlowEventPortal");
        var showassets = component.get("v.Assets");
        console.log('all the assets'+JSON.stringify(showassets));
        if(searchCriteria == 'Part Code'){
            console.log('searchCriteria '+searchCriteria);
        cmpEvent.setParams({
            "searchKeyword"  : searchKeyword,
            "showassets"     : showassets,
            "searchCriteria" : searchCriteria,
            "selectedAsset"  : Assets[0],              
            "showSection" : 2
                      
        });
        cmpEvent.fire(); 
        }
    },       
    
    //Method to Filter Assests
    filterAssests_PartCode: function(component, event, helper) {
        var action = component.get("v.AllAssets"),
            AssetFilter = component.get("v.assetFilterText"),
            results = action, regex;
        try {
            regex = new RegExp(AssetFilter, "i");
            // filter checks each row, constructs new array where function returns true
            results = action.filter(
                row => regex.test(row.HWS_Service_Type__c) || 
                regex.test(row.HWS_ContractLeadTimeDuration__c) ||
                regex.test(row.HWS_ContractLeadTimeUnit__c) ||
                regex.test(row.HWS_Service_Contract_Number__c) ||
				regex.test(row.HWS_SpecifiedDeliveryTargetTime__c) ||
                regex.test(row.HWS_High_Level_Product_Name__c) ||
                regex.test(row.HWS_Part_Code__c) ||
                regex.test(row.HWS_Currency__c) ||
                regex.test(row.HWS_ServiceItemCode__c) ||
                regex.test(row.HWS_ServiceItemDescription__c) ||
                regex.test(row.HWS_Price__c) ||
				regex.test(row.CountryName) ||
                regex.test(row.HWS_Product_Name__c)
            );
        } catch(e) {
            // invalid regex, use full list
        }
        component.set("v.Assets", results);
        
    },
    clearSelection : function (component, event, helper) {
		var cli = component.get('v.Assets');
        var neaCountCheck = 0;
        for(var i = 0; i < cli.length; i++){
            var neaCount = cli[i].HWS_ContractLineItem__r.CH_QtyCoveredNetworkElementAssets__c;
            if(neaCount > 0){
                component.set("v.enableSelectNEA" , false);
            }
        }
        component.find("assetTable").set("v.selectedRows", new Array());  
        var cmpEvent = component.getEvent("HWS_CaseFlowEventPortal");            
        cmpEvent.setParams({                       
            "showSection" : 50,
            "selectedAsset" : undefined,
			"enableButton" : 1,
        });
        cmpEvent.fire();
        
    },
    //26091 - To Select Network Element Asset
    selectNEA : function(component, event, helper) {	
        var cmpEvent = component.getEvent("HWS_CaseFlowEventPortal");	
        cmpEvent.setParams({	
            "showSection" : 20	
        });	
        cmpEvent.fire();        
    },
	clearNetworkElementAsset : function(component, event, helper) {	
        component.set("v.Assets",component.get("v.AllAssets"));
        var cmpEvent = component.getEvent("HWS_CaseFlowEventPortal");
        cmpEvent.setParams({	
            "showSection" : 26	
        });	
        cmpEvent.fire(); 
    }
    
})