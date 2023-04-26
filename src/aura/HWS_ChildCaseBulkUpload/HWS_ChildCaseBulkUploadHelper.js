({
    //Helper method to display the error toast message
    showToast : function(type,title,message) {
        console.log('error message---');
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : title,
            message: message,
            duration:'20000',
            key: 'info_alt',
            type: type,
            mode: 'dismissible'
        });
        toastEvent.fire(); 
    },
    showToastSticky : function(type,title,message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : title,
            message: message,
            key: 'info_alt',
            type: type,
            mode: 'sticky'
        });
        toastEvent.fire(); 
    },
    //Helper method to display the error toast message
    showErrorToast : function(type,title,message) {
        console.log('2 error message---');
        var url = window.location.href;
        var urlsplt = url.split('.com');
        console.log('urlsplt---'+urlsplt[0]);
        //https://chwsdev2-nokiapartners.cs42.force.com/customers/s/hws-support-ticket-create
        //var c = urlsplt[0]+'.com/customers/s/hws-support-ticket-create';
        var c = urlsplt[0]+'.com/customers/s/services';   
        // alert(c);
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : title,
            message: message,
            messageTemplate: 'This file is not in the supported format , please download the file from - {1}',
            messageTemplateData: ['Salesforce', {
                url: c,
                label: 'URL'
            }],
            duration:'20000',
            key: 'info_alt',
            type: type,
            mode: 'dismissible'
        });
        toastEvent.fire(); 
    },
    readFile: function(component, helper, file) {
        component.set("v.spinner",true);
        if (!file) {
            return;
        }
        console.log('file'+file.name);
        var filename = file.name;
        if(!file.name.match(/\.(csv||CSV)$/)){            
            this.showErrorToast(
                "error",
                "Error Message",
                "This file is not in the supported format, please download file from - for correct formatted template"
            );
            component.set("v.spinner",false);
            return;
        }else if(!filename.includes("BulkRMAData")){
            // this.showToast("error","Error Message","This file is not in the supported format, please download file from - https://chwsdev2-nokiapartners.cs42.force.com/customers/s/services for correct formatted template");
            console.log('errorToast');
            this.showErrorToast(
                "error",
                "Error Message",
                "This file is not in the supported format, please download file from - for correct formatted template"
            );
            component.set("v.spinner",false);
            return;
            
        }
            else{
                reader = new FileReader();
                reader.onerror =function errorHandler(evt) {
                    switch(evt.target.error.code) {
                        case evt.target.error.NOT_FOUND_ERR:
                            alert('File Not Found!');
                            break;
                        case evt.target.error.NOT_READABLE_ERR:
                            alert('File is not readable');
                            break;
                        case evt.target.error.ABORT_ERR:
                            break; 
                        default:
                            alert('An error occurred reading this file.');
                    };
                }
                reader.onabort = function(e) {
                    alert('File read cancelled');
                };
                reader.onloadstart = function(e) { 
                    var output = '<ui type=\"disc\"><li><strong> File Name :&nbsp'+file.name +'</strong>'+'</li></ui>';
                    component.set("v.filename",file.name);
                    component.set("v.TargetFileName",output);
                };
                reader.onload = function(e) {
                    var data=e.target.result;
                    component.set("v.fileContentData",data);
                    var allTextLines = data.split(/\r\n|\n/);
                    var dataRows=allTextLines.length-1;
                    // NOKIASC-29185 setting outOfCount
                    var outOfCount = dataRows-1;
                    component.set("v.outOfCount", outOfCount);
                    var headers = allTextLines[0].split(',');
                    var len = (data.match(/,,,,,,,,,,,/g) || []).length;
                    var diff = Number(outOfCount) - Number(len);
                    //NOKIASC-31024
                    component.set("v.outOfCount", diff);
                    //NOKIASC-37920:Error message for restrict bulk upload limit | Start
                    var bulkUploadLimit=$A.get("$Label.c.HWS_LBL_BulkUploadLimit");  
                    if(diff>bulkUploadLimit){
                        var msgbulkUploadLimit=$A.get("$Label.c.HWS_MSG_BulkUploadLimit");
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": 'Error',
                            "type": 'error',
                            "mode":'sticky',
                            "message": msgbulkUploadLimit.replace("{" + 0 + "}", bulkUploadLimit)
                        });
                        toastEvent.fire();
                        component.set("v.spinner",false);
                        return false;
                    }
                    //NOKIASC-37920:Error message for restrict bulk upload limit | End
                    var title = '';
                    var type = '';
                    var message = '';
                    var action = component.get("c.processData");
                    var fieldsList=['Part_Code_Part_Revision__c','Faulty_Serial_number__c','Fault_Detection__c','Fault_Description__c','Fault_Occurrence__c','Fault_Detection_Date__c','Failure_Description_Server_ID__c','Customer_Reference_Number__c','Fault_Reported_by_Name__c','Fault_Reported_by_Phone__c','Fault_Reported_by_Email__c','Site_Id__c','HWS_Site_Information__c'];
                    console.log('field data '+data);
                    action.setParams({ fileData : data,
                                      sobjectName:'HWS_BulkUpload__c', 
                                      fields:fieldsList,
                                      selectedAccount: component.get("v.selectedAccount"),		
                                      selectedServiceType: component.get("v.selectedServiceType")});
                    action.setCallback(this, function(response) {
                        var state = response.getState();
                        console.log('state '+state);
                        if (state === "SUCCESS") {                        
                            var bulkMap = new Map();
                            bulkMap = response.getReturnValue();
                            
                            console.log('response '+JSON.stringify(bulkMap));
                            if(Object.keys(bulkMap).includes("true")){
                                component.set("v.showLoad",false);
                                component.set("v.showMain",false);
                                component.set("v.showFileName",false);
                                component.set("v.bulkRMAIds",bulkMap[true]);
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    "title": 'Success Message',
                                    "type": 'success',
                                    "message": component.get("v.filename")+' file uploaded'
                                });
                                toastEvent.fire();
                                component.set("v.spinner",false);
                            }
                            // added Error message part of NOKIASC-29186 US
                            else{ 
                                component.set("v.showMain",true);
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    "title": 'Error',
                                    "type": 'error',
                                    "message": 'File upload failed, please check file and retry'
                                });
                                toastEvent.fire();
                                component.set("v.spinner",false);
                            }
                        }
                        else if (state === "INCOMPLETE") {
                        }
                    });
                    $A.enqueueAction(action);
                    var numOfRows=component.get("v.NumOfRecords");
                    if(dataRows > numOfRows+1 || dataRows === 1 || dataRows === 0){
                        component.set("v.showMain",true);
                    } 
                    else{
                        component.set("v.showMain",false);                   
                    }
                }
                reader.readAsText(file);
            }
        var reader = new FileReader();
        reader.onloadend = function() {
        };
        reader.readAsDataURL(file);
    },
    //NOKIASC-38077:Refactoring Code-Start
    setDataTableColumns : function(component,helper){
        component.set('v.bulkRMAColumns', [
            {label: 'Status', fieldName: 'Status__c', type: 'text', editable: false, "initialWidth": 100},            
            {label: 'Part Code - Part Revision', fieldName: 'Part_Code_Part_Revision__c', type: 'text', editable: true, "initialWidth": 200,
             "cellAttributes": {
                 "class": {
                     "fieldName": "showClassPartCode"
                 }
             }},
            {label: 'Error Messages', fieldName: 'Validation_Message__c', type: 'text' ,editable: false, "initialWidth": 200},
            {label: 'Contract Number', fieldName: 'HWS_Service_Contract_Number__c', type: 'text', "initialWidth": 120},
            {type: 'button-icon', "initialWidth": 1, typeAttributes: {iconName: 'utility:edit', name: 'editContractNumber', title: 'Edit', variant: 'bare', alternativeText: 'edit', disabled: false, size: 'xx-small'}},
            //Start Changes for 25679
            {label: 'NEA Count', fieldName: 'HWS_NEACount__c', "initialWidth": 100, type: 'number',},
            {label: 'Network Element Asset', fieldName: 'HWS_NetworkElementAssetName__c', type: 'text', "initialWidth": 180},
            {type: 'button-icon', "initialWidth": 1, typeAttributes: {iconName: 'utility:edit', name: 'editNEA', title: 'Edit', variant: 'bare', alternativeText: 'edit', disabled: false, size: 'xx-small'}},
            //End Changes for 25679
            {label: 'SLA Value', fieldName: 'SLA_Value__c', type: 'text', editable: false, "initialWidth": 105},
            {label: 'SLA Unit', fieldName: 'SLA_Unit__c', type: 'text', editable: false, "initialWidth": 100},
            {label: 'SSI Description', fieldName: 'SSI_Description__c', type: 'text', editable: false, "initialWidth": 100},
            {label: 'Comments', fieldName: 'Comments__c', type: 'text', editable: false, "initialWidth": 200},            
            {label: 'Ship to Address', fieldName: 'ShipToAddressName', type: 'text', editable: false, "initialWidth": 150},
            {type: 'button-icon', "initialWidth": 1, typeAttributes: {iconName: 'utility:edit', name: 'editShipToAddress', title: 'Edit', variant: 'bare', alternativeText: 'edit', disabled: false, size: 'xx-small'}},
            {label: 'Faulty Unit Serial Number Reported', fieldName: 'Faulty_Serial_number__c', type: 'text' ,editable: true, "initialWidth": 120},
            {label: 'Failure Detection', fieldName: 'Fault_Detection__c', type: 'text', "initialWidth": 120,
             "cellAttributes": {
                 "class": {
                     "fieldName": "showClassFailDet"
                 }
             }},
            {type: 'button-icon', "initialWidth": 1, typeAttributes: {iconName: 'utility:edit', name: 'faultDetection', title: 'Edit', variant: 'bare', alternativeText: 'edit', disabled: false, size: 'xx-small'}},
            {label: 'Failure Description', fieldName: 'Fault_Description__c', type: 'text', "initialWidth": 120,
             "cellAttributes": {
                 "class": {
                     "fieldName": "showClassFailDesc"
                 }
             }},
            {type: 'button-icon', "initialWidth": 1, typeAttributes: {iconName: 'utility:edit', name: 'editFailureDescription', title: 'Edit', variant: 'bare', alternativeText: 'edit', disabled: false, size: 'xx-small'}},
            {label: 'Failure Occurrence', fieldName: 'Fault_Occurrence__c', type: 'text', "initialWidth": 150,
             "cellAttributes": {
                 "class": {
                     "fieldName": "showClassFailOccu"
                 }
             }},
            {type: 'button-icon', "initialWidth": 1, typeAttributes: {iconName: 'utility:edit', name: 'Faultoccurance', title: 'Edit', variant: 'bare', alternativeText: 'edit', disabled: false, size: 'xx-small'}},
            {label: 'Failure detection Date', fieldName: 'Fault_Detection_Date__c', type: 'date-local', 
             typeAttributes:{month: "2-digit",day: "2-digit"},             
             editable: true, "initialWidth": 200,"cellAttributes": {
                 "class": {
                     "fieldName": "showClassFailDetDate"
                 }}},
            {label: 'Failure Description/ Server ID', fieldName: 'Failure_Description_Server_ID__c', type: 'text', editable: true, "initialWidth": 150},
            {label: 'Customer Reference Number', fieldName: 'Customer_Reference_Number__c', type: 'text', editable: true, "initialWidth": 150},
            {label: 'Fault Reported by Name', fieldName: 'Fault_Reported_by_Name__c', type: 'text', editable: true, "initialWidth": 170},
            {label: 'Fault Reported by Phone', fieldName: 'Fault_Reported_by_Phone__c', type: 'phone', editable: true, "initialWidth": 150},
            {label: 'Fault Reported by Email', fieldName: 'Fault_Reported_by_Email__c', type: 'email', editable: true, "initialWidth": 200},
            {label: 'Site Id', fieldName: 'Site_Id__c', type: 'text', editable: true, "initialWidth": 150},
            {label: 'Additional Configuration Details', fieldName: 'HWS_Site_Information__c', type: 'text', editable: true, "initialWidth": 150}          
        ]);     
    },
    //NOKIASC-38077:Refactoring Code-End
    setColumnsData : function(component, helper) {
        //NOKIASC-38077:Refactoring Code-Start
        this.setDataTableColumns(component, helper);
        //NOKIASC-38077:Refactoring Code-End
        var reqFieldValCheck = component.get('v.requiredFieldValidationCheck');
        if(reqFieldValCheck){			
            component.set("v.spinner",true); //added for NOKIASC-38872
            var action = component.get("c.setTableData");        
            action.setParams({ 
                rmaIds : component.get("v.bulkRMAIds")                
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                var updateValCheck = component.get("v.fieldUpdateValidationCheck");
                if (state === "SUCCESS") {
					if(component.get("v.submitCounter") == 0)
                    component.set("v.spinner",false);
                    var bulkRMA = response.getReturnValue();
                    // NOKIASC-29185 setting totalRecordsCount
                    var totalLength = bulkRMA.length ;
                    component.set("v.totalRecordsCount", totalLength);
                    var casestatusCheck = true;
                    var isSucces = true;
                    var isPending = false;
                    //Added as part of NOKIASC-36821" to prevent enable Save and Review on Success -Start
                    component.set("v.isNotSucces", false);
                    //Added as part of NOKIASC-36821" to prevent enable Save and Review on Success -end
                    for (var i = 0; i < bulkRMA.length; i++) {
                        var row = bulkRMA[i];
                        if (row.HWS_Ship_to_Address__c) {
                            row.ShipToAddressName = row.HWS_Ship_to_Address__r.Name;
                        }
                        //NOKIASC-34442
                        if(row.Fault_Detection_Date__c == undefined || row.Fault_Detection_Date__c== '' || row.Fault_Detection_Date__c== null) {
                            var today = new Date();
                            row.Fault_Detection_Date__c = today.toLocaleDateString('en-CA');
                        } //NOKIASC-34442
                        //Added as part of NOKIASC-36821" to prevent enable Save and Review on Success -Start
                        if(row.Status__c !='Success') {
                            component.set("v.isNotSucces", true);
                        }
                        //Added as part of NOKIASC-36821" to prevent enable Save and Review on Success -End
                        if(row.Status__c== "Failed" || row.Status__c== undefined || row.Status__c== '' || row.Status__c== null){
                            casestatusCheck = false;
                            isSucces = false;
                        } else if(row.Status__c== "Pending"){
                            isPending = true; 
                            component.set('v.statusPending',true);      
                        } else if (row.Status__c== "Success"){
                            isPending = false;   
                            component.set('v.statusPending',false);
                        }
                    } 
                    component.set('v.bulkRMAData',response.getReturnValue());
                    if(bulkRMA.length >0){
                        component.set('v.disableLoad',true);  
                    }
                    if(casestatusCheck && bulkRMA.length > 0){
                        component.set('v.statuscheck',true); 
                    }
                    else{
                        component.set('v.statuscheck',false); 
                    }
                      if(!component.get('v.statusforMandatoryCheck') && !updateValCheck){	
                        this.enableSubmit(component, event);	
                    }
                    component.set("v.showButtons",false);
                    if(component.get('v.statusforMandatoryCheck')){
                        this.validateMandatoryFields(component,event,helper);
                    }
                    //this.enableSubmit(component, event);
                    if(updateValCheck){
                           this.validateMandatoryFields(component,event);
                    } 
                    if (isPending == true) {
                        component.set('v.enableSubmit',true); 
                        component.set('v.enableSaveAndReview',false);
                    } else if (isPending == false) {
                        component.set('v.enableSaveAndReview',true);
                        component.set('v.enableSubmit',false); 
                    }
                    if(isSucces == false){
                        component.set('v.enableSaveAndReview',true);
                        component.set('v.enableSubmit',true);    
                    }
                }
            });
            $A.enqueueAction(action);
        }
    },
    setColumnsDataforPending : function(component, helper) {
        console.log('data for pending =======');
        component.set("v.spinner",false);
        component.set("v.enableSaveAndReview", false);
        component.set("v.enableSubmit", true); 
        //NOKIASC-38077:Refactoring Code-Start
        this.setDataTableColumns(component, helper);
        //NOKIASC-38077:Refactoring Code-End     
        var reqFieldValCheck = component.get('v.requiredFieldValidationCheck');
        console.log('I am in 201 :'+reqFieldValCheck);
        if(reqFieldValCheck){
            console.log('I am in 203 :');
            var action = component.get("c.getInPendingData");        
            action.setParams({ 
                rmaIds : component.get("v.bulkRMAIds")                
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                var updateValCheck = component.get("v.fieldUpdateValidationCheck");
                if (state === "SUCCESS") {
                    component.set("v.spinner",false);
                    var bulkRMA = response.getReturnValue();
                    // NOKIASC-29185 setting totalRecordsCount
                    var totalLength = bulkRMA.length ;
                    component.set("v.totalRecordsCount", totalLength);
                    var casestatusCheck = true;
                    for (var i = 0; i < bulkRMA.length; i++) {
                        var row = bulkRMA[i];
                        console.log('Ship to adress:'+row.HWS_Ship_to_Address__c);
                        if (row.HWS_Ship_to_Address__c) {
                            row.ShipToAddressName = row.HWS_Ship_to_Address__r.Name;
                        }
                        //NOKIASC-34442
                        if(row.Fault_Detection_Date__c == undefined || row.Fault_Detection_Date__c== '' || row.Fault_Detection_Date__c== null) {
                            var today = new Date();
                            row.Fault_Detection_Date__c = today.toLocaleDateString('en-CA');
                        } //NOKIASC-34442
                        console.log('row.Status__c====='+JSON.stringify(row.Status__c));
                        console.log('row.Status__c*******'+row.Status__c);
                        if(row.Status__c== "Failed" || row.Status__c== undefined || row.Status__c== '' || row.Status__c== null){
                            casestatusCheck = false; 
                        }
                    } 
                    console.log('SA 1');
                    component.set('v.bulkRMAData',response.getReturnValue());
                    console.log('SA 2')
                    if(bulkRMA.length >0){
                        component.set('v.disableLoad',true);  
                    }
                    if(casestatusCheck && bulkRMA.length > 0){
                        component.set('v.statuscheck',true); 
                    } else{
                        component.set('v.statuscheck',false); 
                        this.openCaseTab(component);
                    }
                    if(row.Status__c== "Pending"){
                        component.set('v.statusPending',true); // Nokiasc-35882
                        console.log('SA 3');
                    }
                    
                }
                // component.set("v.spinner",false);
            });
            $A.enqueueAction(action);
        }
    },
    validateMandatoryFields : function(component, event, helper) {
        var bulkRMAList = component.get('v.bulkRMAData');
        var errorMsgDisplay;
        var faultdetectDateError = false;
        var failureDetectionDateList = [];
        bulkRMAList.forEach(function(record){ 
            if(typeof record.Id != 'undefined'){                 
                if(record.Part_Code_Part_Revision__c == undefined){
                    errorMsgDisplay = true;
                    record.Status__c = 'Failed';
                    record.showClassPartCode = (record.Part_Code_Part_Revision__c == undefined ? 'redcolor' : 'blackcolor');                	
                }
                if(record.Fault_Detection__c == undefined){
                    errorMsgDisplay = true;
                    record.Status__c = 'Failed';
                    record.showClassFailDet = (record.Fault_Detection__c == undefined ? 'redcolor' : 'blackcolor');                    
                }
                if(record.Fault_Occurrence__c == undefined){
                    errorMsgDisplay = true;
                    record.Status__c = 'Failed';
                    record.showClassFailOccu = (record.Fault_Occurrence__c == undefined ? 'redcolor' : 'blackcolor');
                }
                if(record.Fault_Description__c == undefined){
                    errorMsgDisplay = true;
                    record.Status__c = 'Failed';
                    record.showClassFailDesc = (record.Fault_Description__c == undefined ? 'redcolor' : 'blackcolor');
                }
                var today = new Date();
                var ddate = new Date(record.Fault_Detection_Date__c);
                if(record.Fault_Detection_Date__c == undefined){
                    errorMsgDisplay = true;
                    record.Status__c = 'Failed';
                    record.showClassFailDetDate = (record.Fault_Detection_Date__c == undefined ? 'redcolor' : 'blackcolor');
                }//NOKIASC-34442
                else if (ddate > today){
                    faultdetectDateError = true;
                    record.Status__c = 'Failed';
                    record.showClassFailDetDate = 'redcolor';
                }//NOKIASC-34442
                if(record.Part_Code_Part_Revision__c != undefined && record.Fault_Detection__c != undefined && 
                   record.Fault_Occurrence__c != undefined && record.Fault_Description__c != undefined && record.Fault_Detection_Date__c != undefined && record.Status__c != 'Success'){
                    record.Status__c = '';
                }			
            }
        }); 
        if(errorMsgDisplay){
            component.set('v.mandatoryCheck',false);
            component.set('v.requiredFieldValidationCheck',false); 
            component.set('v.enableSubmit', true);
            component.set("v.statuscheck", false);
            this.setColumnsData(component,event);
            document.getElementById("validateRequiredFields").innerHTML = 'Please enter all the mandatory fields';
            component.set("v.spinner",false);	//added for NOKIASC-38872
        }//NOKIASC-34442
        else if(faultdetectDateError){
            component.set('v.mandatoryCheck',false);
            component.set('v.requiredFieldValidationCheck',false); 
            component.set('v.enableSubmit', true);
            component.set("v.statuscheck", false);
            this.setColumnsData(component,event);
            document.getElementById("validateRequiredFields").innerHTML = 'Failure Detection Date cannot be in the future';
            component.set("v.spinner",false);	//added for NOKIASC-38872
        }//NOKIASC-34442
            else{
                component.set("v.statuscheck", true);
                component.set('v.statusforMandatoryCheck',false);
                component.set('v.mandatoryCheck',true);  
                component.set('v.requiredFieldValidationCheck',true); 
                component.set('v.fieldUpdateValidationCheck',false); 
                //component.set('v.enableSubmit', false);
                this.validateGridHelper(component,event);
                this.setColumnsData(component,event);
                //this.enableSubmit(component, event, helper);
                document.getElementById("validateRequiredFields").innerHTML = ''; 
                component.set("v.spinner",false);	//added for NOKIASC-38872
            }         
        var updateValCheck = component.get("v.fieldUpdateValidationCheck");
        if(updateValCheck){
            console.log('I am in 455 :');
            this.setColumnsData(component,event);
        }
    },
    validateGridHelper : function(component,event,helper) {
        //component.set("v.recordId",'aCF560000004EIm');
        // var recId = component.get("v.bulkRMAData");
        //alert(caseRecId);
        var shipToAddr;
        if(component.get("v.shipToAddrAccId")==null || component.get("v.shipToAddrAccId")=='' || component.get("v.shipToAddrAccId")==undefined){
            shipToAddr = null;           
        }else{
            shipToAddr = component.get("v.shipToAddrAccId");
        }
        var action= component.get("c.validateFaulty"); 
        var ServiceContract = component.get("v.selectedServiceContract");
        //Added as part of NOKIASC-36821 to pass retrofitAccountId -start
        let retrofitAccntId = component.get("v.retrofitAccountId") != undefined &&  component.get("v.retrofitAccountId") != null && component.get("v.isGlobal") ==true? component.get("v.retrofitAccountId"): '';
        // NOKIASC-36821 -end
        //   alert('Starteds');
        if(component.get("v.retrofitRequired") =='true' || component.get("v.retrofitRequired") == true){
            action= component.get("c.validateFaultyRetroFit"); 
            action.setParams({
                recordID : component.get("v.bulkRMAData"),
                accountID :component.get("v.selectedAccount"),
                serviceType:component.get("v.selectedServiceType"),
                contactId : component.get("v.contactId"),
                shipToAddrUpdated : shipToAddr,
                selectedSC: ServiceContract[0].Id,
                retrofitAccountId : retrofitAccntId,
				legalAccNum : component.get("v.selectedLegalAccNum")
            });
        }
        else{
           
            action.setParams({
                recordID : component.get("v.bulkRMAData"),
                accountID :component.get("v.selectedAccount"),
                serviceType:component.get("v.selectedServiceType"),
                contactId : component.get("v.contactId"),
                shipToAddrUpdated : shipToAddr,
				legalAccNum : component.get("v.selectedLegalAccNum")
            });
        }
        console.log('Return values are '+component.get("v.bulkRMAData"));
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            // alert('State is :'+state);
            if (state == "SUCCESS"){
                //  alert('Starteds');
                // component.set("v.requiredFieldValidationCheck",true);
                var caseReturnList = response.getReturnValue();
                console.log('Return values are 1'+JSON.stringify(caseReturnList));
                //  component.set('v.bulkRMAData',response.getReturnValue());
            }
            else{this.showToast('error','Error','An Internal Error Has occurred. Please try after some time');}
        }));
        $A.enqueueAction(action);
    },
	// NOKIASC-37921 | Start
    insertCaseHelper: function(component, event, actionValue){
        component.set("v.spinner",true);
        var bulkRMAadata = component.get("v.bulkRMAData");
		// NOKIASC-39638 | Start
		var iCount = component.get("v.submitCounter");
        iCount = iCount + 1;
        component.set("v.submitCounter", iCount);
		// NOKIASC-39638 | End		
        var accountId = component.get("v.selectedAccount");
        var contactId = component.get("v.contactId");
        var serviceType = component.get("v.selectedServiceType");
        var parentCaseInfo = component.get("v.parentCase");
        if(component.get("v.isGlobal") == true && component.get("v.retrofitRequired") =='true' &&
           component.get("v.retrofitAccountId") != undefined && component.get("v.retrofitAccountId") !=null && component.get("v.retrofitAccountId") !='')  {            
            accountId = component.get("v.retrofitAccountId");
        }
        var action = component.get("c.insertBulkRMACaseData");
        var isInprogress = component.get("v.inProgressCase");
        action.setParams({
            'buList' 		: bulkRMAadata,
            'accountId' 	: accountId,
            'contactId' 	: contactId,
            'parentCaseShipmentInfo' 	: parentCaseInfo,
            'serviceType'	: serviceType,
            'contactTimeZone' : component.get("v.contactTimeZone"),
            'isPending' : isInprogress,
			'Actiontype' :actionValue
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){
                var stringItems = response.getReturnValue();
				component.set("v.submitCounter", 0); 
                component.set("v.spinner",false);
                if(actionValue == 'Submit'){
                     var sNote = $A.get("$Label.c.HWS_BU_Confirmation");
                    sNote = sNote.replace('{0}', stringItems);
                    this.showToastSticky('success','Success Message',sNote);
                }
                else{
                    var sNote = $A.get("$Label.c.HWS_BUW_Confirmation");
                    sNote = sNote.replace('{0}', stringItems);
                    this.showToastSticky('success','Success Message',sNote);
                    
                }
				this.openBulkCaseTab(component);
            }
            else if(state === "ERROR"){
                var errors = response.getError();
				component.set("v.submitCounter", 0); 
                component.set("v.spinner",false);
                this.showToast('error','Error Message',errors[0].message);
            }
            
        });
        $A.enqueueAction(action);
    },
     openBulkCaseTab : function(component) {        
         var navService  = component.find("navService");
         var pageReference = {
             type: 'standard__objectPage',
             attributes: {
                 objectApiName: 'Case',
                 actionName: 'list'
             },
             state: {
                 filterName: $A.get("$Label.c.HWS_Bulk_List_View_Id")
             }
         };
         component.set("v.pageReference", pageReference);
         var pageReference1 = component.get("v.pageReference");      
         navService.navigate(pageReference1);       
    },
    //NOKIASC-37921 | End
    /****** Method to create the Bulk RMA Cases
    		HWST-3681 Sprint - 1926
    		Start ***************************/
    saveCaseHelper : function(component, event){
        component.set("v.spinner",true);
        var bulkRMAadata = component.get("v.bulkRMAData");
        var accountId = component.get("v.selectedAccount");
        var contactId = component.get("v.contactId");
        /*--NOKIASC-36821 Start--*/
        if(component.get("v.isGlobal") == true && component.get("v.retrofitRequired") =='true' &&
           component.get("v.retrofitAccountId") != undefined && component.get("v.retrofitAccountId") !=null && component.get("v.retrofitAccountId") !='') {

            accountId = component.get("v.retrofitAccountId");
        }
        /*--NOKIASC-36821 End-- */
        /*var shipmentName = component.get("v.parentCase.HWS_Shipment_Recipient_Name__c");
        var shipmentEmail = component.get("v.parentCase.HWS_ShipmentRecipientEmailId__c");
        var shipmentPhone = component.get("v.parentCase.HWS_Shipment_Recipient_Phone__c");*/		
        var serviceType = component.get("v.selectedServiceType");
        var parentCaseInfo = component.get("v.parentCase");
        //alert('Shipment Info are: ' +shipmentName +''+shipmentEmail+''+shipmentPhone);
        var action = component.get("c.createBulkRMACase");
        var isInprogress = component.get("v.inProgressCase");
        console.log('isInprogress===='+isInprogress);
        // Send the list whose status is only Success
        
        action.setParams({
            'buList' 		: bulkRMAadata,
            'accountId' 	: accountId,
            'contactId' 	: contactId,
            'parentCaseShipmentInfo' 	: parentCaseInfo,
            'serviceType'	: serviceType,
            'contactTimeZone' : component.get("v.contactTimeZone"),
            'isPending' : isInprogress
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            //alert('response ' +state);
            if(state == "SUCCESS"){
                var stringItems = response.getReturnValue();
                //NOKIASC-37118:Store parentId of child case|Start
                 //Added the null check
                if(stringItems != undefined && stringItems.newTimeZoneCaseList.length > 0){
                  var parentId=stringItems.newTimeZoneCaseList[0].ParentId;
                  component.set("v.parentCaseId",parentId);
                }
                //NOKIASC-37118:Store parentId of child case|End
                console.log('stringItems***'+ JSON.stringify(stringItems));
                var st = [];
                st.push(stringItems.newTimeZoneCaseList);
                //component.set("v.childCases",st[0]);
                var st1 = [];
                st1.push(stringItems.parentAccIds);
                console.log('SSSSTT:'+st1[0]);
                component.set('v.bulkParentCaseNumber',st1[0]);
                var st2 = [];
                st2.push(stringItems.sucessError);
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
                var IsSave = component.get("v.saveAndReview");
                console.log('IsSave'+IsSave);
                if( IsSave == true || IsSave =='true' ){
                    //34752 - START
                    var actionCallout=component.get('c.makeSOOBulkCalloutForWarrantyCheck');
                    actionCallout.setParams({
                        parentCaseNumberList : component.get("v.bulkParentCaseNumber")
                    });
                    actionCallout.setCallback(this, $A.getCallback(function (response) {
                        var state = response.getState();
                        var processResponse=response.getReturnValue();
                        //No need to process response
                    }));
                    $A.enqueueAction(actionCallout);
                    //34752 - END
                    
                    this.showToast('success','Success Message','Warranty check is being performed which could take several minutes.');
                    this.openCaseTab(component);
                }
                if(st2[0].includes("NoError")){
                    //alert('response is success');
                    var caseNumbers = st1[0];
                    component.set('v.caseNumber',caseNumbers);
                    if(IsSave == false || IsSave == 'false' ) {
                        this.showToast('success','Success Message','Your order has been successfully submitted.' );  
                    }
                    if (isInprogress) {
                        //3785
                       // NOKIASC-37920 | Commented out as logic of listChildCasetimeZone is handled in HWS_Utility.accountTimeZoneplannedDeliveryDateTime method called from HWS_CreateSupportTicketportal.timeZoneUpdateCaseList
                        //3785
                       /* var timeZone=component.get('c.listChildCasetimeZone');
                        timeZone.setParams({
                            listChildCasetimeZone : listChildCasetimeZone
                        });
                        timeZone.setCallback(this, $A.getCallback(function (response) {*/
                            var state = response.getState();
                            var processResponse=response.getReturnValue();
                            if (state === "SUCCESS") {
                                console.log('component.get("v.caseNumber"): '+component.get("v.caseNumber"));
                                console.log('listChildCasetimeZone: '+listChildCasetimeZone);
                                var actionCallout=component.get('c.makeSOOCalloutBulkRMAUpdate');
                                actionCallout.setParams({
                                    parentCaseNumberList : component.get("v.caseNumber"),
                                    listChildCasetimeZone : listChildCasetimeZone
                                });
                                actionCallout.setCallback(this, $A.getCallback(function (response) {
                                    var state = response.getState();
                                    var processResponse=response.getReturnValue();
                                    if (state === "SUCCESS") {                                
                                        if(processResponse!=null){
                                            var statuscode=processResponse.statusCode;
                                            if(statuscode===200){
                                                this.showToast('success','Success Message','Case was created and submitted to SOO');
                                                console.log('Case was created and submitted to SOO');
                                            } else
                                            {
                                                console.log('Case was created and Not submitted to SOO');
                                            }
                                        }
                                    }
                                    var isInReview = component.get("v.enableSaveAndReview");
                                    //Added  "&& component.get("v.isSucces") in below code as part of NOKIASC-36821" to prevent enable Save and Review on Success
                                    if ((isInReview == true || isInReview == 'true') && component.get("v.isNotSucces")==true) {
                                        component.set("v.spinner",true);
                                        component.set("v.enableSaveAndReview", false);
                                        this.setColumnsDataforPending(component, event);   
                                    } else {
                                        this.openCaseTab(component);    
                                    }
                                }));
                                $A.enqueueAction(actionCallout);
                            }
                        //}));			
                        //$A.enqueueAction(timeZone);  // NOKIASC-37920 | Commented out as logic of listChildCasetimeZone is handled in HWS_Utility.accountTimeZoneplannedDeliveryDateTime method called from HWS_CreateSupportTicketportal.timeZoneUpdateCaseList
                    } else {
                        this.openCaseTab(component);    
                    }
                } else if(st2[0].includes("DMLError")){
                    this.showToast('error','Error Message','Error While Creating Case' +stringItems.parentAccIds[0]);
                    component.set("v.spinner",false);
                    component.set("v.enableSubmit", false);
                    component.set("v.disableValidateDelete", false);
                } else if(st2[0].includes("error")){
                    this.showToast('error','Error Message','Please enter contract number and Ship to party address to proceed with Case submission');
                    component.set("v.spinner",false);
                    component.set("v.enableSubmit", false);
                    component.set("v.disableValidateDelete", false);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    /************** END *******************/
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
    saveTableValues : function(component, event, helper) {
        var editedRecords =  event.getParam('draftValues');
        var totalRecordEdited = editedRecords.length;
	//NOKIASC-37156:Make default value when part code change|Start
        for(var i=0;i<totalRecordEdited;i++){
            if(typeof(editedRecords[i].Part_Code_Part_Revision__c) != 'undefined'){
                editedRecords[i].NCP_Service_Contract__c = null;
                editedRecords[i].Comments__c = null;
                editedRecords[i].HWS_PO_Number__c=null;
                editedRecords[i].HWS_Sellable_Product__c =null;
                editedRecords[i].HWS_Product_Name__c =null;
                editedRecords[i].HWS_Contract_Line_Item__c = null; 
                editedRecords[i].HWS_Asset__c = null;     
                editedRecords[i].SLA_Unit__c =null;
                editedRecords[i].SLA_Value__c = null;
                editedRecords[i].SSI_Description__c = null;
                editedRecords[i].HWS_Service_Contract_Number__c = null;
                editedRecords[i].HWS_ServiceType__c=null;
                editedRecords[i].Warranty_Verification_Required__c = null;   
                editedRecords[i].HWS_NetworkElementAsset__c=null;
                editedRecords[i].HWS_NetworkElementAssetName__c=null; 
                editedRecords[i].HWS_NEACount__c=null;
                editedRecords[i].HWS_Part_Code__c=null;
                editedRecords[i].HWS_Part_Revision__c=null;
            }
        }
        //NOKIASC-37156:Make default value when part code change|End
        
        var action = component.get("c.updateRMAValues");
        action.setParams({
            'editedRMAList' : editedRecords
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if(state == "SUCCESS")            {                
                var caseReturnList = response.getReturnValue();
                component.find( "bulkRMATable" ).set( "v.draftValues", null );
                component.set('v.requiredFieldValidationCheck',true);
                component.set('v.statusforMandatoryCheck',false);
                document.getElementById("validateRequiredFields").innerHTML = '';
                component.set('v.fieldUpdateValidationCheck',true);
                this.setColumnsData(component,event);
            }
            //  $A.get('e.force:refreshView').fire();
        });
        $A.enqueueAction(action);
    },
    
    deleteCaseHlp:function(component,event){                
        var bulkUploadIdList=component.get("v.selection");
        console.log('bulkUploadIdList : '+bulkUploadIdList);
        var action=component.get("c.deleteBulkUpload");
        action.setParams({
            lstBulkUploadId:bulkUploadIdList
        });
        action.setCallback(this,function(response){
            var state=response.getState();
            
            if (state=='SUCCESS'){
                component.set("v.requiredFieldValidationCheck",true);
                this.setColumnsData(component,event);            
            }
        })
        $A.enqueueAction(action);
    },
    
    getRecordValues : function(component,event){
        var bulkRecId = event.getParam('row').Id;
        var contractNumber = event.getParam('row').HWS_Service_Contract_Number__c;         
        component.set("v.rowId",bulkRecId);
        var actionName = event.getParam('action').name;
        console.log('actionName===='+actionName);
        console.log('actionName '+actionName);
        var serviceType =  component.get("v.selectedServiceType");
        
        var accountId = component.get("v.selectedAccount");
        var contactId = component.get("v.contactId");  
        var ServiceContract = component.get("v.selectedServiceContract");
        if(actionName == 'editContractNumber'){            
            component.set("v.Assets", []);
            var action=component.get("c.getAllAssets");
            if(component.get("v.retrofitRequired") ==true || component.get("v.retrofitRequired") =='true'){
                action.setParams({
                    bulkId:bulkRecId,
                    accId : accountId,
                    serviceType : serviceType,
                    contactId : contactId,
                    selectedSC: ServiceContract[0].Id 
                });
            }
            else{
                action.setParams({
                    bulkId:bulkRecId,
                    accId : accountId,
                    serviceType : serviceType,
                    contactId : contactId
                });
            }            
            action.setCallback(this,function(response){
                var state=response.getState();
                var assets = [];
                if (state=='SUCCESS'){
                    component.set("v.Assets", []);
                    component.set("v.selectedPartCode",'');
                    component.set('v.assetColumns', [
                        {label: 'SLA Value', fieldName: 'HWS_ContractLeadTimeDuration__c', type: 'text'},
                        {label: 'SLA Unit', fieldName: 'HWS_ContractLeadTimeUnit__c', type: 'text'},
                        {label: 'Contract Number', fieldName: 'HWS_Service_Contract_Number__c', type: 'text'},
                        {label: 'SSI Description', fieldName: 'HWS_ServiceItemDescription__c', type: 'text'},
                        {label: 'Comments', fieldName: 'CoverageGroup', type: 'text'}
                    ]); 
                    
                    assets = response.getReturnValue();
                    if(assets!=null && assets.length>0){
                        for (var i = 0; i < assets.length; i++) {
                            var row = assets[i];
                            if (row.HWS_ContractLineItem__c) {
                                row.CoverageGroup = row.HWS_ContractLineItem__r.CH_CoverageGroup__c;
                            }
                        }
                        component.set("v.Assets", assets);
                        //alert('Assets:'+JSON.stringify(assets));
                        component.set("v.selectedPartCode",assets[0].HWS_Part_Code__c);
                    }else{
                        document.getElementById("validateContract").innerHTML ='There is no Contract with the specified Part code';
                    }
                }
            })
            $A.enqueueAction(action);
            component.set("v.selectContractLineItem",true);
        }
        //Start Changes for 25679
        if(actionName == 'editNEA'){   
            if(contractNumber == null || contractNumber == undefined){
                this.showToast('error','Error Message','Please select Contract Number before selecting Network Element Asset');
            } else{
                if(event.getParam('row').HWS_NEA_Count__c === 0){
                    this.showToast('error','Error Message','There is no Network Element Asset with the specified Part code');
                }
                else{ 
                    //NOKIASC-32957
                    component.set('v.netElemAssets',null);
                    component.set('v.NEAFilterText',null);
                    component.set("v.isSpinner",true);
                    component.set('v.enableInfiniteLoading',true);
                    var limit =component.get('v.initialRows');
                    var offSetValue  =component.get('v.rowNumberOffset');
                    var action=component.get("c.fetchAssetNetworkElementWithSearch");	
                    console.log('offSetValue:'+offSetValue+'limit:'+limit);
                    action.setParams({
                        bulkId:bulkRecId,
                        byPassValue:false,
                        "offSetValue" : offSetValue,
                        "soqlLimit":limit
                    });					
                    action.setCallback(this,function(response){
                        // event.getSource().set("v.isLoading", true); 
                        var state=response.getState();
                        console.log(state);
                        var neaList = [];
                        if (state=='SUCCESS'){
                            component.set('v.currentCount',component.get('v.initialRows'));
                            component.set("v.netElemAssets",[]);
                            component.set('v.neaColumns', [
                                {label: 'Network Element ID', fieldName: 'CH_NetworkElementID__c', sortable: 'true', searchable: 'true', type: 'text',"initialWidth": 180},
                                {label: 'Asset Name', fieldName: 'Name', sortable: 'true', searchable: 'true', type: 'text'},
                                {label: 'Product', fieldName: 'ProductName', sortable: 'true', searchable: 'true', type: 'text'},
                                {label: 'Solution', fieldName: 'SolutionName', sortable: 'true', searchable: 'true', type: 'text'},
                                {label: 'Product Variant', fieldName: 'ProductVariant', sortable: 'true', searchable: 'true', type: 'text'},
                                {label: 'Product Release', fieldName: 'ProductRelease', sortable: 'true', searchable: 'true', type: 'text'},
                                {label: 'Address', fieldName: 'Address', sortable: 'true', searchable: 'true', type: 'text'},
                                {label: 'Lab', fieldName: 'CH_LabEnvironment__c', sortable: 'true',searchable: 'true', type: 'boolean'},        
                                {label: 'Country', fieldName: 'CH_CountryISOName__c', searchable: 'true', type: 'hidden'}
                            ]); 
                            var neaList = response.getReturnValue(); 
                            console.log('editRowNEA'+neaList.length);
                            if(neaList!=null && neaList.length>0){
                                for(var i = 0; i < neaList.length; i++) {
                                    neaList[i].CH_NetworkElementID__c= neaList[i].CH_NetworkElementAsset__r.CH_NetworkElementID__c;
                                    neaList[i].Name = neaList[i].CH_NetworkElementAsset__r.Name;
                                    neaList[i].Address = neaList[i].CH_NetworkElementAsset__r.Address__r?neaList[i].CH_NetworkElementAsset__r.Address__r.CH_AddressDetails__c :'N/A';
                                    neaList[i].ProductName = neaList[i].CH_NetworkElementAsset__r.Product2?neaList[i].CH_NetworkElementAsset__r.Product2.Name :'';
                                    neaList[i].SolutionName = typeof(neaList[i].CH_NetworkElementAsset__r.CH_Solution__r) != 'undefined'?neaList[i].CH_NetworkElementAsset__r.CH_Solution__r.Name :'';
                                    neaList[i].ProductVariant = typeof(neaList[i].CH_NetworkElementAsset__r.CH_ProductVariant__r) != 'undefined'?neaList[i].CH_NetworkElementAsset__r.CH_ProductVariant__r.Name :'';
                                    neaList[i].ProductRelease = typeof(neaList[i].CH_NetworkElementAsset__r.CH_ProductRelease__r) != 'undefined'?neaList[i].CH_NetworkElementAsset__r.CH_ProductRelease__r.Name :'';
                                    
                                    if(neaList[i].Id === component.get("v.selected")) {
                                        selected = true;
                                        component.find("neaTable").setSelectedRows(new Array(neaList[i].Id));
                                    }
                                    component.set('v.netElemAssets',neaList);
                                    component.set('v.showAllNEA',neaList);
                                }
                                component.set("v.isSpinner",false);
                                component.set('v.netElemAssets',neaList);
                                component.set('v.showAllNEA',neaList);
                            }
                        }
                        //event.getSource().set("v.isLoading", false); 
                    })
                    $A.enqueueAction(action);
                    component.set("v.selectNEAItem",true);
                }
            }
        }
        //End  Changes for 25679
        if(actionName == 'editShipToAddress'){
            var assetId = event.getParam('row').HWS_Asset__c;
            if(assetId!= undefined){
                //NOKIASC-36274:Ship to party selection for Combined Ordering(Added ServiceContract.HWS_Combined_Ordering__c field)
                if(event.getParam('row').HWS_Asset__r.HWS_ContractLineItem__r.ServiceContract.HWS_Combined_Ordering__c){
                    component.set("v.erpSystem",'Both');
                }
                else{
                    var erp = event.getParam('row').HWS_Asset__r.HWS_ContractLineItem__r.ServiceContract.CH_ERPSystem__c;
                    component.set("v.erpSystem",erp);
                }
                //End-NOKIASC-36274:
                
            }
           if(contractNumber == null || contractNumber == undefined){
               this.showToast('error','Error Message','Please select Contract Number before selecting Ship to Address');
           } else{
                component.set("v.shipToAddrCheck",true);            
           }
        }
        if(actionName == 'editFailureDescription' || actionName == 'Faultoccurance' || actionName == 'faultDetection' )
        {
            //component.set("v.selectContractLineItem",false);
            component.set("v.selectFailureDescription",true);
            var selectedRows = event.getParam("selectedRows");
            var selectedAsset = selectedRows[0];
            component.set("v.selectedAsset",selectedAsset);
        }
    },
    componentRefresh : function(component, event) {//NOKIASC-32957
        component.set('v.netElemAssets',null);
        component.set('v.initialRows',200);
        component.set('v.rowNumberOffset',0);
        component.set('v.currentCount',200);
        component.set('v.enableInfiniteLoading',false);
    },
    fetchAssets : function(component, event) {//Start Method -NOKIASC-32957
        
        var recordOffset = component.get("v.currentCount");
        var recordLimit = component.get("v.initialRows");
        var action = component.get("c.fetchAssetNetworkElementWithSearch"); 
        action.setParams({
            "offSetValue" :recordOffset,
            "soqlLimit":recordLimit,            
            "bulkId" : component.get("v.rowId"),
            "byPassValue" : false,
            "searchKeyWord" : null
        }); 
        action.setCallback(this,function(response){
            event.getSource().set("v.isLoading", true);
            var state=response.getState();
            var neaList = [];
            if (state=='SUCCESS'){
                recordOffset = recordOffset+recordLimit;
                component.set("v.currentCount", recordOffset);                
                var neaList = response.getReturnValue();              
                console.log("NEA LENGTH:"+neaList.length);
                var currentData = component.get('v.netElemAssets');   
                if(neaList!=null && neaList.length>0){
                    for(var i = 0; i < neaList.length; i++) {
                        
                        neaList[i].CH_NetworkElementID__c= neaList[i].CH_NetworkElementAsset__r.CH_NetworkElementID__c;
                        neaList[i].Name = neaList[i].CH_NetworkElementAsset__r.Name;
                        neaList[i].Address = neaList[i].CH_NetworkElementAsset__r.Address__r?neaList[i].CH_NetworkElementAsset__r.Address__r.CH_AddressDetails__c :'N/A';
                        neaList[i].ProductName = neaList[i].CH_NetworkElementAsset__r.Product2?neaList[i].CH_NetworkElementAsset__r.Product2.Name :'';
                        neaList[i].SolutionName = typeof(neaList[i].CH_NetworkElementAsset__r.CH_Solution__r) != 'undefined'?neaList[i].CH_NetworkElementAsset__r.CH_Solution__r.Name :'';
                        neaList[i].ProductVariant = typeof(neaList[i].CH_NetworkElementAsset__r.CH_ProductVariant__r) != 'undefined'?neaList[i].CH_NetworkElementAsset__r.CH_ProductVariant__r.Name :'';
                        neaList[i].ProductRelease = typeof(neaList[i].CH_NetworkElementAsset__r.CH_ProductRelease__r) != 'undefined'?neaList[i].CH_NetworkElementAsset__r.CH_ProductRelease__r.Name :'';
                        if(neaList[i].Id === component.get("v.selected")) {
                            selected = true;
                            component.find("neaTable").setSelectedRows(new Array(neaList[i].Id));
                        }                        
                        component.set("v.netElemAssets", currentData.concat(neaList));
                        component.set('v.showAllNEA',neaList);
                    }                    
                    component.set("v.netElemAssets", currentData.concat(neaList));
                    component.set('v.showAllNEA',neaList);
                    
                }
            }
            event.getSource().set("v.isLoading", false);
        })
        $A.enqueueAction(action);
        component.set("v.selectNEAItem",true);
    },
    updateServiceContract : function(component, event) {
        var selectedAsset = component.get("v.selectedAsset");  
        var bulkRecId = component.get("v.rowId");
        //alert('bulkId+:'+bulkRecId);
        //alert('bulkId+:'+component.get("v.selectedAsset"));
        var action = component.get("c.updateServiceContractValues");
        action.setParams({
            'selectedAsset' : selectedAsset,
            'bulkRecId' : bulkRecId
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){ 
                //alert('state:'+state);
                //component.set("v.Assets",[]);
                component.set("v.selectContractLineItem",false);
                component.set("v.requiredFieldValidationCheck",true);
                component.set("v.selectedAsset",null);
                this.setColumnsData(component,event);
            }
            //  $A.get('e.force:refreshView').fire();
        });
        $A.enqueueAction(action);
    },
    
    enableSubmit : function(component, event, helper) {
        console.log('Input Vaues' );
        var bulkRMAStatus = component.get("v.statuscheck");  
        console.log('Input Vaues'+ bulkRMAStatus );
        if(bulkRMAStatus == true){
            component.set('v.enableSubmit', false);
        }
        else{
            component.set('v.enableSubmit', true);
        }
    },
    //NOKIASC-37118:redirect to parent case tab for console|Start
    openParentCaseTab : function(component, newCaseURL) {
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
    //NOKIASC-37118:redirect to parent case tab for console|End
    openCaseTab : function(component) {
        if($A.util.isEmpty(component.get("v.consoleContactId"))){
            var navService  = component.find("navService");
            var pageReference = {
                type: 'standard__objectPage',
                attributes: {
                    objectApiName: 'Case',
                    actionName: 'list'
                },
                state: {
                    filterName: $A.get("$Label.c.HWS_ListView_Id")
                }
            };
            component.set("v.pageReference", pageReference);
            var pageReference1 = component.get("v.pageReference");      
            navService.navigate(pageReference1);
        }
        else{
            var parentId=component.get("v.parentCaseId");
            this.openParentCaseTab(component, this.getLightningURL(parentId));
            this.closeTab(component);
            
        }
    },
    
    setShipToAddressHelper : function(component, event) {
        var lookupList   = component.find('lookuplistPilot');
        var searchString = component.get('v.strSearchShipToAddrName');
        var accountId = component.get('v.selectedAccount');
        var retroAccoutId = component.get('v.retrofitAccountId');
        if(retroAccoutId != undefined)
            accountId = retroAccoutId;
        var erpSys = component.get('v.erpSystem');
        if (typeof searchString === 'undefined' || searchString.length < 3)
        {
            console.log('searchString'+searchString);
            $A.util.addClass(lookupList, 'slds-hide');
            return;            
        }
        //added for NOKIASC-38438
        var regularExpression;
    	//Added regular expression for Basic Latin,Latin-1 Supplement,Latin Extended-A,Latin Extended-B
    	var regex = new RegExp(/^([\u0000-\u007f\u0080-\u00ff\u0100-\u017f\u2000-\u206f]*)$/g);
    	if(regex.test(searchString) ){
    		component.set("v.isEnglish",true);
    	}
    	else{
    		component.set("v.isEnglish",false);
    	}
        $A.util.removeClass(lookupList, 'slds-hide');  
        var action=component.get("c.selectShipToAddress");
        action.setParams({
            accountId : accountId, 
            erp : erpSys,
            searchKey : searchString,
            countryName:  component.get('v.countryName')
        });
        action.setCallback(this,function(response){
            var state=response.getState();       
            if (state=='SUCCESS'){
                var shipToAdr = response.getReturnValue();
                component.set("v.shipToAddrList",shipToAdr);
                console.log('response '+JSON.stringify(component.get("v.shipToAddrList")));
            }
        })
        $A.enqueueAction(action);
    },
    
    saveShipToAddrHlpr : function(component, event) {
        var bulkRecId = component.get("v.rowId");
        var shipToAddress = component.get("v.shipToAddrAccId");
        var action=component.get("c.updateShipToAddress");
        action.setParams({
            bulkRecId : bulkRecId,
            shipToAddrId : shipToAddress
        });
        action.setCallback(this,function(response){
            var state=response.getState();                
            if (state=='SUCCESS'){                
                component.set("v.requiredFieldValidationCheck",true);
                this.setColumnsData(component, event);
            }
        })
        $A.enqueueAction(action);
    },
    
    
    //Start of Changes for 25679
    // Used to update the SelectedNEA Asset on the Bulkupload
    updateNEA : function(component, event) {
        var selectedNEAAsset = component.get("v.selectedNEAAsset");  
        var bulkRecId = component.get("v.rowId");
        var selectedNEAName=component.get("v.selectedNEA");  
        console.log('selectedNEAAsset : '+selectedNEAAsset.CH_NetworkElementAsset__c+'###'+selectedNEAAsset.CH_NetworkElementAsset__r.Name);
        var action = component.get("c.updateNEAValues");
        action.setParams({
            'selectedAssetId' : selectedNEAAsset.CH_NetworkElementAsset__c,
            'selectedAssetName' : selectedNEAAsset.CH_NetworkElementAsset__r.Name,
            'bulkRecId' : bulkRecId
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            console.log("STATE:"+state);
            if(state == "SUCCESS"){ 
                component.set("v.selectNEAItem",false);
                component.set("v.requiredFieldValidationCheck",true);
                component.set("v.selectedNEAAsset",null);
                this.setColumnsData(component,event);
            }
        });
        $A.enqueueAction(action);
    },
    // End of Changes for 25679
    getAssetsWithSearchFilter: function(component, page, recordToDisply,helper) {//Start Method -NOKIASC-32957
        // debugger;
        component.set("v.isSpinner",true);
        var action = component.get("c.fetchAssetNetworkElementWithSearch"); 
        var limit =component.get('v.initialRows');
        var offSetValue  =component.get('v.rowNumberOffset');
        console.log('PAGE:'+page+'REC:'+recordToDisply+'bulkId:'+component.get("v.rowId")+'##'+component.get("v.NEAFilterText"));
        action.setParams({
            "offSetValue" : offSetValue,
            "soqlLimit":limit,            
            "bulkId" : component.get("v.rowId"),
            "byPassValue" : false,
            "searchKeyWord" : component.get("v.NEAFilterText")
        });  
        action.setCallback(this, function(response) { 
            var state = response.getState();
            if (state === "SUCCESS") {
                var rows = response.getReturnValue();  
                console.log('ROW###'+JSON.stringify(rows)+'LENGTH:'+rows.length);
                for (var i = 0; i < rows.length; i++) {
                    console.log('ROW###'+rows[0]);
                    var row = rows[i];	
                    if (row.CH_NetworkElementAsset__c && row.CH_NetworkElementAsset__c!=null) {
                        row.CH_NetworkElementID__c= row.CH_NetworkElementAsset__r.CH_NetworkElementID__c;
                        row.Name = row.CH_NetworkElementAsset__r.Name;
                        row.Address = row.CH_NetworkElementAsset__r.Address__r?row.CH_NetworkElementAsset__r.Address__r.CH_AddressDetails__c :'N/A';
                        row.ProductName = row.CH_NetworkElementAsset__r.Product2?row.CH_NetworkElementAsset__r.Product2.Name :'';
                        row.SolutionName = typeof(row.CH_NetworkElementAsset__r.CH_Solution__r) != 'undefined'?row.CH_NetworkElementAsset__r.CH_Solution__r.Name :'';
                        row.ProductVariant = typeof(row.CH_NetworkElementAsset__r.CH_ProductVariant__r) != 'undefined'?row.CH_NetworkElementAsset__r.CH_ProductVariant__r.Name :'';
                        row.ProductRelease = typeof(row.CH_NetworkElementAsset__r.CH_ProductRelease__r) != 'undefined'?row.CH_NetworkElementAsset__r.CH_ProductRelease__r.Name :'';
                        
                    }
                }
                console.log('ROW!!!!###'+JSON.stringify(rows)+'LENGTH!!!:'+rows.length);
                component.set("v.isSpinner",false);
                component.set("v.netElemAssets", rows);      
                component.set('v.enableInfiniteLoading',false);
            } else if (state === "ERROR") {
                component.set("v.isSpinner",false);
                var errors = response.getError();
                console.error(errors);
            }
            
        });
        $A.enqueueAction(action);
    }
})