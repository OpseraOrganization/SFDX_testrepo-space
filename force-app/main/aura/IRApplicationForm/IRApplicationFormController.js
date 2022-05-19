({
    myAction : function(component, event, helper) {
        
        //Check to show maintenance page or not
        helper.checkForMaintenance(component);
        // Initialize parentCase object's fields with blank values
        helper.initializeParentCase(component); //SFPRM-510
        // Assign picklist values for all picklist fields used
        helper.getPickListValues(component);
        
        if(component.get("v.LanguageOption").length == 0) {
            var actionLanguage = component.get("c.getLanguageTerm");
            actionLanguage.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var LanguageArray=[];
                    var Text=response.getReturnValue();
                    for(var i=0;i<Text.length;i++) {
                        LanguageArray.push(Text[i].Language__c);
                    }
                    var index=LanguageArray.indexOf('English');
                    if (index > -1) {
                        LanguageArray.splice(index, 1);
                    }   
                    component.set("v.LanguageOption",LanguageArray);
                }
        	});
        	$A.enqueueAction(actionLanguage);
        }
    },
    
    //Opens up the multilang component to display T&C
    Checked: function (component, event, helper)
    {
        // added for multi languahe
        component.set("v.closeModal",true); 
        if(component.get('v.isAgree') == null || typeof component.get('v.isAgree') === 'undefined')
           component.get('v.isAgree').set('v.checked', false);
        
    },
    
    //copies same values as firstname, lastname, email and phonenumber from your contact details to PRIMARY BUSINESS CONTACT FOR NOKIA
    onCheck :function(component, event, helper)
    {
        
        var checkedValue=component.find("checkbox").get("v.checked");
        
        //If the checkbox is checked copy all data from your contact details onto the below section
        if(checkedValue == true)
        {
            var fName= component.find("cfname1").get("v.value");
            var LName= component.find("clname1").get("v.value");
            var LTitle= component.find("ctitle1").get("v.value");
            var Email= component.find("cemail1").get("v.value");
            var oPhone= component.find("coffice1").get("v.value");
            var cRetype= component.find("cRetypeEmail").get("v.value");
            
            var PB_Fname=component.find("primaryfname")
            PB_Fname.set("v.value",fName);
            PB_Fname.reportValidity();
            var primarylname=component.find("primarylname")
            primarylname.set("v.value",LName);
            primarylname.reportValidity();
            var primarytitle=component.find("primarytitle")
            primarytitle.set("v.value",LTitle);
            primarytitle.reportValidity();
            var primaryemail=component.find("primaryemail")
            primaryemail.set("v.value",Email);
            primaryemail.reportValidity();
            var primaryoffice=component.find("primaryoffice")
            primaryoffice.set("v.value",oPhone);
            primaryoffice.reportValidity();
            var primaryretype=component.find("primaryRetypeEmail")
            primaryretype.set("v.value",cRetype);
            primaryretype.reportValidity();
        }
    },
    downloadForm : function(component, event, helper)
    {
        var staticLabel = $A.get("$Label.c.CommunityUrl");
        $A.get("e.force:navigateToURL").setParams(
            {"url": staticLabel+'?Id='+component.get("v.createdCaseId")
            }).fire();
    },
    
    //Populates state picklist values depending on the value selected in Country picklist
    changeState : function(component, event, helper)
    {
        var country = component.find("country").get("v.value");
        var stateValue = component.get("c.getStateValues");
        stateValue.setParams({
            "country" : country
        });
        stateValue.setCallback(this, function(a) {
            
            var tempState = a.getReturnValue();
            var finalStates = [];
            tempState.forEach(function(item, index){
                finalStates.push({"label":item, "value":item});
            });
            
            component.set("v.optState",finalStates);
            component.find('statep').set("v.value",'');
        });
        $A.enqueueAction(stateValue);
    },
    downloadTC1 : function(component, event, helper) {
        var LangTerm=component.find("LanguageSelection1").get("v.value");
        var staticLabel = $A.get("$Label.c.CommunityUrl2");
        $A.get("e.force:navigateToURL").setParams(
            {"url": staticLabel+LangTerm
            }).fire();
        
    },
	downloadTC2 : function(component, event, helper) {
        var LangTerm=component.find("LanguageSelection2").get("v.value");
        var staticLabel = $A.get("$Label.c.CommunityUrl2");
        $A.get("e.force:navigateToURL").setParams(
            {"url": staticLabel+LangTerm
            }).fire();
        
    },
    downloadTC : function(component, event, helper)
    {
       var LangTerm=component.find("LanguageSelection").get("v.value");
       var staticLabel = $A.get("$Label.c.CommunityUrl2");
       $A.get("e.force:navigateToURL").setParams(
            {"url": staticLabel+LangTerm
            }).fire();
        
    },
    
    //Closes Country Details Modal
    closeModalA:function(component,event,helper){ 
        var a = component.find('findableAuraId');
        a.destroy();
    },
    
    //Method to save Country/Child case details from Modal
    saveModalA:function(component,event,helper){
        var a = component.find('findableAuraId');
        //Fetching all the information entered on the country modal
        var country = a.get('v.label');
        var values = a.get('v.sectionLabels');
        var myMap  = {};
        var mandCnt = 0;
        var valCnt = 0;
        var affiliate = a.get('v.sectionLabels.affil');
        var regNo = a.get('v.sectionLabels.regno');
        var sa1 = a.get('v.sectionLabels.sa1');
        var website = a.get('v.sectionLabels.website');
        var domain = a.get('v.sectionLabels.domain');
        var phone = a.get('v.sectionLabels.phone');
        var city = a.get('v.sectionLabels.city');
        var postal = a.get('v.sectionLabels.postal');
        var salesfname = a.get('v.sectionLabels.salesfname');
        var saleslname = a.get('v.sectionLabels.saleslname');
        var salesemail = a.get('v.sectionLabels.salesemail');
        var salesphone = a.get('v.sectionLabels.salesphone'); 
        var distrOp = a.find('distrOp');
        var affil = a.find('affil');
        var phone = a.find('phone');
        var regNo = a.find('regNo');
        var sa1 = a.find('sa1');
        var website = a.find('website');
        var domain = a.find('domain');
        var city = a.find('city');
        var postal = a.find('postal');
        var salesfname = a.find('salesfname');
        var saleslname = a.find('saleslname');
        var salesemail = a.find('salesemail');
        var salesphone = a.find('salesphone');
        
        //Check for validity of all the values entered in modal
        if(!distrOp.get('v.validity').valid ||
          !affil.get('v.validity').valid ||
          !phone.get('v.validity').valid ||
          !regNo.get('v.validity').valid ||
          !sa1.get('v.validity').valid ||
          !website.get('v.validity').valid ||
          !domain.get('v.validity').valid ||
          !city.get('v.validity').valid ||
          !postal.get('v.validity').valid ||
          !salesfname.get('v.validity').valid ||
          !saleslname.get('v.validity').valid ||
          !salesemail.get('v.validity').valid ||
          !salesphone.get('v.validity').valid){
            
            distrOp.reportValidity();
            affil.reportValidity();
            phone.reportValidity();
            regNo.reportValidity();
            sa1.reportValidity();
            website.reportValidity();
            domain.reportValidity();
            city.reportValidity();
            postal.reportValidity();
            salesfname.reportValidity();
            saleslname.reportValidity();
            salesemail.reportValidity();
            salesphone.reportValidity();
           
            var showToast = $A.get('e.force:showToast');        
                //set the title and message params
                showToast.setParams(
                    {
                        'message': 'Please Check the Page for Errors',
                        'type' : 'error'                   
                    }
                );
                showToast.fire();
            
                return false;
            
        }
        //If all the field values are valid proceed to saving the information
        else{
            helper.createChildCase(component, helper, a.get('v.sectionLabels'),a);
        }         
    },
    
    //Opens modal with field values if any, for each countries(Child cases)
    openmodalA: function(component,event,helper) {
        //Prevent default behaviour of anchor/link
        event.preventDefault();
        var isHQCountry = false;
        var fileNames = [];
        
        //fetch which country link was clicked
        var id = event.getSource().get("v.label");
        //Show checkbox to copy address from parent to child case if HQ Country is same as the selected sales territory
        if(id === component.get("v.parentCase.Country__c")){
            isHQCountry = true;
        }
        var valueMap = {};
        if(component.get('v.sectionLabels') != null){
            var valueMap = component.get('v.sectionLabels')[id];
        }
        //Initialize fileNames property on sectionLabels to blank
        else{
            valueMap.fileNames = [];
        }
		if(valueMap && !valueMap.Id){
           valueMap.Id = ''; 
        }
        //Create and open the "modal_cmp" component as a popup/modal for each country
        $A.createComponent(
            "c:ModalCmp",
            {
                "aura:id": "findableAuraId",
                "label": id,
                "sectionLabels" : valueMap,
                "onclick": component.getReference("c.closeModalA"),
                "save" : component.getReference("c.saveModalA"),
                "copyAddress" : component.getReference("c.copyHeadAddress"),
                "isHQCountry" : isHQCountry,
                "closeModal" : component.getReference("c.closeModal")
            },
            function(newButton, status, errorMessage){
                //Add the new button to the body array
                if (status === "SUCCESS") {
                    var body = component.get("v.body");
                    body.push(newButton);
                    component.set("v.body", body);
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                    // Show offline error
                }
                    else if (status === "ERROR") {
                        console.log("Error: " + errorMessage);
                        // Show error message
                    }
                
            }
        );
        
    },
	
	//Reference Method on "Modal_Cmp" component for copying adress from parent case to child(Country) case Modal fields	
    copyHeadAddress :function(component, event, helper) {
        var checkedValue = component.find('findableAuraId').find('addCheck').get('v.checked');
        if(checkedValue == true) {
            component.find('findableAuraId').set('v.sectionLabels.sa1', component.get("v.parentCase.STREET_ADDRESS_1_CHQ__c")); //component.find('street1').get('v.value'));
            component.find('findableAuraId').set('v.sectionLabels.sa2', component.get("v.parentCase.STREET_ADDRESS_2_CHQ__c")); //component.find('street2').get('v.value'));
            component.find('findableAuraId').set('v.sectionLabels.website', component.get("v.parentCase.Company_website_CHQ__c"));//component.find('compweb').get('v.value'));
            component.find('findableAuraId').set('v.sectionLabels.sa3', component.get("v.parentCase.STREET_ADDRESS_3_CHQ__c"));//component.find('street3').get('v.value'));
            component.find('findableAuraId').set('v.sectionLabels.domain', component.get("v.parentCase.EMAIL_DOMAINS_CHQ__c"));//component.find('emaild').get('v.value'));
            component.find('findableAuraId').set('v.sectionLabels.phone', component.get("v.parentCase.PHONE_NO_CHQ__c"));//component.find('phone').get('v.value'));
            component.find('findableAuraId').find('state').set("v.value", component.get("v.parentCase.State__c"));//component.find('statep').get('v.value'));
            component.find('findableAuraId').set('v.sectionLabels.city', component.get("v.parentCase.City__c"));//component.find('city').get('v.value'));
            component.find('findableAuraId').set('v.sectionLabels.postal', component.get("v.parentCase.POSTAL_CODE_CHQ__c"));//component.find('postal').get('v.value'));
            
        }
    },
	
	//Method to show the New NIRA Form
    ShowIRPage:function(component,event,helper){ 
        component.set("v.showIRPage",true);
        component.set("v.SaveAndReturn",false);
        var formRef = component.find("FormDiv");
        $A.util.removeClass(formRef, "slds-hide");
        $A.util.addClass(formRef, "slds-show");
        
    },
    
	//Method to show dependent fields when 'Nokia Digital Automation Cloud (NDAC)' value is selected in Primary Interset field.
    onChangePrimaryInterest : function(component,event,helper)
    {
        var primRef = component.find("PrimaryInterest");
        if(!primRef.get("v.value") || primRef.get("v.value").length === 0 ){
            primRef.setCustomValidity("An option must be selected");
            primRef.reportValidity();
        }
        if(primRef.get("v.value") && primRef.get("v.value").length > 0){
            primRef.setCustomValidity("");
            primRef.reportValidity();
        }
        if(component.find("PrimaryInterest").get("v.value").includes('Nokia Digital Automation Cloud (NDAC)'))
        {
            component.set("v.ShowPrimaryIntDependFields",true);
            
        }
        else
        {
            component.set("v.ShowPrimaryIntDependFields",false);
        }
    },
    //Method to validate field values when Tab is changed
    tabFocus : function(component,event,helper) {
        helper.validateTabFocus(component,event,helper);
    },
    
	//Method to show Prompt when one of the selected Sales Territory country and HQ Country are same 
    salesTerrChangeHandler : function(component,event,helper){
        
        var salesTerrRef = component.find("SalesTerr");
        var salesTerr = component.find("SalesTerr").get("v.value");
        var countryHQ = component.get("v.parentCase.Country__c"); 
        var isCountry = false;
        if(!salesTerrRef.get("v.value") || salesTerrRef.get("v.value").length === 0 ){
           
            salesTerrRef.setCustomValidity("An option must be selected");
            salesTerrRef.reportValidity();
        }
        if(salesTerrRef.get("v.value") && salesTerrRef.get("v.value").length > 0){
            salesTerrRef.setCustomValidity("");
            salesTerrRef.reportValidity();
        }
        //updating list of countries shown on "AFFILIATES" Tab
        component.set("v.conSelected", salesTerr);
        
        helper.isFormFilled(component,null,null); 
        
        //Check for seleted HQ Country is one of the values selected in Salesterritory, If yes show a Prompt
        salesTerr.forEach(function(item, index){
            if(item === countryHQ) {
                if(component.get("v.showPrompt")){
                    
                    component.find('notifLib').showNotice({
                        "variant": "warning",
                        "header": "Headquarter Country Selected",
                        "message": "You have selected HQ Country as a Sales Territory, please be informed that you won't be able to change HQ Country once you switch to next tab and save the HQ country information.",
                        closeCallback: function() {
                        }
                    });
                    component.set("v.showPrompt", false);
                }
                isCountry = true;
                return;
            }
        });
        
        //To avoid showing Prompt everytime a change occurs on Salesterritory field
        if(!isCountry){
             component.set("v.showPrompt", true);
            
        }
    },
    
    //Method on file upload popup to close it and update the count of files uploaded
    closeModal : function(component, event, helper){
        
        var a = component.find("findableAuraId");
        var myMap = {};
        //Check if the country is already saved if not mark it as saved
        if(component.get("v.conEntered").indexOf(a.get("v.label")) == -1) {
            component.get("v.conEntered").push(a.get("v.label"));
        }
        
        //Saving the updated information in local variable so it can be saved at the end or on save and return
        if(component.get('v.sectionLabels') != null){
            myMap = component.get('v.sectionLabels');
        }
        myMap[a.get("v.label")] = a.get("v.sectionLabels");
        component.set('v.sectionLabels' , myMap);
        
        //Check if file uploaded, if yes the check for no of files validity
        if(a.get("v.sectionLabels.uploadFileId")){
            helper.isFormFilled(component, event, helper);
        }
           var showPrompt = false;
        var msg = '';
        var hdmsg = '';
        var fileIds = a.get("v.sectionLabels.uploadFileId");
        
        //Check to Show 'Atleast 2 files are required' Prompt
        if(!a.get("v.isHQCountry") && (!fileIds || fileIds.length <= 1)){
            showPrompt = true;
            hdmsg = "At least two(2) files are required"
            msg = "Please note that at least two(2) files are required to mark this country as complete";
        }
        if(a.get("v.isHQCountry") && (!fileIds || fileIds.length == 0)){
            showPrompt = true;
            hdmsg = "At least one(1) file is required"
            msg = "Please note that at least one(1) file is required to mark this country as complete";
        }
        
        //Close the modal at the end
        a.destroy();
        
        //Show 'Atleast 2 files are required' Prompt
        if(showPrompt){
            component.find('notifLib').showNotice({
            "variant": "warning",
            "header": hdmsg,
            "message": msg,
        });
        }
    },
	
	//Method to track if Files related to Anti Corruption are uploaded  
    handleSaveOfAntiCorr : function(component, event, helper){
        var fileIds = event.getParam("files");
        component.get("v.AntiCorrFile").push(fileIds.documentId);
        component.set("v.parentCase.CH_Article_Attached__c", true);
        helper.immediateFieldValidation(component, helper, "onFileSuccessCompEth");
        var toastEvent = $A.get("e.force:showToast");
         toastEvent.setParams({
             title: "Success!",
             message: 'File uploaded successfully',
             duration:'5000',
			 key: 'info_alt',
			 type: 'success',
			 mode: 'pester'
    	});
        toastEvent.fire();
        
    },
	
	//Method for Final Form Submiting 
    submitForm : function(component, event, helper){
        //check for last tab's validity
        var istabValid = helper.validateTab(component,'COMPLIANCE AND ETHICS',helper);
        //check if T&C is agreed
        var isTermAgreed = component.get("v.isAgree");
        //If both tab and T&C are valid and agreed respectively process with submitting the Form
        if(!istabValid && isTermAgreed){
           
		   var childCaseMap = helper.adjustChildCasesMap(component, true);
           var parentCase = component.get('v.parentCase');
           parentCase['Status'] = 'New';
           parentCase['Id'] = component.get("v.createdCaseId");
           helper.saveForm(component, parentCase, childCaseMap);
           
        }
        else{
           if(!isTermAgreed)
           	helper.showToast('Please make sure all mandatory fields are filled and Terms and Conditions are agreed');
        }

    },
    
	//Method for Save and Return of the form
    draftSaveForm : function(component, event, helper){
        helper.saveDraftCase(component, helper);
    },
    
	//Method for Form Retrieval
    retrDraftCase : function(component, event, helper){
        var tickNum = component.find("ticketNumber");
        //Checking for Case number validity
        if(!tickNum.get("v.validity").valid){
            helper.showToast('Please check page for Errors');
            return;
        }
        helper.retrDraftCaseDetails(component, helper, tickNum);
    },
    
    handleRetypeEmailBlur : function(component, event, helper){
        var emailField = event.getSource();
        var mainEmailField;
        var isError = false;
        
        mainEmailField = component.find(emailField.get("v.name").slice(6));
        
        if(emailField.get("v.validity").valid && (!mainEmailField || emailField.get("v.value") !== mainEmailField.get("v.value")))
        {
            emailField.setCustomValidity("Value does not match with Email field value");
            emailField.reportValidity();
        }
        
        else if(emailField.get("v.validity").customError){
            if(!mainEmailField || emailField.get("v.value") === mainEmailField.get("v.value"))
            {
                emailField.setCustomValidity("");
                emailField.reportValidity();
            }
        }
    },
    
    handleImmediateError : function(component, event, helper){
        var getSrcFld = event.getSource();
        if(!getSrcFld.get("v.name") && event.getParam('expression'))
            helper.immediateFieldValidation(component, helper, event.getParam('expression'));
        else
            helper.immediateFieldValidation(component, helper, getSrcFld.get("v.name"));
    },
    
    clearWhiteSpaces : function(component, event, helper){
        var getField = event.getSource();
        component.find("ticketNumber").set("v.value", getField.get("v.value").trim());
    }
    
})