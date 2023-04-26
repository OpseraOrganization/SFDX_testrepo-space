({
    onLoad: function(component, event) {
        //call apex class method
        /*var action = component.get('c.fetchCase');
        action.setCallback(this, function(response){
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in ListOfCase attribute on component.
                component.set('v.ListOfCase', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);*/
    },
    convertArrayOfObjectsToCSV : function(component,objectRecords,Recordtype){
        // declare variables
        var csvStringResult, counter, keys, columnDivider, lineDivider;
        console.log('Recordtype ==='+Recordtype);
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider =  '\n';
        
        // in the keys variable store fields API Names as a key 
        // this labels use in CSV file header  
        if(Recordtype=="SWS"){
            keys = ['CaseNumber','Severity__c','Contact.Name','Reference_Number__c','Subject','Status','CH_Product_Name__c','CH_ProductVariant__c','CH_Product_Release__c','CH_Solution_Name__c','CH_SW_Release_Name__c','CH_SW_Build_Name__c','CH_NetworkElementAsset__r.Name','Account.Name','Entitlement.Servicecontract.Name','Country__c','Contact.Account.Name','CH_Reported_Date__c','CH_InitialResponse__c','CH_SystemRestored__c','CH_TemporarySolutionProvided__c','CH_SolutionProvided__c','ClosedDate','CH_LastCustomerInteraction__c','CH_Summary__c','CH_InvitationLink__c'];
            csvStringResult = '';
            csvStringResult +=  ['Support Ticket Number','Severity','Contact Name','Reference Number','Subject','Status','Product','Product Variant','Product Release','Solution','SW Release','SW Build','Network Element Asset.Name','Account.Name','Service Contract Number','Country','Contact.Account.Name','Reported Date','Initial Response Date','Restored Date','Temporary Solution Provided Date','Solution Provided Date','Date/Time Closed','Last Customer Interaction','Summary to Customer','Survey'];
            csvStringResult += lineDivider;  
        }
        else if(Recordtype=="HWS"){
            keys = ['HWS_SupportTicketReference__c','HWS_RequestedDateShipment__c','Parent.CH_ReportedDate__c','CreatedDate','Status','ClosedDate','CH_ServiceContractNumber__c','HWS_ServiceType__c','HWS_Service_Offering__c','HWS_Customer_Reference_Number__c','HWS_Planned_Delivery_Date__c','HWS_Requested_Delivery_Date_Time__c','HWS_PlannedDeliveryDateShipment__c','Contact.Account.Name','Account.Name','CH_NetworkElementAsset__c','Parent.HWS_Address_Name__c','HWS_Shipment_Recipient_Name__c','Parent.HWS_Shipment_Recipient_Name__c','Contact.name','Parent.Street_Address_1__c','Parent.Street_Address_2__c','Parent.Street_Address_3__c','Parent.POSTAL_CODE_CHQ__c','Parent.City__c','Parent.State__c','Parent.Country__c','HWS_Part_Code__c','HWS_Stockable_Product__c','HWS_Part_Name__c','NCP_Product_Name__c','parent.HWS_Customer_Reference_Number__c','HWS_Failure_Description__c','HWS_ReplacementUnitMaterialCode__c','HWS_Replacement_Unit_Serial_Number__c','HWS_Shippeddate__c' ,'HWS_ShippedQuantity__c','HWS_LSP_Courier_Name__c','HWS_AWBNumber__c','HWS_ProofDeliveryDate__c','HWS_FaultyUnitMaterialCode__c','HWS_Faulty_Serial_Number__c','HWS_FaultyUnitReceivedDate__c'];
            csvStringResult = '';
            csvStringResult +=['Support Ticket Reference','Requested Date (Shipment Timezone)','Parent.Reported Date','Date/Time Opened','Status','Date/time closed','Service Contract Number','Service Type','Contract Line Item.Service Offering','Customer Reference Number','Planned Delivery Date(User timezone)','Customer Requested Date (User Timezone)','Planned Delivery Date(Shipment timezone)','Contact.Account.Name','Account.Name','Network Element Asset.Name','Parent Case.Ship To Party Address.Name','Shipment Recipient Name','Parent Case.Shipment Recipient Name','Contact Name','Parent Case.Ship To Party Address.Address Line 1','Parent Case.Ship To Party Address.Address Line 2','Parent Case.Ship To Party Address.Address Line 3','Parent Case.Ship To Party Address.Postalcode',' Parent Case.Ship To Party Address.City','Parent Case.Ship To Party Address.State/Province','Parent Case.Ship To Party Address.Country','Part Code','Version Item Name','Part','Product','parent Case.Customer Reference Number','Failure Description','Replacement Unit Material Code','Replacement Unit Serial Number','Shipped Date','Shipped Quantity','LSP(CourierName)','AWB Number','Proof Of Delivery Date','Faulty Unit Material Code','Faulty Unit Serial Number','Faulty Unit Received Date'];
            csvStringResult += lineDivider;
        }
        
        //else if(Recordtype=="HWS"){
        //      keys = ['CaseNumber','Subject', 'Status','Account.Name','Contact.Name','HWS_Part_Code__c','CreatedDate','HWS_Customer_Reference_Number__c','HWS_Stockable_Product__c','HWS_RMA_Number__c','HWS_Planned_Delivery_Date__c','CH_NetworkElementAsset__c','CH_ReportedDate__c','HWS_ServiceType__c','CH_ServiceContractNumber__c','HWS_RequestedDateShipment__c','HWS_Shipment_Recipient_Name__c','HWS_Shipment_Recipient_Phone__c','HWS_PlannedDeliveryDateShipment__c','HWS_FaultyUnitMaterialCode__c','HWS_FaultyUnitReceivedDate__c','HWS_Faulty_Serial_Number__c','HWS_AWBNumber__c'];
        //   csvStringResult =  '';
        //        csvStringResult +=  ['CaseNumber','Subject', 'Status','AccountName','ContactName','PartCode','CreatedDate','CustomerReferenceNumber','StockableProduct','RMANumber','PlannedDeliveryDate','NetworkElementAsset','ReportedDate','ServiceType','ServiceContractNumber','RequestedDateShipment','ShipmentRecipientName','ShipmentRecipientPhone','PlannedDeliveryDateShipment','FaultyUnitMaterialCode','FaultyUnitReceivedDate','FaultySerialNumber','AWBNumber'];
        //   csvStringResult += lineDivider;
        //  }
        
        console.log('objectRecords===='+JSON.stringify(objectRecords));
        for(var i=0; i < objectRecords.length; i++){   
            counter = 0;
            for(var sTempkey in keys) {
                var skey = keys[sTempkey];  
                // add , [comma] after every String value,. [except first]
                if(counter > 0){ 
                    csvStringResult += columnDivider; 
                }   
                if(skey == 'Contact.Name') {
                    csvStringResult += JSON.stringify(objectRecords[i].Contact.Name);     
                }else if(skey == 'Account.Name') {
                    csvStringResult += JSON.stringify(objectRecords[i].Account.Name);
                }else if(skey == 'CaseNumber') {
                    csvStringResult += JSON.stringify(objectRecords[i].CaseNumber);
                    
                } else if(skey == 'HWS_Stockable_Product__c') {
                    if(objectRecords[i][skey] != null && objectRecords[i][skey] != undefined ) {
                        
                        csvStringResult += JSON.stringify(objectRecords[i].HWS_Stockable_Product__r.Name);
                    } 
                } else if(skey =='CH_NetworkElementAsset__c') {
                    if(objectRecords[i][skey] != null && objectRecords[i][skey] != undefined ) {
                        
                        csvStringResult += JSON.stringify(objectRecords[i].CH_NetworkElementAsset__r.Name);
                    } 
                } 
                
                    else if(skey =='Entitlement.Servicecontract.Name') {
                        if(objectRecords[i][skey] != null && objectRecords[i][skey] != undefined ) {
                            
                            csvStringResult += JSON.stringify(objectRecords[i].Entitlement.Servicecontract.Name);
                        } 
                    } 
                
                        else if(skey =='Contact.Account.Name'){
                            if(objectRecords[i].Contact.Account != undefined && JSON.stringify(objectRecords[i].Contact.Account.Name) !== null && JSON.stringify(objectRecords[i].Contact.Account.Name) != undefined){
                                csvStringResult += JSON.stringify(objectRecords[i].Contact.Account.Name);
                            }
                        }
                            else if(skey =='HWS_Planned_Delivery_Date__c'){
                                if(JSON.stringify(objectRecords[i].HWS_Planned_Delivery_Date__c) !== null && JSON.stringify(objectRecords[i].HWS_Planned_Delivery_Date__c) != undefined){
                                    var format = "MMM DD YYYY hh:mm A";
                                    var langLocale = $A.get("$Locale.langLocale");
                                    var timezone = $A.get("$Locale.timezone");
                                    var date = new Date(objectRecords[i].HWS_Planned_Delivery_Date__c);
                                    var sDate;
                                    
                                    $A.localizationService.UTCToWallTime(date, timezone, function(walltime) {           
                                        sDate = $A.localizationService.formatDateTimeUTC(walltime, format, langLocale);
                                    });
                                    csvStringResult += sDate;
                                }
                            }
                                else if(skey =='CreatedDate'){
                                    if(JSON.stringify(objectRecords[i].CreatedDate) !== null && JSON.stringify(objectRecords[i].CreatedDate) != undefined){
                                        var format = "MMM DD YYYY hh:mm A";
                                        var langLocale = $A.get("$Locale.langLocale");
                                        var timezone = $A.get("$Locale.timezone");
                                        var date = new Date(objectRecords[i].CreatedDate);
                                        var s1Date;
                                        
                                        $A.localizationService.UTCToWallTime(date, timezone, function(walltime) {           
                                            s1Date = $A.localizationService.formatDateTimeUTC(walltime, format, langLocale);
                                        });
                                        csvStringResult += s1Date;
                                    }
                                }
                                    else if(skey =='Parent.CH_ReportedDate__c'){
                                        if(JSON.stringify(objectRecords[i].Parent) != undefined && JSON.stringify(objectRecords[i].Parent.CH_ReportedDate__c) !== null && JSON.stringify(objectRecords[i].Parent.CH_ReportedDate__c) !== undefined){
                                            var format = "MMM DD YYYY hh:mm A";
                                            var langLocale = $A.get("$Locale.langLocale");
                                            var timezone = $A.get("$Locale.timezone");
                                            var date = new Date(objectRecords[i].Parent.CH_ReportedDate__c);
                                            var s2Date;
                                            
                                            $A.localizationService.UTCToWallTime(date, timezone, function(walltime) {           
                                                s2Date = $A.localizationService.formatDateTimeUTC(walltime, format, langLocale);
                                            });
                                            csvStringResult += s2Date;
                                        }
                                    }
                                        else if(skey === 'HWS_Contract_Line_Item__r.CH_ServiceOffering__c'){
                                            if(JSON.stringify(objectRecords[i].HWS_Contract_Line_Item__r.CH_ServiceOffering__c) !== null && JSON.stringify(objectRecords[i].HWS_Contract_Line_Item__r.CH_ServiceOffering__c) !== undefined){
                                                csvStringResult += JSON.stringify(objectRecords[i].HWS_Contract_Line_Item__r.CH_ServiceOffering__c);
                                            } 
                                        }
                                            else if(skey === 'Parent.HWS_Address_Name__c'){
                                                if(JSON.stringify(objectRecords[i].Parent) != undefined && JSON.stringify(objectRecords[i].Parent.HWS_Address_Name__c) !== null && JSON.stringify(objectRecords[i].Parent.HWS_Address_Name__c) != undefined){
                                                    csvStringResult += JSON.stringify(objectRecords[i].Parent.HWS_Address_Name__c);
                                                } 
                                            }
                                                else if(skey === 'Parent.HWS_Shipment_Recipient_Name__c'){
                                                    if(JSON.stringify(objectRecords[i].Parent) != undefined && objectRecords[i][skey] !== null && objectRecords[i][skey] != undefined){
                                                        csvStringResult += JSON.stringify(objectRecords[i].Parent.HWS_Shipment_Recipient_Name__c);
                                                    } 
                                                }
                                                    else if(skey === 'Parent.Street_Address_1__c'){
                                                        if(JSON.stringify(objectRecords[i].Parent) != undefined && JSON.stringify(objectRecords[i].Parent.Street_Address_1__c) !== null && JSON.stringify(objectRecords[i].Parent.Street_Address_1__c) != undefined){
                                                            csvStringResult += JSON.stringify(objectRecords[i].Parent.Street_Address_1__c);
                                                        }  
                                                    }
                                                        else if(skey === 'Parent.Street_Address_2__c'){
                                                            if(JSON.stringify(objectRecords[i].Parent) != undefined && JSON.stringify(objectRecords[i].Parent.Street_Address_2__c) !== null && JSON.stringify(objectRecords[i].Parent.Street_Address_2__c) != undefined){
                                                                csvStringResult += JSON.stringify(objectRecords[i].Parent.Street_Address_2__c);
                                                            }  
                                                        }
                                                            else if(skey === 'Parent.Street_Address_3__c'){
                                                                if(JSON.stringify(objectRecords[i].Parent) != undefined && JSON.stringify(objectRecords[i].Parent.Street_Address_3__c) !== null && JSON.stringify(objectRecords[i].Parent.Street_Address_3__c) != undefined){
                                                                    csvStringResult += JSON.stringify(objectRecords[i].Parent.Street_Address_3__c);
                                                                }  
                                                            }
                                                                else if(skey === 'Parent.POSTAL_CODE_CHQ__c'){
                                                                    if(JSON.stringify(objectRecords[i].Parent) != undefined && JSON.stringify(objectRecords[i].Parent.POSTAL_CODE_CHQ__c) !== null && JSON.stringify(objectRecords[i].Parent.POSTAL_CODE_CHQ__c) != undefined){
                                                                        csvStringResult += JSON.stringify(objectRecords[i].Parent.POSTAL_CODE_CHQ__c);
                                                                    }  
                                                                }
                                                                    else if(skey === 'Parent.City__c'){
                                                                        if(JSON.stringify(objectRecords[i].Parent) != undefined && JSON.stringify(objectRecords[i].Parent.City__c) !== null && JSON.stringify(objectRecords[i].Parent.City__c) != undefined){
                                                                            csvStringResult += JSON.stringify(objectRecords[i].Parent.City__c);
                                                                        }  
                                                                    }
                                                                        else if(skey === 'Parent.State__c'){
                                                                            if(JSON.stringify(objectRecords[i].Parent) != undefined && JSON.stringify(objectRecords[i].Parent.State__c) !== null && JSON.stringify(objectRecords[i].Parent.State__c) != undefined){
                                                                                csvStringResult += JSON.stringify(objectRecords[i].Parent.State__c);
                                                                            }  
                                                                        }
                                                                            else if(skey === 'Parent.Country__c'){
                                                                                if(JSON.stringify(objectRecords[i].Parent) != undefined && JSON.stringify(objectRecords[i].Parent.Country__c) !== null && JSON.stringify(objectRecords[i].Parent.Country__c) != undefined){
                                                                                    csvStringResult += JSON.stringify(objectRecords[i].Parent.Country__c);
                                                                                }  
                                                                            }
                
                                                                                else  if(objectRecords[i][skey] != undefined){
                                                                                    csvStringResult += '"'+ objectRecords[i][skey]+'"'; 
                                                                                }else{
                                                                                    csvStringResult += '"'+ '' +'"';
                                                                                }
                
                counter++;
                
            } // inner for loop close 
            csvStringResult += lineDivider;
        }// outer main for loop close 
        
        // return the CSV formate String 
        return csvStringResult;        
    },
    CheckCSVCount : function(cmp, methodName, params){
        return new Promise($A.getCallback(function(resolve, reject) {
            var action = cmp.get(methodName);
            action.setParams(params);
            action.setCallback(self, function(res) {
                var state = res.getState();
                if(state === 'SUCCESS') {
                    resolve(res.getReturnValue());
                } else if(state === 'ERROR') {
                    reject(action.getError())
                }
            });
            $A.enqueueAction(action);
        }));
    },
    CheckExcelCount : function(component, event, params){
        return new Promise($A.getCallback(function(resolve, reject) {
            var action = component.get("c.getCaseInfoForDownload");
            action.setParams(params);
            action.setCallback(self, function(res) {
                var state = res.getState();
                if(state === 'SUCCESS') {
                    resolve(res.getReturnValue());
                } else if(state === 'ERROR') {
                    reject(action.getError())
                }
            });
            $A.enqueueAction(action);
        }));
    },
    getexcelContent : function (component, event, params) {
        return new Promise($A.getCallback(function(resolve, reject) {
            var action = component.get("c.getExcelFileAsBase64String");
            action.setParams(params);
            action.setCallback(self, function(res) {
                var state = res.getState();
                if(state === 'SUCCESS') {
                    resolve(res.getReturnValue());
                } else if(state === 'ERROR') {
                    reject(action.getError())
                }
            });
            $A.enqueueAction(action);
        }));  
    },
    convertListToExcel : function(component,objectRecords, RecordType){
        console.log('RecordType ==='+RecordType);
        var contactList = JSON.stringify(objectRecords);
        var csvStringResult, counter, keys, columnDivider, lineDivider;
        
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        columnDivider = ',';
        lineDivider =  '\r\n';
        
        keys = ['CaseNumber','Subject','Status','Severity__c','CreatedDate','HWS_Part_Code__c'];
        
        
        csvStringResult = '';
        csvStringResult += keys.join(columnDivider);
        csvStringResult += lineDivider;
        
        for(var i=0; i < objectRecords.length; i++){   
            counter = 0;
            
            for(var sTempkey in keys) {
                var skey = keys[sTempkey] ;  
                if(counter > 0){ 
                    csvStringResult += columnDivider; 
                }   
                
                csvStringResult += '"'+ objectRecords[i][skey]+'"'; 
                
                counter++;
                
            } 
            csvStringResult += lineDivider;
        }
        return csvStringResult;        
    }, 
    toggleAction : function(component, event, secId) {
        var acc = component.find(secId);
        for(var cmp in acc) {
            $A.util.toggleClass(acc[cmp], 'slds-show');  
            $A.util.toggleClass(acc[cmp], 'slds-hide');  
        }
    },
    checkManageServiceQuoteDisplay : function(component, event) {
        var action = component.get('c.showManageServiceQuote');
        action.setCallback(this, function(response){
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in showManageServiceQuote attribute on component.
                component.set('v.showManageServiceQuote', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
})