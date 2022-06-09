({    
    getServiceContracts: function(component, event, helper){ 
        var searchValue = component.get("v.searchKeyword");
        var getAccounts = component.get("v.selectedAccount"); 
        var searchCriteria =component.get("v.searchCriteria");
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
            if(searchCriteria=='Contract Number'){                 
               // console.log('Selected Contract Number'); NOKIASC-36296
                component.set("v.showClis",true);
                component.set("v.showAssets",false);
                component.set('v.CLIColumns', [
                    {label: 'Contract Number', fieldName: 'HWS_ServiceContractNumber__c', type: 'text'},
                    {label: 'NEA Count', fieldName: 'CoveredNetworkElementCount', type: 'text'},
                    {label: 'Contract Description', fieldName: 'HWS_ServiceContractName__c', type: 'text'},
                    {label: 'Service Type', fieldName: 'CH_ServiceType__c', type: 'text'}
                ]);
                //3697
                var action = component.get('c.getServiceContracts');
                action.setParams({
                    selectedAccount : getAccounts,
                    searchString : searchValue,
                    serviceType : component.get("v.serviceType"),
                    selectedcontractNumber : component.get("v.contractNumber"),
                    contactId : component.get("v.recordId")
                });
                action.setCallback(this, $A.getCallback(function (response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        component.set("v.IsSpinner", false);
                        var mapContact = new Map();
                        mapContact = response.getReturnValue();
                       // console.log('mapContact '+JSON.stringify(mapContact)); NOKIASC-36296                       
                        if(!Object.keys(mapContact).includes("No Error")){
                            component.set("v.clis",null);
                            component.set("v.ALLclis", null);
                            //component.set("v.showStep6",false);
                            component.set("v.selectedclis",null);
                            if(Object.keys(mapContact).includes("Error Message1")){
                                this.showToast('error','Error Message',$A.get("$Label.c.HWS_Case_flow_contract_inactive_error_message"));
                            }
                            else if(Object.keys(mapContact).includes("Error Message2")){
                                this.showToast('error','Error Message',$A.get("$Label.c.HWS_Case_flow_incorrect_part_code_error_message"));
                            }
                                else if(Object.keys(mapContact).includes("Error Message3")){
                                    
                                    this.showToast('error','Error Message',$A.get("$Label.c.HWS_Case_flow_add_part_error_message"));
                                }
                        }else{                            
                            component.set("v.clis",null);
                            component.set("v.ALLclis", null);
                            component.set("v.showStep6",true);
                            component.set("v.selectedclis",null);
                            component.set("v.clis", mapContact["No Error"]);
                            component.set("v.ALLclis", mapContact["No Error"]);
                            component.set("v.showAssets",false);
                            component.set("v.contractAssetStage",true);
                            component.set("v.contractAssetStage2",false);
                            component.set("v.addPartCheckAsset",false);
                            var clis = mapContact["No Error"];
                            var QuantityNEA;
                            for (var i = 0; i < clis.length; i++) {
                                var row = clis[i];
                                var v = row.CH_QtyCoveredNetworkElementAssets__c;
                                row.CoveredNetworkElementCount = v.toString();
                                //console.log('CNE Count:'+row.CoveredNetworkElementCount); NOKIASC-36296
                                QuantityNEA = row.CH_QtyCoveredNetworkElementAssets__c;
                    if(QuantityNEA > 0){
                        //console.log('NEAB:' + row.CoveredNetworkElementCount); NOKIASC-36296
                        component.set("v.enableSelectNEA" , false);
                    }
                                
                            }
                            component.set("v.clis", clis);
                            component.set("v.ALLclis", clis);
                        }
                    }
                    var cmpEvent = component.getEvent("HWS_CaseFlowEventPortal");        
                    cmpEvent.setParams({           
                        "searchCriteria" : searchCriteria,
                        "showSection" : 10,	
						"allCLIS" : clis
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