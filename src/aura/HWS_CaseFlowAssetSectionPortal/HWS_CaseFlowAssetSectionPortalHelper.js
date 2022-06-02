({    
    getServiceContracts: function(component, event, helper){ 
        var searchValue = component.get("v.searchKeyword");
        var getAccounts = component.get("v.selectedAccount"); 
        var searchCriteria =component.get("v.searchCriteria");
        //console.log('Account Id '+getAccounts); NOKIASC-36296
        if(searchValue==undefined || searchValue=='' || searchValue.length<3){
            this.showToast('Warning','Warning Message','Please enter minimum 3 characters');
            component.set("v.Assets", null);
            component.set("v.AllAssets", null);
            component.set("v.clis",null);
            component.set("v.ALLclis", null);
            component.set("v.selectedAssets",null);
            component.set("v.selectedclis",null);
        }
        else{ 
            component.set("v.IsSpinner", true);
            if(searchCriteria=='Part Code'){
                component.set("v.showClis","false");
                component.set('v.assetColumns', [
		
                    {label: 'Service Type', fieldName: 'HWS_Service_Type__c', type: 'text',"initialWidth": 130},
                    {label: 'Service Item Code', fieldName: 'HWS_ServiceItemCode__c', type: 'text',"initialWidth": 150,hideDefaultActions: true},
                    {label: 'NEA Count', fieldName: 'CoveredNetworkElementCount', type: 'text',"initialWidth": 70,hideDefaultActions: true},
                    {label: 'Country', fieldName: 'CountryName', type: 'text',"initialWidth": 80},
                    {label: 'Service Item Description', fieldName: 'HWS_ServiceItemDescription__c', type: 'text',"initialWidth": 170},
                    {label: 'SLA Value', fieldName: 'HWS_ContractLeadTimeDuration__c', type: 'text',"initialWidth": 80,hideDefaultActions: true},
                    {label: 'SLA Unit', fieldName: 'HWS_ContractLeadTimeUnit__c', type: 'text',"initialWidth": 100},
                    {label: 'Contract Number', fieldName: 'HWS_Service_Contract_Number__c', type: 'text',"initialWidth": 130},
                    {label: 'Hour of the day', fieldName: 'HWS_SpecifiedDeliveryTargetTime__c', type: 'text',"initialWidth": 110},
                    //HWST-3669 - added High Level Product Name column
                    {label: 'Product Name', fieldName: 'HWS_High_Level_Product_Name__c', type: 'text',"initialWidth": 120},
                    {label: 'Part Code', fieldName: 'HWS_Part_Code__c', type: 'text',"initialWidth": 155,hideDefaultActions: true},
					//NOKIASC-36280
                    {label: 'Currency', fieldName: 'HWSCurrency', type: 'text',"initialWidth": 105},
					{label: 'Price', fieldName: 'HWSPrice', type: 'text',"initialWidth": 80},
                    {label: 'Description', fieldName: 'HWS_Product_Name__c', type: 'text',"initialWidth": 150}
                ]);            
                var action = component.get('c.getContractlineItems');                
                //3697
                action.setParams({
                    accountId : getAccounts,                    
                    searchValue : searchValue,
                    serviceType : component.get("v.serviceType"),
                    contractNumber : component.get("v.contractNumber"),
                    contactId : component.get("v.recordId"),
                    //NOKIASC-27010 - Passing country to restrict consequent part items based on the country as well -- Prateek
                    country : component.get("v.country")
                    //NOKIASC-27010 ends
                });            
                action.setCallback(this, $A.getCallback(function (response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {	
                        component.set("v.IsSpinner", false);
                        var mapContact = new Map();
                        mapContact = response.getReturnValue();
                        //console.log('#### return value'+JSON.stringify(mapContact));  NOKIASC-36296
						//34072
                        //if(!Object.keys(mapContact).includes("No Error")){
						if(!(Object.keys(mapContact).includes("No Error") || Object.keys(mapContact).includes("Kit code search"))){
                            component.set("v.Assets", null);
                            component.set("v.AllAssets", null);
                            component.set("v.selectedAssets",null);
                            if(Object.keys(mapContact).includes("Error Message1")){
                                this.showToast('error','Error Message',$A.get("$Label.c.HWS_Case_flow_incorrect_part_code_error_message"));
                            }
                            else if(Object.keys(mapContact).includes("Error Message2")){
                                this.showToast('error','Error Message',$A.get("$Label.c.HWS_Case_flow_part_code_inactive_error_message"));
                            }
                                else if(Object.keys(mapContact).includes("Error Message3")){
                                    this.showToast('error','Error Message',$A.get("$Label.c.HWS_Case_flow_part_code_not_found_error_message	"));
                                }
                        }else{
							//34072
                            var Assets = mapContact["Kit code search"];
                           
                            //Need disply msg
                            if(Assets == null || Assets =='' || Assets == undefined){
                                Assets = mapContact["No Error"];
                                component.set("v.kitcodesearch",false);
                               
                            }
                            else{
                                component.set("v.kitcodesearch",true);
                            }
                    		//var Assets = mapContact["No Error"];
							var QuantityNEA;
                            for (var i = 0; i < Assets.length; i++) {
                                var row = Assets[i];
                                 if (row.HWS_ContractLineItem__c) {
                                    
                                    var v = row.HWS_ContractLineItem__r.CH_QtyCoveredNetworkElementAssets__c;
                                    
                                    if(v != undefined){
                                    	row.CoveredNetworkElementCount = v.toString();
                                    }
                                    var c = row.HWS_ContractLineItem__r.CH_CountryISOName__c;
                                    if(c != undefined){
                                    	row.CountryName = c.toString();
                                    }
                                    
                                }
								//NOKIASC-36280
                                if(row.HWS_ContractLineItem__r.ServiceContract.HWS_PurchaserType__c == 'Customer via Partner'){
                                    
                                    row.HWSPrice = '';
                                    row.HWSCurrency = '';
                                }
                                else{
                                    row.HWSPrice = row.HWS_Price__c;
                                    row.HWSCurrency = row.HWS_Currency__c;
                                }
                                QuantityNEA = row.HWS_ContractLineItem__r.CH_QtyCoveredNetworkElementAssets__c;
                                if(QuantityNEA != undefined && QuantityNEA > 0){
                                   // console.log('NEAB:' + row.CoveredNetworkElementCount); NOKIASC-36296
                                    component.set("v.enableSelectNEA" , false);
                                }
                            }
                            component.set("v.Assets", null);		
                            component.set("v.AllAssets", null);
                            //34072
                			if(mapContact["Kit code search"] !=null && mapContact["Kit code search"] !='' && mapContact["Kit code search"] != undefined){
                                component.set("v.Assets", mapContact["Kit code search"]);
                                component.set("v.AllAssets", mapContact["Kit code search"]);
                            }
                            else{
                                component.set("v.Assets", mapContact["No Error"]);
                                component.set("v.AllAssets", mapContact["No Error"]);
                            }
							component.set("v.showAssets",true);
                            component.set("v.contractAssetStage",false);
                            component.set("v.contractAssetStage2",false);
                            component.set("v.addPartCheckAsset",false);
                        }
                    } 
                    var cmpEvent = component.getEvent("HWS_CaseFlowEventPortal");	
                    cmpEvent.setParams({	
                        "showassets" : component.get("v.Assets"),	
                        "showSection" : 23	
                    });	
                    cmpEvent.fire();
                }));
                $A.enqueueAction(action); 
            }
        }
    },
    
    //Helper method to display the error toast message
    showToast : function(type,title,message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : title,
            message: message,
            duration:'10000',
            key: 'info_alt',
            type: type,
            mode: 'dismissible'
        });
        toastEvent.fire(); 
    }
    
})