({
    //Spinner Code Start
    showWaiting:function(cmp){
        cmp.set("v.IsSpinner",true);
    },
    hideWaiting:function(cmp){
        cmp.set("v.IsSpinner",false);  
    },
    //Spinner Code Ends
    doInit: function(component, event, helper) { 
        component.set("v.NEAFilterText",'');
        helper.componentRefresh(component, event, helper) ;
        component.set('v.neaColumns', [
            {label: 'Network Element ID', fieldName: 'CH_NetworkElementID__c', sortable: 'true', searchable: 'true', type: 'text'},
            {label: 'Asset Name', fieldName: 'AssetName', sortable: 'true', searchable: 'true', type: 'text'},
            {label: 'Product', fieldName: 'ProductName', sortable: 'true', searchable: 'true', type: 'text'},
            {label: 'Solution', fieldName: 'SolutionName', sortable: 'true', searchable: 'true', type: 'text'},
            {label: 'Product Variant', fieldName: 'ProductVariant', sortable: 'true', searchable: 'true', type: 'text'},
            {label: 'Product Release', fieldName: 'ProductRelease', sortable: 'true', searchable: 'true', type: 'text'},
            {label: 'Address', fieldName: 'Address', sortable: 'true', searchable: 'true', type: 'text'},
            {label: 'Lab', fieldName: 'CH_LabEnvironment__c', sortable: 'true',searchable: 'true', type: 'boolean'},        
            {label: 'Country', fieldName: 'CH_CountryISOName__c', searchable: 'true', type: 'hidden'}
        ]);
        var selAccount = component.get('v.selectedAccount');
        var selectedAsset = component.get("v.assetRec");
        
        var selectedCLI = component.get("v.selectedContractLineItem");
        var cliId = null;
        if(selectedAsset != undefined && selectedAsset != '' && selectedAsset != null){
            cliId = selectedAsset[0].HWS_ContractLineItem__c;            
        }  
        if(selectedCLI != undefined && selectedCLI != '' && selectedCLI != null){
            cliId = selectedCLI[0].Id;
        }         
        helper.getNetworkElementAssets(component,selAccount,cliId);
    },
    
    processSelectedNEA : function(component, event, helper) {
        var selectedNEA = event.getParam('selectedRows');
        component.set('v.selectedNEA',selectedNEA);
        var cmpEvent = component.getEvent("HWS_CaseFlowEventPortal");
        var selAsset = component.get("v.assetRec");
        var assets = component.get("v.allAssets");	
        var selCLI = component.get("v.selectedContractLineItem");	
        var clis = component.get("v.allCLIS");	
        var selAssetCheck = false;	
        var selContractCheck = false;	
        var searchCrit = component.get("v.searchCriteria");	
        var CLIID = [];	
        for(var j = 0;j < selectedNEA[0].CH_ContractLineItem__c.length; j++){
            CLIID.push(
                selectedNEA[0].CH_ContractLineItem__c[j]
            );
        }        
        if(searchCrit == 'Part Code' && (selAsset == '' || selAsset == null || selAsset == undefined)){	
            selAssetCheck = true;	            
            var assets1 = [];	
            if(assets != null){	
                for(var i=0;i<assets.length;i++){	
                    //assetRelatedCLIIDs.push(assets[i].HWS_ContractLineItem__c);	
                    if(assets[i].CoveredNetworkElementCount == '0'){	
                        CLIID.push(assets[i].HWS_ContractLineItem__c);	
                    }	
                    //assetMap[assets[i].HWS_ContractLineItem__c] = assets[i];	
                }	
            }	
            for(var i=0;i<CLIID.length;i++){	
                var result = assets.filter(item => item.HWS_ContractLineItem__c.indexOf(CLIID[i]) !== -1);
                    result.forEach(function(row) {
                        var rowDataIndex=assets1.map(function(e) { return e.Id; }).indexOf(row.Id);
                        if(rowDataIndex===-1){
                            assets1.push(row);
                            //assets1=assets1.concat(row);
                        }
                    })			
            }	
            component.set("v.Assets",assets1);	
        }	
        if(searchCrit == 'Contract Number' && (selCLI == '' || selCLI == null || selCLI == undefined)){	
            selContractCheck = true;	            
            var clis1 = [];	
            if(clis != null){	
                for(var i=0;i<clis.length;i++){	
                    //cliIdList.push(clis[i].Id);	
                    if(clis[i].CoveredNetworkElementCount == '0'){	
                        CLIID.push(clis[i].Id);	
                    }	
                    //cliMap[clis[i].Id] = clis[i];	
                }	
            }	
            for(var i=0;i<CLIID.length;i++){	
                var result = clis.filter(item => item.Id.indexOf(CLIID[i]) !== -1);
                    result.forEach(function(row) {
                        var rowDataIndex=clis1.map(function(e) { return e.Id; }).indexOf(row.Id);
                        if(rowDataIndex===-1){
                            clis1.push(row);
                            //assets1=assets1.concat(row);
                        }
                    }) 	
            }	
            component.set("v.clis",clis1);	
        }             
        cmpEvent.setParams({            
            "showSection" : 8,
            "selectedNEA" : selectedNEA[0],   
            "selectedAssetCheck" : selAssetCheck,	
            "showassets" : assets1,	
            "selectedCLICheck" : selContractCheck,	
            "allCLIS" : clis1
        });
        cmpEvent.fire(); 
    },
    clearSelection : function (component, event, helper) {
        component.find("neaTable").set("v.selectedRows", new Array());         
        var cmpEvent = component.getEvent("HWS_CaseFlowEventPortal");            
        cmpEvent.setParams({                       
            "showSection" : 50,
            "selectedNEA" : undefined,
            "enableButton" : 4,
        });
        cmpEvent.fire();
        component.getEvent("onrowselection").setParams({
            selectedRows: new Array()
        }).fire();
        
    },
    filterNEA: function(component, event, helper) {      
        if(event.keyCode === 13  || neaFilterText==''){
            var neaFilterText = component.get("v.NEAFilterText");
            helper.componentRefresh(component, event, helper) ;
            var selAccount = component.get('v.selectedAccount');
            var selectedAsset = component.get("v.assetRec");        
            var selectedCLI = component.get("v.selectedContractLineItem");
            var cliId = null;
            if(selectedAsset != undefined && selectedAsset != '' && selectedAsset != null){
                cliId = selectedAsset[0].HWS_ContractLineItem__c;
            }  
            if(selectedCLI != undefined && selectedCLI != '' && selectedCLI != null){
                cliId = selectedCLI[0].Id;
            }
            helper.getNetworkElementAssets(component,selAccount,cliId);
        } 
        
    },
    componentRefresh : function(component, event, helper) {           
        helper.componentRefresh(component, event, helper) ;
    }, 
    //NOKIASC-32950:Method fire when sroll last to datatable to load more data
    handleLoadMoreNEA: function (component, event, helper) {
        let currentData = component.get('v.netElemAssets');
        if(currentData.length>0){
            event.getSource().set("v.isLoading", true);
            component.set('v.loadMoreStatus', 'Loading....');       
            let recordOffset = component.get("v.currentCount");
            let recordLimit = component.get("v.initialRows");
            if (component.get('v.netElemAssets').length == component.get("v.totalNumberOfRows")) {
                component.set('v.enableInfiniteLoading', false);
                component.set('v.loadMoreStatus', 'No more data to load');
            } else {       
                
                let allNetElemAssets = component.get("v.allNetElemAssets");            
                let neaList=  helper.InitializeNEAData(component,allNetElemAssets.networkEleAssests,(allNetElemAssets.networkEleAssests.length-recordOffset>recordLimit)?recordLimit+recordOffset:allNetElemAssets.networkEleAssests.length,recordOffset);
                let newData = currentData.concat(neaList);
                component.set('v.netElemAssets', newData);
                component.set('v.showAllNEA',newData);
                recordOffset = recordOffset+recordLimit;
                component.set("v.currentCount", recordOffset); 
                component.set('v.loadMoreStatus', 'Please scroll down to load more data');
                if ((component.get('v.netElemAssets').length >= component.get("v.totalNumberOfRows") ) || neaList.length<component.get('v.initialRows')) {
                    component.set('v.enableInfiniteLoading', false);
                    component.set('v.loadMoreStatus', 'No more data to load');
                }
            }                                    
            setTimeout(function(){
                event.getSource().set("v.isLoading", false);
            }, 4000);
        }
    },
    showToolTip : function(component, event, helper) {
        component.set("v.showtooltip" , true);
        
    },
    hideToolTip : function(component, event, helper){
        component.set("v.showtooltip" , false);
    }
    
})