({
    doInit: function(component, event, helper) {  
        component.set('v.VersionItemColumns', [
            {label: 'Part Revision', fieldName: 'HWS_Version_Code__c', type: 'text'},
            {label: 'Part Revision Description', fieldName: 'HWS_Product_Name__c', type: 'text'},
			{label: 'CLEI Code', fieldName: 'CLEI__c', type: 'text'},
            {label: 'Comcode', fieldName: 'Comcode__c', type: 'text'},
        ]);
            var rows = component.get("v.assetRec");
            if(rows!=null && rows!='' && rows!=undefined){
            var selectedAsset = component.get("v.assetRec");
			var searchCode = component.get("v.searchKeyword");
            var searchCriteria = component.get("v.searchCriteria");
            if(searchCriteria == 'Contract Number'){
                searchCode = null;                
            }
            console.log('Asset in versionitem portal '+JSON.stringify(selectedAsset));            
            var action = component.get('c.getVersionItems');
            action.setParams({
            selectedAsset : selectedAsset[0],
			searchValue : searchCode
                      });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.versionItems", response.getReturnValue());
                component.set("v.AllversionItems", response.getReturnValue());
				var versionItems = component.get("v.versionItems");
                if(selectedAsset[0].HWS_Service_Type__c == 'Spare Part Sales'){
                    var dTable = component.find("vItems");
                    var selectedAcc = dTable.getSelectedRows();
                    var selectedAcc = component.get("v.AllversionItems");
                    if (typeof selectedAcc != 'undefined' && selectedAcc) {
                        var selectedRowsIds = [];
                        for(var i=0;i<selectedAcc.length;i++){
                            selectedRowsIds.push(selectedAcc[i].Id);  
                        }         
                        var dTable = component.find("vItems");
                        dTable.set("v.selectedRows", selectedRowsIds);
                    }
                    var versionItemsAll = component.get("v.AllversionItems");
                    var cmpEvent = component.getEvent("HWS_CaseFlowEventPortal");
					cmpEvent.setParams({
                        "selectedVersion" : versionItems[0],
                        "showSection" : 3
                    });
                    cmpEvent.fire();
					if((versionItems!=null && versionItems!='' && versionItems!=undefined) && versionItems.length === 1){
                    cmpEvent.setParams({
                        "selectedVersion" : versionItems[0],
                        "showSection" : 3
                    });
                    cmpEvent.fire();
					}
                }
				else{
					//Start HWST-4191
					var cmpEvent = component.getEvent("HWS_CaseFlowEventPortal");
                    if((versionItems!=null && versionItems!='' && versionItems!=undefined) && versionItems.length === 1){
                        var dTable = component.find("vItems");
                        var selectedAcc = dTable.getSelectedRows();
                        var selectedAcc = component.get("v.AllversionItems");                    
                        var selectedRowsIds = [];
                        component.set("v.selectedVersions", selectedAcc[0]);
                        component.set("v.newChildCase.HWS_Stockable_Product__c", selectedAcc[0].Id);
                        selectedRowsIds.push(selectedAcc[0].Id);   
                        var dTable = component.find("vItems");                        
                        dTable.set("v.selectedRows", selectedRowsIds);
                       var cmpEvent = component.getEvent("HWS_CaseFlowEventPortal");
                        cmpEvent.setParams({
                            "selectedVersion" : versionItems[0],
                            "showSection" : 3
                        });
                        cmpEvent.fire();
                    }
                    //End HWST-4191
					//start HWST-4189	
					var regExpr = /[^a-zA-Z0-9]/g;					
					var captureSearchVal = component.get("v.searchKeyword").toUpperCase();
                    var searchVal = component.get("v.searchKeyword").replace(regExpr, '').toUpperCase();
                    var sfdcPartCode = selectedAsset[0].HWS_Part_Code__c;
					var partCod = null;
					if(sfdcPartCode != null && sfdcPartCode != undefined){
						partCod = sfdcPartCode.replace(regExpr, '').toUpperCase();
					}
					if(searchVal != null && partCod != null && searchVal != undefined && partCod != undefined && searchVal.length > partCod.length){					
						var partRev = searchVal.replace(partCod,'');
                        //HWS-4187
                        var userPartcode = '';
                        var exactPartRev = null;
						if(sfdcPartCode != null && sfdcPartCode != undefined){
							exactPartRev = captureSearchVal.replace(sfdcPartCode.toUpperCase(),'');
						}
						
						var dTable = component.find("vItems");
						//var selectedAcc = dTable.getSelectedRows();
						var selectedAcc = component.get("v.AllversionItems");                    
						var selectedRowsIds = [];
						var viId = '';
                        var selectedVersion = selectedAcc[0];                     
						if (selectedAcc!= null && selectedAcc!= '' && selectedAcc != undefined && selectedAcc) { 
							var isExist = false;
							for(var i=0;i<selectedAcc.length;i++){
								if(selectedAcc[i].HWS_Version_Code__c.toUpperCase() === exactPartRev ){								
									viId = selectedAcc[i].Id;
									selectedVersion = selectedAcc[i];
									userPartcode = null;
									
									isExist = true;
								}
								if(selectedAcc[i].HWS_Version_Code__c.toUpperCase() === captureSearchVal){
									viId = selectedAcc[i].Id;
									userPartcode = null;
									selectedVersion = selectedAcc[i];									
									isExist = true;
								}
                                if(selectedAcc[i].HWS_Part_Code_Part_Revision__c.toUpperCase() === searchVal ){
									viId = selectedAcc[i].Id;
									selectedVersion = selectedAcc[i];
									userPartcode = null;									
									isExist = true;
								}
								else if(isExist ===false && selectedAcc[i].HWS_Version_Code__c.toUpperCase() === 'ANY' && searchVal.includes(partCod)){
                                    if (exactPartRev.indexOf("-") == 0 || exactPartRev.indexOf(".") == 0 || exactPartRev.indexOf(":") == 0)
									{									  
									   exactPartRev = exactPartRev.slice(1);
									   if(exactPartRev.indexOf("-") == 0){
                                             console.log('--final---->'+exactPartRev);
                                            exactPartRev = exactPartRev.slice(1);
                                        }
									}                                    
									userPartcode = exactPartRev;
                                    viId = selectedAcc[i].Id;
									selectedVersion = selectedAcc[i];
								}
                                
							} 							
							selectedRowsIds.push(viId);
                            component.set("v.selectedVersionItem", selectedVersion);
							var dTable = component.find("vItems");							
							dTable.set("v.selectedRows", selectedRowsIds);                           
							var cmpEvent = component.getEvent("HWS_CaseFlowEventPortal");
                            cmpEvent.setParams({
								"selectedVersion" : selectedVersion,
                                "customerPartRev" : userPartcode,
								"showSection" : 3
							});
							cmpEvent.fire();//Uncommented based on NOKIASC-36532
						}						
					}
					if(searchVal != null && partCod != null && searchVal != undefined && partCod != undefined && searchVal === partCod){
						var dTable = component.find("vItems");
						//var selectedAcc = dTable.getSelectedRows();
						var selectedAcc = component.get("v.AllversionItems");                    
						var selectedRowsIds = [];
						var viId = null;
						 var selectedVersion = selectedAcc[0]; 
						if (selectedAcc!= null && selectedAcc!= '' && selectedAcc != undefined && selectedAcc) {					
							for(var i=0;i<selectedAcc.length;i++){
								
								if(selectedAcc[i].HWS_Version_Code__c.toUpperCase() === captureSearchVal){
									viId = selectedAcc[i].Id;
									selectedVersion = selectedAcc[i];
																	
								}
                                if(selectedAcc[i].HWS_Part_Code_Part_Revision__c.toUpperCase() === searchVal ){
									viId = selectedAcc[i].Id;
									selectedVersion = selectedAcc[i];
								}
							} 
							if(viId != null){
								selectedRowsIds.push(viId);
								component.set("v.selectedVersionItem", selectedVersion);
								var dTable = component.find("vItems");							
								dTable.set("v.selectedRows", selectedRowsIds);
								var cmpEvent = component.getEvent("HWS_CaseFlowEventPortal");
								cmpEvent.setParams({
									"selectedVersion" : selectedVersion,									
									"showSection" : 3
								});
								cmpEvent.fire();//Uncommented based on NOKIASC-36532
							}							
						}	
					}
					//End HWST-4189 .
					//cmpEvent.fire();
				}
                console.log('Version Items '+component.get("v.versionItems"));
            }
        }));
        $A.enqueueAction(action);
    }
},
 componentRefreshVersionItem : function(component, event, helper) {           
    component.set("v.selectedVersionItem", null);
    component.set("v.versionItems", null);
    //component.set("v.assetRec", null);        
    component.set("v.VersionItemFilterText", null);        
},
 componentRefresh : function(component, event, helper) {           
    component.set("v.selectedVersionItem", null);
    component.set("v.versionItems", null);
    component.set("v.assetRec", null);        
    component.set("v.VersionItemFilterText", null);        
},
clearFiltersSTage3:function(component, event, helper){
        component.set("v.VersionItemFilterText", '');
        component.set("v.versionItems",component.get("v.AllversionItems"));
    },
    // store selected contract lines in a variable when it is selected
    processSelectedVersion: function (component, event) {
        var selectedRows = event.getParam('selectedRows');       
        component.set("v.selectedVersionItem", selectedRows); 
        var CheckVersion = component.get("v.versionItems");
        var versionItems = component.get("v.selectedVersionItem");
        var cmpEvent = component.getEvent("HWS_CaseFlowEventPortal");
        cmpEvent.setParams({
            "selectedVersion" : versionItems[0],
            "showSection" : 3
        });
        cmpEvent.fire();   
    },
        /*setSelectedVersionItem: function (component, event) {
            var versionItems = component.get("v.selectedVersionItem");          
            console.log('version items '+JSON.stringify(versionItems));
            var cmpEvent = component.getEvent("HWS_CaseFlowEventPortal");
            cmpEvent.setParams({
                "selectedVersion" : versionItems[0],
                "showSection" : 3
            });
            cmpEvent.fire(); 
        },
            gotoAccountSection: function (component, event) {
                //var versionItems = component.get("v.selectedVersionItem");
                var cmpEvent = component.getEvent("HWS_CaseFlowEventPortal");
                cmpEvent.setParams({
                    "selectedVersion" : versionItems[0],
                    "backtoasset" :true,
                    "showSection" : 1
                });
                cmpEvent.fire(); 
            },
                gotoAssetSection: function (component, event) {          
                    var cmpEvent = component.getEvent("HWS_CaseFlowEventPortal");
                    cmpEvent.setParams({
                        "backtoasset" :true,
                        "showSection" : 11
                    });
                    cmpEvent.fire(); 
                },*/
                    //Method to Filter Version Items
   filterVersionItems: function(component, event, helper) {
       var action = component.get("v.AllversionItems"),
           VersionItemFilter = component.get("v.VersionItemFilterText"),
           results = action, regex;
       try {
           component.set("v.selectedVersions", null);
           regex = new RegExp(VersionItemFilter, "i");
           // filter checks each row, constructs new array where function returns true
           results = action.filter(
               row => regex.test(row.HWS_Product_Name__c) || 
               regex.test(row.HWS_Version_Code__c) ||
               regex.test(row.CLEI__c) ||
               regex.test(row.Comcode__c)
           );
           //component.set("v.selectedVersions", null);                
       } catch(e) {
           // invalid regex, use full list
       }
       component.set("v.versionItems", results);
       
   },
     clearSelection : function (component, event, helper) {
         component.find("vItems").set("v.selectedRows", new Array()); 
         var cmpEvent = component.getEvent("HWS_CaseFlowEventPortal");            
         cmpEvent.setParams({                       
             "showSection" : 50,
             "selectedVersion" : undefined,
			 "enableButton" : 3,
         });
         cmpEvent.fire();
         
     }
})