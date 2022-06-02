({
    getRecordTypeId : function(component, event, helper) {
        var serviceType = component.get('v.serviceType');
        var action = component.get("c.getRecordType");
        action.setParams({
            serviceType : serviceType,
        });
        action.setCallback(this, function(response) {   
            var state = response.getState();
            console.log('Response State##### '+state);
            if (state === "SUCCESS") {                                
                component.set("v.recordTypeId",response.getReturnValue());
            }                
        }); 
        $A.enqueueAction(action);
    },
    
    getParentRecordTypeId : function(component, event, helper) {		
        var action = component.get("c.getRecordType");
        action.setParams({
            serviceType : 'HWS_Parent_Case',
        });
        action.setCallback(this, function(response) {   
            var state = response.getState();
            console.log('Response State##### '+state);
            if (state === "SUCCESS") {                                
                component.set("v.parentRecordTypeId",response.getReturnValue());
            }                
        }); 
        $A.enqueueAction(action);
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
    saveCaseFlow : function(component, event) {
        component.set("v.spinner",true);
		//34214
        var fromSaveNReviewBtn = component.get("v.warrantyCheckRequired");
        var buttonName = event.getSource().getLocalId();
        //var buttonName = component.get("v.buttonName");  
        var submitToSOO = (buttonName =='saveAsDraft') ? false :true; 
        var contactid = component.get("v.contactId");
        var accountList = component.get("v.accountId");
		if(component.get("v.isGlobalSingle") == true && component.get("v.retroAccId") != undefined && component.get("v.retroAccId") != null && component.get("v.retroAccId") != '' ) {
        	accountList = component.get("v.retroAccId");
        }
        var contractLines = component.get("v.assetRec");
        var versionItems = component.get("v.versionRec");
        var childCase = component.get("v.listChildCase");
        //var childCaseList = component.get("v.childCases");        
        var parentCase = component.get("v.parentCase");
        var communicationContact = component.get('v.communicationContact');
        var ShiptopartyAddress = component.get('v.ShiptopartyAddress');
        component.set("v.saveDisable",true);
        component.set("v.saveSubmitDisable",true);
        parentCase.HWS_Communication_Contact__c = communicationContact;
        parentCase.Hws_Ship_to_Party_Address__c = ShiptopartyAddress;
		var deliveryTimeZone = component.get("v.deliveryTimeZone");
		parentCase.HWS_Delivery_TimeZone__c  = deliveryTimeZone;
        parentCase.Origin='Web';
		var shipToPartyAccount = component.get('v.shipToPartyAccount'); 
        parentCase.HWS_Address_Name__c  = shipToPartyAccount.Name;
        parentCase.Street_Address_1__c  = shipToPartyAccount.Hws_Address_Line_1__c;
        parentCase.Street_Address_2__c  = shipToPartyAccount.Hws_Address_Line_2__c;
        parentCase.Street_Address_3__c  = shipToPartyAccount.Hws_Address_Line_3__c;
        parentCase.City__c              = shipToPartyAccount.BillingCity;
        parentCase.POSTAL_CODE_CHQ__c   = shipToPartyAccount.BillingPostalCode;
        parentCase.HWS_Region__c        = shipToPartyAccount.Region__c;
        parentCase.State__c             = shipToPartyAccount.BillingState;
        parentCase.Country__c           = shipToPartyAccount.BillingCountry;
        var isRetrofitRequired = component.get('v.isRetrofitRequired'); 
        // NOKIASC-39746
        if (isRetrofitRequired === 'true') {
            parentCase.CH_ServiceType__c = 'Internal Support';   
        }    
        console.log('button name '+buttonName+' submitToSOO '
                    +submitToSOO+' contactid '+contactid+' accountList '+accountList
                    +' contractLines '+JSON.stringify(contractLines) +' versionItems '+
                    JSON.stringify(versionItems)
                    +' childCase '+JSON.stringify(childCase)
                    +' parentCase '+JSON.stringify(parentCase));
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
		 if(childCase != null){
            for(var i=0;i<childCase.length;i++){
                var assetId = childCase[i].AssetId;
                var AstIdToAstMap = component.get("v.AstIdToAstMap");
                var salesBundle=AstIdToAstMap[assetId].HWS_ServiceOffering__c;
                var price = AstIdToAstMap[assetId].HWS_Price__c;
				var InvoicingType = AstIdToAstMap[assetId].HWS_ContractLineItem__r.HWS_InvoicingType__c;

                if (AstIdToAstMap[assetId].HWS_ContractLineItem__r.HWS_WarrantyVerificationRequired__c == 'No') {
                    childCase[i].HWS_WarrantyStatus__c='Not Applicable';
                    childCase[i].CH_EntitlementException__c='No Exception';
                    childCase[i].CH_EntitlementStatus__c='Entitled (Automated Verification)';   
                }
                var isRetrofitRequired = component.get('v.isRetrofitRequired'); 
                if ( isRetrofitRequired === 'true') {
                     childCase[i].CH_ServiceType__c = 'Internal Support';   
                }  
                if (salesBundle != undefined &&
                    (salesBundle.includes("RES RFR PU") ||salesBundle.includes("RES AED PU")) && 
                    (price == "" ||price == null || price == undefined ))
                {
                    component.set("v.isPayPerPriceFound", true);
                }
                if(childCase[i].HWS_WarrantyStatus__c == 'Failed to determine Warranty' || 
                   childCase[i].HWS_WarrantyStatus__c == 'Warranty Unknown' || childCase[i].HWS_WarrantyStatus__c == 'Out of Warranty' ||
                   childCase[i].HWS_WarrantyStatus__c == "" ||childCase[i].HWS_WarrantyStatus__c == null || 
                   childCase[i].HWS_WarrantyStatus__c == undefined ){
                    if(childCase[i].HWS_WarrantyStatus__c == "" ||childCase[i].HWS_WarrantyStatus__c == null || 
                   childCase[i].HWS_WarrantyStatus__c == undefined){
                       component.set("v.warrantyStatusNull",true); 
                    }
                    else{
                       component.set("v.warrantyCheckFailed",true); 
                    }
                    
                }
				if(InvoicingType === 'event based'){
                    component.set("v.InvoicingTypeEventBased",true);
                }
            }
        }
        
		
        var getPO=parentCase.HWS_Customer_PO__c;
        var warntyStatus = component.get('v.warrantyStatus');
		//if-else condition added as part of 34214 and commented some conditions
        if(!fromSaveNReviewBtn){
            if(component.get("v.getPayPerUse") === true && (getPO==null || getPO=='' || getPO==undefined ||getPO=='undefined') && buttonName !== 'saveAsDraft' && component.get("v.isPayPerPriceFound") && submitToSOO){
                component.set("v.saveCase", false); 
                //this.showToast('error','Error Message','This service requires warranty check and/or quotation, please Save as Draft and escalate to the Warranty & Quotation team.'); 
                this.showToast('error','Error Message','You are not entitled to this service as the Customer Purchase Order Number is missing. Please contact the Customer Care Manager.'); 
                component.set("v.spinner",false);
                component.set("v.saveDisable",false);
                component.set("v.saveSubmitDisable",false);
            }
            /*else if(buttonName == 'Submit' && component.get("v.warrantyCheckFailed") == false && component.get("v.warrantyStatusNull") == false && 
                (getPO==null || getPO=='' || getPO==undefined ||getPO=='undefined')&& component.get("v.InvoicingTypeEventBased"))
        {
            var message = 'This service requires Purchase Order Number, please go to previous screen and add the Purchase Order Number or Save as Draft and escalate to the Warranty & Quotation team.';
            this.showToastError(component,event,message);
        }*/
            else if(component.get("v.getPayPerUse") === true && (getPO==null || getPO=='' || getPO==undefined ||getPO=='undefined') && submitToSOO){
                var message = 'This service requires a valid Purchase Order(PO). Please enter a valid PO on the previous screen, or save the Case as a Draft and engage your Customer Care Manager to receive a quote.';
                component.set("v.saveCase", false);   
                this.showToast('error','Error Message',message);
                component.set("v.spinner",false);
                component.set("v.stageNumber", 5);
                component.set("v.saveDisable",false);
                component.set("v.saveSubmitDisable",false);
            }
            /* else if(buttonName == 'saveAsDraft' && component.get("v.warrantyCheckFailed") == true && 
                (getPO==null || getPO=='' || getPO==undefined ||getPO=='undefined')&& component.get("v.InvoicingTypeEventBased"))
        {
            var message = 'Warranty status could not be determined for one or more of the parts also the Purchase Order Number is required. A Nokia representative will be reviewing and updating RMA accordingly';
            this.showToastError(component,event,message);
			parentCase.CH_InternalStatus__c='Warranty Verification Required';
        }
		else if(component.get("v.warrantyCheckFailed")){
            parentCase.CH_InternalStatus__c='Warranty Verification Required';
            submitToSOO = false;
            this.showToast('error','Error Message','Warranty status could not be determined for one or more of the parts. A Nokia representative will be reviewing and updating RMA accordingly'); 
        }*/
            else{
                component.set("v.saveCase", true);  
            }
        }
        else{
            parentCase.CH_InternalStatus__c='Under Review';
            submitToSOO=false; 
        }        
        if(!submitToSOO){
            component.set("v.saveCase", true); 
        }
        if(component.get("v.saveCase")===true){
            var action = component.get('c.createHWSCasePortal');
            console.log('after calling controller');
            action.setParams({
                accountId : accountList,
                shipAccId : ShiptopartyAddress,
                contractLines : contractLines,
                versionItems : versionItems,
                childCaseList : childCase,
                parentCase : parentCase,
                contactid : contactid,
                submitToSOO:submitToSOO,
                contactTimeZone:component.get("v.contactTimeZone")
            });
            console.log('after sending parameters');
           action.setCallback(this, $A.getCallback(function (response) {
                var state = response.getState();
                console.log('Response State '+response.getReturnValue());
                if (state === "SUCCESS") {
                    var recordid = response.getReturnValue();
                    component.set("v.caseNumber", response.getReturnValue());
                    if (submitToSOO) {
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
                                    if(statuscode==200){
                                        this.showToast('success','Success Message','Your request is Successfully submitted');
                                    }
                                    else{
                                        this.showToast('error','Error Message','Your request is Created but not submitted');
                                    }
                                    //this.openCaseTab(component, this.getLightningURL(recordid));
                                    //this.closeTab(component);
                                    this.openCaseTab(component, recordid);
                                }
                            }
                            else{
                                this.showToast('error','Success Message','Your request is Created but not submitted');
                                //this.openCaseTab(component, this.getLightningURL(recordid));
                                //this.closeTab(component);
                                this.openCaseTab(component, recordid);
                            }
                        }));
                        $A.enqueueAction(actionCallout);
                        
                    }
                    else{
                        //34214
                        if(fromSaveNReviewBtn){
                            this.showToast('success','Success Message','Items are saved successfully, please check the Review tab for details before submitting');
                        }
                        else{
                            this.showToast('success','Success Message','Case was created Successfully');
                        }
                        //this.openCaseTab(component, this.getLightningURL(recordid));
                        //this.closeTab(component);
                        this.openCaseTab(component, recordid);
                    }                
                } else {
                    component.set("v.saveDisable",false);
                    component.set("v.saveSubmitDisable",false);
                    component.set("v.spinner",false);
                    var toastEvent = $A.get("e.force:showToast");
                    var message = '';
                    if (state === "INCOMPLETE") {
                        message = 'Server could not be reached. Check your internet connection.';
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
                } 
            }));
            $A.enqueueAction(action);
        }
    },
    createChildCase : function(component, event) {  
        //Start Changes for 26952
        var listToADDValues = []; 
        var newAssetListValues = component.get('v.getAllAssets');
        var assetListValues = component.get("v.assetRec");
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
        //listToADD1.push( JSON.parse(JSON.stringify(assetList1)));
        component.set('v.getAllAssets',listToADDValues);
        console.log('##Final'+JSON.stringify(component.get('v.getAllAssets')));
        //End Changes for 26952
        var assetList = component.get("v.assetRec");
        var contractNumber = assetList[0].HWS_Service_Contract_Number__c;
        var contractLineId = assetList[0].HWS_ContractLineItem__c;
        component.set("v.selectedContractLineItemRetro", contractLineId);
        var serviceType = assetList[0].HWS_Service_Type__c;        	
        var cliId = assetList[0].HWS_ContractLineItem__r.Id;
        var prod2Id = assetList[0].Product2Id;
        var prodName = assetList[0].Product2.Name;
        var assetId = assetList[0].Id;
        var stockableProd = component.get("v.versionRec");
        var stockableProdId = stockableProd[0].Id;
        var parentContractId = assetList[0].HWS_ContractLineItem__r.ServiceContractId;
		var productId = assetList[0].HWS_ContractLineItem__r.Asset.Product2.Name;
        var serviceOffering = assetList[0].HWS_ContractLineItem__r.CH_ServiceOffering__c;
		//Start changes for US 34201
        component.set('v.parentCase.HWS_Customer_PO__c', assetList[0].HWS_ContractLineItem__r.HWS_PONumber__c);
        var getponumber = assetList[0].HWS_ContractLineItem__r.HWS_PONumber__c;            
        if (getponumber === "" || getponumber === null || getponumber === undefined ){
            component.set("v.isponumber", false);                
            }
            else{            
                component.set("v.isponumber", true);
            }
        //End changes for US 34201
		//26091
        var selNEA = component.get("v.neaRec");            
        if(selNEA != null && selNEA != '' && selNEA != undefined){
            var neaId = selNEA[0].CH_NetworkElementAsset__c;
        } 
        component.set("v.newChildCase.HWS_Contract_Line_Item__c",cliId);
        //26101
        component.set("v.newChildCase.Street_Address_2__c",assetList[0].HWS_ContractLineItem__r.CH_BusinessHour__c);
        //Assigning ContractLine Item value by using subject, as portal user doesnot have access for Contract line items. Subject field will be populated with RMA number again while inserting.
        component.set("v.newChildCase.Subject",cliId);
        component.set("v.newChildCase.HWS_Customer_Part_Revision__c",component.get("v.customerPartRev"));
        component.set("v.newChildCase.HWS_Sellable_Product__c",prod2Id);
        component.set("v.newChildCase.HWS_ServiceType__c",serviceType);
        component.set("v.newChildCase.NCP_Service_Contract__c",parentContractId);        
        component.set("v.newChildCase.HWS_Stockable_Product__c", stockableProdId);
        //26101
		//NOKIASC-32497--STARTS
		component.set("v.newChildCase.NCP_Product_Name__c",productId);
        component.set("v.newChildCase.HWS_Part_Name__c",prodName);
        component.set("v.newChildCase.HWS_Service_Offering__c",serviceOffering);
		//NOKIASC-32497--ENDS
        component.set("v.newChildCase.Street_Address_1__c", stockableProd[0].HWS_Version_Code__c); 
        component.set("v.newChildCase.AssetId",assetId);
        var childCase = component.get("v.newChildCase");
        component.set("v.newChildCase.HWS_Part_Code__c",assetList[0].HWS_Part_Code__c);
		component.set("v.newChildCase.CH_NetworkElementAsset__c",neaId);        
        var warrantyStatus = component.get('v.warrantyStatus');
		var faultCode = childCase.HWS_Faulty_Serial_Number__c;
        if(faultCode !='' && faultCode != null && faultCode != undefined && faultCode.toUpperCase() == 'UNKNOWN'){
            component.set("v.newChildCase.HWS_WarrantyStatus__c", 'Out of Warranty');
        }
        if(faultCode !='' && faultCode != null && faultCode != undefined && faultCode.toUpperCase() != 'UNKNOWN' && (serviceType == 'Return for Repair or Replacement' || serviceType == 'Advanced Exchange in Days' || serviceType == 'Identical Repair' || serviceType == 'Spare Part Sales')){
            component.set("v.newChildCase.HWS_WarrantyStatus__c",warrantyStatus);
            //35978	
            var isTraceble = stockableProd[0].HWS_Serial_Number_Traceable__c;  	
            if(assetList[0].HWS_ContractLineItem__r.HWS_WarrantyVerificationRequired__c == "Yes" && (isTraceble == undefined || isTraceble == '' || isTraceble == null || (isTraceble != null && isTraceble != '' && isTraceble != undefined && isTraceble.toUpperCase() == 'NO' || isTraceble.toUpperCase() == 'N' ))){	
                component.set("v.newChildCase.HWS_WarrantyStatus__c",'Not Applicable');  	
                component.set("v.newChildCase.CH_EntitlementException__c",'No Exception');  	
                component.set("v.newChildCase.CH_EntitlementStatus__c",'Entitled (Automated Verification)');  	
            }
        }
        var listToADD = [];  
        var newChildCasesList = component.get('v.listChildCase');    
        for(var i in newChildCasesList){            
            var oldRecipent = newChildCasesList[i];
            if(oldRecipent!=[])
                listToADD.push(oldRecipent);
        }
        listToADD.push( JSON.parse(JSON.stringify(childCase)));
        component.set('v.listChildCase',listToADD);        
    },
    parentCaseValidation : function(component,event){
        console.log('recordTypeId ',component.get("v.recordTypeId"));
        console.log('parentRecordTypeId ',component.get("v.parentRecordTypeId"));
        var validation = false;
        var requiredFieldsValidation = false;
        var phoneValidation = false;
        var emailValidation = false;
        var shippedPartyValidation = false;
        var emailId = component.get('v.parentCase.HWS_ShipmentRecipientEmailId__c');
        var phoneNumber = component.get('v.parentCase.HWS_Shipment_Recipient_Phone__c');
        console.log('emailId====='+emailId);
        console.log('phoneNumber====='+phoneNumber);
        var ShiptopartyAddress = component.get('v.ShiptopartyAddress');
        if(ShiptopartyAddress == null || ShiptopartyAddress == undefined || ShiptopartyAddress == '')
        {
            //component.find("recordValue3").set("v.errors", [{message:"Please Enter Ship to party Address before Proceeding"}]);
            shippedPartyValidation = true;
        } 
        else {   
            //component.find("recordValue3").set("v.errors", [{message: null}]);
            //$A.util.removeClass(component.find("recordValue3"), 'slds-has-error');
            shippedPartyValidation = false;
        }
        if(phoneNumber!= ''){
            if(phoneNumber!= undefined){
                console.log('phone number inside if '+phoneNumber);
                var phoneValidateCheck = this.phoneValidation(phoneNumber);
                console.log('phoneValidateCheck '+phoneValidateCheck);
                if(phoneValidateCheck){
                    document.getElementById("validateParentPhone").innerHTML = 'Please enter valid Phone number. Phone number should only contain digits(ex: +XXX XX XXXX, XXXXXXXXXX)';
                    phoneValidation = true;
                }else{
                    document.getElementById("validateParentPhone").innerHTML = '';
                    phoneValidation = false;
                }
            }
        }
        if(emailId!= ''){
            if(emailId!= undefined){
                var emailValidateCheck = this.emailValidation(emailId);
                console.log('emailValidateCheck '+emailValidateCheck);
                if(emailValidateCheck){
                    document.getElementById("validateParentEmailId").innerHTML = 'You have entered an invalid format.';
                    emailValidation = true;
                }else{
                    document.getElementById("validateParentEmailId").innerHTML = '';
                    emailValidation = false;
                }
            }
        }
        if( shippedPartyValidation || phoneValidation || emailValidation){
            component.set('v.stageNumber', 5);
            validation = true;
        }
        else{
            //component.set('v.stageNumber', parseInt(component.get('v.stageNumber'))+1);
            validation = false;
        }
		if(!validation){
            component.set('v.parentcaseStep5',true);
            component.set('v.ProgressBarCounter', 5);
            component.set("v.ProgressBarNEACounter",6);
            component.set("v.ContNumProgressBarCounter",6);
            component.set("v.ContNEAProgressBarCounter",7);
        }
        return validation;
    },
    childCaseValidation : function (component,parentCheck){         
        var validation = false;
        var requiredFieldsValidation = false;
        var phoneValidation = false;
        var emailValidation = false;
        var dateChangeValidate = false;
        var versionItems = component.get("v.versionRec");
        var faultySerialCheck;
        var isTraceble = versionItems[0].HWS_Serial_Number_Traceable__c;
        //var faultySerialNumber = component.find("faultySerial").get("v.value");
        //console.log('is traceable '+isTraceble+ ' faultySerialNumber '+faultySerialNumber);
        console.log('Faulty value check in childCaseValidation '+isTraceble+versionItems[0].Id);
        //console.log('is faulty serial number value'+faultySerialNumber);
        var serviceType = component.get('v.serviceType'); 
        console.log('service type'+serviceType);
        dateChangeValidate = this.requestDateChangeValidate(component, event);
        if(serviceType != 'Spare Part Sales'){ 
            if(serviceType =='Identical Repair' || serviceType == 'Return for Repair or Replacement'){
                var faultySerialNumber = component.find("faultySerial1").get("v.value");
            }
            if(serviceType =='Advanced Exchange in Days' || serviceType == 'Advanced Exchange in Hours'){
                var faultySerialNumber = component.find("faultySerial").get("v.value");
            }
            console.log('Faulty serial number'+faultySerialNumber);
			//29824         
              if(faultySerialNumber != undefined && faultySerialNumber != null && faultySerialNumber.includes(" ")){  
                            component.set("v.spinner",false);
                			document.getElementById("faultySerialNumber").innerHTML = 'Space not allowed in Serial Number';
                  faultySerialCheck = true;  
               }
            else{
               document.getElementById("faultySerialNumber").innerHTML = '';
				if(isTraceble == undefined || isTraceble.toUpperCase() == 'NO' || ((isTraceble.toUpperCase() == 'YES' || isTraceble.toUpperCase() == 'Y') && (faultySerialNumber != undefined && faultySerialNumber !='' && faultySerialNumber !=null))){    
					faultySerialCheck = false;
					console.log('Faulty Serial Check validation in if '+faultySerialCheck);		
				}
				else if(serviceType != 'Advanced Exchange in Hours' && ((isTraceble.toUpperCase() == 'YES' || isTraceble.toUpperCase() == 'Y') && (faultySerialNumber == undefined || faultySerialNumber =='' || faultySerialNumber ==null))){
					faultySerialCheck = true;              
					console.log('Faulty Serial Check validation in else '+faultySerialCheck);		
				}
				if(faultySerialCheck){
					component.set("v.spinner",false);
					document.getElementById("faultySerialNumber").innerHTML = 'Please enter Serial Number, if serial number is unavailable check Serial Number Unknown';
					
				}
				else{
					//component.set("v.spinner",false);
					document.getElementById("faultySerialNumber").innerHTML = '';
					//phoneValidation = false;
				}
			}
        }
		var isServicedAcc = component.get("v.isServicedAccount"); // added for NOKIASC-35931
        if(serviceType =='Advanced Exchange in Days'){            
            var oCase;
            if(isServicedAcc){
           		oCase = this.requiredFieldValidations(component, [                
                {id: 'failureOccurance', recordEditForm: true, required: true},
                {id: 'failureDetection', recordEditForm: true, required: true},
                {id: 'failureDetectionDate', recordEditForm: true, required: true},
                {id: 'failureDescription', recordEditForm: true, required: true},
                {id: 'siteAuraId', recordEditForm: true, required: true},
                {id: 'addConfigDet', recordEditForm: true, required: true}
                
            	]),
                errorMessage = (oCase.error?oCase.error:''); 
            }
            else{
                oCase = this.requiredFieldValidations(component, [                
                {id: 'failureOccurance', recordEditForm: true, required: true},
                {id: 'failureDetection', recordEditForm: true, required: true},
                {id: 'failureDetectionDate', recordEditForm: true, required: true},
                {id: 'failureDescription', recordEditForm: true, required: true}
                
            	]),
                errorMessage = (oCase.error?oCase.error:''); 
            }
        }  
        if(serviceType =='Identical Repair' || serviceType == 'Return for Repair or Replacement'){            
            var oCase;
            if(isServicedAcc){
                oCase = this.requiredFieldValidations(component, [                
                {id: 'failureOccurance1', recordEditForm: true, required: true},
                {id: 'failureDetection1', recordEditForm: true, required: true},
                {id: 'failureDetectionDate1', recordEditForm: true, required: true},
                {id: 'failureDescription1', recordEditForm: true, required: true},
                {id: 'siteAuraId1', recordEditForm: true, required: true},
                {id: 'addConfigDet1', recordEditForm: true, required: true}
                ]),
                errorMessage = (oCase.error?oCase.error:''); 
            }
            else{
                oCase = this.requiredFieldValidations(component, [                
                {id: 'failureOccurance1', recordEditForm: true, required: true},
                {id: 'failureDetection1', recordEditForm: true, required: true},
                {id: 'failureDetectionDate1', recordEditForm: true, required: true},
                {id: 'failureDescription1', recordEditForm: true, required: true}
                ]),
                errorMessage = (oCase.error?oCase.error:''); 
            }
        }
        if(serviceType =='Spare Part Sales'){            
            var oCase = this.requiredFieldValidations(component, [                
                {id: 'quantity', recordEditForm: true, required: true}                      
            ]),          
            errorMessage = (oCase.error?oCase.error:''); 
        }
        if(errorMessage){
            component.set("v.spinner",false);
            document.getElementById("errorOnCreate").innerHTML = errorMessage;
            requiredFieldsValidation = true;
			
        }else{
            document.getElementById("errorOnCreate").innerHTML = '';
            requiredFieldsValidation = false;
        }               
        var phoneNumber = component.get('v.newChildCase.HWS_Fault_Reported_By_Phone__c');
        console.log('phoneNumber '+phoneNumber);
        if(phoneNumber!= ''){
            if(phoneNumber!= undefined && serviceType != 'Spare Part Sales'){
                console.log('phone number inside if '+phoneNumber);
                var phoneValidateCheck = this.phoneValidation(phoneNumber);
                console.log('phoneValidateCheck '+phoneValidateCheck);
                if(phoneValidateCheck){
                    component.set("v.spinner",false);
                    document.getElementById("validatePhone").innerHTML = 'Please enter valid Phone number. Phone number should only contain digits(ex: +XXX XX XXXX, XXXXXXXXXX)';
                    phoneValidation = true;
                }else{
                    document.getElementById("validatePhone").innerHTML = '';
                    phoneValidation = false;
                }
            }
        }
        //NOKIASC-34442
        var detectionDate = component.get('v.newChildCase.HWS_Failure_Detection_Date__c');
        var detectionDateValidation = false;
       // if(detectionDate != '' && detectionDate!= undefined){
       if(detectionDate != '' && detectionDate!= undefined && serviceType != 'Spare Part Sales'){
            var q = new Date();	
            var m = q.getMonth();	
            var d = q.getDate();	
            var y = q.getFullYear();	
            var today = new Date(y,m,d);	
            var ddate = new Date(detectionDate+" 0:00:00");
            if ( ddate > today){
                detectionDateValidation = true;
                component.set("v.spinner",false);
                document.getElementById("validateDetectionDate").innerHTML = 'Failure Detection Date cannot be in the future';
            } else {
                document.getElementById("validateDetectionDate").innerHTML = '';
            }
        }
        //NOKIASC-34442
        var emailId = component.get('v.newChildCase.HWS_Fault_Reported_By_Email__c');
        //var EmailValidate = component.find("validateEmail").get("v.value");
        console.log('emailId '+emailId);
        if(emailId!= ''){
            if(emailId!= undefined){
                var emailValidateCheck = this.emailValidation(emailId);
                console.log('emailValidateCheck '+emailValidateCheck);
                if(emailValidateCheck){
                    //document.getElementById("validateEmailId").innerHTML = 'Please Enter Valid Email Id';
                    emailValidation = true;
                }else{
                    emailValidation = false;
                }
            }
        } 
        //var dupSerialCheck = this.duplicateSerialnumCheck(component);
        console.log('validation:'+validation);                
        console.log('requiredFieldsValidation outside if '+requiredFieldsValidation+' phoneValidation '+phoneValidation
                    +' faultySerialCheck '+faultySerialCheck );
        if(requiredFieldsValidation || phoneValidation || emailValidation || faultySerialCheck || !dateChangeValidate || detectionDateValidation){
            console.log('requiredFieldsValidation '+requiredFieldsValidation+' phoneValidation '+phoneValidation+' Email validation '+emailValidation);
            component.set('v.stageNumber', 4);
            validation = true;
            component.set('v.oneclick','');
            //return validation;
        }
        else{
            //component.set('v.stageNumber', parseInt(component.get('v.stageNumber'))+1);
            component.set('v.oneclick',undefined);
            validation = false;
        }  
		if(parentCheck == 'addPart' && !validation){
            component.set("v.selectedAssetstep2",false);
            component.set("v.SelectNEA",false);
            component.set("v.SelectConNum",false);
            component.set("v.selectedVersionstep3",false);
            component.set('v.childcasestep4',false);
            component.set("v.ProgressBarCounter",1);
            component.set("v.ProgressBarNEACounter",1);
            component.set("v.ContNumProgressBarCounter",1);
            component.set("v.ContNEAProgressBarCounter",1);
        }
        if(parentCheck == 'parentCheck' && !validation){
            component.set('v.childcasestep4',true);
            component.set('v.ProgressBarCounter', 4);
            component.set("v.ProgressBarNEACounter",5);
            component.set("v.ContNumProgressBarCounter",5);
            component.set("v.ContNEAProgressBarCounter",6);
        }
        return validation;       
    },
    bulkParentCaseValidation : function(component, event){
        var validation = false;
        var phoneValidation = false;
        var emailValidation = false;
        var retroValidation = false;
        var serviceContractValidation=false;
        var recNameValidation = false; //NOKIASC-34787| 19-May-2021| 
        var emailId = component.get('v.parentBulkUploadCase.HWS_ShipmentRecipientEmailId__c');
        var phoneNumber = component.get('v.parentBulkUploadCase.HWS_Shipment_Recipient_Phone__c');
		var retroAccount = component.get('v.selectedRetroAccount');
        var isRetroAccount = component.get('v.isRetrofitRequired');
        console.log('retroAccountretroAccountretroAccountretroAccount==='+retroAccount);
        var retroAccountJSON = JSON.stringify(retroAccount);
        //NOKIASC-34787| 19-May-2021 | Start
        var recipientName = component.get('v.parentBulkUploadCase.HWS_Shipment_Recipient_Name__c');	
		if (recipientName == '' || recipientName == undefined || recipientName == null) {            	
            recNameValidation = true;	
			document.getElementById("validateBulkRecipientName").innerHTML = 'Please enter Shipment Receipient Name';	
        } else  {	
            recNameValidation = false;	
        	document.getElementById("validateBulkRecipientName").innerHTML = '';    	
        } 	
        if (phoneNumber == '' || phoneNumber == undefined || phoneNumber == null) {            	
            phoneValidation = true;	
			document.getElementById("validateBulkRecipientPhone").innerHTML = 'Please enter Shipment Receipient Phone';	
        } else  {	
            phoneValidation = false;	
            document.getElementById("validateBulkRecipientPhone").innerHTML = '';    	
        }
        // NOKIASC-37090:Bulk Case Creation : Allow user to select Service Contract|Start
        if ($A.util.isEmpty(component.get("v.serviceContractId")) && isRetroAccount=='true') {            	
            serviceContractValidation = true;	
            document.getElementById("validateServiceContract").innerHTML = 'Please enter Service Contract.';	
        } else if (!$A.util.isEmpty(component.get("v.serviceContractId")) && isRetroAccount=='true')   {	
            serviceContractValidation = false;	
            document.getElementById("validateServiceContract").innerHTML = '';    	
        }
        // NOKIASC-37090:Bulk Case Creation : Allow user to select Service Contract|Start
        if (emailId == '' || emailId == undefined || emailId == null) {            	
            emailValidation = true;	
			document.getElementById("validateBulkEmailId").innerHTML = 'Please enter Shipment Receipient Email';	
        } else  {	
            emailValidation = false;	
        	document.getElementById("validateBulkEmailId").innerHTML = '';    	
        } 	
		if (retroAccountJSON.length == 2 && (isRetroAccount == 'true' || isRetroAccount == true)) {
            document.getElementById("retroAccountPortal").innerHTML = 'Please enter Sold to Account and then choose Ship To Country'; 
            retroValidation = true;
        } else {
            retroValidation = false;
        }
        //NOKIASC-34787| 19-May-2021 | End
        if(phoneNumber!= ''){
            if(phoneNumber!= undefined){
                console.log('phone number inside if '+phoneNumber);
                var phoneValidateCheck = this.phoneValidation(phoneNumber);
                console.log('phoneValidateCheck '+phoneValidateCheck);
                if(phoneValidateCheck){
                    document.getElementById("validateBulkParentPhone").innerHTML = 'Please enter valid Phone number. Phone number should only contain digits(ex: +XXX XX XXXX, XXXXXXXXXX)';
                    phoneValidation = true;
                }else{
                    document.getElementById("validateBulkParentPhone").innerHTML = '';
                    phoneValidation = false;
                }
            }
        }
        if(emailId!= ''){
            if(emailId!= undefined){
                var emailValidateCheck = this.emailValidation(emailId);
                if(emailValidateCheck){
                    document.getElementById("validateBulkParentEmail").innerHTML = 'You have entered an invalid format.';
                    emailValidation = true;
                }else{
                    document.getElementById("validateBulkParentEmail").innerHTML = '';
                    emailValidation = false;
                }
            }
        }
        if( phoneValidation || emailValidation || retroValidation || serviceContractValidation){
            
            validation = true;
        }
        else{
            //component.set('v.stageNumber', parseInt(component.get('v.stageNumber'))+1);
            validation = false;
        }
        return validation;
    },
    duplicateSerialnumCheck: function(component,parentCheck){
        var validation = false;
        var serialNumber;
        var serviceType = component.get('v.serviceType');
        if(serviceType == 'Advanced Exchange in Days' || serviceType == 'Advanced Exchange in Hours' ){
            serialNumber = component.find("faultySerial").get("v.value");
        }
        if(serviceType == 'Identical Repair' || serviceType == 'Return for Repair or Replacement' ){
            serialNumber = component.find("faultySerial1").get("v.value");
        }
        var contractLines = component.get("v.assetRec");
        var duplicateSerialnumCheck = false;
        var newChildCasesList = component.get('v.listChildCase');
        var action = component.get("c.duplicateSerialNumberInfo");
        action.setParams({
            "serialNumber" : serialNumber,
            materialCode  : contractLines[0].HWS_Part_Code__c
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var dupSerfromApex = response.getReturnValue();
                console.log('dupSerfromApex ' +dupSerfromApex);
                if(!$A.util.isEmpty(dupSerfromApex) &&  dupSerfromApex != '' &&  dupSerfromApex != null){
                    console.log('DuplicateSNum '+dupSerfromApex);
                    duplicateSerialnumCheck = true;
                    this.childCaseValidation(component,parentCheck);
                    component.set("v.spinner",false);
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        title : 'Error Message',
						mode: 'dismissible',
                        type: 'error',
                        duration:'10000',
                        type: 'error',
                        key: 'info_alt',
                        message: 'message',
                        messageTemplate: 'Sorry, Cannot proceed with case creation as entered serial number and {0} pending for closure! {1}',
                        messageTemplateData: ['material code is part of an existing case', {
                            url: $A.get("$Label.c.Duplicate_SerialNumber_Portal")+dupSerfromApex[0].Id,
                            label: 'Case Number: '+dupSerfromApex[0].CaseNumber,
                        }]   
                    });
                    validation = true;
                    component.set('v.oneclick','');
                    resultsToast.fire();
                }else if(newChildCasesList.length!=0){
                    var faultCodeList =[];
                    for(var i in newChildCasesList){
                        var faultCode = newChildCasesList[i].HWS_Faulty_Serial_Number__c;
                        if(faultCode !='' && faultCode != null && faultCode != undefined && faultCode.toUpperCase() != 'UNKNOWN')
                            faultCodeList.push(faultCode.toUpperCase());
                    }
                    if(faultCodeList != null && faultCodeList != '' && faultCode.toUpperCase() != 'UNKNOWN' && faultCodeList.includes(serialNumber.toUpperCase())){
                        component.set("v.spinner",false);
                        this.showToast('error','Error Message','Entered faulty serial number is Part of previously added part');
                        validation = true;
                        component.set("v.duplicateSerialnumCheck",true); 
                        component.set('v.oneclick','');
                    }
                    else{
                        validation = this.childCaseValidation(component,parentCheck);
                        if(parentCheck == 'parentCheck'){                            
                            if(!validation){
                                
                                this.warrantyCheckHelper(component,event,parentCheck);
                                //this.createChildCase(component, event);
								//Code Changes for 29132
                                /*component.set("v.getPPU",false);
                                var newAssetList = component.get('v.getAllAssets');
                                if(newAssetList != null){
                                    for(var i=0;i<newAssetList.length;i++){
                                        var getPayPerUse=newAssetList[i].HWS_ServiceOffering__c;
                                        if( getPayPerUse != undefined && (getPayPerUse.includes('RES RFR PU') || getPayPerUse.includes('RES AED PU'))){
                                            component.set("v.getPPU", true);
                                            break;
                                        }
                                    }
                                }
                                component.set('v.stageNumber', parseInt(component.get('v.stageNumber'))+1);
                                var contactLookup = component.find("contactAuraId");
                                contactLookup.doInitFromPortal();
                                var accountLookup = component.find("recordValue2");
                                accountLookup.doInitFromPortal();*/
                            }
                        }
                        //3876 -- added validation condition
                        else if(parentCheck == 'addPart' && !validation){
                            this.warrantyCheckHelper(component,event,parentCheck);	
                        }
                    }                     
                }else{
                    validation = this.childCaseValidation(component,parentCheck);
                    if(parentCheck == 'parentCheck'){
                        if(!validation){
                            this.warrantyCheckHelper(component,event,parentCheck);	
                            //this.createChildCase(component, event);
							
                        }
                    }
                    //3876 -- added validation condition
                    else if(parentCheck == 'addPart' && !validation){
                        this.warrantyCheckHelper(component,event,parentCheck);	
                    }
                } 
                
                //validation = this.childCaseValidation(component); // this function is called after success of duplicate num check
                return validation;
            }
            
        });
        $A.enqueueAction(action);
    },
    addPartHelper : function(component,event){
        component.set('v.spinner',false);
        //this.warrantyCheckHelper(component,event);
        this.createChildCase(component, event);
        this.clearChild(component, event);
        var serviceType = component.get("v.serviceType");
        var contractNumber = component.get("v.contractNumber");
		var country = component.get("v.country");
        component.set('v.stageNumber', 2);
        component.set("v.addPartCheck",true);
        component.set('v.assetRec',null);
        component.set('v.clis',null);
        component.set("v.versionRec", null); 
        component.set("v.addPartServiceType",serviceType);
        component.set("v.addPartcontractNumber",contractNumber);
		component.set("v.addPartCountry", country);
        component.set('v.warrantyStatus',null);
        var childCmp = component.find("assetSecId");
        childCmp.componentRefresh();
        var childCmp1 = component.find("versionSecId");
        childCmp1.componentRefresh();
	    var childCmp2 = component.find("contractNumberSecId");
        childCmp2.componentRefresh();
        var childCmp3 = component.find("neaSecId");
        childCmp3.componentRefresh();
        var childCmp4 = component.find("contractAssetSecId");
        childCmp4.componentRefresh();
        var contactLookup = component.find("contactAuraId");
        contactLookup.doInitFromPortal();
        var accountLookup = component.find("recordValue2");
        accountLookup.doInitFromPortal();
        component.set('v.oneclick','');
        
    },
    getplannedDeliveryDateTime : function(component, event, helper){
        /*var selectedAsset = component.get("v.assetRec");
        var businesshours = selectedAsset[0].HWS_ContractLineItem__r.CH_BusinessHour__c;
        var leadTimeUnit = selectedAsset[0].HWS_ContractLeadTimeUnit__c;
        var leadTimeDuration = selectedAsset[0].HWS_ContractLeadTimeDuration__c;
        var specifiedTime = selectedAsset[0].HWS_SpecifiedDeliveryTargetTime__c;
        var byPassPlannedDate = component.get("v.byPassDate");
        var action = component.get("c.plannedDeliveryDateTime");
        console.log('businesshours' +businesshours+ '    leadTimeUnit'+leadTimeUnit+'    leadTimeDuration'+leadTimeDuration);
        console.log('byPassPlannedDate' +byPassPlannedDate);
        action.setParams({ businessHrsId : businesshours,
                          leadTimeUnit : leadTimeUnit,
                          leadTimeDuration : leadTimeDuration,
                          byPassPlannedDate: byPassPlannedDate,
                          specifiedTime : specifiedTime
                         });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state of response ' +state);
            if (state === "SUCCESS") {
                var stringItems = response.getReturnValue();
                console.log('Planned date stringItems' +stringItems);
                var date = new Date(stringItems);
                component.set("v.newChildCase.HWS_Planned_Delivery_Date__c", date);
                //alert(component.get("v.newChildCase.HWS_Planned_Delivery_Date__c"));
            }
        });
        $A.enqueueAction(action);*/
        component.set("v.spinner",true);
        var listChildCases = component.get("v.listChildCase");
        var selectedAccount = component.get('v.ShiptopartyAddress');
        //alert('listChildCases**'+listChildCases);
        //alert('selectedAccount**'+selectedAccount);
        var action = component.get("c.accountTimeZoneplannedDeliveryDateTime");
        action.setParams({ listChildCases : listChildCases,
                          selectedAccount : selectedAccount
                         });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var stringItems = response.getReturnValue();                
                var st = [];
                st.push(stringItems.newTimeZoneCaseList);
                var listChildCasetimeZone = st[0];
                var st1 = [];
                st1.push(stringItems.bhTimeZone);
                console.log('SSSSTT:'+st1[0]);
                component.set("v.deliveryTimeZone",st1[0]); 
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
                	listChildCasetimeZone[i].HWS_PlannedDeliveryDateShipment__c = counteryDateOnly +', ' + strTime+' ('+listChildCasetimeZone[i].HWS_Delivery_TimeZone__c+')';
                }
                component.set("v.listChildCase",listChildCasetimeZone);
                console.log('listChildCasetimeZone:'+JSON.stringify(listChildCasetimeZone));
                
            }
            //component.set("v.spinner",false);
			this.getShipToTimeZone(component, event, helper);
        });
        $A.enqueueAction(action);
    }, 
    getBulkServiceTypes : function(component, event){   
        var accountId = component.get('v.accountId');   
        var action = component.get('c.bulkUploadServiceTypes');
        action.setParams({ 
            accountId : accountId 
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state of response ' +state);
            if (state === "SUCCESS") {
                var serviceTypes = response.getReturnValue();
                component.set("v.serviceTypes", serviceTypes);
            }
        });
        $A.enqueueAction(action);
    },
    requiredFieldValidations : function(component, values) {
        console.log('values in validationsOnChildCase '+JSON.stringify(values)+values.length);
        let result = {}, fieldsNotFilled= [];  
        for(let i = 0; i < values.length; i++){
            if(values[i].recordEditForm){
                console.log('inside if '+component.find(values[i].id));
                let fields = component.find(values[i].id).get("v.body");                
                console.log('fields '+JSON.stringify(fields) +'-Length:'+fields.length);
                for(let n = 1; n < fields.length; n++){
                    console.log('values[i] '+fields[n].get('v.value'));
                    if(values[i].required && !fields[n].get('v.value')
                       || values[i].required && fields[n].get('v.value') === undefined || values[i].required && fields[n].get('v.value') === ''){
                        fieldsNotFilled = [...fieldsNotFilled, fields[n].get('v.fieldName')];
                        var redoutlineremover = component.get('v.redoutlineremover');
                        if(redoutlineremover){
                            $A.util.addClass(fields[n], 'redOutLine');
                        }
                        else {
                            $A.util.removeClass(fields[n], 'redOutLine');
                        }
                    }
                    else {
                        $A.util.removeClass(fields[n], 'redOutLine');
                    }
                    result[fields[n].get('v.fieldName')]= fields[n].get('v.value');
                }  
            }
            else {
                let field = component.find(values[i].id);
                if(values[i].required && !field.get('v.value')
                   || values[i].required && field.get('v.value') === '') {
                    fieldsNotFilled = [...fieldsNotFilled, field.get('v.name')];
                    var redoutlineremover = component.get('v.redoutlineremover');
                    if(redoutlineremover){
                        console.log('when click on previous button');
                        $A.util.addClass(field, 'redOutLine');
                    }
                } 
                else {
                    $A.util.removeClass(field, 'redOutLine');
                }
                result[field.get('v.name')]= field.get('v.value');
            }            
        }
        //alert('fieldLength outside for loop'+fieldsNotFilled.length);
        if(fieldsNotFilled.length > 0){
            result= { error : "*All required fields must be completed.", fields: fieldsNotFilled.join(', ') };
        }
        console.log('result '+JSON.stringify(result));
        return result;
    },
    phoneValidation : function(phoneNumber){
        console.log('phone: '+phoneNumber);
        var regExpEmailformat = /^[+]*[\s0-9]*$/;
        var validation = false;
        if(!regExpEmailformat.test(phoneNumber) || phoneNumber == undefined || phoneNumber ==''){
            validation = true; 
        }else{
            validation = false;
        }
        return validation;
    },
    emailValidation : function(emailValue) {
        var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;          
        var validation = false;
        if(!regExpEmailformat.test(emailValue) || emailValue == undefined || emailValue == '' ){
            validation = true; 
        }else{
            validation = false;
        }
        return validation;
    },
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
	openCaseTab : function(component, recordid) {
        var navService  = component.find("navService");
        //34214
        if(component.get("v.warrantyCheckRequired")){
            var action = component.get('c.getHWSGenericSettings');
            action.setParams({ 
                name : 'HWSPortalReviewTabset'
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var genSettings = response.getReturnValue();
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": '/case/'+recordid+'/detail?'+genSettings.HWS_Field1__c,
                        "isredirect" :false
                    });
                    urlEvent.fire();
                }
            });
            
            $A.enqueueAction(action);
            
        }else{
            var pageReference = {
                type: 'standard__recordPage',
                attributes: {
                    actionName: 'view',
                    objectApiName: 'Case',
                    recordId : recordid // change record id. 
                }
            };
            component.set("v.pageReference", pageReference);
            navService.navigate(pageReference);
        }
        
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
                                        'HWS_Fault_Reported_By_Phone__c':undefined,
                                        'HWS_Fault_Reported_By_Email__c':'',
                                        'HWS_Customer_Reference_Number__c':'',
                                        'HWS_Failure_Description__c':'',
                                        'HWS_Quantity__c':'',
                                        'HWS_Failure_Detection_Date__c':'',
                                        'HWS_Requested_Delivery_Date_Time__c':null,
                                        'HWS_Planned_Delivery_Date__c':null,
                                        'HWS_Failure_Description_Server_ID__c':'',
                                        'HWS_Fault_Reported_By_Phone__c':''});
        component.set("v.customerPartRev",'');
		component.set("v.isserialNumberUnknown", false);
    },  
    clearParent : function(component, event){
        component.set("v.parentCase",{'sobjectType':'Case',
                                      'HWS_Shipment_Recipient_Name__c':'',
                                      'HWS_Delivery_Additional_Information__c':'',
                                      'HWS_Shipment_Recipient_Phone__c':'',
                                      'HWS_ShipmentRecipientEmailId__c':'',
                                      'HWS_Customer_PO__c':''});                                        
        component.set('v.ShiptopartyAddress','');
        component.set('v.communicationContact','');
        
    },
     //26101
    deliveryInfo: function(component, event, helper) {               
        var userTimeZone = component.get("v.currentUserTimeZone");
        var selectedServiceType = component.get("v.serviceType");
        if(selectedServiceType == 'Advanced Exchange in Hours'){
            component.set('v.childCaseColumns', [
                {label: 'Part Code', fieldName: 'HWS_Part_Code__c', type: 'text', "initialWidth": 150},
                {label: 'Part Revision', fieldName: 'Street_Address_1__c', type: 'text', "initialWidth": 150},
                 //NOKIASC-34979
                 {label: 'Faulty Unit Serial Number', fieldName: 'HWS_Faulty_Serial_Number__c', type: 'text',"initialWidth": 150},
                {label: 'Planned Delivery Date (User TZ)', fieldName: 'HWS_Planned_Delivery_Date__c', type: 'date', "initialWidth": 250,
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
                {label: 'Planned Delivery Date (Ship to TZ)', fieldName: 'HWS_PlannedDeliveryDateShipment__c', type: 'text', "initialWidth": 260 
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
                {label: 'Planned Delivery Date (Ship to TZ)', fieldName: 'HWS_PlannedDeliveryDateShipment__c', type: 'text',"initialWidth": 260 }					   
            ]);
        }        
        this.getplannedDeliveryDateTime(component,event,helper);               
	},
    //26101
    getShipToTimeZone : function(component, event, helper) {
        var childCasesList = component.get("v.listChildCase");
        var bhIdList = [];
        for(var i=0;i<childCasesList.length;i++){            
            bhIdList.push(childCasesList[i].Street_Address_2__c);
        }
        console.log('Business Id::: '+bhIdList);
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
    
    //26101 To handle the Requested Date Shipment function from Dlivery Info screen in line Edit
    handleCustReqShipmentDate: function(component,event,helper) {
       	var childCasesList = component.get("v.listChildCase");   
		//NOKIASC-34214
        var isRequired = false;
		//NOKIASC-37158 | Added showRetroAccount check in if condition 
		if(!component.get('v.showRetroAccount')){
			(component.get('v.getAllAssets')).forEach(function(row) { 
				if(row.HWS_ContractLineItem__r.HWS_WarrantyVerificationRequired__c && row.HWS_ContractLineItem__r.HWS_WarrantyVerificationRequired__c == 'Yes'){
					isRequired = true;
				}
			});
		}
        component.set("v.warrantyCheckRequired",isRequired)
       	var reqVal = true;
        var countryTimezone = 'GMT';
        var shipToTimeZone = component.get("v.shipToTimeZone");        
        var shipToTimeZoneMap = component.get("v.shipToTimeZoneMap");
        if(childCasesList){
            for(var i=0;i<childCasesList.length;i++){
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
			document.getElementById("validateRequiredFields").innerHTML = '';
            component.set("v.listChildCase",childCasesList);  
			component.set("v.spinner",false);          	
            //this.getplannedDeliveryDateTime(component, event,helper);
            component.set("v.stageNumber",13);
		}
    },
    warrantyCheckHelper: function(component,event,parentCheck) {
        var selAsset = component.get('v.assetRec');
        var selVersionItem = component.get("v.versionRec");
        var isTraceble = selVersionItem[0].HWS_Serial_Number_Traceable__c;        
        var serviceType = component.get('v.serviceType');  
        var isshowRetroAccount = component.get('v.showRetroAccount'); // NOKIASC-37158 | added isshowRetroAccount
		//34214
        if(!isshowRetroAccount && isTraceble != null && isTraceble != '' && isTraceble != undefined && (serviceType == 'Return for Repair or Replacement' || serviceType == 'Advanced Exchange in Days' || serviceType == 'Identical Repair' || serviceType == 'Spare Part Sales') 
           && selAsset[0].HWS_ContractLineItem__r.HWS_WarrantyVerificationRequired__c == "Yes" && (isTraceble.toUpperCase() == 'YES' || isTraceble.toUpperCase() == 'Y')){
            var action =component.get("c.warrantyCheck");
             // NOKIASC-35543 | Start
                var materialCode = '';
                if(selAsset[0].HWS_SourceSystem__c != undefined && selAsset[0].HWS_SourceSystem__c =='Puma1' ){
                    materialCode=selVersionItem[0].Name;
                }
                else
                     materialCode=selAsset[0].HWS_Part_Code__c;
            //component.set("v.spinner",true);
            action.setParams({
                materialCode : materialCode,
                serialNumber : component.get('v.newChildCase.HWS_Faulty_Serial_Number__c'),
                sourceSystem : selAsset[0].HWS_SourceSystem__c
            });
            // NOKIASC-35543 | End
            action.setCallback(this, function(response) {
                var state = response.getState();                
                if (state === "SUCCESS") {                    
                    var warrantyStatusResponse = response.getReturnValue();
					if(warrantyStatusResponse !== null && warrantyStatusResponse !== '' && warrantyStatusResponse !== undefined){
                       component.set('v.warrantyCheckIsNotNull',true); 
                    }
                    console.log('WARRANTY STTAUS:'+warrantyStatusResponse);
                    component.set('v.warrantyStatus',warrantyStatusResponse);                    
                    if(parentCheck == 'addPart'){
                        this.addPartHelper(component,event);
                        component.set("v.spinner",false);
                    }else{
                        this.createChildCase(component, event);
                        //Code Changes for 29132
                        component.set("v.getPPU",false);
                        var newAssetList = component.get('v.getAllAssets');
                        if(newAssetList != null){
                            for(var i=0;i<newAssetList.length;i++){
                                var getPayPerUse=newAssetList[i].HWS_ServiceOffering__c;
                                if( getPayPerUse != undefined && (getPayPerUse.includes('RES RFR PU') || getPayPerUse.includes('RES AED PU'))){
                                    component.set("v.getPPU", true);
                                    break;
                                }
                            }
                        }
                        component.set("v.spinner",false);
                        component.set('v.stageNumber', parseInt(component.get('v.stageNumber'))+1);
                        var contactLookup = component.find("contactAuraId");
                        // NOKIASC-35542
                        if(contactLookup != undefined) 
                            contactLookup.doInitFromPortal();
                        var accountLookup = component.find("recordValue2");
                        // NOKIASC-35542
                        if(accountLookup != undefined) 
                        accountLookup.doInitFromPortal();
                    }                    
                }
                else {
                    component.set("v.spinner",false);
                    var errors = response.getError();                
                    this.showToast('error', 'Error','Update Warranty Status For RFR ServiceType : '+ errors && errors[0] && errors[0].message?errors[0].message:"Something went wrong");
                }
            });
            $A.enqueueAction(action);
        } else{            
            if(parentCheck == 'addPart'){
                this.addPartHelper(component,event);
                component.set("v.spinner",false);
            }else{
                // NOKIASC-37158 Added to set Not Applicable in warranty status
                if(isshowRetroAccount){
                    component.set('v.warrantyStatus','Not Applicable');
                }
                this.createChildCase(component, event);
                //Code Changes for 29132
                component.set("v.getPPU",false);
                var newAssetList = component.get('v.getAllAssets');
                if(newAssetList != null){
                    for(var i=0;i<newAssetList.length;i++){
                        var getPayPerUse=newAssetList[i].HWS_ServiceOffering__c;
                        if( getPayPerUse != undefined && (getPayPerUse.includes('RES RFR PU') || getPayPerUse.includes('RES AED PU'))){
                            component.set("v.getPPU", true);
                            break;
                        }
                    }
                }
                component.set("v.spinner",false);
                component.set('v.stageNumber', parseInt(component.get('v.stageNumber'))+1);
                var contactLookup = component.find("contactAuraId");
                // NOKIASC-35542
                if(contactLookup != undefined) 
                contactLookup.doInitFromPortal();
                var accountLookup = component.find("recordValue2");
                // NOKIASC-35542
                if(accountLookup != undefined) 
                accountLookup.doInitFromPortal();
            }
        }
    },
	showToastError: function(component,event,message) {
        component.set("v.saveCase", false);   
        this.showToast('error','Error Message',message);
        component.set("v.spinner",false);
        //component.set("v.stageNumber", 5);
        component.set("v.saveDisable",false);
        component.set("v.saveSubmitDisable",false);
    },
    isShowRetrofitAccount : function(component, event, helper){
         var selectedContractLineItem = component.get("v.selectedContractLineItem");
         console.log('TESRSRSTRSTSTSTSTSTSTTS'+selectedContractLineItem);
         var action =component.get("c.showRetroAccount");
         
         action.setParams({
             contractLineItemId: selectedContractLineItem
         });
         action.setCallback(this, function(response){
             var state = response.getState();
             var isshow = response.getReturnValue();
             component.set("v.showRetroAccount", isshow);
             
         });
         $A.enqueueAction(action);
     },
    updateAccount: function(component, event, helper, AccountId) {
		var action = component.get("c.getAccountsInfo");
		action.setParams({
			'accountId': AccountId 
		});
		action.setCallback(this, function(response) {            
			var state = response.getState();
			if (state === "SUCCESS") {
				var accountDetails = response.getReturnValue();
				component.set("v.selectedAccount",accountDetails);
			   // component.set("v.accountName", accountDetails[0].Name);
			}
		});
		$A.enqueueAction(action); 
		
	},
	
    //NOKIASC-37090:Bulk Case Creation : Allow user to select Service Contract|Start
    //NOKIASC-37090:Calling apex method to get all the service contarct 
    handleServiceContractSearch: function (component, event, helper) {        
        let action = component.get('c.fetchServiceContract');        
        action.setParams({contactId: component.get("v.contactId"), 
                          accountId : component.get("v.accountId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var returnDataList = response.getReturnValue();
                
                this.setPopUpColumnsConfig(component,event,helper);
                component.set("v.currentCount", component.get("v.initialRows"));
                component.set("v.allServiceContractList",returnDataList);
                component.set("v.totalNumberOfRows", returnDataList.length);
                var popUpDataList=this.InitializePopUpDataList(component,returnDataList,(returnDataList.length>component.get("v.initialRows"))?component.get("v.initialRows"):returnDataList.length,component.get("v.rowNumberOffset"));
                component.set("v.popUpDataList",popUpDataList);   
                //NOKIASC-37156:For single records it will be auto select|Start
                if(popUpDataList.length===1){
                    this.selectServiceContract(popUpDataList[0],component,event,helper);
                }
                else{    
                    component.set("v.ModalSpinner", false);
                }       
                //NOKIASC-37156:For single records it will be auto select|End
                
                
            }else{
                var Error=  response.getError();
                this.showToast(component,"ERROR",Error[0].message) ;                
                component.set("v.ModalSpinner", false);
            }
            
        });        
        $A.enqueueAction(action);
    },
    //NOKIASC-37090:Data table column configure
    setPopUpColumnsConfig : function (component,event,helper){
        component.set('v.columnsConfig', [
            {type: 'button', typeAttributes: {
                label: { fieldName: 'actionLabel'},
                name: 'select_servicecontract',
                title: 'Click to Select Service Contract',
                disabled: {fieldName: 'actionDisabled'}
            }, cellAttributes: { alignment: 'center' }},
            {label: 'CDB Contract Number', fieldName: 'serviceContractName',type: 'text', sortable: 'true'},
            {label: 'SAP P20 Contract Number', fieldName: 'serviceContractNumber', type: 'text',sortable: 'true'},
            {label: 'CARES Service Agreement', fieldName: 'caresServiceAgreement', type: 'text',sortable: 'true'}
        ])           
    },
    //NOKIASC-37090:intialize and buld data list from apex return list
    InitializePopUpDataList : function(component,dataList,limit,offSet){
        var tempList=[];        
        for(var i = offSet; i < limit; i++) {
            var obj={};
            if (typeof(dataList[i].Entitlement.ServiceContractId) != 'undefined') {
                obj['Id'] =dataList[i].Entitlement.ServiceContractId;
                if (dataList[i].Entitlement.ServiceContractId==component.get("v.serviceContractId")){
                    obj['actionLabel']='Selected';
                    obj['actionDisabled']=true;
                }
                else {                        
                    obj['actionLabel']='Select';
                    obj['actionDisabled']=false;
                }
            }
            if (typeof(dataList[i].Entitlement.ServiceContract.CH_CDB_ContractNumber__c) != 'undefined') {
                obj['serviceContractName'] =dataList[i].Entitlement.ServiceContract.CH_CDB_ContractNumber__c;
            }
            if (typeof(dataList[i].Entitlement.ServiceContract.CH_SAP_ContractNumber__c) != 'undefined') {
                obj['serviceContractNumber'] =dataList[i].Entitlement.ServiceContract.CH_SAP_ContractNumber__c;
            }
            if (typeof(dataList[i].Entitlement.ServiceContract.CH_CARES_ServiceAgreement__c) != 'undefined') {
                obj['caresServiceAgreement'] =dataList[i].Entitlement.ServiceContract.CH_CARES_ServiceAgreement__c;
            }
            if (typeof(dataList[i].Entitlement.ServiceContract.HWS_Retrofit_Type__c) != 'undefined') {
                obj['contractGlobalLocal'] =dataList[i].Entitlement.ServiceContract.HWS_Retrofit_Type__c;
            }
            tempList.push(obj); 
        }
        return tempList;                
    },
    //NOKIASC-37090:on onrowaction event selected row data initialized
    selectServiceContract : function (row,component, event, helper) {
        var oldContractId = component.get("v.serviceContractId");
        component.set("v.serviceContractId",row.Id);       
        component.set("v.serviceContractName",row.serviceContractName);
        component.set("v.selectedServiceContract",row);
        component.set("v.isModalVisible", false); 
        if(row.contractGlobalLocal === 'Global Retrofit' || row.contractGlobalLocal=== 'Local Retrofit') {
        	component.set("v.isRetrofitRequired", 'true');
        }
        component.set("v.isGlobal", row.contractGlobalLocal=='Global Retrofit' ?true: false); 
        if((oldContractId != row.Id) || (oldContractId == row.Id)){
            component.set("v.isChangedContractLine",true); 
            var retroAccountCmp = component.find("retroAccountComponent");
            //commented for NOKIASC-38036
            //retroAccountCmp.clear();   
        }
        else{
            component.set("v.isChangedContractLine",false); 
        }
    },
    //NOKIASC-37090:Sort data table records 
    sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.popUpDataList");
        var reverse = sortDirection !== 'asc';
        
        data = Object.assign([],
                             data.sort(this.sortBy(fieldName, reverse ? -1 : 1))
                            );
        cmp.set("v.popUpDataList", data);
    },
    //NOKIASC-37090:Sort data table records 
    sortBy: function (field, reverse, primer) {
        var key = primer
        ? function(x) {
            return primer(x[field]);
        }
        : function(x) {
            return x[field];
        };
        return function (a, b) {
            var A = key(a)? key(a).toLowerCase() : '';
            var B = key(b)? key(b).toLowerCase() : '';
            return reverse * ((A > B) - (B > A));       
        };
    },
    //NOKIASC-37090:Bulk Case Creation : Allow user to select Service Contract|End
	//added for NOKIASC-35931
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
    // NOKIASC-38079 - Start
    checkCountOfParts : function(component, event) {
       
        if(component.get("v.listChildCase") != undefined && 
           component.get("v.listChildCase").length+1 >=
           parseInt($A.get("$Label.c.HWS_CNT_AddPartsLimit_Portal"))) { 
            
            component.set("v.disableAddPart",true);
        }
    }
    // NOKIASC-38079 - End
})