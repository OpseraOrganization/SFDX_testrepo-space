({
    init : function(component, event, helper) {
        
        //console.log("In init");
        //console.log("Opp Id : ");
        //console.log(component.get("v.recordId"));
        component.set("v.hasUserChanged", false);
        component.find("existingMaintenanceContract").set("v.value", "No");
        var action = component.get("c.getOpportunityFields");
        action.setParams({ opportunityId : component.get("v.recordId")});
        action.setCallback(this, function(response) {
			//component.set("v.showSpinner",false);
            var state = response.getState();
            if (state === "SUCCESS") {
                //console.log("[+] Inside 1st success");
                //Added by Christie jj for the license check for the  current user - ITCCPQ-504
                var opptyIds = response.getReturnValue();
                var endCustomerLegalEntity = opptyIds.End_Customer_LE__c;
                var currIso = opptyIds.CurrencyIsoCode;

                //Added by Christie JJ for ITCCPQ-2555(2638)
                //Start
                var accountId = opptyIds.AccountId;
                component.set("v.accountId",accountId);
                //End
                

                //console.log("opptyIds : ");
                //console.log(opptyIds.Id);
                //console.log("endCustomerLegalEntity : ");
                //console.log(endCustomerLegalEntity);
                //console.log("currIso : ");
                //console.log(endCustomerLegalEntity);
                var action2 = component.get("c.isUserLicensedForCPQPackage");
                action2.setParams({ userId : $A.get("$SObjectType.CurrentUser.Id")});
                action2.setCallback(this, function(response2) {
                    var state = response2.getState();
                    if (state === "SUCCESS") {
                        //console.log("[+] Inside 1st success");
                        var licenseCheck=response2.getReturnValue();
                        //console.log("[+] licenseCheck = ");
                        //console.log(licenseCheck);
                        
                        if(licenseCheck===true){
                            component.set("v.licenseCheck", true);
                            component.set("v.opportunityRecord",opptyIds);
                            component.set("v.endCustomerLegalEntity",endCustomerLegalEntity);
                            component.set("v.CurrencyIsoCode",currIso);

                            //Fetch and assosciate "Proposal" recordType for the Quote Record Edit Form
                            var action3 = component.get("c.getRecordType");
        
        action3.setCallback(this, function(response3) {
			//component.set("v.showSpinner",false);
            var state = response3.getState();
            var sampleEvent = $A.get("e.c:ToastEvent");
            //Set Parameter Value
            sampleEvent.setParams({"msg":"INIT"});
            //Fire Event
            sampleEvent.fire();
            //console.log("CUstom Event Fired");
            if (state === "SUCCESS") {
                
                //console.log("[+] Inside recordtype success :");
                //console.log(response3.getReturnValue());
                component.set("v.recordTypeId", response3.getReturnValue());
            }
            else if (state === "INCOMPLETE") {
                
                component.set("v.has_error",true);
                document.getElementsByClassName("servicemessage")[0].style.opacity = 0;
                document.getElementsByClassName("errormessageservice")[0].style.opacity = 1;
                component.set("v.error","There was an error while initializing this application. Please try again.");

                //Send Event to hide VF Spinner
                var sampleEvent_error = $A.get("e.c:ToastEvent");
                sampleEvent_error.setParams({"msg":"ERROR"});
                sampleEvent_error.fire();
            }
            else if (state === "ERROR") {
                var errors = response3.getError();
                if (errors) {
                    component.set("v.has_error",true);
                    document.getElementsByClassName("servicemessage")[0].style.opacity = 0;
                    document.getElementsByClassName("errormessageservice")[0].style.opacity = 1;
                    if (errors[0] && errors[0].message) {
                        //console.log("Error message: " + errors[0].message);
                        component.set("v.error",errors[0].message);
                    }
                } else {
                    //console.log("Unknown error");
                    component.set("v.error","There was an error while initializing this application. Please contact the Administrator.");
                }

                //Send Event to hide VF Spinner
                var sampleEvent_error = $A.get("e.c:ToastEvent");
                sampleEvent_error.setParams({"msg":"ERROR"});
                sampleEvent_error.fire();
            }
        });
		$A.enqueueAction(action3);
                        }
                        else if(licenseCheck===false){
                            component.set("v.licenseCheck", false);
                        }

                    }
                    else if (state === "INCOMPLETE") {
                        component.set("v.has_error",true);
                        document.getElementsByClassName("servicemessage")[0].style.opacity = 0;
                        document.getElementsByClassName("errormessageservice")[0].style.opacity = 1;
                        component.set("v.error","There was an error while initializing this application. Please try again.");

                        //Send Event to hide VF Spinner
                        var sampleEvent_error = $A.get("e.c:ToastEvent");
                        sampleEvent_error.setParams({"msg":"ERROR"});
                        sampleEvent_error.fire();
                    }
                    else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors) {
                            component.set("v.has_error",true);
                            document.getElementsByClassName("servicemessage")[0].style.opacity = 0;
                            document.getElementsByClassName("errormessageservice")[0].style.opacity = 1;
                            if (errors[0] && errors[0].message) {
                                //console.log("Error message: " + errors[0].message);
                                component.set("v.error",errors[0].message);
                            }
                        } else {
                            //console.log("Unknown error");
                            component.set("v.error","There was an error while initializing this application. Please contact the Administrator.");
                        }

                        //Send Event to hide VF Spinner
                        var sampleEvent_error = $A.get("e.c:ToastEvent");
                        sampleEvent_error.setParams({"msg":"ERROR"});
                        sampleEvent_error.fire();
                    }
                    //component.set("v.showSpinner",false);
                
                });
                $A.enqueueAction(action2);

                
                
                //var nameFieldValue = component.find("nameField").set("v.value", response.getReturnValue().Name);;
                //component.set("v.templateId","/servlet/servlet.FileDownload?file="+response.getReturnValue());
            }

            else if (state === "INCOMPLETE") {
                component.set("v.has_error",true);
                document.getElementsByClassName("servicemessage")[0].style.opacity = 0;
                document.getElementsByClassName("errormessageservice")[0].style.opacity = 1;
                component.set("v.error","There was an error while initializing this application. Please try again.");

                //Send Event to hide VF Spinner
                var sampleEvent_error = $A.get("e.c:ToastEvent");
                sampleEvent_error.setParams({"msg":"ERROR"});
                sampleEvent_error.fire();
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    component.set("v.has_error",true);
                    document.getElementsByClassName("servicemessage")[0].style.opacity = 0;
                    document.getElementsByClassName("errormessageservice")[0].style.opacity = 1;
                    if (errors[0] && errors[0].message) {
                        //console.log("Error message: " + errors[0].message);
                        component.set("v.error",errors[0].message);
                    }
                } else {
                    //console.log("Unknown error");
                    component.set("v.error","There was an error while initializing this application. Please contact the Administrator.");
                }

                //Send Event to hide VF Spinner
                var sampleEvent_error = $A.get("e.c:ToastEvent");
                sampleEvent_error.setParams({"msg":"ERROR"});
                sampleEvent_error.fire();
            }
            //component.set("v.showSpinner",false);
        });
		$A.enqueueAction(action);
    },
    onLoadHandler : function(component, event, helper) {
        //component.set("v.showSpinner",true);
        //console.log("In onload");
        //console.log("Opp Id : ");
        //console.log(component.get("v.recordId"));
        component.set("v.hasUserChanged", false);
        component.find("existingMaintenanceContract").set("v.value", "No");
        var action = component.get("c.getOpportunityFields");
        action.setParams({ opportunityId : component.get("v.recordId")});
        action.setCallback(this, function(response) {
			//component.set("v.showSpinner",false);
            var state = response.getState();
            if (state === "SUCCESS") {
                //console.log("[+] Inside 1st success");
                //Added by Christie jj for the license check for the  current user - ITCCPQ-504
                var opptyIds = response.getReturnValue();
                var endCustomerLegalEntity = opptyIds.End_Customer_LE__c;
                var currIso = opptyIds.CurrencyIsoCode;
                //console.log("opptyIds : ");
                //console.log(opptyIds.Id);
                //console.log("endCustomerLegalEntity : ");
                //console.log(endCustomerLegalEntity);
                //console.log("currIso : ");
                //console.log(endCustomerLegalEntity);
                var action2 = component.get("c.isUserLicensedForCPQPackage");
                action2.setParams({ userId : $A.get("$SObjectType.CurrentUser.Id")});
                action2.setCallback(this, function(response2) {
                    var state = response2.getState();
                    if (state === "SUCCESS") {
                        //console.log("[+] Inside 1st success");
                        var licenseCheck=response2.getReturnValue();
                        //console.log("[+] licenseCheck = ");
                        //console.log(licenseCheck);
                        if(licenseCheck===true){
                            component.set("v.licenseCheck", true);
                            component.set("v.opportunityRecord",opptyIds);
                            component.set("v.endCustomerLegalEntity",endCustomerLegalEntity);
                            component.set("v.CurrencyIsoCode",currIso);
                        }
                        else if(licenseCheck===false){
                            component.set("v.licenseCheck", false);
                        }

                    }
                    else if (state === "INCOMPLETE") {
                        component.set("v.has_error",true);
                        document.getElementsByClassName("servicemessage")[0].style.opacity = 0;
                        document.getElementsByClassName("errormessageservice")[0].style.opacity = 1;
                        component.set("v.error","There was an error while initializing this application. Please try again.");
                        
                        //Send Event to hide VF Spinner
                        var sampleEvent_error = $A.get("e.c:ToastEvent");
                        sampleEvent_error.setParams({"msg":"ERROR"});
                        sampleEvent_error.fire();
                    }
                    else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors) {
                            component.set("v.has_error",true);
                            document.getElementsByClassName("servicemessage")[0].style.opacity = 0;
                            document.getElementsByClassName("errormessageservice")[0].style.opacity = 1;
                            if (errors[0] && errors[0].message) {
                                //console.log("Error message: " + errors[0].message);
                                component.set("v.error",errors[0].message);
                            }
                        } else {
                            //console.log("Unknown error");
                            component.set("v.error","There was an error while initializing this application. Please contact the Administrator.");
                        }

                        //Send Event to hide VF Spinner
                        var sampleEvent_error = $A.get("e.c:ToastEvent");
                        sampleEvent_error.setParams({"msg":"ERROR"});
                        sampleEvent_error.fire();
                    }
                    //component.set("v.showSpinner",false);
                
                });
                $A.enqueueAction(action2);

                
                
                //var nameFieldValue = component.find("nameField").set("v.value", response.getReturnValue().Name);;
                //component.set("v.templateId","/servlet/servlet.FileDownload?file="+response.getReturnValue());
            }

            else if (state === "INCOMPLETE") {
                component.set("v.has_error",true);
                document.getElementsByClassName("servicemessage")[0].style.opacity = 0;
                document.getElementsByClassName("errormessageservice")[0].style.opacity = 1;
                component.set("v.error","There was an error while initializing this application. Please try again.");

                //Send Event to hide VF Spinner
                var sampleEvent_error = $A.get("e.c:ToastEvent");
                sampleEvent_error.setParams({"msg":"ERROR"});
                sampleEvent_error.fire();

                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    component.set("v.has_error",true);
                    document.getElementsByClassName("servicemessage")[0].style.opacity = 0;
                    document.getElementsByClassName("errormessageservice")[0].style.opacity = 1;
                    if (errors[0] && errors[0].message) {
                        //console.log("Error message: " + errors[0].message);
                        component.set("v.error",errors[0].message);
                    }
                } else {
                    //console.log("Unknown error");
                    component.set("v.error","There was an error while initializing this application. Please contact the Administrator.");
                }

                //Send Event to hide VF Spinner
                var sampleEvent_error = $A.get("e.c:ToastEvent");
                sampleEvent_error.setParams({"msg":"ERROR"});
                sampleEvent_error.fire();
            }
            //component.set("v.showSpinner",false);
        });
		$A.enqueueAction(action);
		
    },
        
    
    recordSubmit : function(component, event, helper) {
        var sampleEvent = $A.get("e.c:ToastEvent");
        //Set Parameter Value
        sampleEvent.setParams({"msg":"loader"});
        //Fire Event
        sampleEvent.fire();
        //console.log("CUstom Event Fired");
        
        // var nameFieldValid = component.find('nameField').reduce(function (validSoFar, inputCmp) {
        //     inputCmp.showHelpMessageIfInvalid();
        //     return validSoFar && !inputCmp.get('v.validity').valueMissing;
        // }, true);
        
        // var portfolioValid = component.find('portfolio').reduce(function (validSoFar, inputCmp) {
        //     inputCmp.showHelpMessageIfInvalid();
        //     return validSoFar && !inputCmp.get('v.validity').valueMissing;
        // }, true);
        
        // var warrantyCreditValid = component.find('warrantyCredit').reduce(function (validSoFar, inputCmp) {
        //     inputCmp.showHelpMessageIfInvalid();
        //     return validSoFar && !inputCmp.get('v.validity').valueMissing;
        // }, true); 
        // var contractStartDateValid = component.find('contractStartDate').reduce(function (validSoFar, inputCmp) {
        //     inputCmp.showHelpMessageIfInvalid();
        //     return validSoFar && !inputCmp.get('v.validity').valueMissing;
        // }, true);
        // //console.log(nameFieldValid);
        // //console.log(portfolioValid);
        // //console.log(warrantyCreditValid);
        /*event.preventDefault(); // stop form submission
        component.set("v.showModal",false);
        component.set("v.showSpinner",true);
        //console.log("v.opportunityRecord");
        //console.log(component.find("nameField").get("v.value"));
        //console.log(component.get("v.recordId"));
        var eventFields = event.getParam("fields");
        eventFields["Apttus_Proposal__Opportunity__c"] = component.get("v.recordId");
        eventFields["Apttus_Proposal__Account__c"] = component.get("v.opportunityRecord")["AccountId"];
        eventFields["Apttus_Proposal__Proposal_Name__c"] = component.find("nameField").get("v.value");
        //console.log("[+] Setting Opportunity Id on Quote");
        //console.log(component.get("v.recordId"));
        //console.log(eventFields["Apttus_Proposal__Opportunity__c"]);
        eventFields["NokiaCPQ_Portfolio__c"] = component.find("portfolio").get("v.value");
        eventFields["NokiaCPQ_Existing_IONMaint_Contract__c"] = component.find("existingMaintenanceContract").get("v.value");
        eventFields["Warranty_credit__c"] = component.find("warrantyCredit").get("v.value");

        eventFields["Apttus_Proposal__Description__c"] = component.find("description").get("v.value");
        eventFields["NokiaCPQ_LEO_Discount__c"] = component.find("isLeo").get("v.value");
        eventFields["NokiaCPQ_Is_Maintenance_Quote__c"] = component.find("isMaintenanceOnly").get("v.value");
        eventFields["NokiaCPQ_Contract_Start_Date__c"] = component.find("contractStartDate").get("v.value");
        if(component.get("v.has_success")===true && component.get("v.wasUpdated")===true){
            eventFields["systemVerifiedContract__c"] = false;
        }
        else if (component.get("v.has_success")===true){
            eventFields["systemVerifiedContract__c"] = true;
        }
        //eventFields["Apttus_Proposal__Primary__c"] = component.find("isPrimary").get("v.value");
        
        component.find('myform').submit(eventFields);*/
        component.set("v.has_error",false);
        document.getElementsByClassName("errormessageservice")[0].style.opacity = 0;
        component.set("v.display_success",false);
        document.getElementsByClassName("servicemessage")[0].style.opacity = 0;
        component.set("v.showSpinner",true);
        /*var sysVerifiedContract=false;
        if(component.get("v.has_success")===true && component.get("v.wasUpdated")===true){
            sysVerifiedContract = false;
        }
        else if (component.get("v.has_success")===true){
            sysVerifiedContract = true;
        }*/
        //console.log('[+] Date = ');
        //console.log(component.find("contractStartDate").get("v.value"));
        //console.log('hasExistingContract-->' + component.get("v.hasExistingContract"));
        //console.log('existingMaintenanceContract-->' + component.find("existingMaintenanceContract").get("v.value"));
        /*console.log({ Name : component.find("nameField").get("v.value"),
        OppId : component.get("v.recordId"),
        warrantyCredit : component.find("warrantyCredit").get("v.value"),
        contractDate : component.find("contractStartDate").get("v.value"),
        sysContract : component.get("v.hasExistingContract"),
        AccId : component.get("v.opportunityRecord")["AccountId"],
        Description : component.find("description").get("v.value"),
        isMaintenance : component.find("isMaintenanceOnly").get("v.value"),
        leo : component.find("isLeo").get("v.value"),
        Portfolio : component.find("portfolio").get("v.value"),
        quoteEMT :component.find("existingMaintenanceContract").get("v.value"),
        //quoteNYM : component.find("yearsMaintenance").get("v.value"),
        currencyCode : component.get("v.CurrencyIsoCode")
        //needsRepricing : component.get("v.needsReprice")
    });*/
        
        //eventFields["Apttus_Proposal__Primary__c"] = component.find("isPrimary").get("v.value");
		var action = component.get("c.createQuoteRecord");
        
        //Modified by Christie JJ for ITCCPQ-2555 for sending serialized quote record data to the controller class.
        //Seriliaze Data in Variable
        
        var finalSubPortfolios=null;
    

		//Added for ITCCPQ-2555 by Chrisitie JJ 
		//qp.CPQ_SubPortfolio__c = String.join(deserializedData.subportfolios,';');
        console.log("v.subPortfolios : ");
        console.log(component.get("v.subPortfolios"));
    

		if(!component.get("v.subPortfolios") || component.get("v.subPortfolios")===null){
            finalSubPortfolios = null;
            //if((component.get("v.subPortfolios").length!==1))
			//finalSubPortfolios = component.get("v.subPortfolios").join(';');
		}
        else if(component.get("v.subPortfolios")!==null){
		 if((component.get("v.subPortfolios").length===1)){
            if(component.get("v.subPortfolios")[0]!=component.find("portfolio").get("v.value")){
			finalSubPortfolios = component.get("v.subPortfolios").join(';');
            }
        else if((component.get("v.subPortfolios")[0]==component.find("portfolio").get("v.value"))){
            finalSubPortfolios = null;

		}}
    else if((component.get("v.subPortfolios").length>1)){
        finalSubPortfolios = component.get("v.subPortfolios").join(';');

    }}
        else{
            finalSubPortfolios = null;
        }
        console.log("finalSubPortfolios : ");
        console.log(finalSubPortfolios);

        var quoteData={
            "Name":component.find("nameField").get("v.value"),
            "OppId":component.get("v.recordId"),
            "warrantyCredit":component.find("warrantyCredit").get("v.value"),
            "contractDate":component.find("contractStartDate").get("v.value"),
            "sysContract":component.get("v.hasExistingContract"),
            "AccId":component.get("v.opportunityRecord")["AccountId"],
            "Description":component.find("description").get("v.value"),
            "isMaintenance":component.find("isMaintenanceOnly").get("v.value"),
            "leo":component.find("isLeo").get("v.value"),
            "Portfolio":component.find("portfolio").get("v.value"),
            "subportfolios":finalSubPortfolios,//component.get("v.subPortfolios"),
            "quoteEMT":component.find("existingMaintenanceContract").get("v.value"),
            "currencyCode":component.get("v.CurrencyIsoCode"),
         
        };
        
        action.setParams({serializedData :  JSON.stringify(quoteData)});

        /*action.setParams
        ({ Name : component.find("nameField").get("v.value"),
        OppId : component.get("v.recordId"),
        warrantyCredit : component.find("warrantyCredit").get("v.value"),
        contractDate : component.find("contractStartDate").get("v.value"),
        sysContract : component.get("v.hasExistingContract"),
        AccId : component.get("v.opportunityRecord")["AccountId"],
        Description : component.find("description").get("v.value"),
        isMaintenance : component.find("isMaintenanceOnly").get("v.value"),
        leo : component.find("isLeo").get("v.value"),
        Portfolio : component.find("portfolio").get("v.value"),
        
        //Added for ITCCPQ-2555, by Christie JJ
        subportfolios : component.get("v.subPortfolios"),

        quoteEMT :component.find("existingMaintenanceContract").get("v.value"),
        //quoteNYM : component.find("yearsMaintenance").get("v.value"),
        currencyCode : component.get("v.CurrencyIsoCode")
        //needsRepricing : component.get("v.needsReprice")
    });*/
        action.setCallback(this, function(response) {
			component.set("v.showSpinner",false);
            var state = response.getState();
            if (state === "SUCCESS") {
                //console.log('[+] Inside 1st Success - CreateQuoteRecord');
                //display Success Toast
                var quoteRecordId = response.getReturnValue().Id;
                var quoteNumber = response.getReturnValue().Name;
                var action = component.get("c.getOrgUrl");
                //console.log(quoteRecordId);
                //console.log(quoteNumber);
        action.setCallback(this, function(response) {
			//component.set("v.showSpinner",false);
            var state = response.getState();
            var orgUrl='';
            if (state === "SUCCESS") {
                component.set("v.showSpinner",false);
                //console.log('[+] Inside 2st Success - getOrgUrl');
                orgUrl=response.getReturnValue();

                //Add Success Code here
                //console.log('[+] Orgurl =');
        //console.log(orgUrl);
        /*var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Success',
            message: 'Quote Record Created Successfully',
            duration:' 6000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester',
            messageTemplate: 'Quote {0} created!',
            messageTemplateData: [ {
            url: orgUrl+'/'+quoteRecordId,
            label: quoteNumber,
            }
        ]
        });
        toastEvent.fire();
        //console.log("Success");*/

        ////console.log(event.getParam("id"));
        var sampleEvent = $A.get("e.c:ToastEvent");
        //Set Parameter Value
        sampleEvent.setParams({"msg":orgUrl+"|"+quoteRecordId+"|"+quoteNumber});
        //Fire Event
        sampleEvent.fire();
        //console.log("CUstom Event Fired");
        //$A.get("e.force:closeQuickAction").fire();
            }
            else if (state === "INCOMPLETE") {

                //Send Event to hide VF Spinner
                var sampleEvent_error = $A.get("e.c:ToastEvent");
                sampleEvent_error.setParams({"msg":"ERROR"});
                sampleEvent_error.fire();


                component.set("v.showSpinner",false);
                component.set("v.has_error",true);
                document.getElementsByClassName("servicemessage")[0].style.opacity = 0;
                document.getElementsByClassName("errormessageservice")[0].style.opacity = 1;
                component.set("v.error","There was an error while initializing this application. Please try again.");
            }
            else if (state === "ERROR") {
                
                component.set("v.showSpinner",false);
                var errors = response.getError();
                if (errors) {
                    component.set("v.has_error",true);
                    document.getElementsByClassName("servicemessage")[0].style.opacity = 0;
                    document.getElementsByClassName("errormessageservice")[0].style.opacity = 1;
                    if (errors[0] && errors[0].message) {
                        //console.log("Error message: " + errors[0].message);
                        component.set("v.error",errors[0].message);
                    }
                } else {
                    //console.log("Unknown error");
                    component.set("v.error","There was an error while initializing this application. Please contact the Administrator.");
                }


                //Send Event to hide VF Spinner
                var sampleEvent_error = $A.get("e.c:ToastEvent");
                sampleEvent_error.setParams({"msg":"ERROR"});
                sampleEvent_error.fire();
            }
        });
		$A.enqueueAction(action);
        
            }
            else if (state === "INCOMPLETE") {
                
                component.set("v.showSpinner",false);
                //console.log('[+] Inside  CreateQuoteRecord INCOMPLETE');
                component.set("v.has_error",true);
                document.getElementsByClassName("servicemessage")[0].style.opacity = 0;
                document.getElementsByClassName("errormessageservice")[0].style.opacity = 1;
                component.set("v.error","There was an error while initializing this application. Please try again.");

                //Send Event to hide VF Spinner
                var sampleEvent_error = $A.get("e.c:ToastEvent");
                sampleEvent_error.setParams({"msg":"ERROR"});
                sampleEvent_error.fire();
            }
            else if (state === "ERROR") {
                component.set("v.showSpinner",false);
                //console.log('[+] Inside  CreateQuoteRecord ERROR');
                var errors = response.getError();
                if (errors) {
                    component.set("v.has_error",true);
                    document.getElementsByClassName("servicemessage")[0].style.opacity = 0;
                    document.getElementsByClassName("errormessageservice")[0].style.opacity = 1;
                    if (errors[0] && errors[0].message) {
                        //console.log("Error message: " + errors[0].message);
                        component.set("v.error",errors[0].message);
                    }
                } else {
                    //console.log("Unknown error");
                    component.set("v.error","There was an error while initializing this application. Please contact the Administrator.");
                }


                //Send Event to hide VF Spinner
                var sampleEvent_error = $A.get("e.c:ToastEvent");
                sampleEvent_error.setParams({"msg":"ERROR"});
                sampleEvent_error.fire();
            }
        });
		$A.enqueueAction(action);
        
	},
    
    success : function(component, event, helper) {
        var params = event.getParams();
        var fields = params.response.fields;
        var orgUrl="";
        //console.log(params.response.id);
        
        //console.log(fields.NokiaCPQ_Proposal_Id__c.value);
        component.set("v.showSpinner",false);
        var action = component.get("c.getOrgUrl");
        
        action.setCallback(this, function(response) {
			//component.set("v.showSpinner",false);
            var state = response.getState();
            if (state === "SUCCESS") {
                
                getOrgUrl=response.getReturnValue();
            }
            else if (state === "INCOMPLETE") {
                component.set("v.has_error",true);
                document.getElementsByClassName("servicemessage")[0].style.opacity = 0;
                document.getElementsByClassName("errormessageservice")[0].style.opacity = 1;
                component.set("v.error","There was an error while initializing this application. Please try again.");
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    component.set("v.has_error",true);
                    document.getElementsByClassName("servicemessage")[0].style.opacity = 0;
                    document.getElementsByClassName("errormessageservice")[0].style.opacity = 1;
                    if (errors[0] && errors[0].message) {
                        //console.log("Error message: " + errors[0].message);
                        component.set("v.error","There was an error while initializing this application. Please contact the Administrator.");
                    }
                } else {
                    //console.log("Unknown error");
                    component.set("v.error","There was an error while initializing this application. Please contact the Administrator.");
                }
            }
        });
		$A.enqueueAction(action);
        //console.log('[+] Orgurl =');
        //console.log(orgUrl);
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Success',
            message: 'Quote Record Created Successfully',
            duration:' 6000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester',
            messageTemplate: 'Quote {0} Created Successfully',
            messageTemplateData: [ {
            url: orgUrl+'/'+params.response.id,
            label: fields.NokiaCPQ_Proposal_Id__c.value,
            }
        ]
        });
        toastEvent.fire();
        //console.log("Success");
        var sampleEvent = $A.get("e.c:ToastEvent");
        //Set Parameter Value
        sampleEvent.setParams({"msg":"Hello World!!"});
        //Fire Event
        sampleEvent.fire();
        //console.log("CUstom Event Fired");
        ////console.log(event.getParam("id"));
        //$A.get("e.force:closeQuickAction").fire();
        /*var navService = component.find("navService");
        var pageReference = {
        type: 'standard__recordPage',
        attributes: {
            "recordId": payload.id,
            "objectApiName": "Apttus_Proposal__Proposal__c",
            "actionName": "view"
        }
        }
        event.preventDefault();
        
        navService.navigate(pageReference);  */
	},

    cancel : function(component, event, helper) {
       
        //component.set("v.showSpinner",false);$A.get("e.force:closeQuickAction").fire();
        var sampleEvent = $A.get("e.c:ToastEvent");
        //Set Parameter Value
        sampleEvent.setParams({"msg":"CANCEL"});
        //Fire Event
        sampleEvent.fire();
        //console.log("CUstom Event Fired");
        
     },

    errorHandler : function(component, event, helper) {
        //console.log("[+] In errorHandler");
        component.set("v.showModal",true);
        component.set("v.showSpinner",false);
        if(event.getParams()!=null && event.getParam("message")!=null){
        var error = event.getParams();

        // Get the error message
        var errorMessage = event.getParam("message");
        component.set("v.has_error",true);
        document.getElementsByClassName("servicemessage")[0].style.opacity = 0;
        document.getElementsByClassName("errormessageservice")[0].style.opacity = 1;
        component.set("v.error",errorMessage);
     }
    else{
        component.set("v.has_error",true);
        document.getElementsByClassName("servicemessage")[0].style.opacity = 0;
        document.getElementsByClassName("errormessageservice")[0].style.opacity = 1;
        component.set("v.error","An error has occured. Please contact your system administrator.");
    }},

    fieldVisibility : function(component, event, helper) {
        //console.log('[+] Inside fieldVisibility');
        //console.log(component.find("isMaintenanceOnly").get("v.value"));
        if(component.find("isMaintenanceOnly").get("v.value")===true){
        component.set("v.fieldMap",false);
        }else if(component.find("isMaintenanceOnly").get("v.value")===false){
            component.set("v.fieldMap",true);
            var contractStartDate = component.find("contractStartDate").set("v.value","");
            var warrantyCredit = component.find("warrantyCredit").set("v.value","");
            }
        
    },

    fetchExistingContracts : function(component, event, helper) {
        //console.log('[+] In Fetch Contracts' + component.get("v.endCustomerLegalEntity") + '~' + component.find("portfolio").get("v.value"));
        component.set("v.showSpinner",true);
        component.set("v.has_error",false);
        document.getElementsByClassName("errormessageservice")[0].style.opacity = 0;
        component.set("v.display_success",false);
        document.getElementsByClassName("servicemessage")[0].style.opacity = 0;
        var existingMaintenanceContract = component.find("existingMaintenanceContract").set("v.value", "No");
        var sampleEvent = $A.get("e.c:ToastEvent");
        //Set Parameter Value
        sampleEvent.setParams({"msg":"loader"});
        //Fire Event
        sampleEvent.fire();
        //console.log("CUstom Event Fired");


        //Added by Christie JJ for ITCCPQ-2555(2638)
        //START

        //Fetch the related matching subportfolios from the Parent Account Object and the Portfolio Mapping Custom Metadata
        var action0 = component.get("c.getSubPortfolios");
        action0.setParams({ portfolio : component.find("portfolio").get("v.value"),accountId:component.get("v.accountId")});
        action0.setCallback(this, function(response0) {
            var state = response0.getState();

            if (state === "SUCCESS") {
                
                //console.log("[+] Inside recordtype success :");
                //console.log(response0.getReturnValue());

                //Assuming that we get a List<String> for response0 as the related subportfolios if they are accredited for, OR null if no accreditations exists.
                component.set("v.subPortfolios", response0.getReturnValue());
                console.log(response0.getReturnValue());
                // If subportfolios are empty, then don't process the checkExistingContracts method.
        if(!component.get("v.subPortfolios")){
            component.set("v.showSpinner",false);
            var sampleEvent = $A.get("e.c:ToastEvent");
            //Set Parameter Value
            sampleEvent.setParams({"msg":"INIT"});
            //Fire Events
            sampleEvent.fire();

        }
        //Else perform the existing Service Contract check on the a)accredited sub-portfolios, or b) the on the Quote portfolio.
        else{
        var action = component.get("c.checkExistingContracts");
        action.setParams({ legalEntityAccountId : component.get("v.endCustomerLegalEntity"),
        //portfolio : component.find("portfolio").get("v.value")});
        portfolio : component.get("v.subPortfolios")});
        action.setCallback(this, function(response) {
			component.set("v.showSpinner",false);
            var sampleEvent = $A.get("e.c:ToastEvent");
            //Set Parameter Value
            sampleEvent.setParams({"msg":"INIT"});
            //Fire Event
            sampleEvent.fire();
            //console.log("CUstom Event Fired");
            var state = response.getState();
            if (state === "SUCCESS") {
                //console.log("From server: " + response.getReturnValue());
                component.set("v.display_success",false);
                document.getElementsByClassName("servicemessage")[0].style.opacity = 0;
                component.set("v.has_error",false);
                document.getElementsByClassName("errormessageservice")[0].style.opacity = 0;
                if(response.getReturnValue()===true){
                    //component.set("v.has_success",true);
                    component.set("v.display_success",true);

                    //Added for scrollbar defect fix
                    //Start
                    document.getElementsByClassName("servicemessage")[0].style.opacity = 1;
                    //End
                    
                    //console.log('[+] Setting maintenancecontract to true');
                    component.set("v.hasUserChanged", false);
                    var existingMaintenanceContract = component.find("existingMaintenanceContract").set("v.value", "Yes");
                    component.set("v.hasExistingContract",true);
                    ////console.log('[+] after Setting maintenancecontract to true');
                    //var contractStartDate = component.find("contractStartDate").set("v.value","");
                    //var yearsOfMaintenance = component.find("yearsMaintenance").set("v.value","3");
                }
                // else set yearsOfMaintenance to 1
                else if(response.getReturnValue()===false){
                    
                    var existingMaintenanceContract = component.find("existingMaintenanceContract").set("v.value", "No");
                }
                
            }
            else if (state === "INCOMPLETE") {
                component.set("v.has_error",true);
                document.getElementsByClassName("servicemessage")[0].style.opacity = 0;
                document.getElementsByClassName("errormessageservice")[0].style.opacity = 1;
                component.set("v.error","There was an error while initializing this application. Please try again.");

                //Send Event to hide VF Spinner
                var sampleEvent_error = $A.get("e.c:ToastEvent");
                sampleEvent_error.setParams({"msg":"ERROR"});
                sampleEvent_error.fire();
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    component.set("v.has_error",true);
                    document.getElementsByClassName("servicemessage")[0].style.opacity = 0;
                    document.getElementsByClassName("errormessageservice")[0].style.opacity = 1;
                    if (errors[0] && errors[0].message) {
                        //console.log("Error message: " + errors[0].message);
                        component.set("v.error","There was an error while initializing this application. Please contact the Administrator.");
                    }
                } else {
                    //console.log("Unknown error");
                    component.set("v.error","There was an error while initializing this application. Please contact the Administrator.");
                }

                //Send Event to hide VF Spinner
                var sampleEvent_error = $A.get("e.c:ToastEvent");
                sampleEvent_error.setParams({"msg":"ERROR"});
                sampleEvent_error.fire();
            }
        });
		$A.enqueueAction(action);
    }
                

            }
            else if (state === "INCOMPLETE") {
                
                component.set("v.has_error",true);
                document.getElementsByClassName("servicemessage")[0].style.opacity = 0;
                document.getElementsByClassName("errormessageservice")[0].style.opacity = 1;
                component.set("v.error","There was an error while initializing this application. Please try again.");

                //Send Event to hide VF Spinner
                var sampleEvent_error = $A.get("e.c:ToastEvent");
                sampleEvent_error.setParams({"msg":"ERROR"});
                sampleEvent_error.fire();
            }
            else if (state === "ERROR") {
                var errors = response0.getError();
                if (errors) {
                    component.set("v.has_error",true);
                    document.getElementsByClassName("servicemessage")[0].style.opacity = 0;
                    document.getElementsByClassName("errormessageservice")[0].style.opacity = 1;
                    if (errors[0] && errors[0].message) {
                        //console.log("Error message: " + errors[0].message);
                        component.set("v.error",errors[0].message);
                    }
                } else {
                    //console.log("Unknown error");
                    component.set("v.error","There was an error while initializing this application. Please contact the Administrator.");
                }

                //Send Event to hide VF Spinner
                var sampleEvent_error = $A.get("e.c:ToastEvent");
                sampleEvent_error.setParams({"msg":"ERROR"});
                sampleEvent_error.fire();
            }
        });
        $A.enqueueAction(action0);
        
        
    //END
    },
    contractChange : function(component, event, helper) {
        //console.log('[+] Inside Contract Change');
        if(component.get("v.hasUserChanged")){
            component.set("v.hasExistingContract", false);
        }else{
            component.set("v.hasUserChanged", true);
        }

        /*if(component.get("v.counter")===1){
            component.set("v.counter",2);
            //console.log(component.get("v.counter"));
        }
        else{
            component.set("v.wasUpdated",true);
        }*/
        
     },
     render : function(component, event, helper) {
        //console.log('[+] Inside Render');
        component.set("v.showSpinner",false);
        
     }
})