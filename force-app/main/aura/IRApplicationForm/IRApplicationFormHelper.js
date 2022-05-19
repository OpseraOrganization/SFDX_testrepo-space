({
    //A Simple object to track Tabs on the Form and used during Tab Validation
    TABS: {
        "NOKIA PARTNER REGISTRATION": {
            Name: "NOKIA PARTNER REGISTRATION",
            Validity: "Invalid",
            NextTab: "COMPANY HEADQUARTERS",
            Priority:1
        },
        "COMPANY HEADQUARTERS": {
            Name: "COMPANY HEADQUARTERS",
            Validity: "Invalid",
            NextTab: "COMPANY PROFILE",
            Priority:2
        },
        "COMPANY PROFILE": {
            Name: "COMPANY PROFILE",
            Validity: "Invalid",
            NextTab: "AFFILIATES/SUBSIDIARY INFORMATION",
            Priority:3
        },
        "AFFILIATES/SUBSIDIARY INFORMATION": {
            Name: "AFFILIATES/SUBSIDIARY INFORMATION",
            Validity: "Invalid",
            NextTab: "BUSINESS CAPABILITIES",
            Priority:4
        },
        "BUSINESS CAPABILITIES": {
            Name: "BUSINESS CAPABILITIES",
            Validity: "Invalid",
            NextTab: "COMPLIANCE AND ETHICS",
            Priority:5
        },
        "COMPLIANCE AND ETHICS": {
            Name: "COMPLIANCE AND ETHICS",
            Validity: "Invalid",
            NextTab: "",
            Priority:6
        },
        CurTab: "NOKIA PARTNER REGISTRATION"
    },
    
    //Method to validate Country/Child case information has been filled or not
    isFormFilled: function(component, event, helper) {
        var valCnt = 0;
        var mapPushToList = [];
        var parentCase=component.get("v.parentCase");
        var childCasesMap = component.get("v.sectionLabels");
        var listCountries = component.get("v.conSelected");
        //Check if each country information & min number of files are uploaded or not
        for (var country of listCountries) {
            if (
                childCasesMap == null ||
                typeof childCasesMap[country] === "undefined" ||
                typeof childCasesMap[country].uploadFileId === "undefined" ||
                parentCase.Country__c!=country && childCasesMap[country].uploadFileId.length <= 1||
                parentCase.Country__c==country && childCasesMap[country].uploadFileId.length <1
            ) {
                mapPushToList.push({ value: false, key: country });
            } else {
                mapPushToList.push({ value: true, key: country });
            }
        }
        component.set("v.countryChecked", mapPushToList);
    },
    /*SFPRM Changes Start*/
    //Method to Validate each Tab on the Form
    validateTab: function(component, tabN, helper) {
        var isError = false;
        
        //Validate each Tab with thier own set of fields
        //Validation check for Tab "NOKIA PARTNER REGISTRATION"
        if (tabN == "NOKIA PARTNER REGISTRATION") {
            var cfname = component.find("cfname1");
            var clname = component.find("clname1");
            var cemail = component.find("cemail1");
            var ctitle = component.find("ctitle1");
            var coffice = component.find("coffice1");
            var cRetypeEmail = component.find("cRetypeEmail");
            
            var primaryfname = component.find("primaryfname");
            var primarylname = component.find("primarylname");
            var primarytitle = component.find("primarytitle");
            var primaryemail = component.find("primaryemail");
            var primaryoffice = component.find("primaryoffice");
            var primaryRetypeEmail = component.find("primaryRetypeEmail");
            
            var HFirstName = component.find("HFirstName");
            var HLastName = component.find("HLastName");
            var HTitle = component.find("HTitle");
            
            if (
                !cfname.get("v.validity").valid ||
                !clname.get("v.validity").valid ||
                !cemail.get("v.validity").valid ||
                !ctitle.get("v.validity").valid ||
                !coffice.get("v.validity").valid ||
                (!cRetypeEmail.get("v.validity").valid &&
                 !cRetypeEmail.get("v.validity").customError) ||
                !primaryfname.get("v.validity").valid ||
                !primarylname.get("v.validity").valid ||
                !primarytitle.get("v.validity").valid ||
                !primaryemail.get("v.validity").valid ||
                !primaryoffice.get("v.validity").valid ||
                (!primaryRetypeEmail.get("v.validity").valid &&
                 !primaryRetypeEmail.get("v.validity").customError) ||
                !HFirstName.get("v.validity").valid ||
                !HLastName.get("v.validity").valid ||
                !HTitle.get("v.validity").valid
            ) {
                cfname.reportValidity();
                clname.reportValidity();
                cemail.reportValidity();
                ctitle.reportValidity();
                coffice.reportValidity();
                HFirstName.reportValidity();
                HLastName.reportValidity();
                HTitle.reportValidity();
                cRetypeEmail.reportValidity();
                primaryfname.reportValidity();
                primarylname.reportValidity();
                primarytitle.reportValidity();
                primaryemail.reportValidity();
                primaryoffice.reportValidity();
                primaryRetypeEmail.reportValidity();
                
                isError = true;
            }
            //Check if Email and retype email fields both have same value or not
            if (cemail.get("v.value") !== cRetypeEmail.get("v.value")) {
                cRetypeEmail.setCustomValidity(
                    "Value does not match with Email field value"
                );
                cRetypeEmail.reportValidity();
                
                isError = true;
            }
            //Check if Email and retype email fields both have same value or not
            if (primaryemail.get("v.value") !== primaryRetypeEmail.get("v.value")) {
                primaryRetypeEmail.setCustomValidity(
                    "Value does not match with Email field value"
                );
                primaryRetypeEmail.reportValidity();
                
                isError = true;
            }
            //Clear if a custom error message was set previously for the above mentioned validation and if its valid now
            if (!isError) {
                if (cRetypeEmail.get("v.validity").customError) {
                    cRetypeEmail.setCustomValidity("");
                    cRetypeEmail.reportValidity();
                }
                if (primaryRetypeEmail.get("v.validity").customError) {
                    primaryRetypeEmail.setCustomValidity("");
                    primaryRetypeEmail.reportValidity();
                }
            }
        } 
        //Validation check for Tab "COMPANY HEADQUARTERS"
        else if (tabN == "COMPANY HEADQUARTERS") {
            var street1 = component.find("street1");
            var city = component.find("city");
            var postal = component.find("postal");
            var country = component.find("country");
            var state = component.find("statep");
            var phone = component.find("phone");
            var compweb = component.find("compweb");
            var emaild = component.find("emaild");
            
            if (
                !street1.get("v.validity").valid ||
                !city.get("v.validity").valid ||
                !postal.get("v.validity").valid ||
                !country.get("v.validity").valid ||
                !state.get("v.validity").valid ||
                !phone.get("v.validity").valid ||
                !compweb.get("v.validity").valid ||
                !emaild.get("v.validity").valid
            ) {
                street1.reportValidity();
                city.reportValidity();
                postal.reportValidity();
                country.reportValidity();
                state.reportValidity();
                phone.reportValidity();
                compweb.reportValidity();
                emaild.reportValidity();
                
                
                isError = true;
            } else {
                isError = false;
            }
        } 
        //Validation check for Tab "COMPANY PROFILE"
        else if (tabN === "COMPANY PROFILE") {
            var legalOrgName = component.find("legalOrgName");
            var companyType = component.find("companyType");
            var revenue = component.find("revenue");
            var SalesTerr = component.find("SalesTerr");
            var USGovResell = component.find("USGovResell");
            var PrimaryInterest = component.find("PrimaryInterest");
            var refand4G5GExp = component.find("refand4G5GExp");
            var radioFrequencyExp = component.find("radioFrequencyExp");
            var noOfEmployee = component.find("noOfEmployee");
            var radioNetworksInstallationExp = component.find("radioNetworksInstallationExp");
            var tiersSupportLevel = component.find("tiersSupportLevel");
            var ScopeOfPotentialNDACDepl = component.find("ScopeOfPotentialNDACDepl");
            
            if (
                !legalOrgName.get("v.validity").valid ||
                !companyType.get("v.validity").valid ||
                !revenue.get("v.validity").valid ||
                !SalesTerr.get("v.value") ||
                SalesTerr.get("v.value").length === 0 ||
                !USGovResell.get("v.validity").valid ||
                !PrimaryInterest.get("v.value") ||
                PrimaryInterest.get("v.value").length === 0 ||
                !noOfEmployee.get("v.validity").valid ||
                (refand4G5GExp && !refand4G5GExp.get("v.validity").valid) ||
                (radioFrequencyExp && !radioFrequencyExp.get("v.validity").valid) ||
                (radioNetworksInstallationExp && !radioNetworksInstallationExp.get("v.validity").valid) ||
                (tiersSupportLevel && !tiersSupportLevel.get("v.validity").valid) ||
                (ScopeOfPotentialNDACDepl && !ScopeOfPotentialNDACDepl.get("v.validity").valid)
            ) {
                legalOrgName.reportValidity();
                companyType.reportValidity();
                revenue.reportValidity();
                if(!PrimaryInterest.get("v.value") || PrimaryInterest.get("v.value").length === 0 ){
                    PrimaryInterest.setCustomValidity("An option must be selected");
                    PrimaryInterest.reportValidity();
                }
                if(!SalesTerr.get("v.value") || SalesTerr.get("v.value").length === 0 ){
                    SalesTerr.setCustomValidity("An option must be selected");
                    SalesTerr.reportValidity();
                }
                USGovResell.reportValidity();
                noOfEmployee.reportValidity();
                if (
                    tiersSupportLevel &&
                    radioNetworksInstallationExp &&
                    refand4G5GExp &&
                    radioFrequencyExp &&
                    ScopeOfPotentialNDACDepl
                ) {
                    refand4G5GExp.reportValidity();
                    radioFrequencyExp.reportValidity();
                    radioNetworksInstallationExp.reportValidity();
                    tiersSupportLevel.reportValidity();
                    ScopeOfPotentialNDACDepl.reportValidity();
                }
                isError = true;
            }
        } 
        //Validation check for Tab "AFFILIATES/SUBSIDIARY INFORMATION"
        else if (tabN === "AFFILIATES/SUBSIDIARY INFORMATION") {
            var countryChecked = component.get("v.countryChecked");
            countryChecked.forEach(function(item, index) {
                if (!item.value) isError = true;
            });
        } 
        //Validation check for Tab "BUSINESS CAPABILITIES"
        else if (tabN === "BUSINESS CAPABILITIES") {
            var busActivities = component.find("busActivities");
            var ExpRelation = component.find("ExpRelation");
            var AddnInfoNokia = component.find("AddnInfoNokia");
            console.log("log1");
            if (
                !busActivities.get("v.validity").valid ||
                !ExpRelation.get("v.validity").valid ||
                !AddnInfoNokia.get("v.validity").valid
            ) {
                busActivities.reportValidity();
                ExpRelation.reportValidity();
                AddnInfoNokia.reportValidity();
                isError = true;
            }
        } 
        //Validation check for Tab "COMPLIANCE AND ETHICS"
        else if (tabN === "COMPLIANCE AND ETHICS") {
            var BribeorCorrupt = component.find("BribeorCorrupt");
            var CodeofConduct = component.find("CodeofConduct");
            var CriminalInvest = component.find("CriminalInvest");
            var DetailedExpl = component.find("DetailedExpl");
            var AntiCorruption = component.find("AntiCorruption");
            var FormerNoki = component.find("FormerNoki");
            var LastTitle = component.find("LastTitle");
            var YearOfDep = component.find("YearOfDep");
            var DirectIndirectownership = component.find("DirectIndirectownership");
            var PlsDescribe = component.find("PlsDescribe");
            var AntiCorrFile = component.get("v.AntiCorrFile");
            var guideline = component.find("guideline");
            if (
                !BribeorCorrupt.get("v.validity").valid ||
                !CodeofConduct.get("v.validity").valid ||
                !CriminalInvest.get("v.validity").valid ||
                !DetailedExpl.get("v.validity").valid ||
                !AntiCorruption.get("v.validity").valid ||
                !FormerNoki.get("v.validity").valid ||
                !LastTitle.get("v.validity").valid ||
                !YearOfDep.get("v.validity").valid ||
                !DirectIndirectownership.get("v.validity").valid ||
                !PlsDescribe.get("v.validity").valid ||
                !guideline.get("v.validity").valid
            ) {
                BribeorCorrupt.reportValidity();
                CodeofConduct.reportValidity();
                CriminalInvest.reportValidity();
                DetailedExpl.reportValidity();
                AntiCorruption.reportValidity();
                FormerNoki.reportValidity();
                LastTitle.reportValidity();
                YearOfDep.reportValidity();
                DirectIndirectownership.reportValidity();
                PlsDescribe.reportValidity();
                guideline.reportValidity();
                isError = true;
            }
            
            //Check for either a file upload or File link has been entered in the field CH_Article_Attached__c if Anticorruption related question has been answered as "Yes"
            var uploadedAntiCorrFile = component.get("v.parentCase");
            if (
                AntiCorruption.get("v.value") === "Yes" &&
                !uploadedAntiCorrFile.CH_Article_Attached__c &&
                !guideline.get("v.value")
            ) {
                isError = true;
               helper.showToast(
                    "If you have answered Yes for 'Do you provide anti-corruption training to employees within your Company?' question, either Upload a file or fillout the field 'Guideline/Document URL' "
               );
            }
            //return isError;
        }
        
        return isError;
        //return false;
    },
    
    //Method to decide whether to let the user move to subsequent tabs or the one which user has selected based on the Tabs Validity
    validateTabFocus: function(component, event, helper) {
        var curTab = component.get("v.selTab");
        //Do the check only if clicked/selected tab is not same as current one
        if (this.TABS["CurTab"] !== curTab) {
            var prevTab = this.TABS["CurTab"];
            //Get the validity of Current / already selected tab
            var isTabValid = helper.validateTab(component, prevTab, helper) ? "Invalid": "Valid";
            this.TABS[prevTab].Validity = isTabValid;
            
            if (isTabValid === "Valid") {
                 /* If the selected Tab is either 
                 *  the Valid next tab which can be selected
                 *  OR 
                 *  the priority of the selected tab is less than the currently selected tab
                 */
                if (
                    curTab === this.TABS[prevTab].NextTab ||
                    this.TABS[prevTab].Priority > this.TABS[curTab].Priority
                    //this.TABS[curTab].Validity === "Valid"
                ) {
                    //Create a new Parent Case if moving from "NOKIA PARTNER REGISTRATION" to next for the first time
                    if (
                        component.get("v.createdCaseId") === "" &&
                        this.TABS[prevTab].Name === "NOKIA PARTNER REGISTRATION"
                    ) {
                        helper.createCase(
                            component,
                            helper,
                            component.get("v.parentCase"),
                            false
                        );
                    }
                    //Set the Tab icon to indicate its valid 
                    component.find(this.TABS[prevTab].Name).set("v.iconName", "action:approval");
                    this.TABS["CurTab"] = this.TABS[curTab].Name;
                }
                //Show toast message indicating, that movement from one tab to another is not allowed if its not the next tab
                else {  
                    helper.showToast(
                        "you are not allowed to switch to tab " +
                        this.TABS[curTab].Name +
                        " from tab " +
                        this.TABS[prevTab].Name+
                        "...please switch in sequence to next tab "+
                        this.TABS[prevTab].NextTab
                    );
                }
            }
            //Set the Icon on the Tab to indicate that Error exists and not allowed to move to another tab
            else {
                component.find(this.TABS[prevTab].Name).set("v.iconName", "action:close");
                
                if (
                    this.TABS[prevTab].Priority > this.TABS[curTab].Priority
                ) {
                    this.TABS["CurTab"] = this.TABS[curTab].Name;
                }
                
                //Custom Error message to be shown with unfilled country names if tried to move to next tab from "AFFILIATES/SUBSIDIARY INFORMATION"
                else {
                    var errMsg = "Please check the page for Errors";
                    if (
                        this.TABS[prevTab].Name === "AFFILIATES/SUBSIDIARY INFORMATION" &&
                        (this.TABS[curTab].Name === "BUSINESS CAPABILITIES" ||
                         this.TABS[curTab].Name === "COMPLIANCE AND ETHICS")
                    ) {
                        
                        errMsg =
                            "Please make sure you have filled the details and uploaded the file for following countries :";
                        var countriesNotFilled = component.get("v.countryChecked");
                        countriesNotFilled.forEach(function(item, index) {
                            if (!item.value) errMsg = errMsg + item.key + ", ";
                        });
                    }
                    helper.showToast(errMsg);
                }
            }
            
            //Set the Selected tab if everything is valid or remain on the same tab
            component.set("v.selTab", this.TABS["CurTab"]);
        }
    },

    //Method to display Toast Error Messages
    showToast: function(msg) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: "Error!",
            message: msg,
            duration: "5000",
            key: "info_alt",
            type: "error",
            mode: "pester"
        });
        toastEvent.fire();
    },

    //Method for Calling Apex Controller to Create Either Parent or Child(Country) Cases
    createCase: function(component, helper, case_to_create, isDraft) {
        var action = component.get("c.createCaseWithBasicInfo");
        action.setParams({
            caseObj: case_to_create
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (isDraft) {
                var WaitMsg = component.find("waitingCase");
                $A.util.addClass(WaitMsg, "Hide");
                $A.util.removeClass(WaitMsg, "Show");
            }
            if (state === "SUCCESS") {
                var respStr = response.getReturnValue().split(":");
                var caseId = respStr[0];
                
                //check if Parent Case with basic information was created successfully or not and set all the required attributes to show success message that form was created
                if (component.get("v.createdCaseId") === "") {
                    if (caseId !== "") {
                        component.set("v.createdCaseId", caseId);
                        var parentCase = component.get("v.parentCase");
                        if (respStr[1]) {
                            parentCase["CaseNumber"] = respStr[1];
                            component.set("v.parentCase", parentCase);
                            if (isDraft) {
                                component.set("v.caseNum", respStr[1]);
                                component.set("v.isSaveReturn", true); // shows after save message
                                var SrcTarget = component.find("successMessage");
                                $A.util.addClass(SrcTarget, "Show");
                                $A.util.removeClass(SrcTarget, "Hide");
                                component.set("v.showIRPage", true);
                                var formRef = component.find("FormDiv");
                                $A.util.removeClass(formRef, "slds-show");
                                $A.util.addClass(formRef, "slds-hide");
                            }
                        }
                    } else {
                        this.TABS["CurTab"] = "NOKIA PARTNER REGISTRATION";
                        component.set("v.selTab", "NOKIA PARTNER REGISTRATION");
                        helper.showToast("Something went wrong!");
                    }
                } 
                //Check to process when a child/Country Case is successfully created
                else {
                    case_to_create.Id = caseId;
                    case_to_create.CaseNumber = respStr[1];
                    var a = component.find("findableAuraId");
                    var childCaseMap = component.get("v.childCaseMap");
                    a.set("v.sectionLabels.Id", caseId);
                    childCaseMap[caseId] = case_to_create;
                    component.set("v.childCaseMap", childCaseMap);
                    var fieldsDiv = a.find("modal-content-id-1");
                    var fileDiv = a.find("modal-content-id-2");
                    $A.util.addClass(fieldsDiv, "slds-hide");
                    $A.util.removeClass(fileDiv, "slds-hide");
                    var CountryHQ = component.get("v.parentCase.Country__c");
                    if (a.get("v.label") === CountryHQ)
                        component.set("v.isDisabled", true);
                    a.set("v.isSaving", false);
                }
            } 
            //Handle when case creation is failed on the apex backend
            else {
                if (component.get("v.createdCaseID") === "") {
                    this.TABS["CurTab"] = "NOKIA PARTNER REGISTRATION";
                    component.set("v.selTab", "NOKIA PARTNER REGISTRATION");
                    helper.showToast("Error while Case Creation");
                } else {
                    component.find("findableAuraId").set("v.isSaving", false);
                    if (response.getError()) {
                        helper.showToast(
                            "Error while Case Creation, Error: " +
                            JSON.stringify(response.getError()[0])
                        );
                        console.log(
                            "Error while Case Creation, Error: " +
                            JSON.stringify(response.getError()[0])
                        );
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    //Method to fetch All the picklist Field Values used on the Form by inviking Apex Controller method
    getPickListValues: function(component) {
        var pickLstAction = component.get("c.getPickListValues");
        pickLstAction.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                /*Object that contains the Fields for which picklist values have to be fetched from backend
                 * Add any future fields for which picklist values are to be fetched
                 * api(Api name of the field) and attr(related attribute name as defined on the component) have to be added in the below fashion
                 */
                var pickValSet = [
                    { api: "Country__c", attr: "optCountry" },
                    { api: "Company_type_CP__c", attr: "optctype" },
                    { api: "Annual_revenues_CP__c", attr: "optAnnual" },
                    { api: "Total_Number_of_employees_CP__c", attr: "optnoofemp" },
                    { api: "Which_Sales_Territory_Country_Are_You__c",attr: "optSalesTerr"},
                    { api: "Primary_Interest_CP__c", attr: "optPrimaryInterest" },
                    { api: "PRM_Year_of_Departure__c", attr: "optDepartureYear" }
                ];
                var resVal = response.getReturnValue();
                pickValSet.forEach(function(item, index) {
                    var finalOptVals = [];
                    var currOptVals = resVal[item.api];
                    currOptVals.forEach(function(pickVal, index) {
                        finalOptVals.push({ label: pickVal, value: pickVal });
                    });
                    component.set("v." + item.attr, finalOptVals);
                });
                
                  
               var primaryInt = component.get("v.optPrimaryInterest");
                primaryInt.sort((first, second)=>{
                    if(first.label > second.label)
                    	return 1;
                    else if(first.label < second.label)
                    	return -1;
                    return 0;
                });
            } else {
                console.log(JSON.stringify(response.getError()) + "error");
            }
        });
        $A.enqueueAction(pickLstAction);
    },
    
    //Method to prepare Child Case object to be sent to Apex Method for creation.
    createChildCase: function(component, helper, childCaseVals, modal_cmp) {
        var parentCase = component.get("v.parentCase");
        if (!childCaseVals.state) childCaseVals.state = "";
        var childCase = {
            //All the values coming from Parent Case
            SObjectType: "Case",
            Primary_Interest_CP__c: parentCase.Primary_Interest_CP__c,
            List_Ref_and_4G_5G_Experience__c:
            parentCase.List_Ref_and_4G_5G_Experience__c,
            Radio_Networks_Installation_Experience__c:
            parentCase.Radio_Networks_Installation_Experience__c,
            Radio_Frequency_Expirience__c: parentCase.Radio_Frequency_Expirience__c,
            Tier1_Tier2_Support_Level__c: parentCase.Tier1_Tier2_Support_Level__c,
            PRM_NoandScopeOfPotentialNDACDeploy__c: parentCase.PRM_NoandScopeOfPotentialNDACDeploy__c,
            Full_Legal_Name_of_Your_Organization_CP__c:
            parentCase.Full_Legal_Name_of_Your_Organization_CP__c,
            PB_First_Name__c: parentCase.PB_First_Name__c,
            PB_Last_Name__c: parentCase.PB_Last_Name__c,
            PB_Email__c: parentCase.PB_Email__c,
            Which_Sales_Territory_are_You__c:
            parentCase.Which_Sales_Territory_are_You__c,
            //Individual Child Case field values
            Affiliates_Subsidiary_Name__c: childCaseVals.affil,
            Company_Registration_Number__c: childCaseVals.regno,
            Street_Address_1__c: childCaseVals.sa1,
            Street_Address_2__c: childCaseVals.sa2,
            Company_s_Website__c: childCaseVals.website,
            Street_Address_3__c: childCaseVals.sa3,
            Email_Domain__c: childCaseVals.domain,
            Phone_No__c: childCaseVals.phone,
            Country__c: modal_cmp.get("v.label"),
            State_Province_per_country__c: childCaseVals.state,
            City_per_country__c: childCaseVals.city,
            Postal_Code_per_country__c: childCaseVals.postal,
            First_Name_Sales__c: childCaseVals.salesfname,
            Last_Name_Sales__c: childCaseVals.saleslname,
            Email_Sales__c: childCaseVals.salesemail,
            Primary_Phone_Sales__c: childCaseVals.salesphone,
            Distributor_with_whom_transact_business__c: childCaseVals.distributor.join(
                ";"
            ),
            ParentId: component.get("v.createdCaseId"),
            Status: "Draft"
        };
        
        //If the child case is not created in the backend call the backend method to create the case
        if (!modal_cmp.get("v.sectionLabels.Id")) {
            modal_cmp.set("v.isSaving", true);
            helper.createCase(component, helper, childCase, false);
        } 
        //If Case is already created store all the updated information in a local variable until its sent to backend
        else {
            var childCaseMap = component.get("v.childCaseMap");
            var caseId = modal_cmp.get("v.sectionLabels.Id");
            var childCaseNum = childCaseMap[caseId].CaseNumber;
            childCaseMap[caseId] = childCase;
            childCaseMap[caseId].Id = caseId;
            childCaseMap[caseId].CaseNumber = childCaseNum;
            component.set("v.childCaseMap", childCaseMap);
            var myMap = {};
            if (component.get("v.conEntered").indexOf(childCase.Country__c) == -1) {
                component.get("v.conEntered").push(childCase.Country__c);
            }
            if (component.get("v.sectionLabels") != null) {
                myMap = component.get("v.sectionLabels");
            }
            myMap[childCase.Country__c] = modal_cmp.get("v.sectionLabels");
            component.set("v.sectionLabels", myMap);
            var fieldsDiv = modal_cmp.find("modal-content-id-1");
            var fileDiv = modal_cmp.find("modal-content-id-2");
            $A.util.addClass(fieldsDiv, "slds-hide");
            $A.util.removeClass(fileDiv, "slds-hide");
        }
    },
    
    //Method to initialize Parent Case Fields at New Form Load.
    initializeParentCase: function(component) {
        var parentCase = {
            First_Name__c: "",
            Last_Name__c: "",
            Title__c: "",
            Email__c: "",
            Office_Phone__c: "",
            PB_First_Name__c: "",
            PB_Last_Name__c: "",
            PB_Title__c: "",
            PB_Email__c: "",
            PB_Office_Phone__c: "",
            H_First_Name__c: "",
            H_Last_Name__c: "",
            PRM_H_Title__c: "",
            STREET_ADDRESS_1_CHQ__c: "",
            STREET_ADDRESS_2_CHQ__c: "",
            STREET_ADDRESS_3_CHQ__c: "",
            City__c: "",
            POSTAL_CODE_CHQ__c: "",
            Country__c: "",
            PHONE_NO_CHQ__c: "",
            State__c: "",
            Company_website_CHQ__c: "",
            EMAIL_DOMAINS_CHQ__c: "",
            Full_Legal_Name_of_Your_Organization_CP__c: "",
            VAT_Number__c: "",
            Dun_Bradstreet_D_U_N_S_Number_CP__c: "",
            Company_type_CP__c: "",
            Annual_revenues_CP__c: "",
            Total_Number_of_employees_CP__c: "",
            Which_Sales_Territory_are_You__c: "",
            Willing_to_resell_to_USA_Federal_CP__c: "",
            Primary_Interest_CP__c: "",
            List_Ref_and_4G_5G_Experience__c: "",
            Radio_Frequency_Expirience__c: "",
            Radio_Networks_Installation_Experience__c: "",
            Tier1_Tier2_Support_Level__c: "",
            PRM_NoandScopeOfPotentialNDACDeploy__c : "",
            Describe_your_current_business_activity__c: "",
            Describe_the_expereince_or_relationships__c: "",
            PRM_NIRAAdditionalInfo__c: "",
            Bribery_or_corruption__c: "",
            Code_of_Conduct_Compliance_program__c: "",
            Current_criminal_investigation_pending__c: "",
            Anti_corruption_training_to_employees__c: "",
            Provide_a_detailed_expelanation__c: "",
            Guideline_URL__c: "",
            PRM_Is_former_Nokia__c: "",
            PRM_Last_Title__c: "",
            PRM_Year_of_Departure__c: "",
            Direct_Indirect_ownership_in_Company__c: "",
            Describe__c: "",
            SObjectType: "Case",
            Status: "Draft"
        };
        component.set("v.parentCase", parentCase);
    },
    
    //Method to adjust Child Case Map to match the new added/removed country values in 'Which Sales Territory' Field
    adjustChildCasesMap: function(component, isFinalSubmit) {
        var childCaseMap = component.get("v.childCaseMap");
        var newChildCaseMap = {};
        if (childCaseMap) {
            var salesTerr = component.get(
                "v.parentCase.Which_Sales_Territory_are_You__c"
            );
            for (var key in childCaseMap) {
                //Add only those child country values which are selected in "Which_Sales_Territory_are_You__c" field
                if (salesTerr.includes(childCaseMap[key]["Country__c"])) {
                    if (isFinalSubmit) {
                        childCaseMap[key]["Status"] = "New";
                    }
                    //Assign the old values only if the country is still selected in "Which_Sales_Territory_are_You__c" field
                    newChildCaseMap[key] = childCaseMap[key];
                }
            }
        }
        return newChildCaseMap;
    },

    //Method to prepare the Form for Final Submit/Save, and to invoke Apex Controller method to do the Parent and Child cases Save. 
    saveForm: function(component, parentCase, childCaseMap) {
        var action = component.get("c.submitCaseDetails");
        var WaitMsg = component.find("waitingCase");
        
        //Convert both Primary_Interest_CP__c and Which_Sales_Territory_are_You__c fields from Array to string with ; seperated values so that apex can store them as mutli select picklist
        if (
            typeof parentCase["Primary_Interest_CP__c"] === "object" &&
            typeof parentCase["Which_Sales_Territory_are_You__c"] === "object"
        ) {
            parentCase["Primary_Interest_CP__c"] = parentCase["Primary_Interest_CP__c"].join(";");
            parentCase["Which_Sales_Territory_are_You__c"] = parentCase["Which_Sales_Territory_are_You__c"].join(";");
        }
        
        //Clear the 4 fields if value "Nokia Digital Automation Cloud (NDAC)" is not selected 
        if (
            !parentCase["Primary_Interest_CP__c"].includes(
                "Nokia Digital Automation Cloud (NDAC)"
            )
        ) {
            parentCase["List_Ref_and_4G_5G_Experience__c"] = "";
            parentCase["Radio_Frequency_Expirience__c"] = "";
            parentCase["Radio_Networks_Installation_Experience__c"] = "";
            parentCase["Tier1_Tier2_Support_Level__c"] = "";
            parentCase["PRM_NoandScopeOfPotentialNDACDeploy__c"] = "";
        }
        action.setParams({
            parentCase: parentCase,
            childCaseMap: childCaseMap
        });
        
        action.setCallback(this, function(response) {
            $A.util.addClass(WaitMsg, "Hide");
            $A.util.removeClass(WaitMsg, "Show");
            var state = response.getState();
            //Show success message that form is created if the Case saved successfully
            if (state === "SUCCESS") {
                component.set("v.isSaveReturn", false); // shows after save message
                var SrcTarget = component.find("successMessage");
                $A.util.addClass(SrcTarget, "Show");
                $A.util.removeClass(SrcTarget, "Hide");
                component.set("v.showIRPage", true);
                var formRef = component.find("FormDiv");
                $A.util.removeClass(formRef, "slds-show");
                $A.util.addClass(formRef, "slds-hide");
                component.set("v.caseNum", response.getReturnValue());
            } else {
                alert("Error");
            }
        });
        //Show the spinner until the Server method finishes and callback is invoked
        $A.util.addClass(WaitMsg, "Show");
        $A.util.removeClass(WaitMsg, "Hide");
        $A.enqueueAction(action);
    },

    //Method to prepare Form for Partial Save(Save and Return) and to invoke Apex Controller method to the partial Save of parent/Child Cases.
    saveDraftCase: function(component, helper) {
        var parentCase = component.get("v.parentCase");
        parentCase["Status"] = "Draft";
        var parentId = component.get("v.createdCaseId");
        var isSuccess = false;
        var WaitMsg = component.find("waitingCase");
        
        var cfname1 = component.find("cfname1");
        var clname1 = component.find("clname1");
        var ctitle1 = component.find("ctitle1");
        var cemail1 = component.find("cemail1");
        var coffice1 = component.find("coffice1");
        var cRetypeEmail = component.find("cRetypeEmail");
        var isValid = true;
        
        //Validate atleast first 5 fields of the form are filled before saving the case as Draft
        if (
            !cfname1.get("v.validity").valid ||
            !clname1.get("v.validity").valid ||
            !ctitle1.get("v.validity").valid ||
            !cemail1.get("v.validity").valid ||
            !coffice1.get("v.validity").valid ||
            (!cRetypeEmail.get("v.validity").valid &&
             cemail1.get("v.value") !== cRetypeEmail.get("v.value"))
        ) {
            cfname1.reportValidity();
            clname1.reportValidity();
            ctitle1.reportValidity();
            cemail1.reportValidity();
            coffice1.reportValidity();
            cRetypeEmail.reportValidity();
            helper.showToast("Please check the page for Errors");
            isValid = false;
        }
        if (cemail1.get("v.value") !== cRetypeEmail.get("v.value")) {
            cRetypeEmail.setCustomValidity(
                "Email is not matching with above email field value"
            );
            cRetypeEmail.reportValidity();
            isValid = false;
        }
        if (cemail1.get("v.value") === cRetypeEmail.get("v.value")) {
            cRetypeEmail.setCustomValidity("");
            cRetypeEmail.reportValidity();
        }
        
        if (!isValid) {
            return;
        }
        //Show spinner until the backend method is finished
        $A.util.addClass(WaitMsg, "Show");
        $A.util.removeClass(WaitMsg, "Hide");
        //If the case is already saved then execute saveandreturn method from backend
        if (parentId) {
             //Convert both Primary_Interest_CP__c and Which_Sales_Territory_are_You__c fields from Array to string with ; seperated values so that apex can store them as mutli select picklist
            if (
                typeof parentCase["Primary_Interest_CP__c"] === "object" &&
                typeof parentCase["Which_Sales_Territory_are_You__c"] === "object"
            ) {
                parentCase["Primary_Interest_CP__c"] = parentCase["Primary_Interest_CP__c"].join(";");
                parentCase["Which_Sales_Territory_are_You__c"] = parentCase["Which_Sales_Territory_are_You__c"].join(";");
            }
            
            parentCase["Id"] = component.get("v.createdCaseId");
            var action = component.get("c.saveAndReturn");
            
            //Adjust the Child map to be sent to backend based on the Salesterritory field value selected
            var childCaseMap = helper.adjustChildCasesMap(component, false);
            if (
                !parentCase["Primary_Interest_CP__c"].includes(
                    "Nokia Digital Automation Cloud (NDAC)"
                )
            ) {
                parentCase["List_Ref_and_4G_5G_Experience__c"] = "";
                parentCase["Radio_Frequency_Expirience__c"] = "";
                parentCase["Radio_Networks_Installation_Experience__c"] = "";
                parentCase["Tier1_Tier2_Support_Level__c"] = "";
                parentCase["PRM_NoandScopeOfPotentialNDACDeploy__c"] = "";
            }
            
            action.setParams({
                parentCase: parentCase,
                childCaseMap: childCaseMap
            });
            action.setCallback(this, function(res) {
                $A.util.addClass(WaitMsg, "Hide");
                $A.util.removeClass(WaitMsg, "Show");
                var state = res.getState();
                if (state === "SUCCESS") {
                    var resStr = res.getReturnValue().split(":");
                    component.set("v.isSaveReturn", true); // shows after save message
                    var SrcTarget = component.find("successMessage");
                    $A.util.addClass(SrcTarget, "Show");
                    $A.util.removeClass(SrcTarget, "Hide");
                    component.set("v.showIRPage", true);
                    var formRef = component.find("FormDiv");
                    $A.util.removeClass(formRef, "slds-show");
                    $A.util.addClass(formRef, "slds-hide");
                    
                    component.set("v.caseNum", resStr[1]);
                    
                    if (resStr) isSucess = true;
                } else {
                    console.log("ERROR on Save and return");
                }
            });
            
            $A.enqueueAction(action);
        } 
        //If the Save and return is clicked from first tab then call the create case method from backend as its not yet created
        else {
            helper.createCase(component, helper, parentCase, true);
        }
    },
    
    //Method to Retrieve Partially Saved Form details(Parent/Child case information)
    retrDraftCaseDetails: function(component, helper, tickNum) {
        var action = component.get("c.caseFromCaseNo");
        action.setParams({
            loginCaseNumber: tickNum.get("v.value")
        });
        
        action.setCallback(this, function(res) {
            var state = res.getState();
            if (state === "SUCCESS") {
                var resObj = res.getReturnValue();
                if(resObj.isErrorExist){
                    helper.showToast("Please enter a Valid Application Number");
                }
                else{
                    
                var parentCase = component.get("v.parentCase");
                for (var key in resObj.CaseObj) {
                    var parentVal = resObj.CaseObj[key];
                    
                    //Convert both field values from ; seperated string into array so that it can be assigned to dual list component on UI
                    if (
                        key === "Which_Sales_Territory_are_You__c" ||
                        key === "Primary_Interest_CP__c"
                    ) {
                        parentVal = resObj.CaseObj[key].split(";");
                        //Show 4 dependent fields if the value "Nokia Digital Automation Cloud (NDAC)" is selected
                        if (
                            key === "Primary_Interest_CP__c" &&
                            parentVal &&
                            parentVal.includes("Nokia Digital Automation Cloud (NDAC)")
                        )
                            component.set("v.ShowPrimaryIntDependFields", true);
                    } 
                    //Set the values in Retype email fields
                    else if (key === "Email__c") {
                        console.log(typeof parentVal);
                        console.log(parentVal);
                        component.set("v.cRetypeEmailAttr", parentVal);
                    } 
                    //Set the values in Retype email fields
                    else if (key === "PB_Email__c") {
                        console.log(typeof parentVal);
                        console.log(parentVal);
                        component.set("v.primaryRetypeEmailAttr", parentVal);
                    }
                    
                    parentCase[key] = parentVal;
                }
                component.set("v.parentCase", parentCase);
                
                component.set("v.createdCaseId", resObj.CaseObj["Id"]);
                
                //Assign Countries selected as Sales territories to the local variable
                component.set(
                    "v.conSelected",
                    parentCase["Which_Sales_Territory_are_You__c"]
                );
                
                //Set the attribute to track whether to show prompt related to if HQ Country and one of the Sales territory country is same
                if(parentCase["Which_Sales_Territory_are_You__c"] && parentCase["Which_Sales_Territory_are_You__c"].includes(parentCase['Country__c']))
                    component.set("v.showPrompt", false);
                //Set the Distibutor Values and related files count on the child case/Country
                var newTempMap = {};
                for (var key in resObj.CaseMap) {
                    resObj.CaseMap[key].distributor = resObj.CaseMap[
                        key
                    ].distributor.split(";");
                    if (resObj.CaseMap[key].uploadFileIds)
                        resObj.CaseMap[key].uploadFileId = JSON.parse(
                            resObj.CaseMap[key].uploadFileIds
                        );
                    else resObj.CaseMap[key].uploadFileId = [];
                    
                    component.get("v.conEntered").push(key);
                    //Disable Country__c if HQ Country/Child case is already saved
                    if (key === parentCase["Country__c"])
                        component.set("v.isDisabled", true);
                    if (resObj.CaseMap[key].fileNames)
                        resObj.CaseMap[key].fileNames = JSON.parse(
                            resObj.CaseMap[key].fileNames
                        );
                    else
                        resObj.CaseMap[key].fileNames = [];
                }
                //Initialize Child cases with the values retrieved
                helper.setChildCaseMap(
                    component,
                    resObj.CaseMap,
                    component.get("v.parentCase")
                );
                
                component.set("v.sectionLabels", resObj.CaseMap);
                helper.isFormFilled(component, null, helper);
                component.set("v.showIRPage", true);
                var formRef = component.find("FormDiv");
                $A.util.removeClass(formRef, "slds-hide");
                $A.util.addClass(formRef, "slds-show");
                
                //Validate the Tabs and based on that set the Tab which is invalid or if all the tabs are valid set it to Last tab
                helper.helperValidate(component, helper);
                }
                
            } else {
                Console.log("Error while retrieving the Case");
            }
        });
        $A.enqueueAction(action);
    },

    //Method for validation when Form Details are retrieved as to identify which Tab to selected once Form loads.
    helperValidate: function(cmp, hlp) {
        var parentCase = cmp.get("v.parentCase");
        
        /* A Object which maps Tabs to thier respective fields
         * Make sure the Order of the Tabs in this object is as shown on the UI is maintained here as the same order is used to Validate the Tabs
        */
        var mapFields = {
            "NOKIA PARTNER REGISTRATION": [
                "First_Name__c",
                "Last_Name__c",
                "Title__c",
                "Email__c",
                "Office_Phone__c",
                "PB_First_Name__c",
                "PB_Last_Name__c",
                "PB_Title__c",
                "PB_Email__c",
                "PB_Office_Phone__c",
                "H_First_Name__c",
                "H_Last_Name__c",
                "PRM_H_Title__c"
            ],
            "COMPANY HEADQUARTERS": [
                "STREET_ADDRESS_1_CHQ__c",
                "City__c",
                "POSTAL_CODE_CHQ__c",
                "Country__c",
                "PHONE_NO_CHQ__c",
                "Company_website_CHQ__c",
                "EMAIL_DOMAINS_CHQ__c"
            ],
            "COMPANY PROFILE": [
                "Full_Legal_Name_of_Your_Organization_CP__c",
                "Company_type_CP__c",
                "Annual_revenues_CP__c",
                "Total_Number_of_employees_CP__c",
                "Which_Sales_Territory_are_You__c",
                "Willing_to_resell_to_USA_Federal_CP__c",
                "Primary_Interest_CP__c"
            ],
            
            "AFFILIATES/SUBSIDIARY INFORMATION": [],
            
            "BUSINESS CAPABILITIES": [
                "Describe_your_current_business_activity__c",
                "Describe_the_expereince_or_relationships__c",
                "PRM_NIRAAdditionalInfo__c"
            ],
            
            "COMPLIANCE AND ETHICS": [
                "Bribery_or_corruption__c",
                "Code_of_Conduct_Compliance_program__c",
                "Current_criminal_investigation_pending__c",
                "Anti_corruption_training_to_employees__c",
                "PRM_Is_former_Nokia__c",
                "Direct_Indirect_ownership_in_Company__c"
            ]
        };
        
        var setTab = "";
        for (var tab in this.TABS) {
            //Validate if each Country information is valid based on the countryChecked
            if (tab === "AFFILIATES/SUBSIDIARY INFORMATION") {
                cmp.get("v.countryChecked").forEach(function(item, index) {
                    if (!item.value) {
                        setTab = tab;
                        return;
                    }
                });
            } 
            
            else if (tab === "COMPLIANCE AND ETHICS") {
                //First validate all the fields on the tab
                mapFields[tab].forEach(function(item, index) {
                    console.log(parentCase[item]);
                    if (parentCase[item] === "") {
                        setTab = tab;
                        return;
                    }
                });
                
                //If all the fields are valid then validate description fields tied with each question on the Tab
                if (setTab === "") {
                    //If either of the question is answered as Yes the related description must not be blank
                    if (
                        (parentCase["Bribery_or_corruption__c"] === "Yes" ||
                         parentCase["Current_criminal_investigation_pending__c"] ===
                         "Yes") &&
                        parentCase["Provide_a_detailed_expelanation__c"] === ""
                    ) {
                        setTab = tab;
                    } 
                    //If the question is answered as Yes the related description must not be blank
                    else if (
                        parentCase["PRM_Is_former_Nokia__c"] === "Yes" &&
                        (parentCase["PRM_Last_Title__c"] === "" ||
                         parentCase["PRM_Year_of_Departure__c"] === "")
                    ) {
                        setTab = tab;
                    } 
                    //If the question is answered as Yes the related description must not be blank    
                    else if (
                        parentCase["Direct_Indirect_ownership_in_Company__c"] === "Yes" &&
                        parentCase["Describe__c"] === ""
                    ) {
                        setTab = tab;
                    } 
                    //If the question is answered as Yes the related file must be attched or Guideline_URL__c must be filled
                    else if (
                        parentCase["Anti_corruption_training_to_employees__c"] === "Yes" &&
                        !parentCase["CH_Article_Attached__c"] &&
                        parentCase["Guideline_URL__c"] === ""
                    ) {
                        setTab = tab;
                    }
                }
            }
            
            //Validate for all the Tab's related fields
            else {
                mapFields[tab].forEach(function(item, index) {
                    if (parentCase[item] === "") {
                        setTab = tab;
                        return;
                    } else if (
                        tab === "COMPANY PROFILE" &&
                        item === "Primary_Interest_CP__c" &&
                        parentCase[item].includes("Nokia Digital Automation Cloud (NDAC)")
                    ) {
                        if (
                            !parentCase["List_Ref_and_4G_5G_Experience__c"] ||
                            !parentCase["Radio_Frequency_Expirience__c"] ||
                            !parentCase["Radio_Networks_Installation_Experience__c"] ||
                            !parentCase["Tier1_Tier2_Support_Level__c"] ||
                            !parentCase["PRM_NoandScopeOfPotentialNDACDeploy__c"]
                        ) {
                            setTab = tab;
                            return;
                        }
                    }
                });
            }
            
            //If the Tab is invalid then Break out of the loop
            if (setTab !== "") break;
            
            //Set the Approval icon to indicate the Tab is Valid
            cmp.find(tab).set("v.iconName", "action:approval");
            this.TABS[tab].Validity = "Valid";
            this.TABS["CurTab"] = tab;
            cmp.set("v.selTab", tab);
        }
        
        //If a tab is invalid the set that tab as selected tab and icon to indicate that it is invalid
        if (setTab !== "") {
            this.TABS["CurTab"] = setTab;
            cmp.set("v.selTab", setTab);
            cmp.find(setTab).set("v.iconName", "action:close");
        }
    },

    //Method to Initialize All the Child Cases(Countries) on Form Retrieval
    setChildCaseMap: function(component, childCaseMaps, parentCase) {
        var newChildCaseMap = {};
        for (var key in childCaseMaps) {
            var childCaseVals = childCaseMaps[key];
            var childCase = {
                //All the values coming from Parent Case
                SObjectType: "Case",
                Primary_Interest_CP__c: parentCase.Primary_Interest_CP__c,
                List_Ref_and_4G_5G_Experience__c:
                parentCase.List_Ref_and_4G_5G_Experience__c,
                Radio_Networks_Installation_Experience__c:
                parentCase.Radio_Networks_Installation_Experience__c,
                Radio_Frequency_Expirience__c: parentCase.Radio_Frequency_Expirience__c,
                Tier1_Tier2_Support_Level__c: parentCase.Tier1_Tier2_Support_Level__c,
                Full_Legal_Name_of_Your_Organization_CP__c:
                parentCase.Full_Legal_Name_of_Your_Organization_CP__c,
                PB_First_Name__c: parentCase.PB_First_Name__c,
                PB_Last_Name__c: parentCase.PB_Last_Name__c,
                PB_Email__c: parentCase.PB_Email__c,
                Which_Sales_Territory_are_You__c:
                parentCase.Which_Sales_Territory_are_You__c,
                
                //Individual Child Case field values
                Affiliates_Subsidiary_Name__c: childCaseVals.affil,
                Company_Registration_Number__c: childCaseVals.regno,
                Street_Address_1__c: childCaseVals.sa1,
                Street_Address_2__c: childCaseVals.sa2,
                Company_s_Website__c: childCaseVals.website,
                Street_Address_3__c: childCaseVals.sa3,
                Email_Domain__c: childCaseVals.domain,
                Phone_No__c: childCaseVals.phone,
                Country__c: key,
                State_Province_per_country__c: childCaseVals.state,
                City_per_country__c: childCaseVals.city,
                Postal_Code_per_country__c: childCaseVals.postal,
                First_Name_Sales__c: childCaseVals.salesfname,
                Last_Name_Sales__c: childCaseVals.saleslname,
                Email_Sales__c: childCaseVals.salesemail,
                Primary_Phone_Sales__c: childCaseVals.salesphone,
                Distributor_with_whom_transact_business__c: childCaseVals.distributor
                ? childCaseVals.distributor.join(";")
                : childCaseVals.distributor,
                ParentId: parentCase.Id,
                Status: "Draft",
                Id: childCaseVals.Id
            };
            newChildCaseMap[childCaseVals.Id] = childCase;
        }
        component.set("v.childCaseMap", newChildCaseMap);
    },
    
    //Method to Check if Metadata Value is set to display a Custom Maintenance Message instead of the Form.
    checkForMaintenance: function(component) {
        var action = component.get("c.getMaintenanceStatus");
        action.setCallback(this, function(resp) {
            var state = resp.getState();
            if (state === "SUCCESS") {
                var retVal = resp.getReturnValue();
                //Set the maintainance page
                if (retVal !== "false") {
                    component.set("v.MaintainanceMsg", retVal);
                } 
                //Set the Form Page
                else {
                    component.set("v.showIRPage", false);
                }
            } else {
                console.log("Error");
            }
        });
        $A.enqueueAction(action);
    },
    
    immediateFieldValidation : function(cmp, hlp, fieldName){
        var mapFields = {
            "Bribery_or_corruption__c":"COMPLIANCE AND ETHICS",
            "Code_of_Conduct_Compliance_program__c":"COMPLIANCE AND ETHICS",
            "Current_criminal_investigation_pending__c":"COMPLIANCE AND ETHICS",
            "Anti_corruption_training_to_employees__c":"COMPLIANCE AND ETHICS",
            "PRM_Is_former_Nokia__c":"COMPLIANCE AND ETHICS",
            "Direct_Indirect_ownership_in_Company__c":"COMPLIANCE AND ETHICS",
            "Provide_a_detailed_expelanation__c":"COMPLIANCE AND ETHICS",
            "PRM_Year_of_Departure__c":"COMPLIANCE AND ETHICS",
            "Describe__c":"COMPLIANCE AND ETHICS",
            "v.isAgree": "COMPLIANCE AND ETHICS",
            "onFileSuccessCompEth": "COMPLIANCE AND ETHICS"
        };
        
        var tabName = mapFields[fieldName];
        
        var tabValidity = hlp.validateTabforImmErr(cmp, tabName, hlp);
        
        if(!tabValidity){
            cmp.find(tabName).set("v.iconName", "action:approval");            
        }
        if(tabValidity && cmp.find(tabName).get("v.iconName") === "action:approval"){
            cmp.find(tabName).set("v.iconName", "action:close"); 
        }
    },
    validateTabforImmErr: function(component, tabN, helper) {
        var isError = false;
        
        //Validation check for Tab "COMPLIANCE AND ETHICS"
        if (tabN === "COMPLIANCE AND ETHICS") {
            var BribeorCorrupt = component.find("BribeorCorrupt");
            var CodeofConduct = component.find("CodeofConduct");
            var CriminalInvest = component.find("CriminalInvest");
            var DetailedExpl = component.find("DetailedExpl");
            var AntiCorruption = component.find("AntiCorruption");
            var FormerNoki = component.find("FormerNoki");
            var LastTitle = component.find("LastTitle");
            var YearOfDep = component.find("YearOfDep");
            var DirectIndirectownership = component.find("DirectIndirectownership");
            var PlsDescribe = component.find("PlsDescribe");
            var AntiCorrFile = component.get("v.AntiCorrFile");
            var guideline = component.find("guideline");
            if (
                !BribeorCorrupt.get("v.validity").valid ||
                !CodeofConduct.get("v.validity").valid ||
                !CriminalInvest.get("v.validity").valid ||
                !DetailedExpl.get("v.validity").valid ||
                !AntiCorruption.get("v.validity").valid ||
                !FormerNoki.get("v.validity").valid ||
                !LastTitle.get("v.validity").valid ||
                !YearOfDep.get("v.validity").valid ||
                !DirectIndirectownership.get("v.validity").valid ||
                !PlsDescribe.get("v.validity").valid ||
                !guideline.get("v.validity").valid ||
                !component.get("v.isAgree")
            ) {
                
                isError = true;
            }
            
            //Check for either a file upload or File link has been entered in the field CH_Article_Attached__c if Anticorruption related question has been answered as "Yes"
            var uploadedAntiCorrFile = component.get("v.parentCase");
            if (
                AntiCorruption.get("v.value") === "Yes" &&
                !uploadedAntiCorrFile.CH_Article_Attached__c &&
                !guideline.get("v.value")
            ) {
                isError = true;
            }
            //return isError;
        }
        
        return isError;
        //return false;
    }
});