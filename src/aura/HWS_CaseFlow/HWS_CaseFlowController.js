({
    //Spinner Code Start
    showWaiting: function(cmp) {
        cmp.set("v.IsSpinner", true);
    },
    doInit: function(cmp){
    	cmp.set("v.showLookUp", true);    
    },
    handleComponentEvent:function(component, event, helper) {
        var selectedCountryVal = event.getParam("selectedCountry");
		var selectedRetroAccountName = event.getParam("selectedAccountName");
        console.log('selectedCountryVal====='+selectedCountryVal);
        if (selectedCountryVal != '' && selectedCountryVal != undefined) {
            component.set("v.showLookUp", false);
        } else {
        	component.set("v.showLookUp", true);   
        }
		component.set("v.selectedCountryName", selectedCountryVal);
		component.set("v.selectedRetroAccountName", selectedRetroAccountName);
        var AccountId = event.getParam("selectedAccountId");
        var childComp = component.find('recordValue2');
        childComp.removeShiptoParty();
        component.set("v.selectedCountryName", selectedCountryVal);
		if (AccountId != '' && AccountId != undefined) {
			helper.updateAccount(component, event, helper, AccountId);
            component.set("v.showLookUp", false);
        } 
    }, 
    hideWaiting: function(cmp) {
        cmp.set("v.IsSpinner", false);
    },
    //Spinner Code Ends
    handleLookupEvent: function(component, event, helper) {
        var objectId = event.getParam("ParentRecordId");
        var ObjectnameId = event.getParam("objectNameId");
        var shipToPartyAccount = event.getParam("shipToPartyAccount");
        console.log('shipToPartyAccount##'+JSON.stringify(shipToPartyAccount));
        if (ObjectnameId == "Account") {
            component.set("v.ShiptopartyAddress", objectId);
            component.set("v.shipToPartyAccount", shipToPartyAccount);
        } else if (ObjectnameId == "Contact") {
            component.set("v.communicationContact", objectId);
        }
    },
    //set serach criteria
    onSingleSelectChange: function(component) {
        var selectCmp = component.find("InputSelectSingle");
        component.set("v.searchCriteria", selectCmp.get("v.value"));
        component.set("v.isADFDescription", false);
        component.set("v.selectedNEA", null);
        console.log("search criteria ###" + component.get("v.searchCriteria"));
        if (component.get("v.searchCriteria") === "Contract Number") {
            component.set("v.ContractNum", true);
            component.set("v.SelectConNum", false);
            component.set("v.ContractNumProgress", true);
            component.set("v.ContProgressBarCounter", 1);
        } else {
            component.set("v.ContractNumProgress", false);
        }
        if (component.get("v.searchCriteria") === "Part Code") {
            component.set("v.ContractNum", false);
        }
    },
    //store selected accounts in a variable
    processSelectedAccount: function(component, event) {
        component.set("v.enableAccount", false);
        var selectedRows = event.getParam("selectedRows");
        component.set("v.selectedAccount", selectedRows);
         component.set("v.oldAccount", selectedRows); 
        component.set("v.legalEntityNotFound", true);
    },
    setCaseOring: function(component, event) {
        var selectCmp = component.find("caseOrigin");
        component.set("v.caseOrigin", selectCmp.get("v.value"));
    },
    //go to search screen
    gotoStep2: function(component, event, helper) {
        component.set("v.ProgressBarCounter", 1);
        component.set("v.ProgressBarNEACounter", 1);
        helper.gotoSearchScreen(component, event);
        //component.set("v.legalEntityNotFound" , true);
        //added for US-3205 to display Legal Entity Account on Case flow
        var legalEntities = component.get("v.selectedAccount");
        component.set("v.assetFilterText", null);
        component.set("v.CLISFilterText", null);
        if (legalEntities && legalEntities.length) {
            component.set("v.AccountName", legalEntities[0].Name);
        }
    },
    autoPopulateContactInfo : function (component,event) {
        var isEnabled = component.find("chkbox").get("v.value"); 
        component.set("v.isContactDetailsSelected", isEnabled);
        if (isEnabled) {
            
            var contactId = component.get("v.recordId");
            console.log('contactId'+ contactId);
            var action = component.get("c.getContactInfo");     
            action.setParams({
                contactId : contactId,
                
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                console.log('state'+ state);
                if (state === "SUCCESS") {
                    var result = response.getReturnValue();
                    console.log('result'+result);
                    component.set('v.newParentCase.HWS_Shipment_Recipient_Name__c', result.name);
                    component.set('v.newParentCase.HWS_Shipment_Recipient_Phone__c', result.phoneNumber);
                    component.set('v.newParentCase.HWS_ShipmentRecipientEmailId__c', result.email);
                    
                }    
            });
            $A.enqueueAction(action);
        } else {
            component.set('v.newParentCase.HWS_Shipment_Recipient_Name__c', '');
            component.set('v.newParentCase.HWS_Shipment_Recipient_Phone__c', '');
            component.set('v.newParentCase.HWS_ShipmentRecipientEmailId__c', '');   
        }
        
    },
    //US-3325 Initiate search by hitting the Enter/Return key start
    searchPartorContract: function(component, event, helper) {
        var assts = component.get('v.Assets');
        if (assts == null || assts == ' ' ||  assts == undefined){
            component.set("v.finalclisearch", 2); 
        }  
        else{
            component.set("v.finalclisearch", 3);
        }
        var clis1 = component.get('v.clis');
        if (clis1 == null || clis1 == ' ' || clis1 == undefined){
            component.set("v.finalconsearch", 2);  
        }
        else{
            component.set("v.finalconsearch", 3);   
        }
        component.set("v.assetFilterText", "");
        component.set("v.CLISFilterText", "");
        if (event.keyCode === 13) {
            console.log("Line 52" + component.get("v.showtestContract"));
            if (component.get("v.showtestContract") == false) {
                component.set("v.contractNumber", "");
            }
            helper.getServiceContracts(component, event);
        }
        component.set("v.isADFDescription", false);
    },
    //US-3325 Initiate search by hitting the Enter/Return key End
    
    //get list of contract line items
    search: function(component, event, helper) {
        var assts = component.get('v.Assets');
        if (assts == null || assts == ' ' ||  assts == undefined){
            component.set("v.finalclisearch", 2); 
        }  
        else{
            component.set("v.finalclisearch", 3);
        }
        var clis1 = component.get('v.clis');
        if (clis1 == null || clis1 == ' ' || clis1 == undefined){
            component.set("v.finalconsearch", 2);  
        }
        else{
            component.set("v.finalconsearch", 3);   
        }
        component.set("v.assetFilterText", "");
        component.set("v.CLISFilterText", "");
        if (component.get("v.showtestContract") == false) {
            component.set("v.contractNumber", "");
        }
        helper.getServiceContracts(component, event);
        component.set("v.selectedVersions", null);
        component.set("v.isADFDescription", false);
    },
    // store selected contract lines in a variable when it is selected
    processSelectedContract1: function(component, event, helper) {
        var selectedRows = event.getParam("selectedRows");
        //HWSDDP-144:Suspension � block creation of RES RMA||Start
        var action =component.get("c.getSuspensionStatus");
        var selectedServiceContract = selectedRows[0].HWS_ContractLineItem__r.ServiceContractId;
        action.setParams({
            contactList:component.get("v.recordId"),
            serviceContractList:selectedServiceContract.split(',')
            
        });
        action.setCallback(this, function(response){                
            let state = response.getState();
            if (state === "SUCCESS") {	
                let result = response.getReturnValue();
                if(result.length>0){
                    helper.showToast("error","Error Message",$A.get("$Label.c.HWS_MSG_CaseFlow_Suspension")
                                    );
                }
                else{
                    helper.processSelectedServiceContract(component, event,helper,selectedRows);
                }
            }   
            
        });
        $A.enqueueAction(action);
        //HWSDDP-144:Suspension � block creation of RES RMA||End
    },
    processSelectedLineItem: function(component, event,helper) {
        var selectedRows = event.getParam("selectedRows");
        //HWSDDP-144:Suspension � block creation of RES RMA||Start
        var action =component.get("c.getSuspensionStatus");
        var selectedServiceContract = selectedRows[0].ServiceContractId;
        action.setParams({
            contactList:component.get("v.recordId"),
            serviceContractList:selectedServiceContract.split(',')
            
        });
        action.setCallback(this, function(response){                
            let state = response.getState();
            if (state === "SUCCESS") {	
                let result = response.getReturnValue();
                if(result.length>0){
                    helper.showToast("error","Error Message",$A.get("$Label.c.HWS_MSG_CaseFlow_Suspension")
                                    );
                }
                else{
                    component.set("v.enableContract", false);
                    component.set("v.enableAsset", true);
                    if (selectedRows != null && selectedRows != "" && selectedRows != undefined)
                        // NOKIASC-25661 to enable Select NEA button checking count
                        var nea = selectedRows[0].CH_QtyCoveredNetworkElementAssets__c;
                    component.set("v.selectedAssetstep2", true);
                    
                    if (nea == 0) {
                        component.set("v.enableSelectNEA", true);
                        component.set("v.showVI", true);
                        component.set("v.SelectNEAProgress", false);
                        //component.set("v.selectedLineItemstep2" , false);
                        //component.set("v.selectedNEA", null);
                        component.set("v.selectedAssets", null);
                        component.set("v.selectedVersions", null);
                    } else {
                        component.set("v.enableSelectNEA", false);
                        component.set("v.showVI", false);
                    }
                    // NOKIASC-25661 changes end
                    var selNEA = component.get("v.selectedNEA");
                    if (selNEA != "" && selNEA != null && selNEA != undefined) {
                        component.set("v.showVI", true);
                    }
                    //component.set("v.selectedLineItemstep2", true);
                    console.log("#### Selected line Items" + JSON.stringify(selectedRows));
                    component.set("v.selectedclis", selectedRows);
                    if (
                        selectedRows != null &&
                        selectedRows != "" &&
                        selectedRows != undefined
                    ) {
                        component.set("v.isADFDescription", true);
                        component.set("v.showADFDescription", true);
                        var adf = selectedRows[0].CH_CoverageGroup__c;
                        if (!$A.util.isEmpty(adf) && adf != "undefined") {
                            component.set("v.ADFDescription", adf);
                        } else {
                            component.set("v.ADFDescription", "No Additional Description");
                        }
                    }
                    if (
                        selectedRows != null &&
                        selectedRows != "" &&
                        selectedRows != undefined
                    ) {
                        component.set("v.toProceedSPSLOD", false);
                        var serviceEntScript =
                            selectedRows[0].ServiceContract.CH_EntitlementScript__c;
                        var lineEntScript = selectedRows[0].CH_LineItemEntitlementScript__c;
                        //added for US-3205 to display Contract Number and Service Type
                        var contractNumber = selectedRows[0].HWS_ServiceContractNumber__c;
                        var serviceType = selectedRows[0].CH_ServiceType__c;
                        //2503 SPS Last Order Date validation started when contract entered
                        //var SRMLOD = selectedRows[0].HWS_Product_SPSLOD__c;
                        var SRMLOD =
                            selectedRows[0].PricebookEntry.Product2.HWS_SPS_Last_Order_Date__c;
                        if (
                            (selectedRows[0].PricebookEntry.Product2.HWS_SPS_Last_Order_Date__c !=
                             undefined ||
                             selectedRows[0].PricebookEntry.Product2.HWS_SPS_Last_Order_Date__c !=
                             null) &&
                            serviceType == "Spare Part Sales"
                        ) {
                            var milliseconds = new Date().getTime() - Date.parse(SRMLOD);
                        }
                        if (milliseconds > 0 && serviceType == "Spare Part Sales") {
                            component.set("v.toProceedSPSLOD", true);
                        }
                        //2503 SPS Last Order Date validation Ended
                    }
                    var showParentES;
                    var showLineES;
                    component.set("v.entitlementScript", serviceEntScript);
                    component.set("v.entitlementScriptLine", lineEntScript);
                    component.set("v.contractNumber", contractNumber);
                    component.set("v.serviceTypeCheck", serviceType);
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
                        selectedRows == null ||
                        selectedRows == "" ||
                        selectedRows == undefined
                    ) {
                        component.set("v.enableContract", true);
                    }
                }
            }   
            
        });
        $A.enqueueAction(action);
        //HWSDDP-144:Suspension � block creation of RES RMA||End
        
    },
    //Escalate Case
    escalateCase: function(component, event) {
        let button = event.getSource();
        //button.set("v.disabled",true);
        component.set("v.isOpen", true);
        component.set("v.showStep6", false);
    },
    closeModel: function(component, event, helper) {
        component.set("v.isOpen", false);
    },
    saveEscalatedCase: function(component, event, helper) {
        if (component.find("caseComment").get("v.value") == null) {
            var commErr = component.find("caseComment");
            commErr.setCustomValidity(
                $A.get("$Label.c.HWS_MSG_No_CaseComment_Validity")
            );
            commErr.reportValidity();
        }
        if (component.find("caseComment").get("v.value") != null) {
            component.set("v.isOpen", false);
            helper.createEscCase(component, event);
        }
    },
    //show list of Version Item details
    /*  gotoStep3a: function(component, event, helper) {
        helper.gotoStep3(component, event, helper);
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
            //added by lakshman
            component.set("v.SelectProgressBar",false);
            component.set("v.ContractNumProgress",false);
            component.set("v.ContractNumNEAProgress",false);
            //added by lakshman
            }
       }
    },	*/
    gotoStep3b: function(component, event, helper) {
        console.log("step3b");
        helper.gotoStep3(component, event, helper);
    },
    
    stage2Logic: function(component, event, helper) {
        var searchCriteria = component.get("v.searchCriteria");
        var assets = component.get("v.Assets");
        var showVI = component.get("v.showVI");
        var clis = component.get("v.clis");
        console.log(
            "value of service type check " + component.get("v.serviceTypeCheck")
        );
        
        if (searchCriteria == "Part Code" && assets != null) {
            if (showVI) {
                helper.gotoStep3a(component, event, helper);
            } else {
                helper.selectNetworkElementAssetA(component, event, helper);
            }
        }
        if (searchCriteria == "Contract Number" && clis != null) {
            if (showVI) {
                $A.enqueueAction(component.get("c.gotoStep6A"));
            } else {
                $A.enqueueAction(component.get("c.selectNetworkElementAssetB"));
            }
        }
    },
    stage6Logic: function(component, event, helper) {
        console.log("on stage6Logic");
        console.log(
            "value of service type check " + component.get("v.serviceTypeCheck")
        );
        helper.gotoStep3c(component, event, helper);
    },
    
    /*gotoStep3c: function(component, event, helper) {
        console.log('step3c');
        helper.gotoStep3(component, event, helper);
    },*/
    
    // store selected contract lines in a variable when it is selected
    processSelectedVersion: function(component, event) {
        component.set("v.selectedVersionstep3", true);
        component.set("v.newChildAddPart", false);
        var selectedRows = event.getParam("selectedRows");
        component.set("v.selectedVersions", selectedRows);
        if (component.get("v.addPartClearSelection") === true) {
            component.set("v.addPartClearSelection", false);
        }
        var CheckVersion = component.get("v.versionItems");
        if (
            CheckVersion != null &&
            CheckVersion != "" &&
            CheckVersion != undefined
        ) {
            if (
                selectedRows != null &&
                selectedRows != "" &&
                selectedRows != undefined
            ) {
                var stockableProd = selectedRows[0].Id;
                component.set("v.newChildCase.HWS_Stockable_Product__c", stockableProd);
                //25689
                component.set(
                    "v.newChildCase.Street_Address_1__c",
                    selectedRows[0].HWS_Version_Code__c
                );
                component.set("v.newChildCase.Street_Address_3__c", "delInfoBGCol");
                component.set("v.selectedVersions", selectedRows);
                component.set("v.CustPartrevison", "");
            }
            component.set("v.enableVi", false);
        }
    },
    //show list of Version Item details
    gotoStep4: function(component, event, helper) {
        console.log("goto step4");
        component.set("v.isHide", false);
        var rows = component.get("v.selectedVersions");
        if (rows != null && rows != "" && rows != undefined) {
            //NOKIASC-38079
            helper.checkCountOfParts(component, event);
            //NOKIASC-38079
            component.set("v.StageNumber", 4);
            component.set("v.ProgressBarCounter", 3);
            component.set("v.ProgressBarNEACounter", 4);
            component.set("v.ContProgressBarCounter", 4);
            component.set("v.ContNEAProgressBarCounter", 5);
            component.set("v.selectedVersionstep3", true);
            if (component.get("v.newChildAddPart") === true) {
                component.set("v.newChildAddPart", false);
            }
             //NOKIASC-34442
             var today = new Date();
             component.set('v.newChildCase.HWS_Failure_Detection_Date__c',today.toLocaleDateString('en-CA'));
            //NOKIASC-34442
        } else {
            helper.showToast(
                "error",
                "Error Message",
               $A.get("$Label.c.HWS_MSG_Select_PartRevision")
            );
        }
        //added for US-3205 to display Part Name
        var partRevisions = component.get("v.selectedVersions");
        var customerPartRevision = component.get("v.CustPartrevison");
        //if(partRevisions && partRevisions.length) {
        if (
            partRevisions &&
            partRevisions.length &&
            (customerPartRevision == undefined || customerPartRevision == "")
        ) {
            component.set("v.PartCode", partRevisions[0].HWS_Version_Code__c);
        } else {
            component.set("v.PartCode", customerPartRevision);
        }
    },
    gotoStep5: function(component, event, helper) {
        console.log("go to step5");
        component.set("v.ProgressBarCounter", 4);
        component.set("v.ProgressBarNEACounter", 5);
        component.set("v.ContProgressBarCounter", 5);
        component.set("v.ContNEAProgressBarCounter", 6);
        component.set("v.IsSpinner", true);
        //US 27245 begin
        var serviceTypeCheck = helper.assignServiceType(component);
        //US 27245 end
        console.log("serviceTypeCheck" + serviceTypeCheck);
        if (serviceTypeCheck != "Spare Part Sales") {
            component.set("v.newChildCaseCheck", false);
            /*if(component.get("v.newChildCaseCheck")== false){
            component.set("v.childcasestep4", false);
                }
            else{
               component.set("v.childcasestep4", true); 
            }*/
            //NOKIASC-31177 added validation condition
            var isValid = true;
            if(component.get('v.newChildCase.HWS_RequestHWRCAFMA__c')){
                isValid = helper.validation(component, event, helper, 'SWTnSponsorFields');
                if(isValid){
                    helper.validateSWSCase(component, event, helper);
                }
                else{
                    component.set("v.IsSpinner", false);
                }
            }
            else{				              
                helper.duplicateSerialnumCheck(component, event);
            }	
        } else if (serviceTypeCheck == "Spare Part Sales") {
            helper.GetSPSTracked(component, event);
        }
        console.log("Testing active tab####" + component.get("v.childcasestep4"));
        //component.set('v.isHide1', true);
        component.set("v.childcasestep4", true);
        component.set("v.selectedAssetstep2", true);
        component.set("v.selectedLineItemstep2", true);
        component.set("v.selectedVersionstep3", true);
        component.set("v.newChildAddPart", false);
        console.log('TESRSRSTRSTSTSTSTSTSTTS');
         var selectedContractLineItem = component.get("v.selectedContractLineItem");
        console.log('TESRSRSTRSTSTSTSTSTSTTS'+selectedContractLineItem);
        
    },
    gotoStep6A: function(component, event, helper) {
        if (component.get("v.addPartCON")) {
            component.set("v.addPartCON", false);
        }
        console.log("goto step6A");
        var selectedAssets = component.get("v.selectedAssets");
        console.log("selectedAssets###" + selectedAssets);
        if (
            selectedAssets == null ||
            selectedAssets == "" ||
            selectedAssets == undefined
        ) {
            component.set("v.SelectConNum", false);
        }
        var selecVersionItems = component.get("v.selectedVersions");
        console.log("selectedversionItems###" + selecVersionItems);
        if (
            selecVersionItems == null ||
            selecVersionItems == "" ||
            selecVersionItems == undefined
        ) {
            console.log("null");
            component.set("v.selectedVersionstep3", false);
            component.set("v.newChildAddPart", true);
        }
        helper.gotoStep6(component, event, helper);
    },
    gotoStep6B: function(component, event, helper) {
        console.log("goto step6B");
        helper.gotoStep6(component, event, helper);
    },
    //25689
    validateHwCase: function(component, event, helper) {
        component.set("v.parentcaseStep5", true);
        component.set("v.ProgressBarCounter", 5);
        component.set("v.ProgressBarNEACounter", 6);
        component.set("v.ContProgressBarCounter", 6);
        var temp = component.get('v.selectedRetroAccount');
		// NOKIASC-36572
		//NOKIASC-37617 Added global check
        if(component.get("v.isGlobal") && component.get('v.showRetroAccount') && component.get('v.selectedRetroAccount') != undefined && component.get('v.selectedRetroAccount').HWS_Account__c != undefined){  
            var action =component.get("c.getAccounts");
            action.setParams({
                accountId: component.get('v.selectedRetroAccount').HWS_Account__c
            });
            action.setCallback(this, function(response){
                var state = response.getState();
               // if(response.getReturnValue()==null){
               //     component.set("v.isActive","false");
                //    component.set("v.cntInactiveMessage",'Contact is inactive and Support Tickets cannot be initiated.');
               // }
                //else{
                if(state === "SUCCESS") {
                    let accrec =response.getReturnValue();
                   // component.set("v.isActive","true");
                   // component.set("v.conAccounts", response.getReturnValue());
                   // component.set("v.AllAccounts", response.getReturnValue());		       
                    if(accrec.length == 1){			
                     //   component.set("v.enableAccount", false);
                      //  component.set("v.selectedAccount", response.getReturnValue());
                       // component.set("v.AccountName", accrec[0].Name); 
                       // component.set("v.legalEntityNotFound", true);
                       component.set("v.retroAccId", accrec);
                       component.set("v.retroAccName", accrec[0].Name);
 
                    }
                }
            });
            $A.enqueueAction(action);
           // NOKIASC-36572
        } 


         
        helper.deliveryInfo(component, event);
        //Added by Ajesh
        //helper.getplannedDeliveryDateTime(component, event,helper);
    },
    //25689
    saveHwCase: function(component, event, helper) {
        var childCasesList = component.get("v.childCases");
        var reqVal = true;
        for (var i = 0; i < childCasesList.length; i++) {
            var planedDate = childCasesList[i].HWS_Planned_Delivery_Date__c;
            var requestedDate = childCasesList[i].HWS_Requested_Delivery_Date_Time__c;
            console.log(
                "Planned date: subbbb" +
                planedDate +
                " Req Date: subbbbb" +
                requestedDate
            );
            if (
                planedDate != null &&
                new Date(planedDate) > new Date(requestedDate) &&
                requestedDate != null
            ) {
                reqVal = false;
                childCasesList[i].Street_Address_3__c = "delInfoBorderCol";
            }
        }
        component.set("v.childCases", childCasesList);
        if (reqVal) {
            document.getElementById("validateRequiredFields").innerHTML = "";
            component.set("v.onSubmitprogress", true);
            component.set("v.IsSpinner", true);
            helper.save(component, event, helper);
        } else {
            document.getElementById("validateRequiredFields").innerHTML =
                "Date and time cannot be less than Planned Delivery date";
        }
    },
    createNewChild: function(component, event, helper) {
        component.set("v.showAssets", false);
        component.set("v.showClis", false);
        component.set("v.enableAsset", true);
        component.set("v.enableContract", true);
        component.set("v.IsSpinner", true);
        //component.set("v.selectedNEA", null);
        component.set("v.netElemAssets", null);
        var createchildcase = "createchild";
        //US 27245 begin
        var serviceTypeCheck = helper.assignServiceType(component);
        console.log("serviceTypeCheck add part: " + serviceTypeCheck);
        //US 27245 end
        if (serviceTypeCheck != "Spare Part Sales") {
            component.set("v.newChildCaseCheck", true);
            //3952 --> commented below line to fix the bug
            //component.set("v.backDisable",true);
            component.set("v.isADFDescription", false);
            component.set("v.showParentEntS", false);
            component.set("v.showLineEntS", false);
            //NOKIASC-31177 added validation condition
            var isValid = true;
            if(component.get('v.newChildCase.HWS_RequestHWRCAFMA__c')){
                isValid = helper.validation(component, event, helper, 'SWTnSponsorFields');                
                if(isValid){
                    helper.validateSWSCase(component, event, helper);
                }
                else{
                    component.set("v.IsSpinner", false);
                }
            }
            else{				              
                helper.duplicateSerialnumCheck(component, event, createchildcase);
                
                
            } 
        } else if (serviceTypeCheck == "Spare Part Sales") {
            component.set("v.newChildCaseCheck", true);
            //3952 --> commented below line to fix the bug
            //component.set("v.backDisable",true);
            component.set("v.isADFDescription", false);
            component.set("v.showParentEntS", false);
            component.set("v.showLineEntS", false);
            helper.GetSPSTracked(component, event, createchildcase);
        }
        component.set("v.isHide", true);
        component.set("v.newChildAddPart", true);
        component.set("v.addPartClearSelection", true);
    },
    open1: function(component, event, helper) {
        component.set(
            "v.ProgressBarCounter",
            component.get("v.ProgressBarCounter") - 1
        );
        component.set(
            "v.ProgressBarNEACounter",
            component.get("v.ProgressBarNEACounter") - 1
        );
        //component.set("v.legalEntityNotFound", false);
        component.set("v.StageNumber", 1);
        var dTable = component.find("inputFieldsToCheck");
        var selectedAcc = dTable.getSelectedRows();
        component.set("v.assetFilterText", "");
        component.set("v.Assets", component.get("v.AllAssets"));
        component.set("v.CLISFilterText", "");
        component.set("v.clis", component.get("v.ALLclis"));
        var selectedAcc = component.get("v.selectedAccount");
        if (typeof selectedAcc != "undefined" && selectedAcc) {
            var selectedRowsIds = [];
            for (var i = 0; i < selectedAcc.length; i++) {
                selectedRowsIds.push(selectedAcc[i].Id);
            }
            var dTable = component.find("inputFieldsToCheck");
            dTable.set("v.selectedRows", selectedRowsIds);
            component.set("v.oldSelectedAccount", dTable.get("v.selectedRows"));
        }
        var selNEA = component.get("v.selectedNEA");
        var selAst = component.get("v.selectedAssets");
        var selCli = component.get("v.selectedclis");
        var searchCrit = component.get("v.searchCriteria");
        console.log(
            "NEA:" +
            JSON.stringify(component.get("v.selectedAssets")) +
            "CLIS:" +
            JSON.stringify(component.get("v.selectedclis")) +
            "NEA SE:" +
            JSON.stringify(selNEA)
        );
        if (searchCrit == "Part Code") {
            if (
                (selNEA == null || selNEA == "" || selNEA == undefined) &&
                (selAst == null ||
                 selAst == "" ||
                 selAst == undefined ||
                 selAst[0].CoveredNetworkElementCount == 0)
            ) {
                component.set("v.showVI", true);
            } else {
                component.set("v.showVI", false);
            }
        }
        if (searchCrit == "Contract Number") {
            if (
                (selNEA == null || selNEA == "" || selNEA == undefined) &&
                (selCli == null ||
                 selCli == "" ||
                 selCli == undefined ||
                 selCli[0].CoveredNetworkElementCount == 0)
            ) {
                component.set("v.showVI", true);
            } else {
                component.set("v.showVI", false);
            }
        }
    },
    open2A: function(component, event, helper) {
        console.log("open 2A");
        helper.open2(component, event, helper);
        var selecNEA = component.get("v.selectedNEA");
        if (selecNEA != null && selecNEA != "" && selecNEA != undefined) {
            console.log("selected NEA" + selecNEA);
            component.set("v.SelectNEAProgress", true);
        } else {
            component.set("v.SelectNEAProgress", false);
        }
    },
    open2B: function(component, event, helper) {
        console.log("open 2B");
        helper.open2(component, event, helper);
        var selNEA = component.get("v.selectedNEA");
        if (selNEA != null && selNEA != "" && selNEA != undefined) {
            component.set("v.SelectNEAProgress", true);
        }
    },
    open2C: function(component, event, helper) {
        console.log("open 2C");
        helper.open2(component, event, helper);
    },
    open2D: function(component, event, helper) {
        console.log("open 2D");
        helper.open2(component, event, helper);
    },
    open2E: function(component, event, helper) {
        console.log("open 2E");
        helper.open2(component, event, helper);
    },
    
    open3: function(component, event, helper) {
        component.set("v.ProgressBarCounter", 2);
        component.set("v.ProgressBarNEACounter", 3);
        component.set("v.ContProgressBarCounter", 3);
        component.set("v.ContNEAProgressBarCounter", 4);
        component.set("v.StageNumber", 3);
        var dTable = component.find("vItems");
        var selectedAcc = dTable.getSelectedRows();
        var selectedAcc = component.get("v.selectedVersions");
        if (typeof selectedAcc != "undefined" && selectedAcc) {
            var selectedRowsIds = [];
            for (var i = 0; i < selectedAcc.length; i++) {
                selectedRowsIds.push(selectedAcc[i].Id);
            }
            var dTable = component.find("vItems");
            dTable.set("v.selectedRows", selectedRowsIds);
        }
    },
    open4: function(component, event, helper) {
        component.set("v.ProgressBarCounter", 3);
        component.set("v.ProgressBarNEACounter", 4);
        component.set("v.ContProgressBarCounter", 4);
        component.set("v.ContNEAProgressBarCounter", 5);
        component.set("v.StageNumber", 4);
        component.set("v.childcasestep4", true);
        var newChildCasesList = component.get("v.childCases");
        var removeLast = newChildCasesList.pop(newChildCasesList.length);
        var listToADD = [];
        for (var i in newChildCasesList) {
            var oldRecipent = newChildCasesList[i];
            if (oldRecipent != []) {
                listToADD.push(oldRecipent);
            }
        }
       
        component.set("v.childCases", listToADD);
        //component.set("v.ShiptopartyAddress", "");
        component.set("v.communicationContact", "");
        if(component.get("v.showRetroAccount"))
            component.set("v.selectedAccount", component.get("v.oldAccount"));
        component.set("v.isHide1", false);
    },
    open5: function(component, event, helper) {
        var selectedAccount = component.get("v.selectedRetroAccount");	
var countryName = component.get("v.selectedCountryName");	
component.set("v.selectedRetroAccount", selectedAccount);	
component.set("v.selectedCountryName", countryName);
        //component.set("v.ShiptopartyAddress", "");
        component.set("v.communicationContact", "");
        component.set("v.StageNumber", 5);
        var isRetroAccount = component.get("v.showRetroAccount");	
if (isRetroAccount || isRetroAccount == 'true' || isRetroAccount == true) {	
var selectedAccountName = component.get("v.selectedRetroAccount");	
var accountId = component.get('v.selectedRetroAccount').Id;	
var countryNametoSet = component.get("v.selectedCountryName");	
var retroAccountcmp = component.find("retroAccount1");	
retroAccountcmp.setLookupvalues(selectedAccountName,countryNametoSet, accountId);	
}
        component.set("v.parentcaseStep5", true);
        component.set("v.ProgressBarCounter", 4);
        component.set("v.ProgressBarNEACounter", 5);
        component.set("v.ContProgressBarCounter", 5);
        var temp = component.get('v.selectedRetroAccount');
        if(component.get("v.showRetroAccount")){
            component.set("v.selectedAccount", component.get("v.oldAccount"));
            component.set("v.AccountName", component.get("v.oldAccount")[0].Name);
        }          
        
    },
    open6: function(component, event, helper) {
        component.set("v.StageNumber", 6);
        console.log("ope6 diff button");
        component.set("v.ContProgressBarCounter", 2);
        component.set("v.ContNEAProgressBarCounter", 3);
        //component.set("v.SelectConNum", false);
        var dTable = component.find("assetTable");
        var selectedAcc = dTable.getSelectedRows();
        var selectedAcc = component.get("v.selectedAssets");
        var showClis = component.get("v.showClis");
        component.set("v.VersionItemFilterText", "");
        component.set("v.versionItems", component.get("v.AllversionItems"));
        if (
            selectedAcc != null &&
            selectedAcc != "" &&
            selectedAcc != undefined &&
            (showClis == true || showClis)
        ) {
            if (typeof selectedAcc != "undefined" && selectedAcc) {
                var selectedRowsIds = [];
                for (var i = 0; i < selectedAcc.length; i++) {
                    selectedRowsIds.push(selectedAcc[i].Id);
                }
                var dTable = component.find("assetTable");
                dTable.set("v.selectedRows", selectedRowsIds);
                component.set("v.oldSelectedAssets", dTable.get("v.selectedRows"));
            }
        }
    },
    //Method to Filter Accounts
    filterAccounts: function(component, event, helper) {
        var action = component.get("v.AllAccounts"),
            AccountNameFilter = component.get("v.AccountFilterText"),
            results = action,
            regex;
        try {
            regex = new RegExp(AccountNameFilter, "i");
            // filter checks each row, constructs new array where function returns true
            results = action.filter(
                row => regex.test(row.Name) || 
                regex.test(row.AccountNumber)||
                regex.test(row.CH_ParentAccountName__c) ||
                regex.test(row.OperationalCustomerName__c)
            );
        } catch (e) {
            // invalid regex, use full list
        }
        component.set("v.conAccounts", results);
    },
    //Method to Filter Assests
    filterAssests: function(component, event, helper) {
        var action = component.get("v.AllAssets"),
            AssetFilter = component.get("v.assetFilterText"),
            results = action,
            regex;
        try {
            regex = new RegExp(AssetFilter, "i");
            // filter checks each row, constructs new array where function returns true
            results = action.filter(
                row =>
                regex.test(row.HWS_Service_Type__c) ||
                regex.test(row.HWS_ServiceItemCode__c) ||
                regex.test(row.HWS_ServiceItemDescription__c) ||
                regex.test(row.HWS_ContractLeadTimeUnit__c) ||
                regex.test(row.HWS_ContractLeadTimeDuration__c) ||
                regex.test(row.HWS_Service_Contract_Number__c) ||
                regex.test(row.HWS_SpecifiedDeliveryTargetTime__c) ||
                regex.test(row.HWS_High_Level_Product_Name__c) ||
                regex.test(row.HWS_Part_Code__c) ||
                regex.test(row.HWS_Currency__c) ||
                regex.test(row.HWS_Price__c) ||
                regex.test(row.CountryName) ||
                regex.test(row.HWS_Product_Name__c)
            );
        } catch (e) {
            // invalid regex, use full list
        }
        component.set("v.Assets", results);
    },
    //Method to Filter Assests
    filterAssests_PartCode: function(component, event, helper) {
        var action = component.get("v.AllAssets"),
            AssetFilter = component.get("v.assetFilterText"),
            results = action,
            regex;
        try {
            regex = new RegExp(AssetFilter, "i");
            // filter checks each row, constructs new array where function returns true
            results = action.filter(
                row =>
                regex.test(row.HWS_Service_Type__c) ||
                regex.test(row.HWS_ContractLeadTimeDuration__c) ||
                regex.test(row.HWS_ContractLeadTimeUnit__c) ||
                regex.test(row.HWS_Service_Contract_Number__c) ||
                regex.test(row.HWS_SpecifiedDeliveryTargetTime__c) ||
                regex.test(row.HWS_High_Level_Product_Name__c) ||
                regex.test(row.HWS_Part_Code__c) ||
                regex.test(row.HWS_Currency__c) ||
                regex.test(row.HWS_ServiceItemCode__c) ||
                regex.test(row.HWS_ServiceItemDescription__c) ||
                regex.test(row.HWS_Price__c) ||
                regex.test(row.CountryName) ||
                regex.test(row.HWS_Product_Name__c)
            );
        } catch (e) {
            // invalid regex, use full list
        }
        component.set("v.Assets", results);
    },
    //Method to Filter Version Items
    filterVersionItems: function(component, event, helper) {
        var action = component.get("v.AllversionItems"),
            VersionItemFilter = component.get("v.VersionItemFilterText"),
            results = action,
            regex;
        try {
            regex = new RegExp(VersionItemFilter, "i");
            // filter checks each row, constructs new array where function returns true
            results = action.filter(
                row =>
                regex.test(row.HWS_Product_Name__c) ||
                regex.test(row.HWS_Version_Code__c) ||
                regex.test(row.CLEI__c) ||
                regex.test(row.Comcode__c)
            );
        } catch (e) {
            // invalid regex, use full list
        }
        component.set("v.versionItems", results);
    },
    filterCLIS: function(component, event, helper) {
        var action = component.get("v.ALLclis"),
            ContractItemFilter = component.get("v.CLISFilterText"),
            results = action,
            regex;
        try {
            regex = new RegExp(ContractItemFilter, "i");
            // filter checks each row, constructs new array where function returns true
            results = action.filter(
                row =>
                regex.test(row.CH_ServiceType__c) ||
                regex.test(row.HWS_ServiceContractNumber__c) ||
                regex.test(row.HWS_ServiceContractName__c)
            );
        } catch (e) {
            // invalid regex, use full list
        }
        component.set("v.clis", results);
    },
    //filter NEA
    filterNEA: function(component, event, helper) {
        var neaFilterText = component.get("v.NEAFilterText");
        if(event.keyCode === 13 || neaFilterText==''){                        
            var conAccounts = component.get('v.conAccounts');
            var selectedAsset = component.get("v.selectedAssets");
            var selectedCLI = component.get("v.selectedclis");
            var cliId = null;
            if(selectedAsset != undefined && selectedAsset != '' && selectedAsset != null){
                cliId = selectedAsset[0].HWS_ContractLineItem__c;
            }  
            if(selectedCLI != undefined && selectedCLI != '' && selectedCLI != null){
                cliId = selectedCLI[0].Id;
            }
            helper.getNetworkElementAssets(component,conAccounts[0].Id,cliId);
        }        
    },
    // load all related accounts in a data table
    myAction: function(component, event, helper) {
        //added for US-3299 to get Case Initiation Time - start
        helper.getCaseInitiationTime(component, event);
        //added for US-3299 to get Case Initiation Time - end
        //Timezone -- Merged below functions with getContactDetails - start
        //helper.getContactType(component, event);
        //added for US-3205 to get Contact Name
        //helper.getContactName(component, event);
        //helper.getParentAccount(component, event);
        if (
            component.get("v.recordId") != null &&
            component.get("v.recordId") != "" &&
            component.get("v.recordId") != undefined
        ) {
            helper.getContactDetails(component, event);
        }
        //Timezone -- end
        // added for the US-3196, 3198 - start
        helper.setTabIcon(component);
        //helper.setFocusedTabLabel(component, event, helper);
        // added for the US-3196, 3198 - end
        //added for US-3205 to get Contact Name
        //helper.getContactName(component, event);
        helper.getRelatedAccounts(component, event);
        //helper.getParentAccount(component, event);
        helper.getFailureOccurrencePickListValues(component, event);
        helper.getFailureDetectionPickListValues(component, event);
        helper.getFailureDescriptionPickListValues(component, event);
        helper.getServiceAccNumber(component, event, helper); //added for NOKIASC-35931
    },
    requestDateChange: function(component, event, helper) {
        var validation = helper.requestDateChangeValidate(component, event);
    },
    sectionOne: function(component, event, helper) {
        component.set("v.showADFDescription", false);
    },
    sectionTwo: function(component, event, helper) {
        component.set("v.showADFDescription", true);
    },
    //added for bug  HWST-3544:
    shipTopartyEmptyOnPickSelection: function(component, event, helper) {
        var childComp = component.find("recordValue3");
        childComp.removeShiptoParty();
    },
    //HWST-3478:
    cancelChildPart: function(component, event, helper) {
        component.set("v.StageNumber", 5);
        component.set("v.showCancelButton", false);
        component.set(
            "v.selectedAssets",
            component.get("v.selectedAssetforShipToAddress")
        );
        component.set("v.parentPrevDisable", true);
        component.set("v.selectedAssetstep2", true);
        component.set("v.selectedLineItemstep2", true);
        component.set("v.SelectNEA", true);
        component.set("v.SelectConNum", true);
        component.set("v.selectedVersionstep3", true);
        component.set("v.newChildAddPart", false);
        component.set("v.childcasestep4", true);
        component.set("v.ProgressBarCounter", 4);
        component.set("v.ProgressBarNEACounter", 5);
        component.set("v.ContProgressBarCounter", 5);
        component.set("v.ContNEAProgressBarCounter", 6);
    },
    //NOKIASC-25662
    /*selectNetworkElementAssetA : function(component, event, helper){
        console.log('selectNetworkElementAssetA'+component.get("v.selectedNEA"));
        helper.selectNetworkElementAsset(component, event, helper);
        var searchCriteria = component.get("v.searchCriteria");
        if(searchCriteria == 'Part Code'){
        component.set("v.SelectNEAProgress",true);
           component.set("v.SelectNEAProgressBar",true); 
           //added by lakshman
           component.set("v.SelectProgressBar",false); 
            component.set("v.ContractNumProgress",false);
            component.set("v.ContractNumNEAProgress",false);
            //added by lakshman
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
    },*/
    
    selectNetworkElementAssetB: function(component, event, helper) {
        if (component.get("v.addPartCON")) {
            component.set("v.addPartCON", false);
        }
        console.log("selectNetworkElementAssetB");
        helper.selectNetworkElementAsset(component, event, helper);
    },
    selectNetworkElementAssetC: function(component, event, helper) {
        console.log("selectNetworkElementAssetC");
        helper.selectNetworkElementAsset(component, event, helper);
    },
    selectNetworkElementAssetD: function(component, event, helper) {
        console.log("selectNetworkElementAssetD");
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
        
        if (selecNEA.length>0){
            var allSelectedRows=[];
            
            selecNEA.forEach(function(row) {
                allSelectedRows.push(row.Id);                    
            });
            component.find("neaTable").set("v.selectedRows",allSelectedRows);
        }        
    },
    selectNetworkElementAssetE: function(component, event, helper) {
        console.log("selectNetworkElementAssetE");
        helper.selectNetworkElementAsset(component, event, helper);
    },
    processSelectedNEA: function(component, event, helper) {
        var selectedRows = event.getParam("selectedRows");
        component.set("v.enableNea", false);
        console.log("selected rows" + selectedRows);
        var assets = component.get("v.AllAssets");
        var clis = component.get("v.clis");
        var searchCrit = component.get("v.searchCriteria");
        component.set("v.selectedNEA", selectedRows);
        
        if (
            selectedRows != null &&
            selectedRows != "" &&
            selectedRows != undefined
        ) {
            component.set("v.SelectNEA", true);
            var CLIID = [];
			//NOKIASC-33462
            for(var j = 0;j < selectedRows[0].CH_ContractLineItem__c.length; j++){
				CLIID.push(
				selectedRows[0].CH_ContractLineItem__c[j]
				);
			}
            //NOKIASC-25670
            var NEAID1 = selectedRows[0].CH_NetworkElementID__c;
            component.set("v.NEAID", NEAID1);
            var Addr = selectedRows[0].Address;
            component.set("v.Address", Addr);
            var selAst = component.get("v.selectedAssets");
            var selCli = component.get("v.selectedclis");
            component.set("v.showNEA", false);
            if (
                searchCrit == "Part Code" &&
                (selAst == null || selAst == undefined || selAst == "")
            ) {
                component.set("v.showNEA", true);                                
                var assets1 = [];
                if (assets != null) {
                    for (var i = 0; i < assets.length; i++) {
                        //assetRelatedCLIIDs.push(assets[i].HWS_ContractLineItem__c);
                        if (assets[i].CoveredNetworkElementCount == "0") {
                            CLIID.push(assets[i].HWS_ContractLineItem__c);
                        }
                        //assetMap[assets[i].HWS_ContractLineItem__c] = assets[i];
                    }
                }
                for (var i = 0; i < CLIID.length; i++) {
                     var result = assets.filter(item => item.HWS_ContractLineItem__c.indexOf(CLIID[i]) !== -1);
                    result.forEach(function(row) {
                        var rowDataIndex=assets1.map(function(e) { return e.Id; }).indexOf(row.Id);
                        if(rowDataIndex===-1){
                            assets1.push(row);
                        }
                    })
                }
                component.set("v.Assets", assets1);
                component.set("v.AllAssets", assets1);
            }
            if (
                searchCrit == "Contract Number" &&
                (selCli == null || selCli == undefined || selCli == "")
            ) {
                component.set("v.showNEA", true);                
                var clis1 = [];
                if (clis != null) {
                    for (var i = 0; i < clis.length; i++) {
                        //cliIdList.push(clis[i].Id);
                        if (clis[i].CoveredNetworkElementCount == "0") {
                            CLIID.push(clis[i].Id);
                        }
                        //cliMap[clis[i].Id] = clis[i];
                    }
                }
                for (var i = 0; i < CLIID.length; i++) {
                    var result = clis.filter(item => item.Id.indexOf(CLIID[i]) !== -1);
                    result.forEach(function(row) {
                        var rowDataIndex=clis1.map(function(e) { return e.Id; }).indexOf(row.Id);
                        if(rowDataIndex===-1){
                            clis1.push(row);
                            //assets1=assets1.concat(row);
                        }
                    })
                }
                component.set("v.clis", clis1);
            }
        }
        
    },
    //25689 To handle the save function from Dlivery Info screen in line Edit
    handleSave: function(component, event, helper) {
        var editedRecords = event.getParam("draftValues");
        var childCasesList = component.get("v.childCases");
        var reqVal = true;
        var countryTimezone = "GMT";
        var shipToTimeZone = component.get("v.shipToTimeZone");
        console.log("shipToTimeZoneeeeee" + shipToTimeZone);
        var shipToTimeZoneMap = component.get("v.shipToTimeZoneMap");
        if (editedRecords) {
            for (var i = 0; i < editedRecords.length; i++) {
                var rowNumber = editedRecords[i].Id;
                rowNumber = rowNumber.substring(4, rowNumber.length);
                var planedDate = childCasesList[rowNumber].HWS_Planned_Delivery_Date__c;
                var requestedDate =
                    editedRecords[i].HWS_Requested_Delivery_Date_Time__c;
                console.log(
                    "Planned date: " + planedDate + " Req Date: " + requestedDate
                );
                if (
                    new Date(planedDate) > new Date(requestedDate) &&
                    requestedDate != null
                ) {
                    reqVal = false;
                    childCasesList[rowNumber].Street_Address_3__c = "delInfoBorderCol";
                } else {
                    if (
                        editedRecords[i].HWS_Requested_Delivery_Date_Time__c != null &&
                        editedRecords[i].HWS_Requested_Delivery_Date_Time__c != undefined
                    ) {
                        childCasesList[rowNumber].Street_Address_3__c = null;
                        childCasesList[rowNumber].HWS_Requested_Delivery_Date_Time__c =
                            editedRecords[i].HWS_Requested_Delivery_Date_Time__c;
                        
                        if (shipToTimeZone == "Account") {
                            countryTimezone =
                                shipToTimeZoneMap[component.get("v.ShiptopartyAddress")];
                        }
                        if (shipToTimeZone == "BusinessHour") {
                            var bhId = childCasesList[rowNumber].Street_Address_2__c;
                            countryTimezone = shipToTimeZoneMap[bhId];
                            console.log(
                                "bhIdddd" + bhId + "  countryTimezoneeee" + countryTimezone
                            );
                        }
                        var countryTime = new Date(requestedDate).toLocaleString("en-US", {
                            timeZone: countryTimezone
                        });
                        countryTime = new Date(countryTime);
                        var counteryDateOnly = $A.localizationService.formatDate(
                            countryTime
                        );
                        counteryDateOnly = counteryDateOnly.replace(/[\/\\.-]/g, " ");
                        var counteryTimeOnly = $A.localizationService.formatTime(
                            countryTime
                        );
                        /*  var monthNames = [
                            "Jan", "Feb", "Mar",
                            "Apr", "May", "Jun", "Jul",
                            "Aug", "Sep", "Oct",
                            "Nov", "Dec"
                          ];*/
                        var hours = countryTime.getHours();
                        var minutes = countryTime.getMinutes();
                        var ampm = hours >= 12 ? "pm" : "am";
                        if (
                            counteryTimeOnly.includes("AM") ||
                            counteryTimeOnly.includes("PM")
                        ) {
                            ampm = hours >= 12 ? "PM" : "AM";
                        }
                        hours = hours % 12;
                        hours = hours ? hours : 12; // the hour '0' should be '12'
                        minutes = minutes < 10 ? "0" + minutes : minutes;
                        var strTime = hours + ":" + minutes + " " + ampm;
                        childCasesList[rowNumber].HWS_RequestedDateShipment__c =
                            counteryDateOnly + ", " + strTime + " (" + countryTimezone + ")";
                    } else {
                        childCasesList[
                            rowNumber
                        ].HWS_Requested_Delivery_Date_Time__c = null;
                        childCasesList[rowNumber].HWS_RequestedDateShipment__c = null;
                        childCasesList[rowNumber].Street_Address_3__c = "delInfoBGCol";
                    }
                }
            }
        }
        component.set("v.childCases", childCasesList);
        console.log("Final List" + JSON.stringify(component.get("v.childCases")));
        if (reqVal) {
            document.getElementById("validateRequiredFields").innerHTML = "";
            component.find("childTable").set("v.draftValues", null);
        } else {
            document.getElementById("validateRequiredFields").innerHTML =
                "Date and time cannot be less than Planned Delivery date";
        }
    },
    
    //25689 To handle the Cancel function from Dlivery Info screen in line Edit
    handleCancel: function(component, event, helper) {
        var childCasesList = component.get("v.childCases");
        if (childCasesList) {
            for (var i = 0; i < childCasesList.length; i++) {
                if (
                    childCasesList[i].HWS_Requested_Delivery_Date_Time__c != null &&
                    childCasesList[i].HWS_Requested_Delivery_Date_Time__c != undefined
                ) {
                    childCasesList[i].Street_Address_3__c = null;
                } else {
                    childCasesList[i].Street_Address_3__c = "delInfoBGCol";
                }
            }
        }
        document.getElementById("validateRequiredFields").innerHTML = "";
        component.set("v.childCases", childCasesList);
    },
    clearNetworkElementAsset: function(component, event, helper) {
        component.set("v.selectedNEA", null);
        component.set("v.netElemAssets", component.get("v.showAllNEA"));
        component.set("v.Assets", component.get("v.clearNEAAssets"));
        component.set("v.AllAssets", component.get("v.clearNEAAssets"));
        component.set("v.clis", component.get("v.clearNEACLIS"));
        component.set("v.ALLclis", component.get("v.clearNEACLIS"));        
        // NOKIASC-25661
        var selAsset = component.get("v.selectedAssets");
        if (
            selAsset != null &&
            selAsset != "" &&
            selAsset != undefined &&
            selAsset[0].CoveredNetworkElementCount != 0
        )
            component.set("v.enableSelectNEA", false);
    },
    
    // NOKIASC-25667  clearSelection button method start
    clearSelection: function(component, event, helper) {
        var stageNumber = component.get("v.StageNumber");
        if (stageNumber === 1) {
            component.find("inputFieldsToCheck").set("v.selectedRows", new Array());
            component.set("v.enableAccount", true);
            component.set("v.legalEntityNotFound", false);
        }
        if (stageNumber === 2) {
            var searchCriteria = component.get("v.searchCriteria");
            if (searchCriteria == "Part Code") {
                var cli = component.get("v.Assets");
                for (var i = 0; i < cli.length; i++) {
                    var neaCount =
                        cli[i].HWS_ContractLineItem__r.CH_QtyCoveredNetworkElementAssets__c;
                    if (neaCount > 0) {
                        component.set("v.enableSelectNEA", false);
                    }
                }
                var finalclisearch1 = component.get("v.finalclisearch");
                if(finalclisearch1 == 2){
                    component.find("cliTable").set("v.selectedRows", new Array());  
                }
                if(finalclisearch1 == 3){
                    var DTable = component.find("cliTable");
                    DTable[0].set("v.selectedRows", new Array()); 
                }
                component.set("v.selectedAssets", null);
                component.set("v.showVI", true);
                component.set("v.enableAsset", true);
            }
            
            //alert('INSIDE')
            if (searchCriteria == "Contract Number") {
                var cli = component.get("v.clis");
                for (var i = 0; i < cli.length; i++) {
                    var neaCount = cli[i].CH_QtyCoveredNetworkElementAssets__c;
                    if (neaCount > 0) {
                        component.set("v.enableSelectNEA", false);
                    }
                }
                var finalconsearch1 = component.get("v.finalconsearch");
                if(finalconsearch1 == 2){
                    component.find("conTable").set("v.selectedRows", new Array());
                }
                if(finalconsearch1 == 3){
                    var DTable = component.find("conTable");
                    DTable[0].set("v.selectedRows", new Array());    
                }
                component.set("v.selectedclis", null);
                component.set("v.showVI", true);
                component.set("v.enableContract", true);
            }
            component.set("v.enableAccount", false);
            // NOKIASC-25661
            component.set("v.selectedAssetstep2", false);
            component.set("v.selectedLineItemstep2", false);
            component.set("v.selectedNEA", null);
        }
        
        if (stageNumber === 6) {
            component.find("assetTable").set("v.selectedRows", new Array());
            component.set("v.selectedAssets", null);
            component.set("v.SelectConNum", false);
            component.set("v.enableAsset", true);
        }
        if (stageNumber === 3) {
            component.find("vItems").set("v.selectedRows", new Array());
            component.set("v.enableVi", true);
            component.set("v.selectedVersions", null);
            component.set("v.selectedVersionstep3", false);
        }
        if (stageNumber === 7) {
            component.find("neaTable").set("v.selectedRows", new Array());
            component.set("v.SelectNEA", false);
            component.set("v.selectedNEA" , []);
            component.set("v.enableNea", true);            
        }
    },
	 //NOKIASC-34660
    handleserialNumberUnknown: function(component, event, helper) {
        var isChecked= event.getSource().get('v.checked');  
        if(isChecked){
            component.set("v.newChildCase.HWS_Faulty_Serial_Number__c", 'UNKNOWN'); 
            component.set("v.isserialNumberUnknown", true);
            component.set("v.newChildCase.HWS_WarrantyStatus__c", 'Out of Warranty');
            var field = component.find('faultSerial');
            field.setCustomValidity('');
            field.reportValidity();
        }    
        else{
            component.set("v.newChildCase.HWS_Faulty_Serial_Number__c", ''); 
            component.set("v.isserialNumberUnknown", false);
        }        
    },
    // NOKIASC-25667  clearSelection button method end
    // Below Function implemented as part of NOKIASC-31177
    handleRequestHWRCAFMA: function(component, event, helper) {
        var isChecked= event.getSource().get('v.checked');
        if(!isChecked){
            component.set("v.newChildCase.HWS_RelatedSoftwareTicketNumber__c", '');
            component.set("v.newChildCase.HWS_Sponsor__c", '');
        }       
    },
    //NOKIASC-32950:NEA Performance issue -DataTable Infinite Loading
    handleLoadMoreNEA: function (component, event, helper) {
        event.getSource().set("v.isLoading", true);
        component.set('v.loadMoreStatus', 'Loading....');       
        let recordOffset = component.get("v.currentCount");
        let recordLimit = component.get("v.initialRows");
        if (component.get('v.netElemAssets').length == component.get("v.totalNumberOfRows")) {
            component.set('v.enableInfiniteLoading', false);
            component.set('v.loadMoreStatus', 'No more data to load');
        } else {       
            let currentData = component.get('v.netElemAssets');
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
        }, 3000);
        
    },
    showToolTip : function(component, event, helper) {
        component.set("v.showtooltip" , true);
        
    },
    hideToolTip : function(component, event, helper){
        component.set("v.showtooltip" , false);
    }
});