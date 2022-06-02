({
   
    //NOKIASC-32950:get all the network element asset 
    getNetworkElementAssets : function(component, accountId, cliId) {
        component.set("v.IsSpinner", true);
        
        var assets = component.get("v.allAssets");    
        var searchCrit = component.get("v.searchCriteria");
        var CLIIDS = [];
        if(assets != null && searchCrit == 'Part Code'){
            for(var i=0;i<assets.length;i++){
                CLIIDS.push(assets[i].HWS_ContractLineItem__c);
            }
        }
        var clitems = component.get("v.allCLIS");	
        if(clitems != null && searchCrit == 'Contract Number'){	
            for(var i=0;i<clitems.length;i++){	
                CLIIDS.push(clitems[i].Id);	
            }	
        }
        var action =component.get("c.getNEA");  
        action.setParams({
            accId : accountId,
            cliId : cliId,
            cliIdList : CLIIDS,            
            "recordLimit": component.get("v.initialRows"),
            "recordOffset": component.get("v.rowNumberOffset"),
            searchText:component.get("v.NEAFilterText")
        });
        action.setCallback(this, function(response) {                        
            var state = response.getState();
            if (state === "SUCCESS" ) {
                component.set("v.currentCount", component.get("v.initialRows"));
                component.set("v.IsSpinner", false);
                var neaList = response.getReturnValue(); 
                component.set("v.allNetElemAssets",neaList);
                component.set("v.totalNumberOfRows", neaList.networkEleAssests.length);
                //calling method for initialize data into into datatable
                var neaAssetList=this.InitializeNEAData(component,neaList.networkEleAssests,(neaList.networkEleAssests.length>component.get("v.initialRows"))?component.get("v.initialRows"):neaList.networkEleAssests.length,component.get("v.rowNumberOffset"));
                if(component.get('v.clearNEACheck')){
                   // console.log('NEA CLEAERES'); NOKIASC-36296
                    component.set('v.netElemAssets',null);
                    component.set("v.selectedNEA",null);
                }
                component.set('v.clearNEACheck',false);
                component.set('v.netElemAssets',neaAssetList);
                component.set('v.showAllNEA',neaAssetList); 
                
            }
        });
        $A.enqueueAction(action);
    },
    //NOKIASC-32950:Initialize data into into datatable
    InitializeNEAData : function(component,neaList,limit,offset){
        var tempNEAList=[];
        for(var i = offset; i < limit; i++) {
            var obj = {}; 
            obj['Id'] =neaList[i].Id;
            obj['Name'] =neaList[i].Name;
            obj['CH_NetworkElementAsset__c'] =neaList[i].Id;            
            obj['CH_NetworkElementID__c']= neaList[i].CH_NetworkElementID__c;
            obj['AssetName']= neaList[i].Name;
            obj['Address']  = neaList[i].Address__r?neaList[i].Address__r.CH_AddressDetails__c :'N/A';
            obj['ProductName']    = neaList[i].Product2?neaList[i].Product2.Name :'';
            obj['SolutionName']   = typeof(neaList[i].CH_Solution__r) != 'undefined'?neaList[i].CH_Solution__r.Name :'';
            obj['ProductVariant']  = typeof(neaList[i].CH_ProductVariant__r) != 'undefined'?neaList[i].CH_ProductVariant__r.Name :'';
            obj['ProductRelease']  = typeof(neaList[i].CH_ProductRelease__r) != 'undefined'?neaList[i].CH_ProductRelease__r.Name :'';
            obj['CH_CountryISOName__c']  = typeof(neaList[i].CH_CountryISOName__c) != 'undefined'?neaList[i].CH_CountryISOName__c:'';
            obj['CH_LabEnvironment__c']   = typeof(neaList[i].CH_LabEnvironment__c) != 'undefined'?neaList[i].CH_LabEnvironment__c:'';
            obj['CH_ContractLineItem__c'] = neaList[i].CH_ContractLineItem__c;
            if(typeof(neaList[i].Network_Element_Assets__r) != 'undefined'){
                var cli = [];
                for(var j = 0;j < neaList[i].Network_Element_Assets__r.length; j++){                    
                    cli.push(neaList[i].Network_Element_Assets__r[j].CH_ContractLineItem__c);
                    obj['CH_ContractLineItem__c'] = cli;                       
                }
            }
            tempNEAList.push(obj); 
			var selNEA = component.get("v.selectedNEA");           
			if(selNEA != null && selNEA != '' && selNEA != undefined){
				if(component.get("v.selectedNEA").length>0 && neaList[i].Id==component.get("v.selectedNEA")[0].Id){ 
					var allSelectedRows=[];
					var selectedRows= component.get("v.selectedNEA");
					selectedRows.forEach(function(row) {
						allSelectedRows.push(row.Id);                    
					});
					component.find("neaTable").set("v.selectedRows",allSelectedRows); 
				}
			}
        }
        return tempNEAList;                
    },
    //NOKIASC-32950:Refresh compomnent when calling from init and filter method
    componentRefresh : function(component, event, helper) {
        component.set("v.currentCount",0);
        component.set("v.netElemAssets", []);        
        component.set('v.selectedNEA', []);             
        component.set('v.initialRows',50);
        component.set('v.rowNumberOffset',0);
        component.set('v.rowsToLoad',50);         
        component.set('v.enableInfiniteLoading', true);
        component.set('v.loadMoreStatus', 'Please scroll down to load more data');
    },   
})