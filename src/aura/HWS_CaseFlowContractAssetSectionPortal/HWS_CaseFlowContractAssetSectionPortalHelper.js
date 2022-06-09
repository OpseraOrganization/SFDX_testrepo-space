({
	getSellableItems: function(component,event,helper){
        var rows = component.get("v.selectedContractLineItems");     
        component.set('v.selectedContraId',rows[0].Id);
        if(rows!=null && rows!='' && rows!=undefined){
           // console.log('rows in helper inside if '+JSON.stringify(rows)); NOKIASC-36296
            component.set("v.Stage2", "slds-path__item slds-is-complete");
            component.set("v.Stage6", "slds-path__item slds-is-current slds-is-active");
            component.set("v.StageNumber", 6);            
            var selectedRows = component.get("v.selectedContractLineItems");
            component.set('v.assetColumns', [
                {label: 'Service Type', fieldName: 'HWS_Service_Type__c', type: 'text'},
                {label: 'Service Item Code', fieldName: 'HWS_ServiceItemCode__c', type: 'text',"initialWidth": 200},
                {label: 'Service Item Description', fieldName: 'HWS_ServiceItemDescription__c', type: 'text',"initialWidth": 200},
                {label: 'SLA Value', fieldName: 'HWS_ContractLeadTimeDuration__c', type: 'text'},
                {label: 'SLA Unit', fieldName: 'HWS_ContractLeadTimeUnit__c', type: 'text'},
                {label: 'Contract Number', fieldName: 'HWS_Service_Contract_Number__c', type: 'text'},
				{label: 'Hour of the day', fieldName: 'HWS_SpecifiedDeliveryTargetTime__c', type: 'text',"initialWidth": 150},
                    //HWST-3669 - added High Level Product Name column
		        {label: 'Product Name', fieldName: 'HWS_High_Level_Product_Name__c', type: 'text',"initialWidth": 310},
                {label: 'Part Code', fieldName: 'HWS_Part_Code__c', type: 'text'},
                {label: 'Currency', fieldName: 'HWS_Currency__c', type: 'text',"initialWidth": 105},
                {label: 'Price', fieldName: 'HWS_Price__c', type: 'text',"initialWidth": 80},
                {label: 'Description', fieldName: 'HWS_Product_Name__c', type: 'text'}
            ]);
            var action = component.get('c.getCLIOfServiceContracts');
            action.setParams({
                selectedServiceContracts : component.get("v.selectedContraId")
            });
            action.setCallback(this, $A.getCallback(function (response) {                
                var state = response.getState();
                if (state === "SUCCESS"){
                    var assets = response.getReturnValue();
                    component.set("v.Assets",assets); 
                    component.set("v.AllAssets",assets); 
					var cmpEvent = component.getEvent("HWS_CaseFlowEventPortal");	
                    cmpEvent.setParams({	
                        "showassets" : component.get("v.Assets"),	
                        "showSection" : 27	
                    });	
                    cmpEvent.fire();
                } 
            }));
            $A.enqueueAction(action);
            var Assets= component.get("v.selectedAssets");
            var selCli=JSON.parse(JSON.stringify(rows[0]));
            var oldCli = component.get("v.oldSelectedclis");
            var showClis = component.get("v.showClis");
            if(selCli.Id==oldCli){
                if(Assets!=null && Assets!='' && Assets!=undefined){
                    //var dTable = component.find("assetTable");
                    //var selectedAcc = dTable.getSelectedRows();
                    var selectedAcc = component.get("v.selectedAssets");
                    if (typeof selectedAcc != 'undefined' && selectedAcc) {
                        var selectedRowsIds = [];
                        for(var i=0;i<selectedAcc.length;i++){
                            selectedRowsIds.push(selectedAcc[i].Id);  
                        }         
                        var dTable = component.find("assetTable");
                        dTable.set("v.selectedRows", selectedRowsIds);
                    }
                }                 
            }else{
                component.set("v.Assets", null);
                component.set("v.AllAssets", null);
                component.set("v.selectedAssets", null);
                component.set("v.versionItems", null);
                component.set("v.selectedVersions", null);
            }
			
            
        }else{
            this.showToast('error','Error Message','Please select Service Contract before proceeding'); 
        }
    }
})