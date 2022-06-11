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
        //component.get("v.selectedAccount"+accountId);
        //var searchKeyword = component.get("v.searchKeyword");
        // NOKIASC-26091 - Added to set CLIS after selecting NEA  
        if(component.get("v.selectedContractCheckUpfrontNEA")){	
            component.set("v.clis",component.get("v.contractsUpfrontNEASelection"));	
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
      
    processSelectedLineItem: function (component, event) {
        var selectedRows = event.getParam('selectedRows');
        var selAsset;
        var nea;
        if(selectedRows != null && selectedRows != '' && selectedRows != undefined){
             selAsset=JSON.parse(JSON.stringify(selectedRows[0])); 
             nea = selectedRows[0].CH_QtyCoveredNetworkElementAssets__c ; 
        }
        if (nea == 0) {
            component.set("v.enableSelectNEA" , true);
        }
        else{
            component.set("v.enableSelectNEA" , false);
        }
        component.set("v.selectedContractLineItems", selectedRows);
        component.set("v.selectedContraId",selectedRows[0].Id); 
        var searchKeyword = component.get("v.searchKeyword"); 
        var searchCriteria = component.get("v.searchCriteria"); 
        var cmpEvent = component.getEvent("HWS_CaseFlowEventPortal");
        if(searchCriteria == 'Contract Number'){
            console.log('searchCriteria '+searchCriteria);
        cmpEvent.setParams({
            "searchKeyword"  : searchKeyword,
            "searchCriteria" : searchCriteria,
            "selectedContractLineItem"  : selectedRows[0],              
            "showSection" : 6
        });
        cmpEvent.fire(); 
        }
    },
    
    filterCLIS: function(component, event, helper) {
        var action = component.get("v.ALLclis"),
            ContractItemFilter = component.get("v.CLISFilterText"),
            results = action, regex;
        try {
            component.set("v.selectedclis", null);
            regex = new RegExp(ContractItemFilter, "i");
            // filter checks each row, constructs new array where function returns true
            results = action.filter(
                row => regex.test(row.CH_ServiceType__c) || 
                regex.test(row.HWS_ServiceContractNumber__c) ||
                regex.test(row.HWS_ServiceContractName__c) 
            );
            //component.set("v.selectedclis", null);                
        } catch(e) {
            // invalid regex, use full list
        }
        component.set("v.clis", results);    
    },
    clearSelection : function (component, event, helper) {
		var cli = component.get('v.clis');
        var neaCountCheck = 0;
        for(var i = 0; i < cli.length; i++){
            var neaCount = cli[i].CH_QtyCoveredNetworkElementAssets__c;
            if(neaCount > 0){
                component.set("v.enableSelectNEA" , false);
            }
        }
        component.find("cliTable").set("v.selectedRows", new Array()); 
        var cmpEvent = component.getEvent("HWS_CaseFlowEventPortal");            
        cmpEvent.setParams({                       
            "showSection" : 50,
            "selectedContractLineItem" : undefined,
			"enableButton" : 2,
        });
        cmpEvent.fire();
        component.getEvent("onrowselection").setParams({
            selectedRows: new Array()
        }).fire();
        
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
        component.set("v.clis",component.get("v.ALLclis"));
        var cmpEvent = component.getEvent("HWS_CaseFlowEventPortal");
        cmpEvent.setParams({	
            "showSection" : 26	
        });	
        cmpEvent.fire(); 
    }
})