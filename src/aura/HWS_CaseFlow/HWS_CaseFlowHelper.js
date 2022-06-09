({
    showWaiting: function(cmp) {
        cmp.set("v.IsSpinner", true);
    },
    hideWaiting: function(cmp) {
        cmp.set("v.IsSpinner", false);
    },
    clearChild : function(component, event){
        component.set("v.newChildCase",{'sobjectType':'Case',
                                        'HWS_Site_ID__c':'',
                                        'HWS_Replacement_Unit_Serial_Number__c':'',
                                        'HWS_Fault_Reported_By_Name__c':'',
                                        'HWS_Faulty_Serial_Number__c':'',
                                        'HWS_Failure_Occurance__c':'',
                                        'HWS_Failure_Detection__c':'',
                                        'HWS_Site_Information__c':'',
                                        'HWS_Fault_Reported_By_Phone__c':'',
                                        'HWS_Fault_Reported_By_Email__c':'',
                                        'HWS_Customer_Reference_Number__c':'',
                                        'HWS_Failure_Description__c':'',
                                        'HWS_Quantity__c':'',
                                        'HWS_Failure_Detection_Date__c':'',
                                        'HWS_Requested_Delivery_Date_Time__c':null,
                                        'HWS_Planned_Delivery_Date__c':null,
                                        'HWS_Failure_Description_Server_ID__c':''});
        //component.set("v.PartCode",'');
		component.set("v.isserialNumberUnknown", false);
        component.set("v.CustPartrevison",'');
		component.set("v.selectedNEA", []);
    },
    clearParent : function(component, event){
        component.set("v.newParentCase",{'sobjectType':'Case',
                                         'HWS_Site_ID__c':'',
                                         'HWS_Replacement_Unit_Serial_Number__c':'',
                                         'HWS_Fault_Reported_By_Name__c':'',
                                         'HWS_Faulty_Serial_Number__c':'',
                                         'HWS_Communication_Contact__c':'',
                                         'Hws_Ship_to_Party_Address__c':'',
                                         'HWS_Site_Information__c':'',
                                         'HWS_Fault_Reported_By_Phone__c':'',
                                         'HWS_Fault_Reported_By_Email__c':'',
                                         'HWS_Customer_Reference_Number__c':'',
                                         'HWS_Failure_Description__c':'',
                                         'HWS_ShipmentRecipientEmailId__c':'',
                                         'HWS_Failure_Description_Server_ID__c':''});
        component.set('v.ShiptopartyAddress','');
        component.set('v.communicationContact','');
    },
    getFailureOccurrencePickListValues : function(component, event) {
        
        var action = component.get("c.getPickListValues1");
        action.setParams({ obj:"Case",str:"HWS_Failure_Occurance__c"});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var stringItems = response.getReturnValue();
                
                component.set("v.FailureOccurance", stringItems); 
            }
        });
        $A.enqueueAction(action);
    },
    getFailureDetectionPickListValues : function(component, event) {
        
        var action = component.get("c.getPickListValues1");
        action.setParams({ obj:"Case",str:"HWS_Failure_Detection__c"});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var stringItems = response.getReturnValue();
                
                component.set("v.FailureDetection", stringItems); 
            }
        });
        $A.enqueueAction(action);
    },
    getFailureDescriptionPickListValues : function(component, event) {
        
        var action = component.get("c.getPickListValues1");
        action.setParams({ obj:"Case",str:"HWS_Failure_Description__c"});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var stringItems = response.getReturnValue();
                
                component.set("v.FailureDescription", stringItems); 
            }
        });
        $A.enqueueAction(action);
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
    },  
    getEmailValidation : function(component,event){
        
        var emailField = component.find('reportEmail');
        var validation = false;
        var emailValue = component.find('reportEmail').get('v.value');
        validation = this.emailValidation(emailValue);
        if(!validation){
            emailField.setCustomValidity('Please Enter Valid Emial Id'); //do not get any message
            emailField.reportValidity();
        }
        return validation;
    },
    emailValidation  : function(emailValue){
        
        var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;          
        var validation = false;
        if(regExpEmailformat.test(emailValue) || emailValue == undefined || emailValue == '' ){
            validation = true; 
        }else{
            validation = false;
        }
        return validation;
    },
    getPhoneValidation : function(component,event){
        
        var phoneField = component.find('reportPhone'); 
        var validation = false;
        var phoneValue = phoneField.get('v.value');
        validation = this.phoneValidation(phoneValue);
        if(!validation){
            phoneField.setCustomValidity('Please enter valid Phone number. Phone number should only contain digits(ex: +XXX XX XXXX, XXXXXXXXXX)'); //do not get any message
            phoneField.reportValidity();
        }
        return validation;
    },
    phoneValidation : function(phoneValue){
        
        var regExpEmailformat = /^[+]*[\s0-9]*$/;
        var validation = false;
        if(regExpEmailformat.test(phoneValue) || phoneValue == undefined || phoneValue ==''){
            validation = true; 
        }else{
            validation = false;
        }
        return validation;
    },
    gotoSearchScreen: function(component, event, helper) {
        
        var rows = component.get("v.selectedAccount");
        if(rows!=null && rows!='' && rows!=undefined){
            component.set("v.StageNumber", 2);
            var Cli=component.get("v.selectedclis");
            var Asset=component.get("v.selectedAssets");
            var Acc=component.get("v.selectedAccount");
            var selAcc=JSON.parse(JSON.stringify(Acc[0]));
            var oldAcc = component.get("v.oldSelectedAccount");
            var showAssets = component.get("v.showAssets");
            var showCli = component.get("v.showClis");
            if(selAcc.Id==oldAcc){
                var searchCriteria =component.get("v.searchCriteria");
                var searchType=component.find("InputSelectSingle");
                searchType.set("v.value",searchCriteria);
                if(Asset!=null && Asset!='' && Asset!=undefined && showAssets=='true'){
                    
                    var dTable = component.find("cliTable");
                    var selectedAcc = dTable.getSelectedRows();
                    var selectedAcc = component.get("v.selectedAssets");
                    if (typeof selectedAcc != 'undefined' && selectedAcc) {
                        var selectedRowsIds = [];
                        for(var i=0;i<selectedAcc.length;i++){
                            selectedRowsIds.push(selectedAcc[i].Id);  
                        }         
                        var dTable = component.find("cliTable");
                        dTable.set("v.selectedRows", selectedRowsIds);
                    }
                    
                }
                if((Cli!=null && Cli!='' && Cli!=undefined) && showCli=='true'){
                    
                    var dTable = component.find("conTable");
                    var selectedAcc = dTable.getSelectedRows();
                    var selectedAcc = component.get("v.selectedclis");
                    if (typeof selectedAcc != 'undefined' && selectedAcc) {
                        var selectedRowsIds = [];
                        for(var i=0;i<selectedAcc.length;i++){
                            selectedRowsIds.push(selectedAcc[i].Id);  
                        }         
                        var dTable = component.find("conTable");
                        dTable.set("v.selectedRows", selectedRowsIds);
                    }
                    
                }
            }else{
                component.set("v.showParentEntS",false);//HIDE ENTITLEMENT IF ACC IS CHANGED
                component.set("v.showLineEntS",false);//HIDE ENTITLEMENT IF ACC IS CHANGED
                component.set("v.isADFDescription",false);//HIDE COMMENTS IF ACC IS CHANGED
                component.set("v.Assets", null);
                component.set("v.AllAssets", null);
                component.set("v.selectedAssets", null);
                component.set("v.clis", null);
                component.set("v.ALLclis", null);
                component.set("v.selectedclis", null);
                component.set("v.selectedVersions", null);
                component.set("v.versionItems", null);
                component.set("v.searchKeyword",'');
                component.set("v.contractNumber",'');
                component.set("v.serviceType",'');
                component.set("v.showStep6",false);
                component.set("v.showAssets",false);
                component.set("v.showClis",false);
                component.set("v.searchCriteria",'Part Code');
                if(oldAcc!=null && oldAcc!='' && oldAcc!=undefined){
                    this.clearChild(component,event);
                    this.clearParent(component,event);
                }
            }
            
        }else{
            this.showToast('error','Error Message',$A.get("$Label.c.HWS_MSG_Select_Account"));
        }
        var today = new Date();
        component.set('v.newChildCase.HWS_Planned_Delivery_Date__c', today);
    },
    requestDateChangeValidate : function(component, event){
        var reqVal = false;
        var planedDate = component.get('v.newChildCase.HWS_Planned_Delivery_Date__c');
        var requestedDate = component.get('v.newChildCase.HWS_Requested_Delivery_Date_Time__c');
        if(new Date(planedDate) > new Date(requestedDate) && requestedDate != null){
            component.set("v.dateValidationError" , true);
            reqVal = false; 
        }else{
            component.set("v.dateValidationError" , false);
            reqVal = true; 
        }
        return reqVal;
    }, 
    getplannedDeliveryDateTime : function(component, event, helper){
        /*var selectedAsset = component.get("v.selectedAssets");
        var action = component.get("c.plannedDeliveryDateTime");
        var businesshours = selectedAsset[0].HWS_ContractLineItem__r.CH_BusinessHour__c;
        var leadTimeUnit = selectedAsset[0].HWS_ContractLeadTimeUnit__c;
        var leadTimeDuration = selectedAsset[0].HWS_ContractLeadTimeDuration__c;
        var specifiedTime = selectedAsset[0].HWS_SpecifiedDeliveryTargetTime__c;
        //alert('specifiedTime'+specifiedTime);
        var byPassPlannedDate = component.get("v.byPassDate");
        //console.log('##### bypass'+byPassPlannedDate);
        action.setParams({ businessHrsId : businesshours,
                          leadTimeUnit : leadTimeUnit,
                          leadTimeDuration : leadTimeDuration,
                          byPassPlannedDate: byPassPlannedDate,
                          specifiedTime : specifiedTime
                         });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var stringItems = response.getReturnValue();
                //alert('stringItems'+stringItems);
                //var userLocalDateTime = stringItems[1];
                var date = new Date(stringItems);
                component.set("v.newChildCase.HWS_Planned_Delivery_Date__c",date);
                component.set("v.plannedDateTime",date);
            }
        });
        $A.enqueueAction(action);*/
        //Added By Ajesh 
        component.set("v.IsSpinner", true);
        var listChildCases = component.get("v.childCases");
        var selectedAccount = component.get('v.ShiptopartyAddress');
        //alert('listChildCases**'+listChildCases);
        //alert('selectedAccount**'+selectedAccount);
        var action = component.get("c.accountTimeZoneplannedDeliveryDateTime");// NOKIASC-37920 | Added isBulkUploadCall
        action.setParams({ listChildCases : listChildCases,
                          selectedAccount : selectedAccount,
                          isBulkUploadCall : false
                         });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var stringItems = response.getReturnValue();                
                var st = [];
                st.push(stringItems.newTimeZoneCaseList);
                //component.set("v.childCases",st[0]);
                var st1 = [];
                st1.push(stringItems.bhTimeZone);
                console.log('SSSSTT:'+st1[0]);
                component.set("v.deliveryTimeZone",st1[0]);
                var listChildCasetimeZone = st[0];
                for(var i=0; i<listChildCasetimeZone.length; i++){
                    var countryTime = listChildCasetimeZone[i].HWS_PlannedDeliveryDateShipment__c;
                    countryTime = new Date(countryTime);
                    var counteryDateOnly = $A.localizationService.formatDate(countryTime); 
                	counteryDateOnly = counteryDateOnly.replace(/[\/\\.-]/g, ' ');
                	var counteryTimeOnly = $A.localizationService.formatTime(countryTime);
                	var hours = countryTime.getHours();
                	var minutes = countryTime.getMinutes();
                	var ampm = hours >= 12 ? 'pm' : 'am';
                    if(counteryTimeOnly.includes("AM") || counteryTimeOnly.includes("PM")){
                        ampm = hours >= 12 ? 'PM' : 'AM';
                    }
                	hours = hours % 12;
                	hours = hours ? hours : 12; // the hour '0' should be '12'
               		minutes = minutes < 10 ? '0'+minutes : minutes;
                	var strTime = hours + ':' + minutes + ' ' + ampm; 
                	listChildCasetimeZone[i].HWS_PlannedDeliveryDateShipment__c = counteryDateOnly +', ' + strTime+' ( '+listChildCasetimeZone[i].HWS_Delivery_TimeZone__c+ ' )';
                    console.log('listChildCasetimeZone[i].HWS_PlannedDeliveryDateShipment__c:'+listChildCasetimeZone[i].HWS_PlannedDeliveryDateShipment__c);
                    
                }
                component.set("v.childCases",listChildCasetimeZone);
                console.log('listChildCasetimeZone:'+JSON.stringify(listChildCasetimeZone));
            }
			this.getShipToTimeZone(component, event, helper);
            //component.set("v.IsSpinner", false);
        });
        $A.enqueueAction(action);
    },
    getServiceContracts: function(component, event, helper){
        component.set("v.IsSpinner", true);
        component.set("v.showParentEntS",false);//Hide Entitlements while searching
        component.set("v.showLineEntS",false);//Hide Entitlements while searching
        var selectedRows = component.get("v.selectedAccount");
        var searchCriteria =component.get("v.searchCriteria");
        var searchValue = component.get("v.searchKeyword");
		//added for NOKIASC-35931
		var legalAccNumber = selectedRows[0].AccountNumber;
        var servicedAccounts = component.get("v.serviceAcountNumber");
        if(legalAccNumber != null && servicedAccounts != null && servicedAccounts.includes(legalAccNumber)){
            component.set("v.isServicedAccount",true);
        }
        if(searchValue==undefined || searchValue=='' || searchValue.length<3){
            this.showToast('Warning','Warning Message',$A.get("$Label.c.HWS_MSG_Enter_Minimum3Char"));
            this.hideWaiting(component);
            component.set("v.Assets", null);
            component.set("v.AllAssets", null);
            component.set("v.clis",null);
            component.set("v.ALLclis",null);
            component.set("v.selectedAssets",null);
            component.set("v.selectedclis",null);
        }else{
	
            if(searchCriteria=='Part Code'){
                component.set("v.showAssets","true");
                component.set("v.showClis","false");
                component.set("v.showStep6","false");
                //NOKIASC-25686 Reordered all the columns
                //NOKIASC-34980 - Adjusted the width of Product Name,Description,SLA Value
                component.set('v.assetColumns', [
                    {label: 'Part Code', fieldName: 'HWS_Part_Code__c', type: 'text',"initialWidth": 155},
                    {label: 'Description', fieldName: 'HWS_Product_Name__c', type: 'text',"initialWidth": 180},
                    {label: 'Product Name', fieldName: 'HWS_High_Level_Product_Name__c', type: 'text',"initialWidth": 160},
                    {label: 'Service Item Description', fieldName: 'HWS_ServiceItemDescription__c', type: 'text',"initialWidth": 160},
                    {label: 'Service Type', fieldName: 'HWS_Service_Type__c', type: 'text',"initialWidth": 160},
                    //NOKIASC-25659
                    {label: 'NEA Count', fieldName: 'CoveredNetworkElementCount', type: 'text',"initialWidth": 85, hideDefaultActions: true},
                    //NOKIASC-25677
                    {label: 'Country', fieldName: 'CountryName', type: 'text',"initialWidth": 90},
                    {label: 'SLA Value', fieldName: 'HWS_ContractLeadTimeDuration__c', type: 'text',"initialWidth": 87, hideDefaultActions: true},
                    {label: 'SLA Unit', fieldName: 'HWS_ContractLeadTimeUnit__c', type: 'text',"initialWidth": 95, hideDefaultActions: true},
                    {label: 'Contract Number', fieldName: 'HWS_Service_Contract_Number__c', type: 'text',"initialWidth": 110},
                    {label: 'Price', fieldName: 'HWSPrice', type: 'text',"initialWidth": 100},
                    {label: 'Currency', fieldName: 'HWSCurrency', type: 'text',"initialWidth": 100},
                    
                ]); 
                    //3697 - passing contactId 32414
                    var action = component.get('c.getContractlineItems');
                    action.setParams({
                    listAccounts : selectedRows,
                    searchValue : searchValue,
                    serviceType : component.get("v.serviceType"),
                    contractNumber : component.get("v.contractNumber"),
                    country : component.get("v.serviceContractCountry"), 
                    contactId : component.get("v.recordId")
                    });
                    action.setCallback(this, $A.getCallback(function (response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                    component.set("v.IsSpinner", false);
                    var mapContact = new Map();
                    mapContact = response.getReturnValue();
                    //console.log('#### return value'+JSON.stringify(mapContact));
                    //34072 & 34073
					//if(!Object.keys(mapContact).includes("No Error")){
					if(!(Object.keys(mapContact).includes("No Error") || Object.keys(mapContact).includes("Kit code search"))){
                    component.set("v.Assets", null);
                    component.set("v.AllAssets", null);
                    component.set("v.selectedAssets",null);
                    var Asset = component.get("v.Assets");
                    console.log('Asset '+Asset);
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
                    // NOKIASC-25659, 25677 added to get lookup field in a string to display country and Nea count fields in the data table after search
                    //34072 &34073
					var Assets = mapContact["Kit code search"];
					
					//Need disply msg
					if(Assets == null || Assets =='' || Assets == undefined){
						Assets = mapContact["No Error"];
						component.set("v.kitcodesearch",false);
					}
					else{
						component.set("v.kitcodesearch",true);
					}
                    /*var Assets = mapContact["No Error"];*/
					var QuantityNEA;
					var AstIdToAstMap = {};
                	for (var i = 0; i < Assets.length; i++) {
                        var row = Assets[i];
                        var country = row.HWS_ContractLineItem__r.CH_CountryISOName__c;
                        if(row.HWS_ContractLineItem__r.CH_CountryISOName__c != undefined && row.HWS_ContractLineItem__r.CH_CountryISOName__c != null && row.HWS_ContractLineItem__r.CH_CountryISOName__c != ''){
                            var country = row.HWS_ContractLineItem__r.CH_CountryISOName__c;
                            row.CountryName = country.toString();
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
                        row.CoveredNetworkElementCount = QuantityNEA.toString();
                        // NOKIASC-25661 to enable Select NEA button checking count
                        var nea = row.CoveredNetworkElementCount > 0 ;
                        if(QuantityNEA > 0){
                            console.log('NEAB:' + row.CoveredNetworkElementCount);
                            component.set("v.enableSelectNEA" , false);
                        }
					AstIdToAstMap[row.Id] = row;
					                   
                }
				
				var astMap = component.get("v.AstIdToAstMap");
                for(var key in astMap){
                    var assetRec = astMap[key];
                    AstIdToAstMap[assetRec.Id] = assetRec;
                }
				
				component.set("v.AstIdToAstMap",AstIdToAstMap);
				
                // Ending changes NOKIASC-25659 , 25677
                if(Assets.length>0){
                    component.set("v.Assets", null);
                    component.set("v.AllAssets", null);
                    component.set("v.selectedAssets",null);
                }
                //34072 & 34073
                if(mapContact["Kit code search"] !=null && mapContact["Kit code search"] !='' && mapContact["Kit code search"] != undefined){
					component.set("v.Assets", mapContact["Kit code search"]);
					component.set("v.AllAssets", mapContact["Kit code search"]);
					component.set("v.clearNEAAssets", mapContact["Kit code search"]);
				}
				else{
					component.set("v.Assets", mapContact["No Error"]);
					component.set("v.AllAssets", mapContact["No Error"]);
					component.set("v.clearNEAAssets", mapContact["No Error"]);
				}
            }
        }
    }));
    $A.enqueueAction(action);
}
 
 if(searchCriteria=='Contract Number'){
    component.set("v.showClis","true");
    component.set("v.showAssets","false");
    component.set("v.showStep6","true");
    component.set('v.CLIColumns', [
        {label: 'Contract Number', fieldName: 'HWS_ServiceContractNumber__c', type: 'text'},
        //NOkiasc-25659
        {label: 'NEA Count', fieldName: 'CoveredNetworkElementCount', type: 'text'},
        {label: 'Contract Description', fieldName: 'HWS_ServiceContractName__c', type: 'text'},
        {label: 'Service Type', fieldName: 'CH_ServiceType__c', type: 'text'}
    ]);
    //3697 - passing contactId
    var action = component.get('c.getServiceContracts');
    action.setParams({
        selectedAccounts : selectedRows,
        searchString : searchValue,
        serviceType : component.get("v.serviceType"),
        selectedContractNumber : component.get("v.selectedContractNumber"),
        contactId : component.get("v.recordId")
    });
    action.setCallback(this, $A.getCallback(function (response) {
        var state = response.getState();
        if (state === "SUCCESS") {
            component.set("v.IsSpinner", false);
            var mapContact = new Map();
            mapContact = response.getReturnValue();
            if(!Object.keys(mapContact).includes("No Error")){
                component.set("v.clis",null);
                component.set("v.ALLclis",null);
                component.set("v.showStep6",false);
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
                component.set("v.ALLclis",null);
                component.set("v.showStep6",true);
                component.set("v.selectedclis",null);
                component.set("v.clis", mapContact["No Error"]);
                component.set("v.ALLclis", mapContact["No Error"]);
                // NOKIASC-25659 added to get lookup field in a string to display country and Nea count fields in the data table after search
                var clis = mapContact["No Error"];
                var QuantityNEA;
                              for (var i = 0; i < clis.length; i++) {
                    var row = clis[i];
                   QuantityNEA = row.CH_QtyCoveredNetworkElementAssets__c;
                    row.CoveredNetworkElementCount = QuantityNEA.toString();
                    // NOKIASC-25661 to enable Select NEA button checking count
                    var nea = row.CoveredNetworkElementCount > 0 ;
                    if(QuantityNEA > 0){
                        component.set("v.enableSelectNEA" , false);
                    }
					                   
                }
                // NOKIASC-25659 changes end
                component.set("v.clis", clis);
                component.set("v.ALLclis", clis);
                component.set("v.clearNEACLIS", clis);
            }
        }
    }));$A.enqueueAction(action);
}
}
},
    getVersionItems: function(component, event, helper) {
        console.log('SELECTED NEAS:'+component.get('v.selectedNEA'));
        console.log('Stage NUmber'+component.get('v.StageNumber'));
        var rows = component.get("v.selectedAssets");
        // var searchCode = component.get("v.searchKeyword");
        if(rows!=null && rows!='' && rows!=undefined){
            component.set("v.StageNumber", 3);
            var selectedRows = component.get("v.selectedAssets");
            var searchCriteria =component.get("v.searchCriteria");
            var searchCode = component.get("v.searchKeyword");
            if(searchCriteria == 'Contract Number'){
                searchCode = null;
            }            
            var action = component.get('c.getVersions');
            console.log('-hlpr 415-action--'+action);
            action.setParams({
                listServiceServiceCon : selectedRows,
                searchValue : searchCode
            });
            action.setCallback(this, $A.getCallback(function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set("v.versionItems", response.getReturnValue());
                    component.set("v.AllversionItems", response.getReturnValue());
                    
					let responseLength = response.getReturnValue();
                    if(responseLength.length == 1){
                        component.set("v.selectedVersionstep3",true);
                        component.set("v.newChildAddPart",false);
                    }
					
                    //start HWST-4189
                    console.log('-426 --hlpr----'+component.get("v.versionItems"));
                    var versionItems = component.get("v.versionItems");
                    var regExpr = /[^a-zA-Z0-9]/g;                    
                    var captureSearchVal = component.get("v.searchKeyword").toUpperCase();                   
                    var searchVal = component.get("v.searchKeyword").replace(regExpr, '').toUpperCase();            
                    var sfdcPartCode = component.get("v.ProductCode");                    
                    var partCod = null;
                    if(sfdcPartCode != null && sfdcPartCode != undefined){						
                        partCod = sfdcPartCode.replace(regExpr, '').toUpperCase();                      
                    }
                    if(searchVal != null && partCod != null && searchVal != undefined && partCod != undefined && searchVal.length > partCod.length){					
                        var partRev = searchVal.replace(partCod,'');
                        //HWS-4187
                        var exactPartRev = null;
                        if(sfdcPartCode != null && sfdcPartCode != undefined){
                            exactPartRev = captureSearchVal.replace(sfdcPartCode.toUpperCase(),'');                            
                        }
                        
                        var dTable = component.find("vItems");						
                        var selectedAcc = component.get("v.AllversionItems");                    
                        var selectedRowsIds = [];
                        var viId = '';                                             
                        if (selectedAcc!= null && selectedAcc!= '' && selectedAcc != undefined && selectedAcc) { 
						    component.set("v.enableVi" , false);
                            var isExist = false;
                            for(var i=0;i<selectedAcc.length;i++){
                                if(selectedAcc[i].HWS_Version_Code__c.toUpperCase() === exactPartRev ){
                                    viId = selectedAcc[i].Id;
                                    component.set("v.selectedVersions", selectedAcc[i]);
                                    component.set("v.newChildCase.HWS_Stockable_Product__c", selectedAcc[i].Id);
                                    component.set("v.CustPartrevison", selectedAcc[i].HWS_Version_Code__c);
                                    component.set("v.newChildCase.HWS_Customer_Part_Revision__c", "");	
									//25689
									component.set("v.newChildCase.Street_Address_1__c",selectedAcc[i].HWS_Version_Code__c);
                                    isExist = true;
                                }
                                if(selectedAcc[i].HWS_Version_Code__c.toUpperCase() === captureSearchVal){									
                                    viId = selectedAcc[i].Id;
                                    component.set("v.selectedVersions", selectedAcc[i]);
                                    component.set("v.newChildCase.HWS_Stockable_Product__c", selectedAcc[i].Id);
                                    component.set("v.CustPartrevison", selectedAcc[i].HWS_Version_Code__c);
                                    component.set("v.newChildCase.HWS_Customer_Part_Revision__c", "");
									//25689
									component.set("v.newChildCase.Street_Address_1__c",selectedAcc[i].HWS_Version_Code__c);
                                    isExist = true;
                                }
                                if(selectedAcc[i].HWS_Part_Code_Part_Revision__c != null && selectedAcc[i].HWS_Part_Code_Part_Revision__c != undefined && selectedAcc[i].HWS_Part_Code_Part_Revision__c.toUpperCase() === searchVal ){									
                                    viId = selectedAcc[i].Id;
                                    component.set("v.selectedVersions", selectedAcc[i]);
                                    component.set("v.newChildCase.HWS_Stockable_Product__c", selectedAcc[i].Id);
                                    component.set("v.CustPartrevison", selectedAcc[i].HWS_Version_Code__c);
                                    component.set("v.newChildCase.HWS_Customer_Part_Revision__c", "");
									//25689
									component.set("v.newChildCase.Street_Address_1__c",selectedAcc[i].HWS_Version_Code__c);
                                    isExist = true;
                                }
                                else if(isExist ===false && selectedAcc[i].HWS_Version_Code__c.toUpperCase() === 'ANY' && searchVal.includes(partCod)){									
                                    // start 4190
                                    
                                    if (exactPartRev.indexOf("-") == 0 || exactPartRev.indexOf(".") == 0 || exactPartRev.indexOf(":") == 0 || exactPartRev.indexOf("/") == 0 || exactPartRev.indexOf(",") == 0)
                                    {									  
                                        exactPartRev = exactPartRev.slice(1);
                                        if(exactPartRev.indexOf("-") == 0){        
                                            exactPartRev = exactPartRev.slice(1);
                                        }									  
                                    }                                   
                                    component.set("v.CustPartrevison", exactPartRev);
                                    component.set("v.newChildCase.HWS_Customer_Part_Revision__c", exactPartRev);
                                    viId = selectedAcc[i].Id;
                                    component.set("v.selectedVersions", selectedAcc[i]);
                                    component.set("v.newChildCase.HWS_Stockable_Product__c", selectedAcc[i].Id);
									//25689
									component.set("v.newChildCase.Street_Address_1__c",selectedAcc[i].HWS_Version_Code__c);
                                }
                                
                            } 
                            selectedRowsIds.push(viId);   
                            var dTable = component.find("vItems");                            
                            if(dTable != null && dTable != '' && dTable != undefined){
                                dTable.set("v.selectedRows", selectedRowsIds);								
                            }
                            
                        }						
                    }                   
                    if(searchVal != null && partCod != null && searchVal != undefined && partCod != undefined && searchVal === partCod){
                        
                        var dTable = component.find("vItems");						
                        var selectedAcc = component.get("v.AllversionItems");                    
                        var selectedRowsIds = [];
                        var viId = null;
                        if (selectedAcc!= null && selectedAcc!= '' && selectedAcc != undefined && selectedAcc) {
                            var isExist = false;
                            for(var i=0;i<selectedAcc.length;i++){								
                                if(selectedAcc[i].HWS_Version_Code__c.toUpperCase() === captureSearchVal){									
                                    viId = selectedAcc[i].Id;
                                    component.set("v.selectedVersions", selectedAcc[i]);
                                    component.set("v.newChildCase.HWS_Stockable_Product__c", selectedAcc[i].Id);
                                    component.set("v.CustPartrevison", selectedAcc[i].HWS_Version_Code__c);
                                    component.set("v.newChildCase.HWS_Customer_Part_Revision__c", "");
									//25689
									component.set("v.newChildCase.Street_Address_1__c",selectedAcc[i].HWS_Version_Code__c);
                                    
                                }                                
                                if(selectedAcc[i].HWS_Part_Code_Part_Revision__c != null && selectedAcc[i].HWS_Part_Code_Part_Revision__c != undefined && selectedAcc[i].HWS_Part_Code_Part_Revision__c.toUpperCase() === searchVal ){									
                                    viId = selectedAcc[i].Id;
                                    component.set("v.selectedVersions", selectedAcc[i]);
                                    component.set("v.newChildCase.HWS_Stockable_Product__c", selectedAcc[i].Id);
                                    component.set("v.CustPartrevison", selectedAcc[i].HWS_Version_Code__c);
                                    component.set("v.newChildCase.HWS_Customer_Part_Revision__c", "");
									//25689
									component.set("v.newChildCase.Street_Address_1__c",selectedAcc[i].HWS_Version_Code__c);
                                    
                                }
                            } 
                            if(viId != null){
                                selectedRowsIds.push(viId);   
                                var dTable = component.find("vItems");								
                                if(dTable != null && dTable != '' && dTable != undefined){
                                    dTable.set("v.selectedRows", selectedRowsIds);                                    
                                }
                            }
                            
                        }	
                    }
                    //End HWST-4189
                    //Start HWST-4191
                    
                    if((versionItems!=null && versionItems!='' && versionItems != undefined) && versionItems.length === 1){
						component.set("v.enableVi" , false);
                        var dTable = component.find("vItems");						
                        if(dTable != null && dTable != '' && dTable != undefined){
                            var selectedAcc = dTable.getSelectedRows();
                        }
                        var selectedAcc = component.get("v.AllversionItems");  
                        
                        var selectedRowsIds = [];
                        component.set("v.selectedVersions", selectedAcc[0]);
                        component.set("v.newChildCase.HWS_Stockable_Product__c", selectedAcc[0].Id);
						//25689
						component.set("v.newChildCase.Street_Address_1__c",selectedAcc[0].HWS_Version_Code__c);
                        selectedRowsIds.push(selectedAcc[0].Id);   
                        var dTable = component.find("vItems");							
                        if(dTable != null && dTable != '' && dTable != undefined){
                            dTable.set("v.selectedRows", selectedRowsIds);                            
                        }
                    }
                    //End HWST-4191
                    
                }
            }));
            $A.enqueueAction(action);
            
            var versions= component.get("v.selectedVersions");
            var selAsset=JSON.parse(JSON.stringify(rows[0]));
            
            var oldAsset = component.get("v.oldSelectedAssets");
            if(selAsset.Id==oldAsset){
                if(versions!=null && versions!='' && versions!=undefined){
                    
                    var dTable = component.find("vItems");					
                    if(dTable != null && dTable != '' && dTable != undefined){
                        var selectedAcc = dTable.getSelectedRows();
                    }
                    var selectedAcc = component.get("v.selectedVersions");
                    if (typeof selectedAcc != 'undefined' && selectedAcc) {
                        var selectedRowsIds = [];
                        for(var i=0;i<selectedAcc.length;i++){
                            selectedRowsIds.push(selectedAcc[i].Id);  
                        }         
                        var dTable = component.find("vItems");						
                        if(dTable != null && dTable != '' && dTable != undefined){
                            dTable.set("v.selectedRows", selectedRowsIds);
                        }
                    }
                }
            }else{
                component.set("v.versionItems", null);
                component.set("v.AllversionItems", null);
                component.set("v.selectedVersions", null);
            }
        }
        else{
            var clis = component.get("v.clis");
            if(clis != null && clis != '' && clis != undefined){
                component.set("v.SelectConNum",false);
                component.set("v.selectedAssetstep2",true);
                component.set("v.selectedLineItemstep2",true);
                component.set("v.ContProgressBarCounter" ,2);
                component.set("v.ContNEAProgressBarCounter" ,3);
                
            }
            else
            {
                component.set("v.selectedAssetstep2",false);
                component.set("v.selectedLineItemstep2",false);
                component.set("v.ProgressBarCounter" ,1);
            }
        }
    },
        getSellableItems: function(component,event,helper){
            
            var rows = component.get("v.selectedclis");
            if(rows!=null && rows!='' && rows!=undefined){
                component.set("v.StageNumber", 6);
                var selectedRows = component.get("v.selectedclis");
                component.set('v.assetColumns', [
                    {label: 'Service Type', fieldName: 'HWS_Service_Type__c', type: 'text'},
                    {label: 'Service Item Code', fieldName: 'HWS_ServiceItemCode__c', type: 'text'},
                    {label: 'Service Item Description', fieldName: 'HWS_ServiceItemDescription__c', type: 'text'},
                    {label: 'SLA Value', fieldName: 'HWS_ContractLeadTimeDuration__c', type: 'text',"initialWidth": 80},
                    {label: 'SLA Unit', fieldName: 'HWS_ContractLeadTimeUnit__c', type: 'text'},
                    {label: 'Contract Number', fieldName: 'HWS_Service_Contract_Number__c', type: 'text'},
                    {label: 'Hour of the day', fieldName: 'HWS_SpecifiedDeliveryTargetTime__c', type: 'text'},
                    //HWST-3669 - added High Level Product Name column
                    {label: 'Product Name', fieldName: 'HWS_High_Level_Product_Name__c', type: 'text',"initialWidth": 150},
                    {label: 'Part Code', fieldName: 'HWS_Part_Code__c', type: 'text'},
                    {label: 'Currency', fieldName: 'HWS_Currency__c', type: 'text'},
                    {label: 'Price', fieldName: 'HWS_Price__c', type: 'text'},
                    {label: 'Description', fieldName: 'HWS_Product_Name__c', type: 'text',"initialWidth": 150}
                ]);
                var action = component.get('c.getCLIOfServiceContracts');
                action.setParams({
                    selectedServiceContracts : rows
                });
                action.setCallback(this, $A.getCallback(function (response) {
                    var state = response.getState();
                    if (state === "SUCCESS"){
                        component.set("v.Assets", response.getReturnValue());
                        component.set("v.AllAssets", response.getReturnValue());
						var Assets = component.get("v.Assets");
                        var AstIdToAstMap = {};
                        for (var i = 0; i < Assets.length; i++) {
                            var row = Assets[i];
                            AstIdToAstMap[row.Id] = row;
                        }
						
			    var astMap = component.get("v.AstIdToAstMap");
                for(var key in astMap){
                    var assetRec = astMap[key];
                    AstIdToAstMap[assetRec.Id] = assetRec;
                }
                component.set("v.AstIdToAstMap",AstIdToAstMap);
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
                    // component.set("v.AllAssets", null);
                    component.set("v.selectedAssets", null);
                    component.set("v.versionItems", null);
                    component.set("v.selectedVersions", null);
                }
            }else{
                this.showToast('error','Error Message',$A.get("$Label.c.HWS_MSG_Select_ServiceContract_Before_SelectNEA")); 
                component.set("v.SelectConNum",false);
                component.set("v.selectedAssetstep2",false);
                component.set("v.selectedLineItemstep2",false);
                component.set("v.ContProgressBarCounter",1);
                
            }
        },
            //25689
            deliveryInfo: function(component, event, helper) {
                var parentCase = component.get("v.newParentCase");           
                var Emailvalidation = false;
                var phoneNoValidation = false;
                var EmailFieldShip = component.find('ShipRecipntEmail');
                console.log(EmailFieldShip+'EmailFieldShip') ;
                var phoneField = component.find('ShipRecipntphone');
                var communicationContact = component.get('v.communicationContact');
                var ShiptopartyAddress = component.get('v.ShiptopartyAddress'); 
                var caseOrigin = component.find('caseOrigin').get('v.value');
                var ShipmentName = component.find("ShipmentRecipientName").get('v.value');
                var reporteddateVal = component.find('reporteddate').get('v.value');
                var reporteddate = new Date(component.find('reporteddate').get('v.value'));
                var shipToPartyAccount = component.get('v.shipToPartyAccount'); 
                var deliveryTimeZone = component.get("v.deliveryTimeZone");
                var isRetroAccount = component.get("v.showRetroAccount");
                if (isRetroAccount || isRetroAccount == 'true' || isRetroAccount == true) {
                	 parentCase.CH_ServiceType__c = 'Internal Support';  
               	}
                parentCase.HWS_Communication_Contact__c = communicationContact;
                parentCase.Hws_Ship_to_Party_Address__c = ShiptopartyAddress;
                parentCase.HWS_Delivery_TimeZone__c  = deliveryTimeZone;
                parentCase.HWS_Address_Name__c  = shipToPartyAccount==null ? '' : shipToPartyAccount.Name;
                parentCase.Street_Address_1__c  = shipToPartyAccount==null ? '' : shipToPartyAccount.Hws_Address_Line_1__c;
                parentCase.Street_Address_2__c  = shipToPartyAccount==null ? '' : shipToPartyAccount.Hws_Address_Line_2__c;
                parentCase.Street_Address_3__c  = shipToPartyAccount==null ? '' : shipToPartyAccount.Hws_Address_Line_3__c;
                parentCase.City__c              = shipToPartyAccount==null ? '' : shipToPartyAccount.BillingCity;
                parentCase.POSTAL_CODE_CHQ__c   = shipToPartyAccount==null ? '' : shipToPartyAccount.BillingPostalCode;
                parentCase.HWS_Region__c        = shipToPartyAccount==null ? '' : shipToPartyAccount.Region__c;
                parentCase.State__c             = shipToPartyAccount==null ? '' : shipToPartyAccount.BillingState;
                parentCase.Country__c           = shipToPartyAccount==null ? '' : shipToPartyAccount.BillingCountry;
                //parentCase.Origin = caseOrigin;
                console.log('DTZ:'+parentCase.HWS_Delivery_TimeZone__c);
                console.log('DTZ:'+JSON.stringify(parentCase));
                var phoneValue1;
                var EmailFeildShipEmail;
                if(EmailFieldShip!=undefined){            
                    EmailFeildShipEmail = EmailFieldShip.get('v.value');
                    console.log(EmailFeildShipEmail+'EmailFeildShipEmail');
                    Emailvalidation = this.emailValidation(EmailFeildShipEmail);            
                }
                if(phoneField!=undefined){            
                    phoneValue1 = phoneField.get('v.value');
                    phoneNoValidation = this.phoneValidation(phoneValue1);            
                }
                var isValidEmail = true; 
                
                //Start- NOKIASC-33012:SRM Email subject
                //Group all the fields aura ids 
                var controlAuraIds = [{"input":"caseOrigin","msg":"caseOriginMsg"},
                                      {"input":"ShipRecipntEmail","msg":"ShipRecipntEmailMsg"},
                                      {"input":"ShipRecipntphone","msg":"phoneMsg"},
                                      {"input":"ShipmentRecipientName","msg":"ShipRecipntMsg"},
                                      {"input":"ShiptopartyAddress","msg":"shipMandatoryMSg"}
                                     ];
                //reducer function iterates over the array and return false if any of the field is invalid otherwise true.
                let isAllValid = controlAuraIds.reduce(function(isValidSoFar, controlAuraId){
                    //fetches the component details from the auraId
                    var inputCmp = component.find(controlAuraId.input);
                    var value=controlAuraId.input=="ShiptopartyAddress"?ShiptopartyAddress:inputCmp.get("v.value");
                    var isValid=true;
                    if($A.util.isEmpty(value)){
                        isValid=false;
                        switch(controlAuraId.input) {
                            case "caseOrigin":
                                component.find("caseOriginMsg").set("v.errors", [{message:"Please Enter Support Ticket Origin before Proceeding"}]);
                                break;
                            case "ShipRecipntEmail":
                                component.find("ShipRecipntEmailMsg").set("v.errors", [{message:"Please fill  the Shipment Recipient Email"}]);
                                break;
                            case "ShipRecipntphone":
                                component.find("phoneMsg").set("v.errors", [{message:"Please fill the Shipment Recipient Phone Number"}]);
                                break;
                            case "ShipmentRecipientName":
                                component.find("ShipRecipntMsg").set("v.errors", [{message:"Please fill the Shipment Recipient Name"}]);                            
                                break;
                            case "ShiptopartyAddress":                                
                                component.find("shipMandatoryMSg").set("v.errors", [{message:"Please Enter Ship to party Address before Proceeding"}]);  
                                break;
                            default:
                                isValid=true;           
                        }
                    }
                    if(isValid){
                        //fetches the message details from the auraId
                        var msgCmp = component.find(controlAuraId.msg);
                        msgCmp.set("v.errors", [{message: null}]);
                        $A.util.removeClass(msgCmp, 'slds-has-error');
                        //return true;  
                    }
                    return isValidSoFar && isValid
                },true);
                //End- NOKIASC-33012:SRM Email subject

                
                //NOKIASC-31884
                var today = new Date();
                var reporteddateNotEmpty = reporteddateVal != null && reporteddateVal != undefined && reporteddateVal != '';
                if(reporteddateNotEmpty && reporteddate > today ){
                    this.hideWaiting(component);
                    component.find("reportedDateMsg").set("v.errors", [{message:"Reported Date should be less than or equal to today"}]);
                } else {
                    component.find("reportedDateMsg").set("v.errors", [{message: null}]);
                    $A.util.removeClass(component.find("reportedDateMsg"), 'slds-has-error');
                    isValidEmail = false;
                } 
               
                var isRetroAccount = component.get('v.showRetroAccount');
                var selectedAccountInfo = component.get('v.selectedRetroAccount');
                var info = JSON.stringify(selectedAccountInfo);
                if (isRetroAccount && info.length == 2) {
                	component.find("retroAccountInfo").set("v.errors", [{message:"Please enter Sold to Account and then choose Ship To Country"}]); 
                } else {
                	component.find("retroAccountInfo").set("v.errors", [{message: null}]);
                    $A.util.removeClass(component.find("retroAccountInfo"), 'slds-has-error');
                }
                
                if(isAllValid && !$A.util.isEmpty(ShiptopartyAddress) && phoneNoValidation 
                   && Emailvalidation 
                   && caseOrigin != '--None--' 
                   && (!reporteddateNotEmpty || reporteddate <= today) &&  !$A.util.isEmpty(ShipmentName) && !$A.util.isEmpty(EmailFeildShipEmail) && !$A.util.isEmpty(phoneValue1)){
                    console.log('child Listt=='+JSON.stringify(component.get("v.childCases")));
					//25689
                    var userTimeZone = component.get("v.currentUserTimeZone");
                    var selectedServiceType = component.get("v.serviceTypeCheck");
                    if(selectedServiceType == 'Advanced Exchange in Hours'){
                        component.set('v.childCaseColumns', [
                            {label: 'Part Code', fieldName: 'HWS_Part_Code__c', type: 'text', "initialWidth": 150},
                            {label: 'Part Revision', fieldName: 'Street_Address_1__c', type: 'text', "initialWidth": 150},
                            //NOKIASC-34979
                            {label: 'Faulty Unit Serial Number', fieldName: 'HWS_Faulty_Serial_Number__c', type: 'text',"initialWidth": 150},
                            {label: 'Planned Delivery Date (User TZ)', fieldName: 'HWS_Planned_Delivery_Date__c', type: 'date', "initialWidth": 250,
                             typeAttributes:{
                                 day: 'numeric',
                                 year: "numeric",
                                 month: "short",
                                 day: "2-digit",
                                 hour: "2-digit",
                                 minute: "2-digit",
                                 hour12: true,
								 timeZone: userTimeZone
                             }
                            },
                            {label: 'Planned Delivery Date (Ship to TZ)', fieldName: 'HWS_PlannedDeliveryDateShipment__c', type: 'date', "initialWidth": 260,
                            	typeAttributes:{
                                 day: '2-digit',
                                 year: "numeric",
                                 month: "short",
                                 day: "2-digit",
                                 hour: "2-digit",
                                 minute: "2-digit",
                                 hour12: true,
								 timeZone: userTimeZone
                             } 
                            },  
                            {label: 'Cust Req Delivery Date (User TZ)', fieldName: 'HWS_Requested_Delivery_Date_Time__c', editable:true, type: 'date', "initialWidth": 260,
                                 typeAttributes: {
                                     day: '2-digit',
                                     month: 'short',
                                     year: 'numeric',
                                     hour: '2-digit',
                                     minute: '2-digit',                                     
                                     hour12: true,
									 timeZone: userTimeZone
                                 },
                                 cellAttributes:{  
                                     class:{  
                                         fieldName:"Street_Address_3__c"
                                     }
                                 }
                         	},
                            {label: 'Cust Req Delivery Date (Ship to TZ)', fieldName: 'HWS_RequestedDateShipment__c', type: 'text', "initialWidth": 260},      
                        ]);
                            }
                            else{
                            component.set('v.childCaseColumns', [
                            {label: 'Part Code', fieldName: 'HWS_Part_Code__c', type: 'text'},
                            {label: 'Part Revision', fieldName: 'Street_Address_1__c', type: 'text'},
                            //NOKIASC-34979
                            {label: 'Faulty Unit Serial Number', fieldName: 'HWS_Faulty_Serial_Number__c', type: 'text'},
                            {label: 'Planned Delivery Date (User TZ)', fieldName: 'HWS_Planned_Delivery_Date__c', type: 'date',
                            typeAttributes:{
                            day: '2-digit',
                            year: "numeric",
                            month: "short",
                            day: "2-digit",
                            hour: "2-digit",
                            minute: "2-digit",
                            hour12: true
                            }
                            },
                            {label: 'Planned Delivery Date (Ship to TZ)', fieldName: 'HWS_PlannedDeliveryDateShipment__c', type: 'date',
                            	typeAttributes: {
                                     day: 'numeric',
                                     month: 'short',
                                     year: 'numeric',
                                     hour: '2-digit',
                                     minute: '2-digit',
                                     second: '2-digit',
                                     hour12: true,
									 timeZone: userTimeZone
                                 },
                            }					   
                        ]);
                    }
                    //this.getShipToTimeZone(component, event, helper); 
					this.getplannedDeliveryDateTime(component,event,helper);
                }
                else{
                    this.hideWaiting(component);
                    component.set("v.parentcaseStep5", false);
                    component.set("v.ProgressBarCounter",4);
                    component.set("v.ProgressBarNEACounter" ,5);
                    component.set("v.ContProgressBarCounter" ,5); 
                    if(!Emailvalidation){
                        this.hideWaiting(component);
                        EmailFieldShip.setCustomValidity('Please enter a valid EmailId'); //do not get any message
                    }
                    else{
                        EmailFieldShip.setCustomValidity('');
                    }
                    EmailFieldShip.reportValidity(); 
                    if(!phoneNoValidation){
                        this.hideWaiting(component);
                        phoneField.setCustomValidity('Please enter valid Phone number. Phone number should only contain digits(ex: +XXX XX XXXX, XXXXXXXXXX)'); //do not get any message
                        phoneField.reportValidity(); 
                    }
                }
                 
            },
			getPayPerUse : function(component,event,helper){
             var childCaseList = component.get("v.childCases");
             if(childCaseList != null){
                            for(var i=0;i<childCaseList.length;i++){
                                console.log('childcase[i] '+JSON.stringify(childCaseList[i]));
                                var assetId = childCaseList[i].AssetId;
                                var AstIdToAstMap = component.get("v.AstIdToAstMap");
                                var salesBundle=AstIdToAstMap[assetId].HWS_ServiceOffering__c;
                                var price = AstIdToAstMap[assetId].HWS_Price__c;
                                var InvoicingType = AstIdToAstMap[assetId].HWS_ContractLineItem__r.HWS_InvoicingType__c;
                             
                                if (AstIdToAstMap[assetId].HWS_ContractLineItem__r.HWS_WarrantyVerificationRequired__c == 'No') {
                                   
                                    childCaseList[i].HWS_WarrantyStatus__c='Not Applicable';
                                     childCaseList[i].CH_EntitlementException__c='No Exception';
                                    childCaseList[i].CH_EntitlementStatus__c='Entitled (Automated Verification)';    
                                }
                                var isRetroAccount = component.get("v.showRetroAccount");
                                if (isRetroAccount || isRetroAccount == 'true' || isRetroAccount == true) {
                                    childCaseList[i].CH_ServiceType__c = 'Internal Support';   
                                } 
                                if (salesBundle != undefined &&
                                    (salesBundle.includes("RES RFR PU") ||salesBundle.includes("RES AED PU")) && 
                                    (price == "" ||price == null || price == undefined))
                                {
                                    component.set("v.isPayPerPriceFound", true);
                                }
                                if(InvoicingType === 'event based'){
                                    component.set("v.InvoicingTypeEventBased",true);
                                } else {
                                 	component.set("v.InvoicingTypeEventBased",false);   
                                }
                            }
                        }
         },
                //25689
                save: function(component, event, helper) {        
                    var buttonName = event.getSource().getLocalId();
                    //NOKIASC-34199
					var fromSaveNReviewBtn = component.get("v.saveandReviewEnable");
                    var submitToSOO= (buttonName =='saveAndSubmit') ? true : false;
                    var workspaceAPI = component.find("CreateCaseWorkspace");
                    var accountList = component.get("v.selectedAccount");
					//// NOKIASC-37617 -Start- Saving under sold to for global
					if(component.get("v.isGlobal") == true && component.get("v.retroAccId") != undefined && component.get("v.retroAccId") !=null && component.get("v.retroAccId") != '' ) {
        				accountList = component.get("v.retroAccId");
        			}
                    else if(component.get("v.isGlobal") == false && component.get('v.showRetroAccount') == true) {
                        
                        accountList = component.get("v.oldAccount");
                    }
					// NOKIASC-37617 -End
                    var contractLines = component.get("v.selectedAssets");
                    console.log('#contractLines: '+JSON.stringify(contractLines));
                    var versionItems = component.get("v.selectedVersions");
                    var childCase = component.get("v.newChildCase");
                    var childCaseList = component.get("v.childCases");
                    var parentCase = component.get("v.newParentCase");
                    console.log('PARENT CASE DETAILS:'+JSON.stringify(parentCase));
                    var contactid = component.get("v.recordId");
                    var selectedContact = component.get("v.contcatDetails");        
                    var caseInitiationTime = component.get('v.caseStartTime');        
                    component.set("v.saveDisable",true);
                    component.set("v.saveSubmitDisable",true);
                    var searchCode = component.get("v.searchKeyword");
                    //Code Changes for 26952
                    var newAssetList = component.get('v.getAllAssets');
                    console.log('##FinalnewAssetLis##'+JSON.stringify(newAssetList));
                    if(newAssetList != null){
                        for(var i=0;i<newAssetList.length;i++){
                            var getPayPerUse=newAssetList[i].HWS_ServiceOffering__c;
                            if( getPayPerUse != undefined && (getPayPerUse.includes('RES RFR PU') || getPayPerUse.includes('RES AED PU'))){
                                component.set("v.getPayPerUse", true);
                            }
                        }
                    }
				    this.getPayPerUse(component,event);
                    var warrantyCheckFailed = false;
                    /*
                    component.set("v.warrantyCheckFailed",false);
                    console.log('I am hereeeeeee==='+childCaseList.length);
                    if(childCaseList != null){	
                        for(var i=0;i<childCaseList.length;i++){	
                            if(childCaseList[i].HWS_WarrantyStatus__c != 'In Warranty' && childCaseList[i].HWS_WarrantyStatus__c != null && childCaseList[i].HWS_WarrantyStatus__c != '' && childCaseList[i].HWS_WarrantyStatus__c != undefined){	
                                component.set("v.warrantyCheckFailed",true);
                                warrantyCheckFailed = true;
								component.set("v.newParentCase.CH_InternalStatus__c",'Warranty Verification Required');
                                
                            }
                            console.log('TESTSESTSESTSESTSEST==='+JSON.stringify(childCaseList[i]));
                              
                        }	
                    } */
                    var getPO=parentCase.HWS_Customer_PO__c;
                   
                    var isInvoiceType = component.get("v.InvoicingTypeEventBased");
                    console.log('buttonName====>'+buttonName);
                    //console.log('BP====>'+warrantyCheckFailed);
                    console.log('SSSSS===>'+isInvoiceType);
                    console.log('getPO===='+getPO);
                    if(!fromSaveNReviewBtn){
                    //NOKIASC-36802:Re-Order condition for this defects
                     if(buttonName == 'saveAndSubmit' && (getPO==null || getPO=='' || getPO==undefined ||getPO=='undefined') && isInvoiceType) {
                         console.log('++++',getPO);
                         var message = $A.get("$Label.c.HWS_MSG_CustomerPO_Mandatory_Escalate_WQTeam");
                         this.showToastError(component,event,message);
                     }
                     else if(component.get("v.getPayPerUse") && (getPO==null || getPO=='' || getPO==undefined ||getPO=='undefined') && submitToSOO){
                         component.set("v.saveCase", false);   
                         this.showToast('error','Error Message',$A.get("$Label.c.HWS_MSG_CustomerPO_Mandatory_Escalate_CutomerCare"));
                         this.hideWaiting(component);
                         component.set("v.StageNumber", 8);
                         component.set("v.saveDisable",false);
                         component.set("v.saveSubmitDisable",false);
                     }	
                         else if(component.get("v.getPayPerUse") && (getPO==null || getPO=='' || getPO==undefined ||getPO=='undefined') && buttonName !== 'saveAsDraft'&& component.get("v.isPayPerPriceFound") && submitToSOO ){
                             component.set("v.saveCase", false);   
                             this.showToast('error','Error Message',$A.get("$Label.c.HWS_MSG_WarrantyCheckOrQuotationReqrd"));
                             this.hideWaiting(component);
                             component.set("v.StageNumber", 8);
                             component.set("v.saveDisable",false);
                             component.set("v.saveSubmitDisable",false);
                         }
                     //End
                    /*commented as part of NOKIASC-34199
					//Added for NOKIASC-32561
                    else if(warrantyCheckFailed == true)	{
                        submitToSOO = false;	
                        this.showToast('error','Error Message','Warranty status could not be determined for one or more of the parts. Please check Entitlement tab and also the Purchase Order Number is required, please escalate to the Warranty & Quotation team.');	
						//this.showToast('error','Error Message','Warranty status could not be determined for one or more of the parts. Please check Entitlement tab to review');	
                        component.set("v.saveCase", true);	                        	
                        component.set("v.saveDisable",false);	
                        component.set("v.saveSubmitDisable",false);	
                    }*/
                    else if(buttonName == 'saveAndSubmit')
                  {
                     // var message = 'Warranty status could not be determined for one or more of the parts. Please check Entitlement tab and also the Purchase Order Number is required, please escalate to the Warranty & Quotation team.';
                    // this.showToastError(component,event,message);
                     submitToSOO = true;
					 component.set("v.saveCase", true);
        			}
                	}
                    else{
                        if(fromSaveNReviewBtn){
                            parentCase.CH_InternalStatus__c='Under Review';
                        }
                        component.set("v.saveCase", true);  
                    }
                    if(!submitToSOO){
                        component.set("v.saveCase", true); 
                    }
                    
                    var saveCase=component.get("v.saveCase");
                    if(component.get("v.saveCase")===true){
                        var action = component.get('c.createHWSCase');
                        action.setParams({
                            accountList : accountList,
                            contractLines : contractLines,
                            versionItems : versionItems,
                            childCaseList : childCaseList,
                            parentCase : parentCase,
                            contactid : contactid,
                            submitToSOO:submitToSOO,
                            caseInitiationTime : caseInitiationTime,
                            deliveryTimeZone : component.get('v.deliveryTimeZone')
                        });
                        action.setCallback(this, $A.getCallback(function (response) {
                            var state = response.getState();
                            if (state === "SUCCESS") {					
                                var recordid = response.getReturnValue();
                                component.set("v.caseNumber", response.getReturnValue());                    
                                // display toast message
                                if (submitToSOO)
                                {
                                    var actionCallout=component.get('c.makeSOOCallout');
                                    actionCallout.setParams({
                                        parentCaseId : recordid});
                                    actionCallout.setCallback(this, $A.getCallback(function (response) {
                                        var state = response.getState();
                                        component.set("v.ProcessResponse", response.getReturnValue());
                                        var processResponse=component.get("v.ProcessResponse");
                                        if (state === "SUCCESS") {
                                            if(processResponse!=null){
                                                var statuscode=processResponse.statusCode;
                                                
                                                if(statuscode === 200){
                                                 this.showToast('success','Success Message',$A.get("$Label.c.HWS_MSG_Case_Create_SubmitSOO"));
                                                }
                                                else
                                                {
                                                    this.hideWaiting(component);  
                                                 this.showToast('error','Error Message',$A.get("$Label.c.HWS_MSG_Case_Create_NotSubmitSOO"));
                                                }
                                                this.openCaseTab(component, this.getLightningURL(recordid));
                                                this.closeTab(component);
                                                
                                            }
                                        }
                                        else{
                                         this.showToast('error','Success Message',$A.get("$Label.c.HWS_MSG_Case_Create_NotSubmitSOO")+' '+response.getReturnValue());
                                            this.openCaseTab(component, this.getLightningURL(recordid));
                                            this.closeTab(component);
                                            
                                        }
                                    }));
                                    $A.enqueueAction(actionCallout);
                                    
                                }
                                else
                                {
                                    //NOKIASC-34199
                                    if(fromSaveNReviewBtn){
                                     this.showToast('success','Success Message',$A.get("$Label.c.HWS_MSG_Save_Success_CheckReviewTab"));
                                    }
                                    else{
                                     this.showToast('success','Success Message',$A.get("$Label.c.HWS_MSG_Case_Created_Successfully"));
                                    }
                                   /* var navEvt = $A.get("e.force:navigateToSObject");
                                    navEvt.setParams({
                                        "recordId": recordid,
                                        "slideDevName": "Review"
                                    });
                                    navEvt.fire(); */
                                    this.openCaseTab(component, this.getLightningURL(recordid));
                                    this.closeTab(component);
                                    //Navigate to detail page
                                    
                                }
                                
                            } 
                            //Display Error msg for Customer Reference number field
                            else {
                                component.set("v.IsSpinner", false);
                                component.set("v.saveDisable",false);
                                component.set("v.saveSubmitDisable",false);
                                var toastEvent = $A.get("e.force:showToast");
                                var message = '';
                                if (state === "INCOMPLETE") {
                                    message =$A.get("$Label.c.HWS_MSG_Server_ERR_Check_Internet");
                                } else if (state === "ERROR") {
                                    var errors = response.getError();
                                    if (errors) {
                                        for(var i=0; i < errors.length; i++) {
                                            for(var j=0; errors[i].pageErrors && j < errors[i].pageErrors.length; j++) {
                                                message += (message.length > 0 ? '\n' : '') + errors[i].pageErrors[j].message;
                                            }
                                            if(errors[i].fieldErrors) {
                                                for(var fieldError in errors[i].fieldErrors) {
                                                    var thisFieldError = errors[i].fieldErrors[fieldError];
                                                    for(var j=0; j < thisFieldError.length; j++) {
                                                        message += (message.length > 0 ? '\n' : '') + thisFieldError[j].message;
                                                    }
                                                }
                                            }
                                            if(errors[i].message) {
                                                message += (message.length > 0 ? '\n' : '') + errors[i].message;
                                            }
                                        }
                                    } else {
                                        message += (message.length > 0 ? '\n' : '') + 'Unknown error';
                                    }
                                }
                                toastEvent.setParams({
                                    title: 'Error',
                                    type: 'error',
                                    message: message
                                });
                                toastEvent.fire();
                            }//Error code ends 
                        }));
                        $A.enqueueAction(action);  
                    }
                
                },
          getIsTracked: function(component, event, createchildcase){
                        
                        var serialNumber = component.find("faultSerial").get("v.value");
						//29824         
					  if(serialNumber != undefined && serialNumber != null && serialNumber.includes(" ")){  
									var field = component.find('faultSerial');
									field.setCustomValidity('Space not allowed in Serial Number');
									field.reportValidity();
									component.set("v.childcasestep4", false);
									component.set("v.IsSpinner", false);
								}
					  else{
						  var field = component.find('faultSerial');
                            field.setCustomValidity('');
                        var failureOccurrence = component.find("FailureOccurrenceId").get("v.value");
                        var failureDetection = component.find("FailureDetectionId").get("v.value");
                        var failureDescription = component.find("FailureDescriptionId").get("v.value");
                        var failureDetectionDate = component.find("FailureDetectionDate").get("v.value");
                        // var ShipmentName = component.find("ShipmentRecipientName").get("v.value");
                        var isTracable = false;
                        var faultSerialfromApex;
                        var selectedAsset = component.get("v.selectedAssets");
                        //25672
                        if(selectedAsset[0].HWS_ContractLineItem__r.CH_CountryISOName__c !=null){
                            component.set("v.serviceContractCountry", selectedAsset[0].HWS_ContractLineItem__r.CH_CountryISOName__c);
                        }
                        //NOKIASC-25669
                        var country= component.get("v.serviceContractCountry");  
                        var serviceTypeCheck = this.assignServiceType(component);
                        var versionItems = component.get("v.selectedVersions");
                        var emailValidation = false;
                        var phoneValidation = false;
                        var siteIdValidation = true;
                        var addConfigValidation = true;
                        var duplicateSerialnumCheck = false;
                        var dateChangeValidate = false;
                         //NOKIASC-34442
                         var detectionDate = component.get('v.newChildCase.HWS_Failure_Detection_Date__c');
                         var detectionDateValidation = true;
                         if(detectionDate != '' && detectionDate!= undefined){
                             var q = new Date();
                             var m = q.getMonth();
                             var d = q.getDate();
                             var y = q.getFullYear();
                             var today = new Date(y,m,d);
                             var ddate = new Date(detectionDate+" 0:00:00");
                             if ( ddate > today){
                                 detectionDateValidation = false;
                                 component.set("v.spinner",false);
                                 document.getElementById("validateDetectionDate").innerHTML = 'Failure Detection Date cannot be in the future';
                             } else {
                                 document.getElementById("validateDetectionDate").innerHTML = '';
                             }
                         }//NOKIASC-34442
                        emailValidation = this.getEmailValidation(component, event);
                        phoneValidation = this.getPhoneValidation(component, event);
                        dateChangeValidate = this.requestDateChangeValidate(component, event);
						//added for NOKIASC-35931 - START
						if(component.get("v.isServicedAccount") == true){
                           siteIdValidation = this.siteIdValidation(component, event);
                           addConfigValidation = this.additionalConfigValidation(component, event);
                        }
                        var isServicedAccountValidate=  siteIdValidation && addConfigValidation; 
                        //added for NOKIASC-35931 - END
                        duplicateSerialnumCheck = component.get("v.duplicateSerialnumCheck");
                        var action = component.get("c.getSerialNumberInfo");
                        action.setParams({
                            versionItems : versionItems
                        });
                        action.setCallback(this, function(response){
                            var state = response.getState();
                            if (state === "SUCCESS") {
                                component.set("v.IsSpinner", false);
                                faultSerialfromApex= response.getReturnValue();               
                                if(isServicedAccountValidate && dateChangeValidate && duplicateSerialnumCheck && emailValidation && phoneValidation && detectionDateValidation && (faultSerialfromApex.toUpperCase() == 'NO' || ((faultSerialfromApex.toUpperCase() == 'YES' && serialNumber != undefined && serialNumber != '' && serialNumber != null) || serviceTypeCheck == 'Advanced Exchange in Hours')) && (((serviceTypeCheck == 'Return for Repair or Replacement' || serviceTypeCheck == 'Identical Repair' || serviceTypeCheck == 'Advanced Exchange in Days') && ((failureOccurrence != '--None--' && failureOccurrence != undefined && failureOccurrence != '') && (failureDetection != '--None--' && failureDetection != undefined && failureDetection != '') && (failureDescription != '--None--' && failureDescription != undefined && failureDescription != '') && (failureDetectionDate != '--None--' && failureDetectionDate != undefined && failureDetectionDate != ''))) || (serviceTypeCheck == 'Advanced Exchange in Hours'))){
                                    component.set("v.ProgressBarCounter",4);
                                    component.set("v.ProgressBarNEACounter" ,5);
                                    component.set("v.ContProgressBarCounter" ,5);
                                    if(createchildcase == 'createchild'){
                                        component.set("v.childcasestep4", false);     
                                        component.set("v.selectedAssetstep2", false);
                                        component.set("v.selectedLineItemstep2", false);
                                        component.set("v.selectedVersionstep3", false);
                                        component.set("v.newChildAddPart", true);
                                        component.set("v.SelectNEA", false);
                                        component.set("v.SelectConNum", false);
                                        component.set("v.parentcaseStep5", false);
                                        component.set("v.ProgressBarCounter",1);
                                        component.set("v.ProgressBarNEACounter",1);
                                        component.set("v.ContProgressBarCounter",1);    
                                        component.set("v.ContNEAProgressBarCounter",1);      
                                    }
                                    
                                   // this.childCaseCreation(component, event);
                                    //NOKIASC-32212:Check and update warranty status for RFR Service 
                                    //calling childCaseCreation method inside updateWarrantyStatusForRFRServiceType
                					if (serviceTypeCheck=='Return for Repair or Replacement' || serviceTypeCheck == 'Advanced Exchange in Days' || serviceTypeCheck == 'Identical Repair' || serviceTypeCheck == 'Spare Part Sales'){                                                                                  
                                        this.updateWarrantyStatusForRFRServiceType(component,event);                                                                            
                					}
                                    else{
                                        this.childCaseCreation(component, event);
                                    }
                					//End
                                }
                                else{
                                    component.set("v.IsSpinner", false);
                                    component.set('v.isHide1', false);
                                    component.set('v.isHide', false);
                                    if(serviceTypeCheck != 'Advanced Exchange in Hours' && ((failureOccurrence == '--None--' || failureOccurrence == undefined || failureOccurrence == '') || (failureDetection == '--None--' || failureDetection == undefined || failureDetection == '') || (failureDescription == '--None--' || failureDescription == undefined || failureDescription == '') || (failureDetectionDate == '--None--' || failureDetectionDate == undefined || failureDetectionDate == ''))){
                                        this.showToast('error','Error Message',$A.get("$Label.c.HWS_MSG_Failure_Occurrence_Detection_Description_Reqrd")); 
                                        component.set("v.childcasestep4", false);
                                    }
                                    
                                    if(faultSerialfromApex.toUpperCase() == 'YES' && (serialNumber == undefined || serialNumber == '' || serialNumber == null)){                        
                                        var field = component.find('faultSerial');
                                        field.setCustomValidity('Please enter Serial Number , if serial number is unavailable check Serial Number Unknown');
                                        field.reportValidity();
                                        component.set("v.childcasestep4", false);
                                    }
                                    component.set("v.ProgressBarCounter",3);
                                    component.set("v.ProgressBarNEACounter" ,4);
                                    component.set("v.ContProgressBarCounter" ,4);
                                    if(createchildcase == 'createchild'){
                                        component.set("v.selectedVersionstep3", true);
                                        component.set("v.newChildAddPart", false);
                                    }
                                    component.set("v.newChildCaseCheck", false);
                                }
                            }
                        });
                        $A.enqueueAction(action);
					  }
                    },
                        childCaseCreation: function(component, event){
                            var childCaseCheck = component.get("v.newChildCaseCheck");
                            //Start Changes for 26952
                            var listToADDValues = []; 
                            var newAssetListValues = component.get('v.getAllAssets');
                            var assetListValues = component.get("v.selectedAssets");
                            for(var i in newAssetListValues){
                                var oldRecipentValues = newAssetListValues[i];
                                if(oldRecipentValues!=[]){
                                    listToADDValues.push(oldRecipentValues);
                                }
                            }
                            for(var i in assetListValues){
                                var oldRecipentValues = assetListValues[i];
                                if(oldRecipentValues!=[]){
                                    listToADDValues.push(oldRecipentValues);
                                }
                            }
                            component.set('v.getAllAssets',listToADDValues);
                            console.log('##Final'+JSON.stringify(component.get('v.getAllAssets')));
                            //End Changes for 26952
                            if(childCaseCheck){
                                component.set("v.StageNumber", 2);
                                //3952
                                //component.set("v.backDisable", true);
                                //3478
                                component.set("v.showCancelButton", true);
                                var listToADD = [];  
                                var newChildCasesList = component.get('v.childCases');
                                var assetList = component.get("v.selectedAssets");
                                var contractNumber = assetList[0].HWS_Service_Contract_Number__c;
                                var serviceType = this.assignServiceType(component);
                                var cliId = assetList[0].HWS_ContractLineItem__c;
                                console.log('cliId========='+cliId);
                                component.set("v.selectedContractLineItem",cliId);              
                                var prod2Id = assetList[0].Product2Id;
                                var prodName = assetList[0].Product2.Name;
                                var assetId = assetList[0].Id;
                                var parentContractId = assetList[0].HWS_ContractLineItem__r.ServiceContractId;
                                var productId = assetList[0].HWS_ContractLineItem__r.Asset.Product2.Name;
                                var serviceOffering = assetList[0].HWS_ContractLineItem__r.CH_ServiceOffering__c;
                                console.log('child CH_ServiceOffering__c###'+assetList[0].HWS_ContractLineItem__r.CH_ServiceOffering__c);
                                
                                //25662
                                var selNEA = component.get("v.selectedNEA");            
                                if(selNEA != null && selNEA != '' && selNEA != undefined){
                                    var neaId = selNEA[0].CH_NetworkElementAsset__c;
                                }
                                component.set("v.newChildCase.HWS_Contract_Line_Item__c",cliId);
                                //25689	
                                component.set("v.newChildCase.Street_Address_2__c",assetList[0].HWS_ContractLineItem__r.CH_BusinessHour__c);
                                component.set("v.newChildCase.HWS_Sellable_Product__c",prod2Id);
                                //added for single email
                                //component.set("v.newChildCase.NCP_Product_Name__c",prodName);
                                component.set("v.newChildCase.HWS_ServiceType__c",serviceType);
                                component.set("v.newChildCase.NCP_Service_Contract__c",parentContractId);
                                component.set("v.newChildCase.AssetId",assetId);
                                component.set("v.newChildCase.HWS_Part_Code__c",assetList[0].HWS_Part_Code__c);
                                component.set("v.newChildCase.CH_NetworkElementAsset__c",neaId);
                                component.set("v.newChildCase.NCP_Product_Name__c",productId);
                                component.set("v.newChildCase.HWS_Part_Name__c",prodName);
                                component.set("v.newChildCase.HWS_Service_Offering__c",serviceOffering);
                                 
								 var childCase = component.get("v.newChildCase");//NOKIASC-34660
                                //NOKIASC-32212:warrantyStatus and status value initialize for RFR Service  -->                                
                                var faultCode = childCase.HWS_Faulty_Serial_Number__c;	
								if(faultCode !='' && faultCode != null && faultCode != undefined && faultCode.toUpperCase() == 'UNKNOWN'){	
									component.set("v.newChildCase.HWS_WarrantyStatus__c", 'Out of Warranty');	
								}	
								if(faultCode !='' && faultCode != null && faultCode != undefined && faultCode.toUpperCase() != 'UNKNOWN' && (serviceType == 'Return for Repair or Replacement' || serviceType == 'Advanced Exchange in Days' || serviceType == 'Identical Repair' || serviceType == 'Spare Part Sales')){
                                    var warrantyStatus = component.get("v.warrantyStatus");
                                    component.set("v.newChildCase.HWS_WarrantyStatus__c",warrantyStatus);   
                                    //35978
                                    if(warrantyStatus == 'Not Applicable'){
                                        component.set("v.newChildCase.CH_EntitlementException__c",'No Exception');  
                                        component.set("v.newChildCase.CH_EntitlementStatus__c",'Entitled (Automated Verification)');  
                                    }
                                }
                                //end
                                component.set("v.showtestContract",true);
                                component.set("v.contractNumber", contractNumber);
                                component.set("v.selectedContractNumber", contractNumber);
                                component.set("v.serviceType", serviceType);
                                component.set("v.hideFilter",false);
                                var childCase = component.get("v.newChildCase");
                                for(var i in newChildCasesList){
                                    
                                    var oldRecipent = newChildCasesList[i];
                                    if(oldRecipent!=[]){
                                        listToADD.push(oldRecipent);
                                    }
                                }
                                listToADD.push( JSON.parse(JSON.stringify(childCase)));
                                component.set('v.childCases',listToADD);
                                component.set('v.childCaseCreate',true);
                                component.set("v.newChildCaseCheck", false);
                                this.clearChild(component,event);
                                component.set('v.Assets',[]);
                                component.set('v.clis',[]);
                                component.set("v.searchKeyword",'');
                                component.set("v.selectedAssets",'');
                                component.set("v.selectedclis",'');
                                component.set("v.versionItems", null);
                                component.set("v.selectedVersions", null);
                                component.set("v.assetFilterText", null);
                                component.set("v.VersionItemFilterText", null);
                                component.set("v.warrantyStatus",'');
                                var searchCriteria =component.get("v.searchCriteria");
                                var searchType=component.find("InputSelectSingle");
                                searchType.set("v.value",searchCriteria);
                                //this.getServiceContracts(component,event);
                            }else{
                                var assetList = component.get("v.selectedAssets");
                                var contractNumber = assetList[0].HWS_Service_Contract_Number__c;
                                var serviceType = this.assignServiceType(component);
                                var cliId = assetList[0].HWS_ContractLineItem__c;
                                component.set("v.selectedContractLineItem",cliId); 
                                var prod2Id = assetList[0].Product2Id;
                                var prodName = assetList[0].Product2.Name;
                                var assetId = assetList[0].Id;
                                var parentContractId = assetList[0].HWS_ContractLineItem__r.ServiceContractId;
                                var productId = assetList[0].HWS_ContractLineItem__r.Asset.Product2.Name;
                                var serviceOffering = assetList[0].HWS_ContractLineItem__r.CH_ServiceOffering__c;                                
                                //25662
                                var selNEA = component.get("v.selectedNEA");            
                                if(selNEA != null && selNEA != '' && selNEA != undefined){
                                    var neaId = selNEA[0].CH_NetworkElementAsset__c;
                                }
                                component.set("v.newChildCase.HWS_Contract_Line_Item__c",cliId);
                                //25689	
                                component.set("v.newChildCase.Street_Address_2__c",assetList[0].HWS_ContractLineItem__r.CH_BusinessHour__c);
                                component.set("v.newChildCase.HWS_Sellable_Product__c",prod2Id);
                                //Added for single email
                                //component.set("v.newChildCase.NCP_Product_Name__c",prodName);
                                component.set("v.newChildCase.HWS_ServiceType__c",serviceType);
                                component.set("v.newChildCase.NCP_Service_Contract__c",parentContractId);
                                component.set("v.newChildCase.AssetId",assetId);
                                component.set("v.newChildCase.HWS_Part_Code__c",assetList[0].HWS_Part_Code__c);
                                component.set("v.newChildCase.CH_NetworkElementAsset__c",neaId);
                                component.set("v.newChildCase.NCP_Product_Name__c",productId);
                                component.set("v.newChildCase.HWS_Part_Name__c",prodName);
                                component.set("v.newChildCase.HWS_Service_Offering__c",serviceOffering);
                                component.set("v.contractNumber", contractNumber);
                                //component.set("v.selectedContractNumber", contractNumber); 
                                //component.set("v.serviceType", serviceType); 
                                //NOKIASC-32212:warrantyStatus and status value initialize for RFR Service  -->   
								var childCase = component.get("v.newChildCase"); //NOKIASC-34660								
                                var faultCode = childCase.HWS_Faulty_Serial_Number__c;	
							if(faultCode !='' && faultCode != null && faultCode != undefined && faultCode.toUpperCase() == 'UNKNOWN'){	
								component.set("v.newChildCase.HWS_WarrantyStatus__c", 'Out of Warranty');	
							}							
							if(faultCode !='' && faultCode != null && faultCode != undefined && faultCode.toUpperCase() != 'UNKNOWN' && (serviceType == 'Return for Repair or Replacement' || serviceType == 'Advanced Exchange in Days' || serviceType == 'Identical Repair' || serviceType == 'Spare Part Sales')){
                                    var warrantyStatus = component.get("v.warrantyStatus");
                                    component.set("v.newChildCase.HWS_WarrantyStatus__c",warrantyStatus); 
                                    //35978
                                    if(warrantyStatus == 'Not Applicable'){
                                        component.set("v.newChildCase.CH_EntitlementException__c",'No Exception');  
                                        component.set("v.newChildCase.CH_EntitlementStatus__c",'Entitled (Automated Verification)');  
                                    }
                                }
                                //end
                                component.set("v.assetFilterText", null);
                                component.set("v.VersionItemFilterText", null);
                                component.set("v.warrantyStatus",'');
                                var childCase = component.get("v.newChildCase");
                                var listToADD = [];  
                                var newChildCasesList = component.get('v.childCases');
                                for(var i in newChildCasesList){
                                    var oldRecipent = newChildCasesList[i];
                                    if(oldRecipent!=[]){
                                        listToADD.push(oldRecipent);
                                    }
                                }
                                listToADD.push( JSON.parse(JSON.stringify(childCase)));
                                component.set('v.childCases',listToADD);
                                component.set("v.StageNumber", 5);
                                	var isRetroAccount = component.get("v.showRetroAccount");	
if ((isRetroAccount || isRetroAccount == 'true' || isRetroAccount == true)) {	
var selectedAccountName = component.get("v.selectedRetroAccount");	
var countryNametoSet = component.get("v.selectedCountryName");	
var retroAccountcmp = component.find("retroAccount1");	
var accountId = component.get('v.selectedRetroAccount').Id;	
console.log('retroAccountcmp==='+retroAccountcmp);	
retroAccountcmp.setLookupvalues(selectedAccountName,countryNametoSet, accountId);	
}
                                //3952
                                //component.set("v.backDisable", true);
                                //3478
                                component.set("v.showCancelButton", false);
                                component.set("v.newChildCaseCheck", false);
                            }
                        },
                            GetSPSTracked: function(component, event,createchildcase){
                                component.set("v.IsSpinner", false);
                                var childCase = component.get("v.newChildCase");
                                var listToADD = [];
                                var newChildCasesList = component.get('v.childCases'); 
                                var Quantity =  component.find('Quantity').get("v.value");
                                var childCaseCheck = component.get("v.newChildCaseCheck");
                                var selectedAsset = component.get("v.selectedAssets");
                                //25672
                                if(selectedAsset[0].HWS_ContractLineItem__r.CH_CountryISOName__c !=null){
                                    component.set("v.serviceContractCountry", selectedAsset[0].HWS_ContractLineItem__r.CH_CountryISOName__c);
                                }
                                //25669
                                var country=component.get("v.serviceContractCountry");
                                
                                var serviceTypeCheck = this.assignServiceType(component);
                                
                                var dateChangeValidate = false;
                                dateChangeValidate = this.requestDateChangeValidate(component, event);
                                //var validateDate = component.get('v.dateValidationError');
                                if(!($A.util.isEmpty(Quantity)) && Quantity != null && Quantity !=''&& serviceTypeCheck == 'Spare Part Sales' && dateChangeValidate){
                                    this.childCaseCreation(component, event);  
                                }else{
                                    if(($A.util.isEmpty(Quantity)) || Quantity == null || Quantity ==''){
                                        var field1 = component.find('Quantity');
                                        field1.showHelpMessageIfInvalid();
                                        component.set('v.isHide1', false);
                                    }
                                    component.set("v.newChildCaseCheck", false);
                                }
                                
                            },
                                duplicateSerialnumCheck: function(component, event, createchildcase){
                                    
                                    var serialNumber = component.find('faultSerial').get("v.value");  
                                    var contractLines = component.get("v.selectedAssets");
                                    var duplicateSerialnumCheck = false;
                                    var childCaseCheck = component.get("v.newChildCaseCheck");
                                    var newChildCasesList = component.get('v.childCases');
                                    var action = component.get("c.duplicateSerialNumberInfo");
                                    action.setParams({
                                        "serialNumber" : serialNumber,
                                        materialCode  : contractLines[0].HWS_Part_Code__c
                                    });
                                    
                                    action.setCallback(this, function(response) {
                                        var state = response.getState();
                                        
                                        if (state === "SUCCESS") {
                                            var dupSerfromApex = response.getReturnValue();
                                            
                                            if(!$A.util.isEmpty(dupSerfromApex) &&  dupSerfromApex != '' &&  dupSerfromApex != null){
                                                console.log('DuplicateSNum '+dupSerfromApex);
                                                component.set("v.duplicateSerialnumCheck",false);
                                                var sNumBooleanAttribute = component.get("v.duplicateSerialnumCheck");
                                                var resultsToast = $A.get("e.force:showToast");
                                                resultsToast.setParams({
                                                    title : 'Error Message',
                                                    mode: 'dismissible',
                                                    type: 'error',
                                                    key: 'info_alt',
													duration:'10000',
                                                    message: 'message',
                                                    messageTemplate: 'Sorry, Cannot proceed with case creation as entered serial number and {0} pending for closure! {1}',
                                                    messageTemplateData: ['material code is part of an existing case', {
                                                        url: $A.get("$Label.c.Duplicate_SerialNumber")+dupSerfromApex[0].Id,
                                                        label: 'Case Number: '+dupSerfromApex[0].CaseNumber
                                                    }]   
                                                });
                                                resultsToast.fire();
                                                
                                            }  
                                            else if(newChildCasesList.length !== 0){
                                                var faultCodeList =[];
                                                for(var i in newChildCasesList){
                                                    var faultCode = newChildCasesList[i].HWS_Faulty_Serial_Number__c;
                                                    if(faultCode !='' && faultCode != null && faultCode != undefined && faultCode.toUpperCase() != 'UNKNOWN'){
                                                        faultCodeList.push(faultCode.toUpperCase());
                                                    }
                                                }
                                                if(faultCodeList.includes(serialNumber.toUpperCase())){
                                                    this.showToast('error','Error Message',$A.get("$Label.c.HWS_MSG_Faulty_Serial_Reqrd"));
                                                    component.set("v.duplicateSerialnumCheck",false);  
                                                    var sNumBooleanAttribute = component.get("v.duplicateSerialnumCheck");
                                                    component.set("v.childcasestep4",false);
                                                }
                                                else{
                                                    component.set("v.duplicateSerialnumCheck",true);
                                                    var sNumBooleanAttribute = component.get("v.duplicateSerialnumCheck");                    
                                                }                     
                                            }else{
                                                component.set("v.duplicateSerialnumCheck",true);
                                                var sNumBooleanAttribute = component.get("v.duplicateSerialnumCheck");                    
                                            } 
                                            this.getIsTracked(component, event, createchildcase); // this function is called after success of duplicate num check
                                        }
                                    });
                                    $A.enqueueAction(action);
                                    
                                },
                                    /* getParentAccount : function(component, event){
        var action = component.get("c.getParentAccountId");
        action.setParams({ contactId : component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var stringItems = response.getReturnValue();
                
                component.set("v.defaultAccount", stringItems);
                
            }
        });
        $A.enqueueAction(action);
    },*/
        getCaseInitiationTime : function(component, event){
            var action =component.get("c.getCaseInitiationTime");
            action.setCallback(this, function(response) {                       
                var caseInitiationTime = response.getReturnValue();
                //var caseInitiationTime = caseInitiationTime1.toString();
                component.set("v.caseStartTime",caseInitiationTime);            
            });
            $A.enqueueAction(action);
        },
            //added for US-3205 to get Contact Name
            /* getContactName : function(component, event, helper) {        
        var id = component.get("v.recordId");                
        var action =component.get("c.getContactName");
        action.setParams({
            contactid: id
        });                
        action.setCallback(this, function(response) {                       
            var contactName = response.getReturnValue();
            component.set("v.ContactName",contactName);            
        });
        $A.enqueueAction(action);
    },*/
        /* getContactType : function(component, event, helper) {
        var id = component.get("v.recordId");
        var action =component.get("c.getContactType");
        action.setParams({
            contactid: id
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if(response.getReturnValue()=='Communication Contact'){
                component.set("v.isCommunicationContact","true");
                component.set("v.communicationContactMessage",'Contact is a Communication Contact and Support Tickets cannot be initiated.')
            }
            else{
                component.set("v.isCommunicationContact","false");
            }
        });
        $A.enqueueAction(action);
    },*/
        getContactDetails : function(component, event, helper) {
           
            var id = component.get("v.recordId");
            var action =component.get("c.getContactDetails");
            console.log('idn'+ id);
            action.setParams({
                contactId: id
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                var con = response.getReturnValue(); 
                component.set("v.contcatDetails",con);
                component.set("v.ContactName",con.Name);
                component.set("v.ContactName",con.Name);
				//component.set("v.contactId1",con.Id);
				component.set("v.newParentCase.CH_Email2__c",con.Email1__c);//Nokiasc-27247
                component.set("v.newParentCase.CH_Email3__c",con.CH_Email3__c);//Nokiasc-27247
                component.set("v.defaultAccount", con.AccountId);
                if(con.CH_ContactType__c=='Communication Contact'){
                    component.set("v.isCommunicationContact","true");
                    component.set("v.communicationContactMessage",'Contact is a Communication Contact and Support Tickets cannot be initiated.')
                }
                else{
                    component.set("v.isCommunicationContact","false");
                }
            });
            $A.enqueueAction(action);
        },
            
            //ESCALATE CASE HELPER CODE 
            createEscCase: function(component,event,helper){
                this.showWaiting(component);
                var accountList;
                if (component.get("v.selectedAccount")!=null){
                    accountList = component.get("v.selectedAccount");
                }
                var contactId = component.get("v.recordId");  
                var escalationCase = component.get("v.newEscalationCase");
                var action= component.get("c.ecsalateCase"); 
                action.setParams({contactId : contactId, accList : accountList,escCase : escalationCase});
                action.setCallback(this, $A.getCallback(function (response) {
                    var state;
                    if (response!=null){
                        state = response.getState();
                    }
                    
                    if (state === "SUCCESS"){
                        this.hideWaiting(component);
                        var can = response.getReturnValue();
                        if (component.get("v.StageNumber")!=1){
                            component.set("v.StageNumber", 1);//NAVIGATING TO LEGAL ENTITY SCREEN
                            component.set("v.selectedAccount",null);
                        }
                        this.showToast('success','Success',$A.get("$Label.c.HWS_MSG_Case_Create_Escalate_to_CaPM")+can[0].CaseNumber);  
                    }else{
                        this.showToast('error','Error',$A.get("$Label.c.HWS_MSG_Case_NotEscalate_Due_to_InternalProblem"));
                        this.hideWaiting(component);
                    }
                }));
                $A.enqueueAction(action);
            },
                /*showWaitingHelper : function(component){
        component.set("v.IsSpinner",true);
    },
    hideWaitingHelper : function(component){
        component.set("v.IsSpinner",false);  
    },
    setFocusedTabLabel : function(component, event, helper) {
        var workspaceAPI = component.find("CreateCaseWorkspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.setTabLabel({
                tabId: focusedTabId,
                label: "Create Case"
            });
            workspaceAPI.setTabIcon({
                tabId: focusedTabId,
                icon: "action:new_case",
                iconAlt: "Create Case" 
            });
            workspaceAPI.focusTab({
                tabId : response                
            }); 
        })
        .catch(function(error) {
            console.log(error);
        });
    },*/
        // Set Tab Icon and Label - added for the US-3196, 3198 - start
        setTabIcon : function(component) {
            //Js Controller
            var workspaceAPI = component.find("CreateCaseWorkspace");        
            workspaceAPI.getEnclosingTabId().then(function(response) {            
                workspaceAPI.setTabLabel({
                    tabId: response.subtabId,
                    label: "Create Case" //set label you want to set
                    //title: "Create Case"                
                });
                workspaceAPI.setTabIcon({
                    tabId: response.subtabId,
                    icon: "action:new_case", //set icon you want to set
                    iconAlt: "Create Case" //set label tooltip you want to set
                });
                workspaceAPI.focusTab({
                    tabId : response.subtabId               
                }); 
            })
        },
            openCaseTab : function(component, newCaseURL) {
                var workspaceAPI = component.find("CreateCaseWorkspace");
                workspaceAPI.openTab({
                    url: newCaseURL,
                    focus: true
                });
            },
                getLightningURL: function(recordId) {
                    return '/one/one.app?#/sObject/' + recordId + '/view';
                },
                    closeTab : function(component) {
                        var workspaceAPI = component.find("CreateCaseWorkspace");        
                        workspaceAPI.getEnclosingTabId().then(function(response) {
                            workspaceAPI.closeTab({
                                tabId : response
                            })
                            .catch(function(error) {
                                console.log(error);
                            });
                        })
                    },
                        // Set Tab Icon and Label - added for the US-3196, 3198 - end
                        getRelatedAccounts : function(component, event, helper) {
                            component.set('v.AccountColumns', [
                                //NOKIASC-29400
                                {label: 'Name', fieldName: 'linkName', type: 'url', typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'}},
                                {label: 'Account Number', fieldName: 'AccountNumber', sortable: 'true', type: 'text'},
                                {label: 'Country', fieldName: 'Country__c', sortable: 'true', type: 'text'},
                                {label: 'City', fieldName: 'BillingCity', sortable: 'true', type: 'text'},
                                {label: 'Street', fieldName: 'BillingStreet', sortable: 'true', type: 'text'},
								{label: 'Operational Customer Name', fieldName: 'OperationalCustomerName__c', type: 'text'},
                                								
                            ]);
                            component.set('v.VersionItemColumns', [
                                {label: 'Part Revision', fieldName: 'HWS_Product_Name__c', type: 'text'},
                                {label: 'Version Code', fieldName: 'HWS_Version_Code__c', type: 'text'},
                                {label: 'CLEI Code', fieldName: 'CLEI__c', type: 'text'},
                                {label: 'Comcode', fieldName: 'Comcode__c', type: 'text'}
                            ]);
                            var id = component.get("v.recordId");            
                            var action =component.get("c.getAllAccounts");
                            action.setParams({
                                contactid: id
                            });
                            action.setCallback(this, function(response){
                                var state = response.getState();
                                if(response.getReturnValue()==null){
                                    component.set("v.isActive","false");
                                    component.set("v.cntInactiveMessage",'Contact is inactive and Support Tickets cannot be initiated.')
                                }
                                else{
                                    //US-3199 code added Legal Account hyper link
                                    var records =response.getReturnValue();
                                   
                                    records.forEach(function(record){
                                        //record.linkName = this.getLightningURL(record.Id);
                                        record.linkName ='/one/one.app?#/sObject/' + record.Id + '/view';
                                    });
                                    //NOKIASC-34276 default account selection
                                    var accrec =response.getReturnValue();
                                    var selectedRowsIds = [];
                                    if(accrec.length == 1){
                                        selectedRowsIds.push(accrec[0].Id); 
                                    }
									component.set("v.isActive","true");
                                    component.set("v.conAccounts", response.getReturnValue());
                                    component.set("v.AllAccounts", response.getReturnValue());
                                    //NOKIASC-34276
                                    var dTable = component.find("inputFieldsToCheck");       
                                    if(accrec.length == 1){
                                        dTable.set("v.selectedRows", selectedRowsIds);
                                        //for Next button  
                                        component.set("v.enableAccount", false);
                                        component.set("v.selectedAccount", response.getReturnValue());
                                        component.set("v.oldAccount", response.getReturnValue());
                                        component.set("v.legalEntityNotFound", true);
                                    }
                                }
                            });
                            $A.enqueueAction(action);
                        },
                            //NOKIASC-25662--Commented due to performence issue
                          /*  getNetworkElementAssets : function(component, accountId, cliId) {
                                var assets = component.get("v.AllAssets");    
                                var searchCrit = component.get("v.searchCriteria");
                                var CLIIDS = [];
                                if(assets != null && searchCrit == 'Part Code'){
                                    for(var i=0;i<assets.length;i++){
                                        CLIIDS.push(assets[i].HWS_ContractLineItem__c);
                                    }
                                }
                                var clitems = component.get("v.clis");
                                if(clitems != null && searchCrit == 'Contract Number'){
                                    for(var i=0;i<clitems.length;i++){
                                        CLIIDS.push(clitems[i].Id);
                                    }
                                }
                                var action =component.get("c.getNEA");  
                                action.setParams({
                                    accId : accountId,
                                    cliId : cliId,
                                    cliIdList : CLIIDS
                                });
                                action.setCallback(this, function(response){
                                    var state = response.getState();            
                                    var neaList = response.getReturnValue();            
                                    for(var i = 0; i < neaList.length; i++) {
                                        neaList[i].URL = '/one/one.app?#/sObject/' + neaList[i].Id + '/view';
                                        neaList[i].Address = neaList[i].Address__r?neaList[i].Address__r.CH_AddressDetails__c :'N/A';
                                        neaList[i] = this.setObjectNameUrl(neaList[i], 'Product2', 'Product');
                                        neaList[i] = this.setObjectNameUrl(neaList[i], 'CH_Solution__r', 'Solution');
                                        neaList[i] = this.setObjectNameUrl(neaList[i], 'CH_ProductVariant__r', 'Variant');
                                        neaList[i] = this.setObjectNameUrl(neaList[i], 'CH_ProductRelease__r', 'Release');
                                        if(neaList[i].Id === component.get("v.selected")) {
                                            selected = true;
                                            component.find("neaTable").setSelectedRows(new Array(neaList[i].Id));
                                        }
                                        
                                    } 
                                   
                                    component.set('v.netElemAssets',neaList);
                                    component.set('v.showAllNEA',neaList);
                                });
                                $A.enqueueAction(action);
                                /*var selNEA= component.get("v.selectedNEA");
                                var selAst = component.get("v.selectedAssets");	
                                var selCLI = component.get("v.selectedclis");	
                                var selAstCheck = false;	
                                var selCLICheck = false;	
                                if((selAst != null && selAst != '' && selAst != undefined) || (selCLI != null && selCLI != '' && selCLI != undefined)){	
                                    if(selAst != null && selAst != '' && selAst != undefined){	
                                        selAstCheck = true;	
                                        var selAsset=JSON.parse(JSON.stringify(selAst[0]));	
                                        var oldAsset = component.get("v.oldSelectedAssets");	
                                    }	
                                    if(selCLI != null && selCLI != '' && selCLI != undefined){	
                                        selCLICheck = true;	
                                        var selCLItem=JSON.parse(JSON.stringify(selCLI[0]));	
                                        var oldCLItem = component.get("v.oldSelectedclis");	
                                    }	                                    	
                                    if((selAstCheck && (selAsset.Id==oldAsset || (oldAsset == null || oldAsset == '' || oldAsset == undefined)))	
                                       || (selCLICheck && (selCLItem.Id==oldCLItem || (oldCLItem == null || oldCLItem == '' || oldCLItem == undefined)))){
                                        if(selNEA!=null && selNEA!='' && selNEA!=undefined){
                                            var dTable = component.find("nea");					
                                            if(dTable != null && dTable != '' && dTable != undefined){
                                                var selectedNEA = dTable.getSelectedRows();
                                            }
                                            var sNEA = component.get("v.selectedNEA");
                                            if (typeof sNEA != 'undefined' && sNEA) {
                                                var selectedRowsIds = [];
                                                for(var i=0;i<sNEA.length;i++){
                                                    selectedRowsIds.push(sNEA[i].Id);  
                                                }         
                                                var dTable = component.find("nea");						
                                                if(dTable != null && dTable != '' && dTable != undefined){
                                                    dTable.set("v.selectedRows", selectedRowsIds);
                                                }
                                            }
                                        }
                                    }else{
                                        component.set("v.versionItems", null);
                                        component.set("v.AllversionItems", null);
                                        component.set("v.selectedVersions", null);
                                        component.set("v.selectedNEA",null);
                                        //component.set('v.showVI',false);
                                        component.set('v.enableVI',true);
										component.set('v.enableNea',true);
                                    }
                                }
                            },*/
                                setObjectNameUrl: function(entry, object, key) {
                                    entry[key+'URL'] = (entry[object] != null)?('/one/one.app?#/sObject/' + entry[object].Id + '/view'):'';
                                    entry[key+'Name'] = (entry[object] != null)?entry[object].Name:'';
                                    return entry;
                                },
	//25689
    getShipToTimeZone : function(component, event, helper) {
        var childCasesList = component.get("v.childCases");
        var bhIdList = [];
        for(var i=0;i<childCasesList.length;i++){            
            bhIdList.push(childCasesList[i].Street_Address_2__c);
        }
        console.log('Business Id'+bhIdList);
        var action =component.get("c.getShipToTimeZone");
        action.setParams({
            selectedAccount: component.get('v.ShiptopartyAddress'),
            businessHourIdList : bhIdList,
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var stringTimeZoneMap = response.getReturnValue();                
                if(Object.keys(stringTimeZoneMap).includes("Account")){
                    component.set("v.shipToTimeZone", "Account");
                    component.set("v.shipToTimeZoneMap",stringTimeZoneMap["Account"]);
                    
                }
                else if(Object.keys(stringTimeZoneMap).includes("BusinessHour")){
                   component.set("v.shipToTimeZone", "BusinessHour");
                   component.set("v.shipToTimeZoneMap",stringTimeZoneMap["BusinessHour"]);
                   
                }                
            }
             this.handleCustReqShipmentDate(component,event,helper);
        });
        $A.enqueueAction(action);
    }, 
        //show list of Version Item details
    gotoStep3: function(component, event, helper) {
        //2503 SPS Last Order Date validation started
        console.log('Entered on non NEA TEST ##');
		var selAsset = component.get("v.selectedAssets");        
        if (selAsset != null && selAsset != '' && selAsset != undefined && selAsset[0].HWS_ContractLineItem__r.CH_QtyCoveredNetworkElementAssets__c == 0) {      
            component.set("v.selectedNEA", null);
        }
        var cli = component.get("v.selectedclis");
        if (cli != null && cli != '' && cli != undefined && cli[0].CH_QtyCoveredNetworkElementAssets__c == 0) {
            component.set("v.selectedNEA", null);
        } 
        component.set("v.SelectConNum" ,true);
        component.set("v.ProgressBarCounter" ,2);
        component.set("v.ProgressBarNEACounter" ,3);
        component.set("v.ContProgressBarCounter" ,3);
        component.set("v.ContNEAProgressBarCounter" ,4);
        //component.set("v.selectedAssetstep2", true);
        //component.set("v.selectedLineItemstep2", true);
        var selNEA = component.get("v.selectedNEA");            
        if(selNEA != null && selNEA != '' && selNEA != undefined){
            component.set("v.SelectNEA",true);
        }
        // Start Changes for US-26951
            if(component.get("v.toProceedSPSLOD")){
                this.showToast('error','Error Message',$A.get("$Label.c.HWS_MSG_Part_LastOrder_Passed"));
            }
        else{
            this.getVersionItems(component, event);
        }
        //2503 SPS Last Order Date validation Ended
        // this.getVersionItems(component, event);
        // added for US-3205 to display Asset Name in main Case Flow 
        var assets = component.get("v.selectedAssets");  
        component.set("v.VersionItemFilterText", null);
        if(assets && assets.length) {
            component.set("v.ProductCode", assets[0].HWS_Part_Code__c);
        }
        var selectedNEA = component.get("v.selectedNEA");     
        var stageNum = component.get("v.StageNumber");
        /*if(stageNum == 3 && (selectedNEA == null || selectedNEA == undefined || selectedNEA =='')){
            this.showToast('error','Error Message','Please select Network Element Asset before proceeding');
            component.set("v.StageNumber",7);
            //component.set("v.ProgressBarCounter" ,2);
            component.set("v.ProgressBarNEACounter" ,2);
            component.set("v.ContProgressBarCounter" ,2);
            component.set("v.ContNEAProgressBarCounter" ,3);
            
        }
        */
    },
        //NOKIASC-25662
    selectNetworkElementAsset : function(component, event, helper){
        component.set("v.SelectNEAProgress",true);
        component.set("v.selectedAssetstep2", true);
        var clis = component.get("v.clis");
        if(clis != null && clis != '' && clis != undefined){
            component.set("v.ContractNumNEAProgress", true);
            component.set("v.ContNEAProgressBarCounter", 2);
            
        }
        component.set("v.SelectNEA",false);
        //progress Bar changes starts
        var selecNEA = component.get("v.selectedNEA");
        if(selecNEA != null && selecNEA != '' && selecNEA != undefined){
          component.set("v.SelectNEA",true);  
        }
        component.set("v.ProgressBarNEACounter",2);
        component.set("v.StageNumber",7);        
        component.set('v.neaColumns', [
            {label: 'Network Element ID', fieldName: 'CH_NetworkElementID__c', sortable: 'true', searchable: 'true', type: 'text'},
            {label: 'Asset Name', fieldName: 'URL', sortable: 'true', searchable: 'true', type: 'url', typeAttributes: {
                label: { fieldName: 'Name' }
            }},
            {label: 'Product', fieldName: 'ProductURL', sortable: 'true', searchable: 'true', type: 'url', typeAttributes: {
                label: { fieldName: 'ProductName' }
            }},
            {label: 'Solution', fieldName: 'SolutionURL', sortable: 'true', searchable: 'true', type: 'url', typeAttributes: {
                label: { fieldName: 'SolutionName' }
            }},
            {label: 'Product Variant', fieldName: 'VariantURL', sortable: 'true', searchable: 'true', type: 'url', typeAttributes: {
                label: { fieldName: 'VariantName' }
            }},
            {label: 'Product Release', fieldName: 'ReleaseURL', sortable: 'true', searchable: 'true', type: 'url', typeAttributes: {
                label: { fieldName: 'ReleaseName' }
            }},
            {label: 'Address', fieldName: 'Address', sortable: 'true', searchable: 'true', type: 'text'},
            {label: 'Lab', fieldName: 'CH_LabEnvironment__c', sortable: 'true', type: 'boolean'},        
            {label: 'Country', fieldName: 'CH_CountryISOName__c', searchable: 'true', type: 'hidden'}
        ]);
        var conAccounts = component.get('v.conAccounts');
        var selectedAsset = component.get("v.selectedAssets");
        var selectedCLI = component.get("v.selectedclis");
        var cliId = null;        
        //console.log('SEL ASSET:'+selectedAsset[0].HWS_ContractLineItem__c);
        if(selectedAsset != undefined && selectedAsset != '' && selectedAsset != null){
            cliId = selectedAsset[0].HWS_ContractLineItem__c;
        }  if(selectedCLI != undefined && selectedCLI != '' && selectedCLI != null){
            cliId = selectedCLI[0].Id;
        } 
        component.set("v.selectedContractLineItem",cliId); 
        component.set("v.NEAFilterText",'');
        this.getNetworkElementAssets(component,conAccounts[0].Id,cliId);
    },
   gotoStep6: function(component,event,helper){
        //2503 SPS Last Order Date validation started
        var selCLI = component.get("v.selectedclis");
        if(selCLI != null && selCLI != '' && selCLI != undefined)
            if(selCLI[0].CH_QtyCoveredNetworkElementAssets__c == 0){
                component.set("v.showVI",true);
            } else{
                component.set("v.showVI",false);
            }
        component.set("v.selectedAssetstep2",true);
        component.set("v.selectedLineItemstep2",true);
        var clis = component.get("v.clis");
        if(clis != null && clis != '' && clis != undefined){
            console.log('enter NEA for ### clis'+JSON.stringify(component.get("v.clis")));
            component.set("v.ContractNumProgress" ,true);
            component.set("v.ContProgressBarCounter" ,2);
            
        }
        var selNEA = component.get("v.selectedNEA");            
        if(selNEA != null && selNEA != '' && selNEA != undefined && clis != null && clis != '' && clis != undefined){
            console.log('contract number true and Select NEA > 0');
            component.set("v.SelectNEA" ,true); 
            component.set("v.ContNEAProgressBarCounter" ,3);
        }
        
        if(component.get("v.toProceedSPSLOD")){
            this.showToast('error','Error Message',$A.get("$Label.c.HWS_MSG_Part_LastOrder_Passed"));
        }
        else{
            this.getSellableItems(component,event);    
        }
        //2503 SPS Last Order Date validation Ended
        //this.getSellableItems(component,event);     
        component.set("v.assetFilterText", null); 
    },
   open2: function(component, event, helper) {  
        console.log('Entered here open2');
        component.set("v.ProgressBarCounter",1);
        component.set("v.ProgressBarNEACounter",1);
        component.set("v.ContProgressBarCounter", 1);
       // progress bar change start
        component.set("v.selectedAssetstep2",true);
        component.set("v.selectedLineItemstep2",true);
         // progress bar change Ends
        component.set("v.ContractNumNEAProgress", false);
        component.set("v.SelectNEAProgress",false); 
        var clis = component.get("v.clis");
        if(clis != null && clis != '' && clis != undefined){
            console.log('enter NEA for clis'+component.get("v.clis"));
            component.set("v.ContractNumProgress" ,false);
        }
       
       component.set("v.StageNumber", 2);
        var selectedAssets = component.get("v.selectedAssets");
        var selectedClis = component.get("v.selectedclis");
        var showAssets = component.get("v.showAssets");
        var showClis = component.get("v.showClis");                
        component.set("v.assetFilterText", '');
        component.set("v.Assets",component.get("v.AllAssets"));
        component.set("v.VersionItemFilterText", '');
        component.set("v.versionItems",component.get("v.AllversionItems"));
        if(showAssets=='true'){
            
            var searchType=component.find("InputSelectSingle");
            searchType.set("v.value",'Part Code');
            var dTable = component.find("cliTable");
            var selectedAcc = dTable.getSelectedRows();
            var selectedAcc = component.get("v.selectedAssets")
            if (typeof selectedAcc != 'undefined' && selectedAcc) {
                var selectedRowsIds = [];
                for(var i=0;i<selectedAcc.length;i++){
                    selectedRowsIds.push(selectedAcc[i].Id);  
                }         
                var dTable = component.find("cliTable");
                dTable.set("v.selectedRows", selectedRowsIds);
                component.set("v.oldSelectedAssets",dTable.get("v.selectedRows"));
            }
        }
        if(showClis=='true'){
            var searchType=component.find("InputSelectSingle");
            searchType.set("v.value",'Contract Number');
            var dTable = component.find("conTable");
            var selectedCli = dTable.getSelectedRows();
            console.log('selected rows'+selectedCli);
            var selectedCli = component.get("v.selectedclis")
            if (typeof selectedCli != 'undefined' && selectedCli) {
                var selectedRowsIds = [];
                for(var i=0;i<selectedCli.length;i++){
                    selectedRowsIds.push(selectedCli[i].Id);  
                }         
                var dTable = component.find("conTable");
                dTable.set("v.selectedRows", selectedRowsIds);
                component.set("v.oldSelectedclis",dTable.get("v.selectedRows"));
            }
        }
        var selectedNEA = component.get("v.selectedNEA");
        var buttonName = event.getSource().getLocalId();
        var neaButton= (buttonName=='neaNext') ? true :false;
        if(neaButton && (selectedNEA == null || selectedNEA == undefined || selectedNEA =='')){
            this.showToast('error','Error Message',$A.get("$Label.c.HWS_MSG_NEA_Mandatory"));
            component.set("v.StageNumber",7);
        }
    },
    //25689 To handle the Requested Date Shipment function from Dlivery Info screen in line Edit
    handleCustReqShipmentDate: function(component,event,helper) {       
       	var childCasesList = component.get("v.childCases");        
       	var reqVal = true;
        var countryTimezone = 'GMT';
        var shipToTimeZone = component.get("v.shipToTimeZone");        
        var shipToTimeZoneMap = component.get("v.shipToTimeZoneMap");
		//NOKIASC-34199
		var assetIdlistFinal = [];
        if(childCasesList){            
            for(var i=0;i<childCasesList.length;i++){
				assetIdlistFinal.push(childCasesList[i].AssetId);
                var requestedDate = childCasesList[i].HWS_Requested_Delivery_Date_Time__c; 
                if(childCasesList[i].HWS_Requested_Delivery_Date_Time__c != null && childCasesList[i].HWS_Requested_Delivery_Date_Time__c != undefined){
						childCasesList[i].Street_Address_3__c =  null;                                           
                        
                        if(shipToTimeZone == 'Account'){
                            countryTimezone = shipToTimeZoneMap[component.get('v.ShiptopartyAddress')];
                        }
                        if (shipToTimeZone == 'BusinessHour'){
                            var bhId = childCasesList[i].Street_Address_2__c;
                            countryTimezone = shipToTimeZoneMap[bhId];
                            console.log('bhIdddd'+bhId+'  countryTimezoneeee'+countryTimezone);
                        }
                        var countryTime = new Date(requestedDate).toLocaleString("en-US", {timeZone: countryTimezone});                    
                        countryTime = new Date(countryTime);
                        var counteryDateOnly = $A.localizationService.formatDate(countryTime);                       
                        counteryDateOnly = counteryDateOnly.replace(/[\/\\.-]/g, ' ');                        
                        var counteryTimeOnly = $A.localizationService.formatTime(countryTime);                        
                      /*  var monthNames = [
                            "Jan", "Feb", "Mar",
                            "Apr", "May", "Jun", "Jul",
                            "Aug", "Sep", "Oct",
                            "Nov", "Dec"
                          ];*/
                        var hours = countryTime.getHours();
                        var minutes = countryTime.getMinutes();
                        var ampm = hours >= 12 ? 'pm' : 'am';
                        if(counteryTimeOnly.includes("AM") || counteryTimeOnly.includes("PM")){
                            ampm = hours >= 12 ? 'PM' : 'AM';
                        }
                        hours = hours % 12;
                        hours = hours ? hours : 12; // the hour '0' should be '12'
                        minutes = minutes < 10 ? '0'+minutes : minutes;
                        var strTime = hours + ':' + minutes + ' ' + ampm;                        
                        childCasesList[i].HWS_RequestedDateShipment__c = counteryDateOnly +', ' + strTime +' ('+countryTimezone+')';
                                        
                    }                    
                    else{
                        childCasesList[i].HWS_Requested_Delivery_Date_Time__c = null;
                        childCasesList[i].HWS_RequestedDateShipment__c = null;
                        childCasesList[i].Street_Address_3__c =  "delInfoBGCol"; 
                    }
                } 
            	component.set("v.childCases",childCasesList);  
				component.set("v.IsSpinner", false);
            	//this.getplannedDeliveryDateTime(component, event,helper);
				//NOKIASC-34199
                var isRequired = false;
                // NOKIASC-37158 | added v.showRetroAccount check
                if(!component.get('v.showRetroAccount')){
                    (component.get('v.getAllAssets')).forEach(function(row) { 
                        console.log('row.HWS_ContractLineItem__r.HWS_WarrantyVerificationRequired__c'+row.HWS_ContractLineItem__r.HWS_WarrantyVerificationRequired__c);
                        console.log('assetIdlistFinal:'+JSON.stringify(assetIdlistFinal)+'&& assetIdlistFinal.includes(row.Id)'+assetIdlistFinal.includes(row.Id));
                        if(assetIdlistFinal.includes(row.Id) && row.HWS_ContractLineItem__r.HWS_WarrantyVerificationRequired__c == 'Yes'){
                            isRequired = true;
                        }
                    });
                }
            	console.log('saveandReviewEnable'+isRequired);
             	component.set('v.saveandReviewEnable',isRequired);
            	component.set("v.StageNumber",8);
           	}
    },
	
    gotoStep3a: function(component, event, helper) {
        this.gotoStep3(component, event, helper);
        var searchCriteria = component.get("v.searchCriteria");
        if(searchCriteria == 'Part Code'){
        	component.set("v.SelectNEAProgress",false);
        	component.set("v.SelectNEAProgressBar",false);
            component.set("v.SelectProgressBar",true);
            
            }
        var selecVersionItems = component.get("v.selectedVersions");
        if(selecVersionItems == null || selecVersionItems == '' || selecVersionItems == undefined){
            console.log('null'); 
            component.set("v.selectedVersionstep3",false);
            component.set("v.newChildAddPart",true);
        }
        var selNEA = component.get("v.selectedNEA");            
        if(selNEA != null && selNEA != '' && selNEA != undefined){
            if(searchCriteria == 'Part Code'){
                component.set("v.SelectNEAProgress",true);
                component.set("v.SelectNEAProgressBar",true);
                component.set("v.SelectProgressBar",false);
                component.set("v.ContractNumProgress",false);
                component.set("v.ContractNumNEAProgress",false);
            }
       }
    },	
    gotoStep3c: function(component, event, helper) {
        console.log('step3c');
        this.gotoStep3(component, event, helper);
    },
    //NOKIASC-25662    
    selectNetworkElementAssetA : function(component, event, helper){
        console.log('selectNetworkElementAssetA'+component.get("v.selectedNEA"));
        this.selectNetworkElementAsset(component, event, helper);
        var searchCriteria = component.get("v.searchCriteria");
        if(searchCriteria == 'Part Code'){
            component.set("v.SelectNEAProgress",true);
            component.set("v.SelectNEAProgressBar",true); 
            component.set("v.SelectProgressBar",false); 
            component.set("v.ContractNumProgress",false);
            component.set("v.ContractNumNEAProgress",false);
            }
        var selecNEA = component.get("v.selectedNEA");
        if(selecNEA == null && selecNEA == '' && selecNEA == undefined){
          component.set("v.SelectNEA",false);  
        }
        var selecVersionItems = component.get("v.selectedVersions");
        if(selecVersionItems == null || selecVersionItems == '' || selecVersionItems == undefined){
            console.log('null'); 
            component.set("v.selectedVersionstep3",false);
            component.set("v.newChildAddPart",true);
        }
       component.set("v.ContractNumNEAProgress", false);
    },
	
    assignServiceType : function(component){
        var selectedAsset = component.get("v.selectedAssets");
            return selectedAsset[0].HWS_Service_Type__c;
     },
     valid : function(object) {
         return object != null && object != '' && object != undefined;
     },	 
	/**************************************************	
        NOKIASC-31177
		Funtion to validate form fields 	
		@return true or false	
	**************************************************/	
    validation: function (component, event, helper, executeName) {	
        var isValid; 
		var isAllValid = [];
        if(executeName == 'SWTnSponsorFields'){
            isValid = this.stringValidation(component, 'relatedSoftwareTicketNumber');	
            isAllValid.push(isValid);	
            isValid = this.stringValidation(component, 'sponsor');	
            isAllValid.push(isValid);
        }
        if(isAllValid.includes(false)){	
				component.set("v.isValid", false);	
				isValid = false;	
			} else {	
				component.set("v.isValid", true);	
				isValid = true;	
			} 
        return isValid;
    },
		showToastError: function(component,event,message) {	
			component.set("v.saveCase", false);	
			this.showToast('error','Error Message',message);	
			this.hideWaiting(component);	
			component.set("v.StageNumber", 8);	
			component.set("v.saveDisable",false);	
			component.set("v.saveSubmitDisable",false);	
		},
    /**************************************************	
     	NOKIASC-31177
		String validation funtion	
		@return true or false	
	**************************************************/	
	stringValidation: function(component, fieldId, errorMessage){	
		var isValidField = true;	
		var inputField = component.find(fieldId);	
        if(inputField.length>1){
            inputField = inputField[inputField.length-1];
        }        
		var inputVal = inputField.get("v.value");        
		if ($A.util.isEmpty(inputVal)){	
			isValidField = false;	
			inputField.showHelpMessageIfInvalid();	
		} else if(!inputField.checkValidity()){	
			isValidField = false;	
		} else {	
			inputField.setCustomValidity('');	
			isValidField = true;	
		}	
		inputField.reportValidity();
		return isValidField;			
	},	
    /**************************************************	
     	NOKIASC-31177
		validateSWSCase		
	**************************************************/	
	validateSWSCase: function(component, event, helper){	
        var action = component.get("c.validateSWSCase");
        action.setParams({
            caseNumberLst : component.get('v.newChildCase.HWS_RelatedSoftwareTicketNumber__c')
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var caseData = response.getReturnValue();
                if(caseData != undefined && caseData !=null && caseData !=''){ 
                    var actLst = component.get("v.selectedAccount");
                    if(!caseData[0].CH_RecordTypeCheck__c){
                        this.showToast('error','Error Message',$A.get("$Label.c.HWS_RedTagFMAInvalidServiceTypeError"));
                        component.set("v.IsSpinner", false);
                    }
                    else if(caseData[0].AccountId != actLst[0].Id){
                        this.showToast('error','Error Message',$A.get("$Label.c.HWS_RedTagFMALegalEnityMismatchError"));
                        component.set("v.IsSpinner", false);
                    }
                    else{
                        if(component.get("v.newChildCaseCheck")){
                            this.duplicateSerialnumCheck(component, event,'createchild'); 
                        }
                        else{
                            this.duplicateSerialnumCheck(component, event); 
                        }
                    }
                }
                else{                                    
                    this.showToast('error','Error Message',$A.get("$Label.c.HWS_RedTagFMACaseNumberNotExistsError"));
                    component.set("v.IsSpinner", false);
                }
            }
        });
        $A.enqueueAction(action);
	},
        //NOKIASC-32212:Check and update warranty status for RFR Service  
        updateWarrantyStatusForRFRServiceType: function(component,event) {
            
            var selectedAssets = component.get("v.selectedAssets");
            var selectedVersions = component.get("v.selectedVersions");
            var isTraceble = selectedVersions[0].HWS_Serial_Number_Traceable__c;  
            var isshowRetroAccount = component.get('v.showRetroAccount'); // NOKIASC-37158 | added isshowRetroAccount in if condition
            if(!isshowRetroAccount && isTraceble != null && isTraceble != '' && isTraceble != undefined  
               && selectedAssets[0].HWS_ContractLineItem__r.HWS_WarrantyVerificationRequired__c == "Yes"
               && (isTraceble.toUpperCase() == 'YES' || isTraceble.toUpperCase() == 'Y')){
                
                component.set("v.IsSpinner", true);
                var action =component.get("c.warrantyCheck");
                action.setParams({
                    materialCode : selectedAssets[0].HWS_Part_Code__c,
                    serialNumber : component.get("v.newChildCase.HWS_Faulty_Serial_Number__c"),
                    sourceSystem :selectedAssets[0].HWS_SourceSystem__c
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        var warrantyStatusResponse = response.getReturnValue();
                        console.log('WARRANTY CHCK INSIDE'+warrantyStatusResponse);
                       /* if (warrantyStatusResponse != 'Out Of Warranty' || warrantyStatusResponse !='Warranty Unknown'||warrantyStatusResponse!='In Warranty'){
                            warrantyStatusResponse='Failed to determine Warranty';
                        }*/
                        component.set('v.warrantyStatus',warrantyStatusResponse);
                        this.childCaseCreation(component, event);
                        component.set("v.IsSpinner", false);
                    }
                    else {
                        var errors = response.getError();                
                        this.showToast('error', 'Error',$A.get("$Label.c.HWS_MSG_Update_WarrantyStatus_ForRFR")+ errors && errors[0] && errors[0].message?errors[0].message:$A.get("$Label.c.HWS_MSG_SomethingWent_Wrong"));
                        component.set("v.IsSpinner",false);
                    }
                    
                });
                $A.enqueueAction(action);
            } 
            //35978
            else if(selectedAssets[0].HWS_ContractLineItem__r.HWS_WarrantyVerificationRequired__c == "Yes" && (isTraceble == undefined || isTraceble == '' || isTraceble == null || (isTraceble != null && isTraceble != '' && isTraceble != undefined && isTraceble.toUpperCase() == 'NO' || isTraceble.toUpperCase() == 'N' ))){
                component.set('v.warrantyStatus','Not Applicable');
                        this.childCaseCreation(component, event);
            }
            else{
                 // NOKIASC-37158 Added to set Not Applicable in warranty status
               if(isshowRetroAccount){
                    component.set('v.warrantyStatus','Not Applicable');
               }
                this.childCaseCreation(component, event);
            }
            return true;
        },
    //End
    //NOKIASC-32950:NEA Performance issue 
      getNetworkElementAssets : function(component, accountId, cliId) {
          component.set("v.IsSpinner", true);           
          var assets = component.get("v.AllAssets");    
          var searchCrit = component.get("v.searchCriteria");
          var CLIIDS = [];
          if(assets != null && searchCrit == 'Part Code'){              
              CLIIDS = assets.map(function(asset) {
                  return asset.HWS_ContractLineItem__c;
              });
          }
          var clitems = component.get("v.ALLclis");	
          if(clitems != null && searchCrit == 'Contract Number'){	              
              CLIIDS = clitems.map(function(clitem) {
                  return clitem.Id;
              });
          }
          this.componentRefresh(component);          
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
                  var neaAssetList=this.InitializeNEAData(component,neaList.networkEleAssests,(neaList.networkEleAssests.length>component.get("v.initialRows"))?component.get("v.initialRows"):neaList.networkEleAssests.length,component.get("v.rowNumberOffset"));
                  if(component.get('v.clearNEACheck')){
                      console.log('NEA CLEAERES');
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
    getLightningURL: function(recordId) {
        return '/one/one.app?#/sObject/' + recordId + '/view';
    },
    InitializeNEAData : function(component,neaList,limit,offSet){
        var tempNEAList=[];        
        for(var i = offSet; i < limit; i++) {
            console.log('$####'+neaList[i].Network_Element_Assets__r.length+typeof(neaList[i].Network_Element_Assets__r[i]));
            var obj = {}; 
            obj['Id'] =neaList[i].Id;
            obj['CH_NetworkElementID__c'] = neaList[i].CH_NetworkElementID__c;  
            obj['CH_NetworkElementAsset__c'] =neaList[i].Id;
            if (typeof(neaList[i].Name) != 'undefined') {
                obj['URL']   = this.getLightningURL(neaList[i].Id);
                obj['Name']  = neaList[i].Name;
            }
            if (typeof(neaList[i].Product2) != 'undefined') {
                obj['ProductURL']= this.getLightningURL(neaList[i].Product2Id);
                obj['ProductName'] = neaList[i].Product2.Name;
            }
            if (typeof(neaList[i].CH_ProductVariant__c) != 'undefined') {
                obj['VariantURL']= this.getLightningURL(neaList[i].CH_ProductVariant__c);
                obj['VariantName'] = neaList[i].CH_ProductVariant__r.Name;
            }
            if (typeof(neaList[i].CH_Solution__c) != 'undefined') {
                obj['SolutionURL']= this.getLightningURL(neaList[i].CH_Solution__c);
                obj['SolutionName'] =  neaList[i].CH_Solution__r.Name;
            }
            if (typeof(neaList[i].CH_ProductRelease__c) != 'undefined') {
                obj['ReleaseURL']= this.getLightningURL(neaList[i].CH_ProductRelease__c);
                obj['ReleaseName'] =   neaList[i].CH_ProductRelease__r.Name;
            }
            obj['Address'] = typeof(neaList[i].Address__r) != 'undefined'?neaList[i].Address__r.CH_AddressDetails__c :'N/A';                 
            obj['CH_CountryISOName__c'] = typeof(neaList[i].CH_CountryISOName__c) != 'undefined'?neaList[i].CH_CountryISOName__c:'';
            obj['CH_LabEnvironment__c'] =  typeof(neaList[i].CH_LabEnvironment__c) != 'undefined'?neaList[i].CH_LabEnvironment__c:'';            
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
                if(component.get("v.selectedNEA").length>0 ){
                    if(neaList[i].Id==component.get("v.selectedNEA")[0].Id){
                        var allSelectedRows=[];
                        var selectedRows= component.get("v.selectedNEA");
                        selectedRows.forEach(function(row) {
                            allSelectedRows.push(row.Id);                    
                        });
                        component.find("neaTable").set("v.selectedRows",allSelectedRows); 
                    }
                }  
            }								
        }
        return tempNEAList;                
    },
    componentRefresh : function(component) {                        
        component.set('v.initialRows',50);
        component.set('v.rowNumberOffset',0);
        component.set('v.rowsToLoad',50);         
        component.set('v.enableInfiniteLoading', true);
        component.set('v.loadMoreStatus', 'Please scroll down to load more data');
        component.set('v.allNetElemAssets', {});
        
    },    
	updateAccount: function(component, event, helper, AccountId) {
		var action = component.get("c.getAccounts");
		action.setParams({
			'accountId': AccountId 
		});
		action.setCallback(this, function(response) {            
			var state = response.getState();
			if (state === "SUCCESS") {
				var accountDetails = response.getReturnValue();
				component.set("v.selectedAccount",accountDetails);
				//component.set("v.AccountName", accountDetails[0].Name);
			}
		});
		$A.enqueueAction(action); 
		
	},
	//added for NOKIASC-35931 -- START
	getServiceAccNumber : function(component, event, helper) {
        var action =component.get("c.getServicedAccountNumbers");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
            	var result = response.getReturnValue();
                component.set("v.serviceAcountNumber",result);
            }
        });
        $A.enqueueAction(action);
        
    },
    siteIdValidation : function(component, event, helper) {
        var siteIdField = component.find("siteId1");
        var isValid = true;
        if(siteIdField.get("v.value") == undefined || siteIdField.get("v.value") == ''){
            isValid =  false;
        }
        if(!isValid){
            siteIdField.setCustomValidity('Please Enter Site ID'); 
            siteIdField.reportValidity();
        }
        console.log('siteId isValid-'+isValid);
        return isValid;
    },
    additionalConfigValidation : function(component, event, helper) {
        var addConfigField = component.find("addConfigDet1");
        var isValid = true;
        if(addConfigField.get("v.value") == undefined || addConfigField.get("v.value") == ''){
            isValid =  false;
        }
        if(!isValid){
            addConfigField.setCustomValidity('Please Enter Additional Configuration Details'); 
            addConfigField.reportValidity();
        }
        console.log('add Config isValid-'+isValid);
        return isValid;
    },    
	//added for NOKIASC-35931 -- END
    //NOKIASC-38079 Start
    checkCountOfParts : function(component, event) {

        if(component.get("v.childCases") != undefined && 
           component.get("v.childCases").length+1 >=
           parseInt($A.get("$Label.c.HWS_CNT_AddPartsLimit_Console"))) { 
            
            component.set("v.disableAddPart",true);
        }
    },
	//NOKIASC-38079 End
	//HWSDDP-144:Suspension � block creation of RES RMA||Start
	processSelectedServiceContract : function(component, event,helper,selectedRows) {
        
       
        //NOKIASC-37150 - added toast message for LE approval in progress
         if(selectedRows != null &&
            selectedRows != "" &&
            selectedRows != undefined && selectedRows[0].HWS_PartLEStatus__c =='LE approval in progress') {
           
            helper.showToast(
                        "error",
                        "Error Message",
                        $A.get("$Label.c.HWS_Case_flow_LE_Approval_Error_Console")
                );
             component.set("v.enableAsset", true);
        }
        else {
            
             component.set("v.enableAsset", false);
        }
        var oldSelectedAsset = component.get("v.oldSelectedAssets");
        var selAsset;
        var nea;
        if (
            selectedRows != null &&
            selectedRows != "" &&
            selectedRows != undefined
        ) {
            selAsset = JSON.parse(JSON.stringify(selectedRows[0]));
            nea =
                selectedRows[0].HWS_ContractLineItem__r
            .CH_QtyCoveredNetworkElementAssets__c;
        }
        // NOKIASC-25661 to enable Select Nea button if count is greater than 0
        if (nea == 0) {
            component.set("v.enableSelectNEA", true);
            component.set("v.showVI", true);
            //component.set("v.selectedNEA", null);
        } else {
            // NOKIASC-25661
            component.set("v.enableSelectNEA", false);
            component.set("v.showVI", false);
        }
        var selNEA = component.get("v.selectedNEA");
        if (
            selNEA != "" &&
            selNEA != null &&
            selNEA != undefined &&
            selAsset != "" &&
            selAsset != null &&
            selAsset != undefined &&
            (selAsset.Id == oldSelectedAsset ||
             oldSelectedAsset == null ||
             oldSelectedAsset == "" ||
             oldSelectedAsset == undefined)
        ) {
            component.set("v.showVI", true);
        }
        var searchCrit = component.get("v.searchCriteria");
        var cli = component.get("v.selectedclis");
        if (searchCrit == "Contract Number") {
            if (cli[0].CH_QtyCoveredNetworkElementAssets__c == 0) {
                component.set("v.showVI", true);
                component.set("v.selectedNEA", null);
            } else {
                component.set("v.showVI", false);
            }
        }
        //console.log("##### Selected Asset" + JSON.stringify(selectedRows));
        component.set("v.selectedAssetstep2", true);
        component.set("v.selectedLineItemstep2", true);
        component.set("v.SelectConNum", true);
		// start changes for US 34201
        component.set('v.newParentCase.HWS_Customer_PO__c',selectedRows[0].HWS_ContractLineItem__r.HWS_PONumber__c);
         var getponumber=selectedRows[0].HWS_ContractLineItem__r.HWS_PONumber__c;
            if(getponumber == "" || getponumber == null || getponumber == undefined ){
                component.set("v.isponumber", false);
            }
            else{
                component.set("v.isponumber", true);
            }
		//End changes for US 34201
        if (
            selectedRows != null &&
            selectedRows != "" &&
            selectedRows != undefined
        ) {  
            var getPayPerUse = selectedRows[0].HWS_ServiceOffering__c;
            var getPrice = selectedRows[0].HWS_Price__c;
            if (
                getPayPerUse != undefined &&
                (getPayPerUse.includes("RES RFR PU") ||
                 getPayPerUse.includes("RES AED PU")) &&
                (getPrice == "" || getPrice == null || getPrice == undefined )
            ) {
                component.set("v.isPayPerPriceFound", true);
            } else {
                component.set("v.isPayPerPriceFound", false);
            }
            //End Changes for US-26951
            var serviceEntScript =
                selectedRows[0].HWS_ContractLineItem__r.ServiceContract
            .CH_EntitlementScript__c;
            var lineEntScript =
                selectedRows[0].HWS_ContractLineItem__r.CH_LineItemEntitlementScript__c;
            console.log(
                "252 ##### Selected Asset 1" +
                selectedRows[0].HWS_ContractLineItem__r.HWS_AdditionalSIInfo1__c
            );
            component.set("v.isADFDescription", true);
            component.set("v.showADFDescription", true);
            var adf = selectedRows[0].HWS_ContractLineItem__r.CH_CoverageGroup__c;
            if (!$A.util.isEmpty(adf) && adf != "undefined") {
                component.set("v.ADFDescription", adf);
            } else {
                component.set("v.ADFDescription", "No Additional Description");
            }
        }
        var showParentES;
        var showLineES;
        component.set("v.selectedAssets", selectedRows);
        component.set("v.entitlementScript", serviceEntScript);
        component.set("v.entitlementScriptLine", lineEntScript);
        if (
            selectedRows != null &&
            selectedRows != "" &&
            selectedRows != undefined
        ) {
            component.set("v.selectedAssetforShipToAddress", selectedRows);
        }
        if (component.get("v.entitlementScript") != null) {
            showParentES = true;
        } else {
            showParentES = false;
        }
        if (component.get("v.entitlementScriptLine") != null) {
            showLineES = true;
        } else {
            showLineES = false;
        }
        component.set("v.showParentEntS", showParentES);
        component.set("v.showLineEntS", showLineES);
        if (
            selectedRows != null &&
            selectedRows != "" &&
            selectedRows != undefined
        ) {
            //helper.getplannedDeliveryDateTime(component, event);
            component.set("v.toProceedSPSLOD", false);
            var contractNumber = selectedRows[0].HWS_Service_Contract_Number__c;
            component.set("v.contractNumber", contractNumber);
            var serviceType = selectedRows[0].HWS_Service_Type__c;
            // Added by NK
            var contractLineItemId = selectedRows[0].HWS_ContractLineItem__c;
            console.log('########'+contractLineItemId);
            component.set("v.selectedContractLineItem", contractLineItemId);
            var country =
                selectedRows[0].HWS_ContractLineItem__r.CH_CountryISOName__c;
            console.log("testing country" + country);
            component.set("v.country", country);
            //2503 SPS Last Order Date validation started when part entered
            var SRMLOD = selectedRows[0].HWS_Product_SPSLOD__c;
            var SPSLOD = new Date();
            SPSLOD = selectedRows[0].HWS_Product_SPSLOD__c;
            if (
                (selectedRows[0].HWS_Product_SPSLOD__c != undefined ||
                 selectedRows[0].HWS_Product_SPSLOD__c != null) &&
                serviceType == "Spare Part Sales"
            ) {
                var milliseconds = new Date().getTime() - Date.parse(SRMLOD);
            }
            if (milliseconds > 0 && serviceType == "Spare Part Sales") {
                component.set("v.toProceedSPSLOD", true);
            }
            //2503 SPS Last Order Date validation Ended
            if (
                serviceType == "" ||
                serviceType == null ||
                serviceType == undefined ||
                contractNumber == "" ||
                contractNumber == null ||
                contractNumber == undefined
            ) {
                helper.showToast(
                    "error",
                    "Error Message",
                    $A.get("$Label.c.HWS_MSG_No_ServiceType_ContractNumber")
                );
            } else {
                component.set("v.newChildCase.HWS_ServiceType__c", serviceType);
                component.set("v.serviceTypeCheck", serviceType);
            }
        }
        if (
            selectedRows == null ||
            selectedRows == "" ||
            selectedRows == undefined
        ) {
            component.set("v.enableAsset", true);
        }
       //NOKIASC-37158 | Start
        var action =component.get("c.showRetroAccount");
        var selectedContractLineItem = component.get("v.selectedContractLineItem");
            action.setParams({
                contractLineItemId: selectedContractLineItem
            });
            action.setCallback(this, function(response){                
               // NOKIASC-37617 -Added code to check if contract is global or not
                let state = response.getState();
                if (state === "SUCCESS") {	
                    let result = response.getReturnValue();
                    let isshow = result.length > 0 ? true:false;
                    component.set("v.showRetroAccount", isshow);
                    component.set("v.isGlobal", isshow &&  result[0].ServiceContract !=null &&  result[0].ServiceContract !=undefined && result[0].ServiceContract.HWS_Retrofit_Type__c =='Global Retrofit' ?true: false);
            	}   
                
            });
            $A.enqueueAction(action);
        //NOKIASC-37158 | End
    }
    //HWSDDP-144:Suspension � block creation of RES RMA||Start
})