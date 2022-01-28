({
    myAction : function(component, event, helper) {
        //alert('33');
        // Prepare a new record from template
        component.find("contactRecordCreator").getNewRecord(
            "Case", // sObject type (objectApiName)
            null,      // recordTypeId
            false,     // skip cache?
            $A.getCallback(function() {
                var rec = component.get("v.newContact");
                var error = component.get("v.newContactError");
                if(error || (rec === null)) {
                    console.log("Error initializing record template: " + error);
                    return;
                }
                console.log("Record template initialized: " + rec.sobjectType);
            })
        );
        // helper.validateForm(component, event, helper);
        //getting current user profile
        
        var WaitMsg = component.find("waitingCase");
        $A.util.addClass(WaitMsg,'Hide');                            
        $A.util.removeClass(WaitMsg,'Show');
        var optsctype=[];
        //for T & C
        var HideModa=component.find("backdrop");
        // var required = component.find("firstPage");
        $A.util.addClass(HideModa, 'Hide');
        $A.util.removeClass(HideModa, 'Show');
        
        var HideModal=component.find("CLoseTab");
        // var required = component.find("firstPage");
        $A.util.addClass(HideModal, 'Hide');
        $A.util.removeClass(HideModal, 'Show');
        
        var required = component.find("required");
        $A.util.addClass(required, 'Hide');
        $A.util.removeClass(required, 'Show');
        var finalButton = component.find("finalButton");
        $A.util.addClass(finalButton, 'Hide');
        $A.util.removeClass(finalButton, 'Show'); 
        var secondPageButton = component.find("secondPageButton");
        $A.util.addClass(secondPageButton, 'Hide');
        $A.util.removeClass(secondPageButton, 'Show'); 
        var countryPageButton = component.find("countryPageButton");
        $A.util.addClass(countryPageButton, 'Hide');
        $A.util.removeClass(countryPageButton, 'Show');
        /*var validation1 = component.find("validationFirstPage");
        $A.util.addClass(validation1, 'Hide');
        $A.util.removeClass(validation1, 'Show'); 
        var validation2 = component.find("validationSecondPage");
        $A.util.addClass(validation2, 'Hide');
        $A.util.removeClass(validation2, 'Show'); */
        var SrcTarget = component.find('successMessage');
        $A.util.addClass(SrcTarget, 'Hide');
        $A.util.removeClass(SrcTarget, 'Show'); 
        var SrcTarget = component.find('SecondPage');
        $A.util.addClass(SrcTarget, 'Hide');
        $A.util.removeClass(SrcTarget, 'Show'); 
        var SrcTarget = component.find('CountryPage');
        $A.util.addClass(SrcTarget, 'Hide');
        $A.util.removeClass(SrcTarget, 'Show');
        var finalPage = component.find('finalPage');
        $A.util.addClass(finalPage, 'Hide');
        $A.util.removeClass(finalPage, 'Show'); 
        
        //Added to get the picklist values dynamically
        var actionCaseMarket = component.get("c.getCaseMarket");
        
        var inputsel = component.find("InputSelectDynamic");
        var opts=[];
        actionCaseMarket.setCallback(this, function(a) {
            component.set("v.opts",a.getReturnValue());
            
        });
        $A.enqueueAction(actionCaseMarket);
        
        
        var actionCaseCType = component.get("c.getCaseCompanytype");
        var optsctype=[];
        actionCaseCType.setCallback(this, function(a) {
            for(var i=0;i< a.getReturnValue().length;i++){                
                optsctype.push(a.getReturnValue()[i]);
            }
            component.set("v.optctype",optsctype);
        });
        $A.enqueueAction(actionCaseCType);
        
        var actionCaseAnnual = component.get("c.getCaseAnnualRevenue");
        var optsAnnual=[];
        actionCaseAnnual.setCallback(this, function(a) {
            for(var i=0;i< a.getReturnValue().length;i++){                
                optsAnnual.push(a.getReturnValue()[i]);
            }
            component.set("v.optAnnual",optsAnnual);
            
        });
        $A.enqueueAction(actionCaseAnnual);
        
        var actionCaseRevenueSer = component.get("c.getCaseRevServices");
        var optsrevServices=[];
        actionCaseRevenueSer.setCallback(this, function(a) {
            for(var i=0;i< a.getReturnValue().length;i++){                
                optsrevServices.push(a.getReturnValue()[i]);
            }
            component.set("v.optRevServices",optsrevServices);
            
        });
        $A.enqueueAction(actionCaseRevenueSer);
        
        var actionNoofEmp = component.get("c.getCaseNumOfEmployees");
        var optsnoemp=[];
        actionNoofEmp.setCallback(this, function(a) {
            for(var i=0;i< a.getReturnValue().length;i++){                
                optsnoemp.push(a.getReturnValue()[i]);
            }
            component.set("v.optnoofemp",optsnoemp);
            
        });
        $A.enqueueAction(actionNoofEmp);
        
        var actionCaseTechPro = component.get("c.getCaseTechProfessional");
        var optstechpro=[];
        actionCaseTechPro.setCallback(this, function(a) {
            for(var i=0;i< a.getReturnValue().length;i++){                
                optstechpro.push(a.getReturnValue()[i]);
            }
            component.set("v.optTechPro",optstechpro);
            
        });
        $A.enqueueAction(actionCaseTechPro);
        
        var actionCaseNoEmpinSales = component.get("c.getCaseEmpInSales");
        var optsempinsales=[];
        actionCaseNoEmpinSales.setCallback(this, function(a) {
            for(var i=0;i< a.getReturnValue().length;i++){                
                optsempinsales.push(a.getReturnValue()[i]);
            }
            component.set("v.optEmpinSales",optsempinsales);
            
        });
        $A.enqueueAction(actionCaseNoEmpinSales);
        
        var actionCaseEmpService = component.get("c.getCaseEmpInService");
        var optsempservice=[];
        actionCaseEmpService.setCallback(this, function(a) {
            for(var i=0;i< a.getReturnValue().length;i++){                
                optsempservice.push(a.getReturnValue()[i]);
            }
            component.set("v.optEmpinServices",optsempservice);
            
        });
        $A.enqueueAction(actionCaseEmpService);
        
        var actionCaseEmpMarketing = component.get("c.getCaseEmpInMarketing");
        actionCaseEmpMarketing.setCallback(this, function(a) {
            component.set("v.optEmpinMarketing",a.getReturnValue());
            
        });
        $A.enqueueAction(actionCaseEmpMarketing);
        
        var actionCaseRepNokia = component.get("c.getCaseRepNokia");
        actionCaseRepNokia.setCallback(this, function(a) {
            component.set("v.optRepNokia",a.getReturnValue());
            
        });
        $A.enqueueAction(actionCaseRepNokia);
        
        var actionCaseVerFocus = component.get("c.getCaseVerticalFocus");
        actionCaseVerFocus.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS"){
                var result = a.getReturnValue();
                var resultArr = [];
                for (var i = 0; i < result.length; i++) {
                    resultArr.push({
                        label: result[i],
                        value: result[i]
                    });
                }
                component.set("v.optverfocus",resultArr);
            } 
        });
        $A.enqueueAction(actionCaseVerFocus);
        
        var actionCaseManufacture = component.get("c.getCaseManufacture");
        actionCaseManufacture.setCallback(this, function(a) {
         var state=a.getState();
          if (state === "SUCCESS"){
                var result = a.getReturnValue();
                var resultArr = [];
                for (var i = 0; i < result.length; i++) {
                    resultArr.push({
                        label: result[i],
                        value: result[i]
                    });
                }
                component.set("v.optManufacture",resultArr);
            }  
            
        });
        $A.enqueueAction(actionCaseManufacture);
        
        var actionCasePrimaryInterest = component.get("c.getCasePrimaryInterest");
        actionCasePrimaryInterest.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS"){
                var result = a.getReturnValue();
                var resultArr = [];
                for (var i = 0; i < result.length; i++) {
                    resultArr.push({
                        label: result[i],
                        value: result[i]
                    });
                }
               component.set("v.optPrimaryInterest",resultArr);
            }
            
        });
        $A.enqueueAction(actionCasePrimaryInterest);
        
        var actionCaseMaintenance = component.get("c.getCaseMaintenanceSupport");
        actionCaseMaintenance.setCallback(this, function(a) {
            component.set("v.optMaintenance",a.getReturnValue());
            
        });
        $A.enqueueAction(actionCaseMaintenance);
        
        
        var actionCaseCountry = component.get("c.getCaseCountry");
        actionCaseCountry.setCallback(this, function(a) {
            component.set("v.optCountry",a.getReturnValue());
            
            
        });
        $A.enqueueAction(actionCaseCountry);
        
               
        var actionDepartureYear = component.get("c.getDepartureYears");
        var optsDepYears=[];
        actionDepartureYear.setCallback(this, function(a) {
            for(var i=0;i< a.getReturnValue().length;i++){                
                optsDepYears.push(a.getReturnValue()[i]);
            }
            component.set("v.optDepartureYear",optsDepYears);

        });
        $A.enqueueAction(actionDepartureYear);
        
        var actionSellNokia = component.get("c.getCaseSellNokia");
        actionSellNokia.setCallback(this, function(a) {
           var state = a.getState();
            if (state === "SUCCESS"){
                var result = a.getReturnValue();
                var resultArr = [];
                for (var i = 0; i < result.length; i++) {
                    resultArr.push({
                        label: result[i],
                        value: result[i]
                    });
                }
               component.set("v.optSellNokia",resultArr);
            }
            
        });
        $A.enqueueAction(actionSellNokia);
        
        var actionSalesTerr = component.get("c.getCaseSalesTerr");
        actionSalesTerr.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS"){
                var result = a.getReturnValue();
                var cyValues = [];
                for (var i = 0; i < result.length; i++) {
                    cyValues.push({
                        label: result[i],
                        value: result[i]
                    });
                }
               component.set("v.optSalesTerr",cyValues);
            }
        });

        $A.enqueueAction(actionSalesTerr);
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
    
    OnNextPage : function(component, event, helper)
    {
        //Review This Code
       var SaleTerr=[];
        var SaleTerr = component.find("SalesTerr").get("v.value");
        //alert(SaleTerr);
       /* var x6=document.getElementById("SalesTerr");
        for (var i = 0; i < x6.options.length; i++) {
            if(x6.options[i].selected){
                SaleTerr.push(x6.options[i].value);

        } */
       	var SaleTerrList=[];
        SaleTerrList = SaleTerr;
        var SaleTerrListNew=[];
        for(var  i=0;i<SaleTerrList.length;i++){
            if(SaleTerrList[i] != 'None'){
                SaleTerrListNew.push(SaleTerrList[i]);
            }
        }
        component.set("v.conSelected",SaleTerrListNew);
        helper.isFormFilled(component, event, helper);
        var selectedValues = component.get("v.conSelected");
        var savedValues = component.get("v.conEntered");
        var i;
        for(i = 0; i < savedValues.length; i++) {
            if(!selectedValues.includes(savedValues[i])) {
                savedValues.splice(i, 1);
            }
        }
        component.set("v.conEntered", savedValues);
        var cfname2Field = component.find("cfname2");
        var cfname2 = component.get("v.cfname");
        var clname2Field = component.find("clname2");
        var clname2 = component.get("v.clname");
        var cemail2Field = component.find("cemail2");
        var cemail2 = component.get("v.cemail");
        var cityField = component.find("city");
        var cityValue = component.find("city").get("v.value");
        var StreetAddress = component.find("street1").get("v.value");
        var postal = component.find("postal").get("v.value");
        var phone = component.find("phone").get("v.value");
        var emaildomain = component.find("emaild").get("v.value");
        var legalOrgName = component.find("legalOrgName").get("v.value");
        var Fax = component.find("fax").get("v.value");
        var ctype = component.find("companyType").get("v.value");
        var annual = component.find("revenue").get("v.value");
        var totalemp = component.find("noOfEmployee").get("v.value");
        //var x4=document.getElementById("distributorOption").value;
        var StreetAddField = component.find("street1");
        var phoneField = component.find("phone");
        var postalField = component.find("postal");
        var faxField = component.find("fax");
        var emaildomainField = component.find("emaild");
        var legalOrgNameField = component.find("legalOrgName");
        //var resellerMarket = component.find("SelectMarket").get("v.value");
        //var resellerMarketField = component.find("SelectMarket");
        var country = component.find("country").get("v.value");
        var countryField = component.find("country");
        var annual = component.find("revenue").get("v.value");
        var annualField = component.find("revenue");
        var totalemp = component.find("noOfEmployee").get("v.value");
        var totalempField = component.find("noOfEmployee");
        var ctype = component.find("companyType").get("v.value");
        var ctypeField = component.find("companyType");
        var SalesTerr = component.find("SalesTerr").get("v.value");
        var PrimaryInterest = component.find("PrimaryInterest");
        var PrimaryInterestValue=PrimaryInterest.get("v.value");
        var SalesTerrField = component.find("SalesTerr");
        var companyWeb = component.find("compweb").get("v.value");
        var companyWebField = component.find("compweb");
        
        if(PrimaryInterestValue.includes('Nokia Digital Automation Cloud (NDAC)'))
        {
            var refand4G5GExp = component.find("refand4G5GExp");
            var refand4G5GExpValue = refand4G5GExp.get("v.value");
            var radioNetworksInstallationExp = component.find("radioNetworksInstallationExp");
            var radioNetworksInstallationExpValue = radioNetworksInstallationExp.get("v.value");
            var radioFrequencyExp = component.find("radioFrequencyExp");
            var radioFrequencyExpValue = radioFrequencyExp.get("v.value");
            var tiersSupportLevel = component.find("tiersSupportLevel");
            var tiersSupportLevelValue = tiersSupportLevel.get("v.value");              
        }             

        var clickedButton= event.getSource().getLocalId();
        if(clickedButton == "Next"){
           window.scrollTo(0,0);
        
        	// validation start
        	var validCnt = 0;
            if(cfname2 == '' || cfname2 == undefined){
                cfname2Field.set("v.errors",[{message:"Please enter the mandatory field"}])
                validCnt++;
            }else{
            	cfname2Field.set("v.errors",null);
        	}
            if(clname2 == '' || clname2 == undefined){
                clname2Field.set("v.errors",[{message:""}])
                validCnt++;
            }else{
            	clname2Field.set("v.errors",null);
        	}
            if(cemail2 == '' || cemail2 == undefined){
                cemail2Field.set("v.errors",[{message:"Please enter the mandatory field"}])
                validCnt++;
            }else{
            	cemail2Field.set("v.errors",null);
        	}
            if(cityValue == '' || cityValue == undefined){
                cityField.set("v.errors",[{message:"Please enter the mandatory field"}]);
                validCnt++;
            }else{
            	cityField.set("v.errors",null);
        	}
            if(StreetAddress == '' || StreetAddress == undefined){
                StreetAddField.set("v.errors",[{message:"Please enter the mandatory field"}]);
                validCnt++;
            }
            else{
                StreetAddField.set("v.errors",null);
            }
            if(postal == '' || postal == undefined){
                postalField.set("v.errors",[{message:"Please enter the mandatory field"}]);
                validCnt++;
            }
            else{
                postalField.set("v.errors",null);
            }
            if(phone == '' || phone == undefined){
                phoneField.set("v.errors",[{message:"Please enter the mandatory field"}]);
                validCnt++;
            }
            else{
                phoneField.set("v.errors",null);
            }
            if(emaildomain == '' || emaildomain == undefined){
                emaildomainField.set("v.errors",[{message:"Please enter the mandatory field"}]);
                validCnt++;
            }
            else{
                emaildomainField.set("v.errors",null);
            }
            if(legalOrgName == '' || legalOrgName == undefined){
                legalOrgNameField.set("v.errors",[{message:"Please enter the mandatory field"}]);
                validCnt++;
            }
            else{
                legalOrgNameField.set("v.errors",null);
            }
            /*if(resellerMarket == '' || resellerMarket == undefined){
                resellerMarketField.set("v.errors",[{message:"Please enter the mandatory field"}]);
                validCnt++;
            }
            else{
                resellerMarketField.set("v.errors",null);
            }*/
            if(country == '' || country == undefined){
                countryField.set("v.errors",[{message:"Please enter the mandatory field"}]);
                validCnt++;
            }
            else{
                countryField.set("v.errors",null);
            }
            if(annual == '' || annual == undefined){
                annualField.set("v.errors",[{message:"Please enter the mandatory field"}]);
                validCnt++;
            }
            else{
                annualField.set("v.errors",null);
            }
            if(totalemp == '' || totalemp == undefined){
                totalempField.set("v.errors",[{message:"Please enter the mandatory field"}]);
                validCnt++;
            }
            else{
                totalempField.set("v.errors",null);
            }
            if(ctype == '' || ctype == undefined){
                ctypeField.set("v.errors",[{message:"Please enter the mandatory field"}]);
                validCnt++;
            }
            else{
                ctypeField.set("v.errors",null);
            }
           
            if(SalesTerr.length == 0 || SalesTerr == undefined){
                SalesTerrField.setCustomValidity('Please enter the mandatory field');
                SalesTerrField.reportValidity();
                validCnt++;
            }
            else{
               
                //SalesTerrField.set("v.errors",null);
            }
            if(companyWeb == '' || companyWeb == undefined){
                companyWebField.set("v.errors",[{message:"Please enter the mandatory field"}]);
                validCnt++;
            }
            else{
                companyWebField.set("v.errors",null);
            }
            
            /*var sPDistributor=document.getElementById("distributorOption").value;
            if(sPDistributor == '' || sPDistributor == undefined){
                document.getElementById("SPNDistributor").innerHTML = "Please enter the mandatory field";
                validCnt++;
            }
            else{
                document.getElementById("SPNDistributor").innerHTML = "";
            }*/
            
            /*var salesTrr=document.getElementById("SalesTerr").value;
            if(salesTrr == '' || salesTrr == undefined){
                document.getElementById("message10").innerHTML = "Please enter the mandatory field";
                validCnt++;
            }
            else{
                document.getElementById("message10").innerHTML = "";
            }*/
           
           
            var PrimaryInterestValueCnt = PrimaryInterestValue.length; //replace(/[^;]/g, "").length;
             if(PrimaryInterestValue.length == 0 || PrimaryInterestValue == undefined){
                
                
                PrimaryInterest.setCustomValidity('Please enter the mandatory field');
                PrimaryInterest.reportValidity();
                validCnt++;
            }
            else{
                //PrimaryInterest.set("v.errors",null);
                if(PrimaryInterestValue.includes('Nokia Digital Automation Cloud (NDAC)'))
                {      
                    if(typeof refand4G5GExpValue == 'undefined' || refand4G5GExpValue == ''){
                        refand4G5GExp.set("v.errors",[{message:"Please enter the mandatory field"}]);
                        validCnt++;
                    }
                    else{
                        refand4G5GExp.set("v.errors",null);
                    }
                    if(typeof radioNetworksInstallationExpValue == 'undefined' || radioNetworksInstallationExpValue == ''){
                        radioNetworksInstallationExp.set("v.errors",[{message:"Please enter the mandatory field"}]);
                        validCnt++;
                    }
                    else{
                        radioNetworksInstallationExp.set("v.errors",null);
                    }
                    if(typeof radioFrequencyExpValue == 'undefined' || radioFrequencyExpValue == '' ){
                        radioFrequencyExp.set("v.errors",[{message:"Please enter the mandatory field"}]);
                        validCnt++;
                    }
                    else{
                        radioFrequencyExp.set("v.errors",null);
                    }
                    if(typeof tiersSupportLevelValue == 'undefined' || tiersSupportLevelValue == '' ){
                        tiersSupportLevel.set("v.errors",[{message:"Please enter the mandatory field"}]);
                        validCnt++;
                    }
                    else{
                        tiersSupportLevel.set("v.errors",null);
                    }
                }
            }
            
           /* var x5=document.getElementById("SellNokia").value;
            if(x5 == '' || x5 == undefined){
                document.getElementById("message9").innerHTML = "Please enter the mandatory field";
                validCnt++;
            }
            else{
                document.getElementById("message9").innerHTML = "";
            }*/
            var count = 0;
            
            if(!document.getElementById("radio-27").checked && !document.getElementById("radio-28").checked){
                document.getElementById("message1").innerHTML = "Please enter the mandatory field";
                validCnt++;
            }
            else{
                document.getElementById("message1").innerHTML = "";
            }
            if(!document.getElementById("Group31").checked && !document.getElementById("Group32").checked){
                document.getElementById("message2").innerHTML = "Please enter the mandatory field";
                validCnt++;
            }
            else{
                document.getElementById("message2").innerHTML = "";
            }
            var cemail2Field = component.find("cemail2");
            
            var mailformat = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,18})+$/;
            if(cemail2.match(mailformat)){
                cemail2Field.set("v.errors",null);
            }else{
                cemail2Field.set("v.errors",[{message:"Please enter valid email format"}]);
                validCnt++;
            }
            if(validCnt>0){
                var showToast = $A.get('e.force:showToast');
                
                //set the title and message params
                showToast.setParams(
                    {
                        'message': 'Please enter mandatory field values',
                        'type' : 'error'
                    }
                );
                
                showToast.fire(); 
                return false;
            }
            
            var cnt = 0;
            var letters = /^[a-zA-Z ]*$/; 
            if(cityValue.match(letters))  
            {  
                cityField.set("v.errors",null);  
            }  
            else  
            {  
                cityField.set("v.errors",[{message:"Please enter only text value"}]);
                cnt++;
            }  
            
            var numb = /^[-+]?[0-9]+$/;
            if(phone.match(numb)){
                phoneField.set("v.errors",null);
            }
            else{
                phoneField.set("v.errors",[{message:"Please enter only numeric value"}]);
                cnt++;
            }
            
            if(Fax == '' || Fax == undefined || Fax.match(numb)){
                faxField.set("v.errors",null);
            }
            else{
                faxField.set("v.errors",[{message:"Please enter only numeric value"}]);
                cnt++;
            }
            if(cnt>0){
                var showToast = $A.get('e.force:showToast');
                
                //set the title and message params
                showToast.setParams(
                    {
                        'message': 'Please enter correct input of fields',
                        'type' : 'error'
                        
                    }
                );
                
                showToast.fire(); 
                return false;
            }

                var SrcTarget = component.find('firstPage');
                $A.util.addClass(SrcTarget, 'Hide');
                $A.util.removeClass(SrcTarget, 'Show'); 
                var nextButton = component.find('nextButton');
                $A.util.addClass(nextButton, 'Hide');
                $A.util.removeClass(nextButton, 'Show'); 
                
                var cmpTarget = component.find('CountryPage');
                $A.util.addClass(cmpTarget, 'Show');
                $A.util.removeClass(cmpTarget, 'Hide');
                var secondPageButton = component.find('countryPageButton');
                $A.util.addClass(secondPageButton, 'Show');
                $A.util.removeClass(secondPageButton, 'Hide');
                
            }else if(clickedButton == "SaveReturn"){
                /*var a = component.get('c.handleSaveCase');
        		$A.enqueueAction(a);      */      
            }
        },
    handleSaveCase : function(component, event, helper) {
        var cfname2Field = component.find("cfname2");
        var cfname2 = component.get("v.cfname");
        var clname2Field = component.find("clname2");
        var clname2 = component.get("v.clname");
        var cemail2Field = component.find("cemail2");
        var cemail2 = component.get("v.cemail");
        //alert('3'+SaleTerr);
        var SaleTerr = component.find("SalesTerr").get("v.value");
        var SaleTerrList= SaleTerr;  
        var SaleTerrListNew=[];
        for(var  i=0;i<SaleTerrList.length;i++){
            if(SaleTerrList[i] != 'None'){
                SaleTerrListNew.push(SaleTerrList[i]);
            }
        }
        // validation start
        window.scrollTo(0,0);
        var validCnt = 0;
        if(cfname2 == '' || cfname2 == undefined){
            cfname2Field.set("v.errors",[{message:"Please enter the mandatory field"}])
            validCnt++;
        }else{
            cfname2Field.set("v.errors",null);
        }
        if(clname2 == '' || clname2 == undefined){
            clname2Field.set("v.errors",[{message:""}])
            validCnt++;
        }else{
            clname2Field.set("v.errors",null);
        }
        if(cemail2 == '' || cemail2 == undefined){
            cemail2Field.set("v.errors",[{message:"Please enter the mandatory field"}])
            validCnt++;
        }else{
            cemail2Field.set("v.errors",null);
        }
        
        var cemail2Field = component.find("cemail2");
        var mailformat = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,18})+$/;
        if(cemail2.match(mailformat)){
            cemail2Field.set("v.errors",null);
        }else{
            cemail2Field.set("v.errors",[{message:"Please enter valid email format"}]);
            validCnt++;
        }
        if(validCnt>0){
            var showToast = $A.get('e.force:showToast');
            
            //set the title and message params
            showToast.setParams(
                {
                    'message': 'Please enter mandatory field values',
                    'type' : 'error'
                    
                }
            );                    
            showToast.fire(); 
            return false;
        }
		component.set("v.conSelected",SaleTerrListNew);
        /*if(component.get("v.LanguageOption").length == 0) {
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
        }*/
        
        var clickedButton= event.getSource().getLocalId();
        component.set("v.isSaveReturn",true);
        var saveAndReturn = true;
        helper.save(component, event, helper, saveAndReturn);
		
        //Review This Code
      // var SaleTerr=[];
       // var SaleTerr = component.find("SalesTerr").get("v.value");
       /* var x6=document.getElementById("SalesTerr");
        for (var i = 0; i < x6.options.length; i++) {
            if(x6.options[i].selected){
                SaleTerr.push(x6.options[i].value);
            }
        } */
       
       // component.set("v.conSelected",SaleTerr);
	   /*
        var selectedValues = component.get("v.conSelected");
        var savedValues = component.get("v.conEntered");
        var i;
        for(i = 0; i < savedValues.length; i++) {
            if(!selectedValues.includes(savedValues[i])) {
                savedValues.splice(i, 1);
            }
        }
        component.set("v.conEntered", savedValues);
        var cityField = component.find("city");
        var cityValue = component.find("city").get("v.value");
        var StreetAddress = component.find("street1").get("v.value");
        var postal = component.find("postal").get("v.value");
        var phone = component.find("phone").get("v.value");
        var emaildomain = component.find("emaild").get("v.value");
        var legalOrgName = component.find("legalOrgName").get("v.value");
        var Fax = component.find("fax").get("v.value");
        var ctype = component.find("companyType").get("v.value");
        var annual = component.find("revenue").get("v.value");
        var totalemp = component.find("noOfEmployee").get("v.value");
        //var x4=document.getElementById("distributorOption").value;
        var StreetAddField = component.find("street1");
        var phoneField = component.find("phone");
        var postalField = component.find("postal");
        var faxField = component.find("fax");
        var emaildomainField = component.find("emaild");
        var legalOrgNameField = component.find("legalOrgName");
        //var resellerMarket = component.find("SelectMarket").get("v.value");
        //var resellerMarketField = component.find("SelectMarket");
        var country = component.find("country").get("v.value");
        var countryField = component.find("country");
        var annual = component.find("revenue").get("v.value");
        var annualField = component.find("revenue");
        var totalemp = component.find("noOfEmployee").get("v.value");
        var totalempField = component.find("noOfEmployee");
        var ctype = component.find("companyType").get("v.value");
        var ctypeField = component.find("companyType");
        var SalesTerr = component.find("SalesTerr").get("v.value");
        var PrimaryInterest = component.find("PrimaryInterest");
        var PrimaryInterestValue=PrimaryInterest.get("v.value");
        var SalesTerrField = component.find("SalesTerr");
        var companyWeb = component.find("compweb").get("v.value");
        var companyWebField = component.find("compweb");
        
        var clickedButton= event.getSource().getLocalId();
		alert(clickedButton);
        if(clickedButton == "SaveReturn"){
           window.scrollTo(0,0);
        
			// validation start
			var validCnt = 0;
			if(cityValue == '' || cityValue == undefined){
				cityField.set("v.errors",[{message:"Please enter the mandatory field"}]);
				validCnt++;
			}
			else{
				cityField.set("v.errors",null);
			}
			if(StreetAddress == '' || StreetAddress == undefined){
				StreetAddField.set("v.errors",[{message:"Please enter the mandatory field"}]);
				validCnt++;
			}
			else{
				StreetAddField.set("v.errors",null);
			}
			if(postal == '' || postal == undefined){
				postalField.set("v.errors",[{message:"Please enter the mandatory field"}]);
				validCnt++;
			}
			else{
				postalField.set("v.errors",null);
			}
			if(phone == '' || phone == undefined){
				phoneField.set("v.errors",[{message:"Please enter the mandatory field"}]);
				validCnt++;
			}
			else{
				phoneField.set("v.errors",null);
			}
			if(emaildomain == '' || emaildomain == undefined){
				emaildomainField.set("v.errors",[{message:"Please enter the mandatory field"}]);
				validCnt++;
			}
			else{
				emaildomainField.set("v.errors",null);
			}
			if(legalOrgName == '' || legalOrgName == undefined){
				legalOrgNameField.set("v.errors",[{message:"Please enter the mandatory field"}]);
				validCnt++;
			}
			else{
				legalOrgNameField.set("v.errors",null);
			}
			if(resellerMarket == '' || resellerMarket == undefined){
				resellerMarketField.set("v.errors",[{message:"Please enter the mandatory field"}]);
				validCnt++;
			}
			else{
				resellerMarketField.set("v.errors",null);
			}
			if(country == '' || country == undefined){
				countryField.set("v.errors",[{message:"Please enter the mandatory field"}]);
				validCnt++;
			}
			else{
				countryField.set("v.errors",null);
			}
			if(annual == '' || annual == undefined){
				annualField.set("v.errors",[{message:"Please enter the mandatory field"}]);
				validCnt++;
			}
			else{
				annualField.set("v.errors",null);
			}
			if(totalemp == '' || totalemp == undefined){
				totalempField.set("v.errors",[{message:"Please enter the mandatory field"}]);
				validCnt++;
			}
			else{
				totalempField.set("v.errors",null);
			}
			if(ctype == '' || ctype == undefined){
				ctypeField.set("v.errors",[{message:"Please enter the mandatory field"}]);
				validCnt++;
			}
			else{
				ctypeField.set("v.errors",null);
			}
			if(SalesTerr == '' || SalesTerr == undefined){
				SalesTerrField.set("v.errors",[{message:"Please enter the mandatory field"}]);
				validCnt++;
			}
			else{
				SalesTerrField.set("v.errors",null);
			}
			if(companyWeb == '' || companyWeb == undefined){
				companyWebField.set("v.errors",[{message:"Please enter the mandatory field"}]);
				validCnt++;
			}
			else{
				companyWebField.set("v.errors",null);
			}
			
			if(PrimaryInterestValue == '' || PrimaryInterestValue == undefined){
				 PrimaryInterest.set("v.errors",[{message:"Please enter the mandatory field"}]);
				validCnt++;
			}
			else{
				PrimaryInterest.set("v.errors",null);
			}
			var count = 0;
			
			if(!document.getElementById("radio-27").checked && !document.getElementById("radio-28").checked){
				document.getElementById("message1").innerHTML = "Please enter the mandatory field";
				validCnt++;
			}
			else{
				document.getElementById("message1").innerHTML = "";
			}
			if(!document.getElementById("Group31").checked && !document.getElementById("Group32").checked){
				document.getElementById("message2").innerHTML = "Please enter the mandatory field";
				validCnt++;
			}
			else{
				document.getElementById("message2").innerHTML = "";
			}
			
			if(validCnt>0){
				var showToast = $A.get('e.force:showToast');
				
				//set the title and message params
				showToast.setParams(
					{
						'message': 'Please enter mandatory field values',
						'type' : 'error'
						
					}
				);
				
				showToast.fire(); 
				return false;
			}
			
			var cnt = 0;
			var letters = /^[a-zA-Z ]*$/; 
			if(cityValue.match(letters))  
			{  
				cityField.set("v.errors",null);  
			}  
			else  
			{  
				cityField.set("v.errors",[{message:"Please enter only text value"}]);
				cnt++;
			}  
			
			var numb = /^[-+]?[0-9]+$/;
			if(phone.match(numb)){
				phoneField.set("v.errors",null);
			}
			else{
				phoneField.set("v.errors",[{message:"Please enter only numeric value"}]);
				cnt++;
			}
			
			if(Fax == '' || Fax == undefined || Fax.match(numb)){
				faxField.set("v.errors",null);
			}
			else{
				faxField.set("v.errors",[{message:"Please enter only numeric value"}]);
				cnt++;
			}
			alert('yahan aaya')
			if(cnt>0){
				var showToast = $A.get('e.force:showToast');
				
				//set the title and message params
				showToast.setParams(
					{
						'message': 'Please enter correct input of fields',
						'type' : 'error'
						
					}
				);
				
				showToast.fire(); 
				return false;
			}else{
				
				
				
                alert('aaya yahan');
				var action = component.get("c.saveAndReturn");
				var details = [cityValue,StreetAddress,postal,phone,emaildomain,legalOrgName,Fax,ctype,StreetAddField,phoneField,postalField,faxField,emaildomainField,legalOrgNameField,country,annual,totalemp];
				for(var a=0;a<details.length;a++){
					if(details[a] == undefined){
						details[a] = ' ';
					}
				}
				 action.setParams({
				 "details": JSON.stringify(details)})
				 action.setCallback(this, function(response) { 
				var state = response.getState();

					if (state === "SUCCESS") {
						alert("From server: " + response.getReturnValue().id);

					}

				});
			  $A.enqueueAction(action); 


				
			} 
		}	
        
        /*
        component.find("contactRecordCreator").saveRecord(function(saveResult) {
            component.set("v.simpleNewContact.of_Employees_to_represent_Nokia_CP__c", "0-10%");
            component.set("v.simpleNewContact.Subject", "Draft Case");
            component.set("v.simpleNewContact.Description", "Draft Description");

            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                // record is saved successfully
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Saved",
                    "message": "The record was saved."
                });
                resultsToast.fire();
                
            } else if (saveResult.state === "INCOMPLETE") {
                // handle the incomplete state
                alert("User is offline, device doesn't support drafts.");
            } else if (saveResult.state === "ERROR") {
                // handle the error state
                alert('Problem saving case, error: ' + JSON.stringify(saveResult.error));
            } else {
                alert('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
            }
        });
        */
    },  
  BackToCountryPage : function(component, event, helper) {
      	
        var SrcTarget = component.find('CountryPage');
        $A.util.addClass(SrcTarget, 'Show');
        $A.util.removeClass(SrcTarget, 'Hide'); 
        var nextButton = component.find('countryPageButton');
        $A.util.addClass(nextButton, 'Show');
        $A.util.removeClass(nextButton, 'Hide'); 
        
        var cmpTarget = component.find('SecondPage');
        $A.util.addClass(cmpTarget, 'Hide');
        $A.util.removeClass(cmpTarget, 'Show');
        var secondPageButton = component.find('secondPageButton');
        $A.util.addClass(secondPageButton, 'Hide');
        $A.util.removeClass(secondPageButton, 'Show');
    },
    OnSecondPage : function(component, event, helper)
    {
        component.get("v.conEntered").sort();
        component.get("v.conSelected").sort();
        var conEnteredVar = component.get("v.conEntered");
        var conSelectedVar = component.get("v.conSelected");
        //('conEnteredVar::'+conEnteredVar);
        //alert('conSelectedVar::'+conSelectedVar);
        var isCountryMatch = true;
        for(var i=0; i<conSelectedVar.length; i++){                
            if(conEnteredVar[i] != conSelectedVar[i]) {
                isCountryMatch = false;
                break;
            }
        }
        if(!isCountryMatch) {
            var showToast = $A.get('e.force:showToast');
            showToast.setParams(
                {
                    'message': 'Please Fill Details of all Countries',
                    'type' : 'error'
                    
                }
            );
            showToast.fire(); 
            return false;
        }
        var SrcTarget = component.find('CountryPage');
        $A.util.addClass(SrcTarget, 'Hide');
        $A.util.removeClass(SrcTarget, 'Show'); 
        var nextButton = component.find('countryPageButton');
        $A.util.addClass(nextButton, 'Hide');
        $A.util.removeClass(nextButton, 'Show'); 
        
        var cmpTarget = component.find('SecondPage');
        $A.util.addClass(cmpTarget, 'Show');
        $A.util.removeClass(cmpTarget, 'Hide');
        var secondPageButton = component.find('secondPageButton');
        $A.util.addClass(secondPageButton, 'Show');
        $A.util.removeClass(secondPageButton, 'Hide');
    },
    finalPage : function(component, event, helper)
    {
        window.scrollTo(0,0);
        var ConFName = component.get("v.cfname");
        var ConFNameField = component.find("cfname1");
        var ConLName = component.get("v.clname");
        var ConLNameField = component.find("clname1");
        var ConTitle = component.find("ctitle1").get("v.value");
        var ConTitleField = component.find("ctitle1");
        var ConEmail = component.get("v.cemail");
        var ConEmailField = component.find("cemail1");
        var ConOffice = component.find("coffice1").get("v.value");
        var ConOfficeField = component.find("coffice1");
        var ConMobile = component.find("cmobile1").get("v.value");
        var ConMobileField = component.find("cmobile1");
        var PriFName = component.find("primaryfname").get("v.value");
        var PriFNameField = component.find("primaryfname");
        var PriLName = component.find("primarylname").get("v.value");
        var PriLNameField = component.find("primarylname");
        var PriTitle = component.find("primarytitle").get("v.value");
        var PriTitleField = component.find("primarytitle");
        var PriEmail = component.find("primaryemail").get("v.value");
        var PriEmailField = component.find("primaryemail");
        var PriOffice = component.find("primaryoffice").get("v.value");
        var PriOfficeField = component.find("primaryoffice");
        var PriMobile = component.find("primarymobile").get("v.value");
        var PriMobileField = component.find("primarymobile");
        var ConRetypeEmail = component.find("cRetypeEmail").get("v.value");
        var ConRetypeEmailField = component.find("cRetypeEmail");
        var PriRetypeEmail = component.find("primaryRetypeEmail").get("v.value");
        var PriRetypeEmailField = component.find("primaryRetypeEmail");
        var HFirstName = component.find("HFirstName").get("v.value");
        var HFirstNameField = component.find("HFirstName");
        var HLastName = component.find("HLastName").get("v.value");
        var HLastNameField = component.find("HLastName");
        var HTitle = component.find("HTitle").get("v.value");
        var HTitleField = component.find("HTitle");
        //var MarkFName = component.find("MFName").get("v.value");
        //var MarkFNameField = component.find("MFName");
        //var MarkLName = component.find("MLName").get("v.value");
        //var MarkLNameField = component.find("MLName");
        //var MarkEmail = component.find("MEmail").get("v.value");
        //var MarkEmailField = component.find("MEmail");
        //var MarkPri = component.find("MarkPrimary").get("v.value");
        //var MarkPriField = component.find("MarkPrimary");
        
        //var SCFName = component.find("SCFName").get("v.value");
        //var SCFNameField = component.find("SCFName");
        //var SCLName = component.find("SCLName").get("v.value");
        //var SCLNameField = component.find("SCLName");
        //var SCEmail = component.find("SCEmail").get("v.value");
        //var SCEmailField = component.find("SCEmail");
        //var SCOffice = component.find("SCOffice").get("v.value");
        //var SCOfficeField = component.find("SCOffice");
        //
        var validCntt = 0;
        if(ConFName == '' || ConFName == undefined){
            ConFNameField.set("v.errors",[{message:"Please enter the mandatory field"}]);
            validCntt++;
        }
        else{
            ConFNameField.set("v.errors",null);
        }
        if(ConLName == '' || ConLName == undefined){
            ConLNameField.set("v.errors",[{message:"Please enter the mandatory field"}]);
            validCntt++;
        }
        else{
            ConLNameField.set("v.errors",null);
        }
        if(ConTitle == '' || ConTitle == undefined){
            ConTitleField.set("v.errors",[{message:"Please enter the mandatory field"}]);
            validCntt++;
        }
        else{
            ConTitleField.set("v.errors",null);
        }
        if(ConEmail == '' || ConEmail == undefined){
            ConEmailField.set("v.errors",[{message:"Please enter the mandatory field"}]);
            validCntt++;
        }
        else{
            ConEmailField.set("v.errors",null);
        }
        if(ConOffice == '' || ConOffice == undefined){
            ConOfficeField.set("v.errors",[{message:"Please enter the mandatory field"}]);
            validCntt++;
        }
        else{
            ConOfficeField.set("v.errors",null);
        }
        if(ConMobile == '' || ConMobile == undefined){
            ConMobileField.set("v.errors",[{message:"Please enter the mandatory field"}]);
            validCntt++;
        }
        else{
            ConMobileField.set("v.errors",null);
        }
        if(PriFName == '' || PriFName == undefined){
            PriFNameField.set("v.errors",[{message:"Please enter the mandatory field"}]);
            validCntt++;
        }
        else{
            PriFNameField.set("v.errors",null);
        }
        if(PriLName == '' || PriLName == undefined){
            PriLNameField.set("v.errors",[{message:"Please enter the mandatory field"}]);
            validCntt++;
        }
        else{
            PriLNameField.set("v.errors",null);
        }
        if(PriTitle == '' || PriTitle == undefined){
            PriTitleField.set("v.errors",[{message:"Please enter the mandatory field"}]);
            validCntt++;
        }
        else{
            PriTitleField.set("v.errors",null);
        }
        if(PriEmail == '' || PriEmail == undefined){
            PriEmailField.set("v.errors",[{message:"Please enter the mandatory field"}]);
            validCntt++;
        }
        else{
            PriEmailField.set("v.errors",null);
        }
        if(PriOffice == '' || PriOffice == undefined){
            PriOfficeField.set("v.errors",[{message:"Please enter the mandatory field"}]);
            validCntt++;
        }
        else{
            PriOfficeField.set("v.errors",null);
        }
        if(PriMobile == '' || PriMobile == undefined){
            PriMobileField.set("v.errors",[{message:"Please enter the mandatory field"}]);
            validCntt++;
        }
        else{
            PriMobileField.set("v.errors",null);
        }
        if(ConRetypeEmail == '' || ConRetypeEmail == undefined){
            ConRetypeEmailField.set("v.errors",[{message:"Please enter the mandatory field"}]);
            validCntt++;
        }
        else{
            ConRetypeEmailField.set("v.errors",null);
        }
        if(PriRetypeEmail == '' || PriRetypeEmail == undefined){
            PriRetypeEmailField.set("v.errors",[{message:"Please enter the mandatory field"}]);
            validCntt++;
        }
        else{
            PriRetypeEmailField.set("v.errors",null);
        }
         if(HFirstName == '' || HFirstName == undefined){
            HFirstNameField.set("v.errors",[{message:"Please enter the mandatory field"}]);
            validCntt++;
        }
        else{
            HFirstNameField.set("v.errors",null);
        }
        if(HLastName == '' || HLastName == undefined){
            HLastNameField.set("v.errors",[{message:"Please enter the mandatory field"}]);
            validCntt++;
        }
        else{
            HLastNameField.set("v.errors",null);
        }
        
        if(HTitle == '' || HTitle == undefined){
            HTitleField.set("v.errors",[{message:"Please enter the mandatory field"}]);
            validCntt++;
        }
        else{
            HTitleField.set("v.errors",null);
        }
        /*if(SCFName == '' || SCFName == undefined){
            SCFNameField.set("v.errors",[{message:"Please enter the mandatory field"}]);
            validCntt++;
        }
        else{
            SCFNameField.set("v.errors",null);
        }*/
        /*if(SCLName == '' || SCLName == undefined){
            SCLNameField.set("v.errors",[{message:"Please enter the mandatory field"}]);
            validCntt++;
        }
        else{
            SCLNameField.set("v.errors",null);
        }*/
        /* if(SCEmail == '' || SCEmail == undefined){
            SCEmailField.set("v.errors",[{message:"Please enter the mandatory field"}]);
            validCntt++;
        }
        else{
            SCEmailField.set("v.errors",null);
        }
        if(SCOffice == '' || SCOffice == undefined){
            SCOfficeField.set("v.errors",[{message:"Please enter the mandatory field"}]);
            validCntt++;
        }
        else{
            SCOfficeField.set("v.errors",null);
        }*/
        /*if(MarkFName == '' || MarkFName == undefined){
            MarkFNameField.set("v.errors",[{message:"Please enter the mandatory field"}]);
            validCntt++;
        }
        else{
            MarkFNameField.set("v.errors",null);
        }
        if(MarkLName == '' || MarkLName == undefined){
            MarkLNameField.set("v.errors",[{message:"Please enter the mandatory field"}]);
            validCntt++;
        }
        else{
            MarkLNameField.set("v.errors",null);
        }
        if(MarkEmail == '' || MarkEmail == undefined){
            MarkEmailField.set("v.errors",[{message:"Please enter the mandatory field"}]);
            validCntt++;
        }
        else{
            MarkEmailField.set("v.errors",null);
        }
        if(MarkPri == '' || MarkPri == undefined){
            MarkPriField.set("v.errors",[{message:"Please enter the mandatory field"}]);
            validCntt++;
        }
        else{
            MarkPriField.set("v.errors",null);
        }*/
        if(validCntt > 0){
            var showToast = $A.get('e.force:showToast');
            
            //set the title and message params
            showToast.setParams(
                {
                    'message': 'Please enter mandatory field values',
                    'type' : 'error'
                    
                }
            );
            
            showToast.fire(); 
            return false;
        }
        
        
        
        
        
        var ConEmailField = component.find("cemail1");
        var ConOfficeField = component.find("coffice1");
        var ConMobileField = component.find("cmobile1");
        var PriEmailField = component.find("primaryemail");
        var PriOfficeField = component.find("primaryoffice");
        var PriMobileField = component.find("primarymobile");
        var ConRetypeEmailField = component.find("cRetypeEmail");
        var PriRetypeEmailField = component.find("primaryRetypeEmail");
        //var MarkEmail = component.find("MEmail").get("v.value");
        //var MarkEmailField = component.find("MEmail");
        //var MarkPri = component.find("MarkPrimary").get("v.value");
        //var MarkPriField = component.find("MarkPrimary");
        //var SCEmail = component.find("SCEmail").get("v.value");
        //var SCEmailField = component.find("SCEmail");
        //var SCOffice = component.find("SCOffice").get("v.value");
        //var SCOfficeField = component.find("SCOffice");
        //var SerCEmail = component.find("SerCEmail").get("v.value");
        //var SerCEmailField = component.find("SerCEmail");
        //var SerCOffice = component.find("SerCOffice").get("v.value");
        //var SerCOfficeField = component.find("SerCOffice");
        
        
        
        var mailformat = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,18})+$/;
        var cnt = 0;
        if(ConEmail.match(mailformat)){
            ConEmailField.set("v.errors",null);
        }
        else{
            ConEmailField.set("v.errors",[{message:"Please enter valid email format"}]);
            cnt++;
        }
        
        if(PriEmail.match(mailformat)){
            PriEmailField.set("v.errors",null);
        }
        else{
            PriEmailField.set("v.errors",[{message:"Please enter valid email format"}]);
            cnt++;
        }
        if(ConRetypeEmail.match(mailformat)){
            ConRetypeEmailField.set("v.errors",null);
        }
        else{
            ConRetypeEmailField.set("v.errors",[{message:"Please enter valid email format"}]);
            cnt++;
        }
        if(PriRetypeEmail.match(mailformat)){
            PriRetypeEmailField.set("v.errors",null);
        }
        else{
            PriRetypeEmailField.set("v.errors",[{message:"Please enter valid email format"}]);
            cnt++;
        }
        /*if(MarkEmail == '' || MarkEmail == undefined || MarkEmail.match(mailformat)){
            MarkEmailField.set("v.errors",null);
        }
        else{
            MarkEmailField.set("v.errors",[{message:"Please enter valid email format"}]);
            cnt++;
        }
        if(SCEmail == '' || SCEmail == undefined || SCEmail.match(mailformat)){
            SCEmailField.set("v.errors",null);
        }
        else{
            SCEmailField.set("v.errors",[{message:"Please enter valid email format"}]);
            cnt++;
        }
        if(SerCEmail == '' || SerCEmail == undefined || SerCEmail.match(mailformat)){
            SerCEmailField.set("v.errors",null);
        }
        else{
            SerCEmailField.set("v.errors",[{message:"Please enter valid email format"}]);
            cnt++;
        }
        */
        var numb = /^[-+]?[0-9]+$/;
        if(ConOffice.match(numb)){
            ConOfficeField.set("v.errors",null);
        }
        else{
            ConOfficeField.set("v.errors",[{message:"Please enter only numeric value"}]);
            cnt++;
        }
        if(ConMobile.match(numb)){
            ConMobileField.set("v.errors",null);
        }
        else{
            ConMobileField.set("v.errors",[{message:"Please enter only numeric value"}]);
            cnt++;
        }
        if(PriOffice.match(numb)){
            PriOfficeField.set("v.errors",null);
        }
        else{
            PriOfficeField.set("v.errors",[{message:"Please enter only numeric value"}]);
            cnt++;
        }
        if(PriMobile.match(numb)){
            PriMobileField.set("v.errors",null);
        }
        else{
            PriMobileField.set("v.errors",[{message:"Please enter only numeric value"}]);
            cnt++;
        }
        /*if(MarkPri == '' || MarkPri == undefined || MarkPri.match(numb)){
            MarkPriField.set("v.errors",null);
        }
        else{
            MarkPriField.set("v.errors",[{message:"Please enter only numeric value"}]);
            cnt++;
        }
        if(SCOffice == '' || SCOffice == undefined || SCOffice.match(numb)){
            SCOfficeField.set("v.errors",null);
        }
        else{
            SCOfficeField.set("v.errors",[{message:"Please enter only numeric value"}]);
            cnt++;
        }
        if(SerCOffice == '' || SerCOffice == undefined || SerCOffice.match(numb)){
            SerCOfficeField.set("v.errors",null);
        }
        else{
            SerCOfficeField.set("v.errors",[{message:"Please enter only numeric value"}]);
            cnt++;
        }
        */
        if(cnt>0){
            var showToast = $A.get('e.force:showToast');
            
            //set the title and message params
            showToast.setParams(
                {
                    'message': 'Please enter correct input of fields',
                    'type' : 'error'
                    
                }
            );
            
            showToast.fire(); 
            return false;
        }
        if(ConEmail != ConRetypeEmail || PriEmail != PriRetypeEmail){
            var showToast = $A.get('e.force:showToast');
            
            //set the title and message params
            showToast.setParams(
                {
                    'message': 'Email and Retype Email values do not match',
                    'type' : 'error'
                    
                }
            );
            
            showToast.fire(); 
            return false;
            
        }
        var cmpTarget = component.find('SecondPage');
        $A.util.addClass(cmpTarget, 'Hide');
        $A.util.removeClass(cmpTarget, 'Show');
        var secondPageButton = component.find('secondPageButton');
        $A.util.addClass(secondPageButton, 'Hide');
        $A.util.removeClass(secondPageButton, 'Show');
        var finalPage = component.find('finalPage');
        $A.util.addClass(finalPage, 'Show');
        $A.util.removeClass(finalPage, 'Hide');
        var finalButton = component.find('finalButton');
        $A.util.addClass(finalButton, 'Show');
        $A.util.removeClass(finalButton, 'Hide');
    },
    BackToFirstPage : function(component, event, helper)
    {
        var cmpTarget = component.find('CountryPage');
        $A.util.addClass(cmpTarget, 'Hide');
        $A.util.removeClass(cmpTarget, 'Show');
        var secondPageButton = component.find('countryPageButton');
        $A.util.addClass(secondPageButton, 'Hide');
        $A.util.removeClass(secondPageButton, 'Show');
        
        var finalPage = component.find('firstPage');
        $A.util.addClass(finalPage, 'Show');
        $A.util.removeClass(finalPage, 'Hide');
        var nextButton = component.find('nextButton');
        $A.util.addClass(nextButton, 'Show');
        $A.util.removeClass(nextButton, 'Hide');
    },
    GotoSecondPage : function(component, event, helper)
    {
        var cmpTarget = component.find('SecondPage');
        $A.util.addClass(cmpTarget, 'show');
        $A.util.removeClass(cmpTarget, 'hide');
        var finalPage = component.find('finalPage');
        $A.util.addClass(finalPage, 'hide');
        $A.util.removeClass(finalPage, 'show');
        
    },
    finalsubmit : function(component, event, helper)
    {
        var counter = 0;
        if(!document.getElementById("Group51").checked && !document.getElementById("Group52").checked){
            document.getElementById("message3").innerHTML = "Please enter the mandatory field";
            counter++;
        }
        else{
            document.getElementById("message3").innerHTML = "";
        }
        if(!document.getElementById("Group61").checked && !document.getElementById("Group62").checked){
            document.getElementById("message4").innerHTML = "Please enter the mandatory field";
            counter++;
        }
        else{
            document.getElementById("message4").innerHTML = "";
        }
        if(!document.getElementById("Group71").checked && !document.getElementById("Group72").checked){
            document.getElementById("message5").innerHTML = "Please enter the mandatory field";
            counter++;
        }
        else{
            document.getElementById("message5").innerHTML = "";
        }
        if(!document.getElementById("Group81").checked && !document.getElementById("Group82").checked){
            document.getElementById("message6").innerHTML = "Please enter the mandatory field";
            counter++;
        }
        else{
            document.getElementById("message6").innerHTML = "";
        }
        if(!document.getElementById("Group91").checked && !document.getElementById("Group92").checked){
            document.getElementById("message7").innerHTML = "Please enter the mandatory field";
            counter++;
        }
        else{
            document.getElementById("message7").innerHTML = "";
        }
        if(!document.getElementById("Group101").checked && !document.getElementById("Group102").checked){
            document.getElementById("message10").innerHTML = "Please enter the mandatory field";
            counter++;
        }
        else{
            document.getElementById("message10").innerHTML = "";
        }
        
        /*if(counter>0){
            var showToast = $A.get('e.force:showToast');
            
            //set the title and message params
            showToast.setParams(
                {
                    'message': 'Please enter mandatory field values',
                    'type' : 'error'
                    
                }
            );
            
            showToast.fire();
            return false;
        }*/
        
         //Validate files inserted
        /*if(!helper.validateChildFiles(component, event, helper))
        {
            var showToast = $A.get('e.force:showToast');
            showToast.setParams(
                {
                    'message': 'Please, make sure all documents related to proof of legal entity are uploaded!',
                    'type' : 'error'
                }
            );
            showToast.fire(); 
            return false;

        }*/
        
        var  DetailedExp = component.find("DetailedExpl");
        var  DetailedExplant = component.find("DetailedExpl").get("v.value");
        var cntr = 0;
        if((document.getElementById("Group51").checked || document.getElementById("Group61").checked)&& (DetailedExplant == '' || DetailedExplant == undefined)){
            DetailedExp.set("v.errors",[{message:"Detailed Explanation is required if you select Yes above"}]);
            
            cntr++;
        }
        else{
            DetailedExp.set("v.errors",null);
        }
        var  PleaseDes = component.find("PlsDescribe");
        var  PleaseDesc = component.find("PlsDescribe").get("v.value");
        if(document.getElementById("Group91").checked && (PleaseDesc == '' || PleaseDesc == undefined)){
            PleaseDes.set("v.errors",[{message:"Describe section is required if you select Yes above"}]);
            cntr++;
        }
        else{
            PleaseDes.set("v.errors",null);
        }
        var  LastTitle = component.find("LastTitle");
        var  LastTitleValue = component.find("LastTitle").get("v.value");
        if(document.getElementById("Group101").checked && (LastTitleValue == '' || LastTitleValue == undefined)){
            LastTitle.set("v.errors",[{message:"Last Title Is Mandatory If You Have Selected Previous Employee As yes"}]);
            cntr++;
        }
        else{
            LastTitle.set("v.errors",null);
        }
        var  YearOfDeparture = component.find("YearOfDep");
        var  YearOfDepartureValues = component.find("YearOfDep").get("v.value");
        if(document.getElementById("Group101").checked && (YearOfDepartureValues == '' || YearOfDepartureValues == undefined)){
            YearOfDeparture.set("v.errors",[{message:"Year Of Departure Is Mandatory If You Have Selected Previous Employee As yes"}]);
            cntr++;
        }
        else{
            YearOfDeparture.set("v.errors",null);
        }
        if(counter>0 || cntr>0){
            var showToast = $A.get('e.force:showToast');
            
            //set the title and message params
            showToast.setParams(
                {
                    'message': 'Please enter mandatory field values',
                    'type' : 'error'
                    
                }
            );
            
            showToast.fire();
            return false;
        }
        
        if(cntr>0){
            return false;
        }
        
        var checkCmp=component.get("v.closeModal");
        if(checkCmp != false) {
            var showToast = $A.get('e.force:showToast');
            showToast.setParams(
                {
                    'message': 'Please click at the bottom of the page on the red text to open & read the Nokia Indirect Reseller Agreement. You must accept the agreement by selecting the “I Accept” box at the bottom of the agreement.',
                    'type' : 'error'
                    
                }
            );
            showToast.fire(); 
            return false;
        }
        
        helper.save(component, event, helper, false);
    },
    downlaoddata : function(component, event, helper)
    {
        /* $A.get("e.force:navigateToURL").setParams(
                {"url": "https://nokia--dprm--c.cs51.visual.force.com/apex/IRPDF?Id="+component.get("v.casenumber")
                }).fire(); */   
    },
    
    closeModal : function(component, event, helper)
    {
        
        var checkCmp = component.find("Agretc").get("v.value");
        var checkCmpField = component.find("Agretc");
        if(checkCmp != true)
        {
            //checkCmpField.set("v.errors",[{message:"Please enter the mandatory field"}]);
            var showToast = $A.get('e.force:showToast');
            //set the title and message params
            showToast.setParams(
                {
                    'message': 'Please Agree With T&C',
                    'type' : 'error'
                    
                }
            );
            
            showToast.fire(); 
            
            return false;
            
        }
        else
        {
            //
            var HideModal=component.find("CLoseTab");
            // var required = component.find("firstPage");
            $A.util.addClass(HideModal, 'Hide');
            $A.util.removeClass(HideModal, 'Show');
            var HideModa=component.find("backdrop");
            // var required = component.find("firstPage");
            $A.util.addClass(HideModa, 'Hide');
            $A.util.removeClass(HideModa, 'Show');
        }
    },
    Checked: function (component, event, helper)
    {
        // added for multi languahe
        component.set("v.closeModal",true); 
        /*var HideModa=component.find("backdrop");
        $A.util.addClass(HideModa, 'Show');
        $A.util.removeClass(HideModa, 'Hide');
        
        var HideModal=component.find("CLoseTab");
        $A.util.addClass(HideModal, 'Show');
        $A.util.removeClass(HideModal, 'Hide');*/
        
    },
    showSpinner : function (component, event, helper) {
        var spinner = component.find('spinner');
        /*var evt = spinner.get("e.toggle");
        evt.setParams({ 
            isVisible : true
        });
        evt.fire(); */   
    },
    
    onCheck :function(component, event, helper)
    {
        var checkedValue=component.find("checkbox").get("v.value");
        
        if(checkedValue == true)
        {
            var fName= component.find("cfname1").get("v.value");
            var LName= component.find("clname1").get("v.value");
            var LTitle= component.find("ctitle1").get("v.value");
            var Email= component.find("cemail1").get("v.value");
            var oPhone= component.find("coffice1").get("v.value");
            var fPhone= component.find("cmobile1").get("v.value");
            var cRetype= component.find("cRetypeEmail").get("v.value");
            
            var PB_Fname=component.find("primaryfname").set("v.value",fName);
            var primarylname=component.find("primarylname").set("v.value",LName);
            var primarytitle=component.find("primarytitle").set("v.value",LTitle);
            var primaryemail=component.find("primaryemail").set("v.value",Email);
            var primaryoffice=component.find("primaryoffice").set("v.value",oPhone);
            var primarymobile=component.find("primarymobile").set("v.value",fPhone);
            var primaryretype=component.find("primaryRetypeEmail").set("v.value",cRetype);
        }
    },
    downloadForm : function(component, event, helper)
    {
        var staticLabel = $A.get("$Label.c.CommunityUrl");
       // alert('staticLabel-1512'+staticLabel);
        $A.get("e.force:navigateToURL").setParams(
            {"url": staticLabel+'?Id='+component.get("v.casenumber[0]")
            }).fire();
    },
    BackforSecond : function(component, event, helper)
    {
        var PageShow = component.find("finalButton");
        $A.util.addClass(PageShow, 'Hide');
        $A.util.removeClass(PageShow, 'Show');
        var finalPageHide =component.find("finalPage");
        $A.util.addClass(finalPageHide, 'Hide');
        $A.util.removeClass(finalPageHide, 'Show');
        
        var PagetoShow = component.find("secondPageButton");
        $A.util.addClass(PagetoShow, 'Show');
        $A.util.removeClass(PagetoShow, 'Hide');
        var SecondPage =component.find("SecondPage");
        $A.util.addClass(SecondPage, 'Show');
        $A.util.removeClass(SecondPage, 'Hide');
        
        
    },
    
    /*selectChange : function(component, event, helper)
    {
        var market = component.find("SelectMarket").get("v.value");
        var distributor = component.get("c.getDistributor");
        var optsdist=[];
        distributor.setParams({
            "market" : market
        });
        distributor.setCallback(this, function(a) {
            for(var i=0;i< a.getReturnValue().length;i++){                
                optsdist.push(a.getReturnValue()[i]);
            }	
            component.set("v.optDistributor",optsdist);
        });
        $A.enqueueAction(distributor);
    },*/
    
    changeState : function(component, event, helper)
    {
        var country = component.find("country").get("v.value");
        var stateValue = component.get("c.getStateValues");
        stateValue.setParams({
            "country" : country
        });
        stateValue.setCallback(this, function(a) {
            component.set("v.optState",a.getReturnValue());
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
    downloadTC : function(component, event, helper)
    {
       var LangTerm=component.find("LanguageSelection").get("v.value");
       var staticLabel = $A.get("$Label.c.CommunityUrl2");
       $A.get("e.force:navigateToURL").setParams(
            {"url": staticLabel+LangTerm
            }).fire();
        
    },
    handleError:function(component, event, helper){
        var comp = event.getSource();
        $A.util.addClass(comp, "error");   
    },
          
    handleClearError:function(component, event, helper){
        var comp = event.getSource();
        $A.util.removeClass(comp, "error");   
    },
    
    closeModalA:function(component,event,helper){ 
        var a = component.find('findableAuraId');
        a.destroy();
    },
    
    saveModalA:function(component,event,helper){
        var a = component.find('findableAuraId');
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
        var fax = a.get('v.sectionLabels.fax');
        var city = a.get('v.sectionLabels.city');
        var postal = a.get('v.sectionLabels.postal');
        var salesfname = a.get('v.sectionLabels.salesfname');
        var saleslname = a.get('v.sectionLabels.saleslname');
        var salesemail = a.get('v.sectionLabels.salesemail');
        var salesphone = a.get('v.sectionLabels.salesphone');    
        var markemail = a.get('v.sectionLabels.markemail');
        var markphone = a.get('v.sectionLabels.markphone');
        var servemail = a.get('v.sectionLabels.servemail');
        var servphone = a.get('v.sectionLabels.servphone');
        var dist = a.get('v.sectionLabels.distributor');
        if(dist == '' || dist == undefined){
            a.find('distrOp').set("v.errors",[{message:"Please enter the mandatory field."}]);
            mandCnt++;
        }
        else{
            a.find('distrOp').set("v.errors",null);
        }             
        /*if(errorState == '' || errorState == undefined){
            document.getElementById("errorState").innerHTML = "Please enter the mandatory field";
            mandCnt++;
        }
        else{
            document.getElementById("errorState").innerHTML = "";
        }  */
        if(affiliate == '' || affiliate == undefined){
            a.find('affil').set("v.errors",[{message:"Please enter the mandatory field."}]);
            mandCnt++;
        }
        else{
            a.find('affil').set("v.errors",null);
        }        
        if(phone == '' || phone == undefined){
            a.find('phone').set("v.errors",[{message:"Please enter the mandatory field."}]);
            mandCnt++;
        }
        else{
            a.find('phone').set("v.errors",null);
        }      
        if(regNo == '' || regNo == undefined){
            a.find('regNo').set("v.errors",[{message:"Please enter the mandatory field."}]);
            mandCnt++;
        }
        else{
            a.find('regNo').set("v.errors",null);
        }
        if(sa1 == '' || sa1 == undefined){
            a.find('sa1').set("v.errors",[{message:"Please enter the mandatory field."}]);
            mandCnt++;
        }
        else{
            a.find('sa1').set("v.errors",null);
        }
        if(website == '' || website == undefined){
            a.find('website').set("v.errors",[{message:"Please enter the mandatory field."}]);
            mandCnt++;
        }
        else{
            a.find('website').set("v.errors",null);
        }
        
        if(domain == '' || domain == undefined){
            a.find('domain').set("v.errors",[{message:"Please enter the mandatory field."}]);
            mandCnt++;
        }
        else{
            a.find('domain').set("v.errors",null);
        }
        
        if(city == '' || city == undefined){
            a.find('city').set("v.errors",[{message:"Please enter the mandatory field."}]);
            mandCnt++;
        }
        else{
            a.find('city').set("v.errors",null);
        }        
        if(postal == '' || postal == undefined){
            a.find('postal').set("v.errors",[{message:"Please enter the mandatory field."}]);
            mandCnt++;
        }
        else{
            a.find('postal').set("v.errors",null);
        }        
        if(salesfname == '' || salesfname == undefined){
            a.find('salesfname').set("v.errors",[{message:"Please enter the mandatory field."}]);
            mandCnt++;
        }
        else{
            a.find('salesfname').set("v.errors",null);
        }        
        if(saleslname == '' || saleslname == undefined){
            a.find('saleslname').set("v.errors",[{message:"Please enter the mandatory field."}]);
            mandCnt++;
        }
        else{
            a.find('saleslname').set("v.errors",null);
        }        
        if(salesemail == '' || salesemail == undefined){
            a.find('salesemail').set("v.errors",[{message:"Please enter the mandatory field."}]);
            mandCnt++;
        }
        else{
            a.find('salesemail').set("v.errors",null);
        }        
        if(salesphone == '' || salesphone == undefined){
            a.find('salesphone').set("v.errors",[{message:"Please enter the mandatory field."}]);
            mandCnt++;
        }
        else{
            a.find('salesphone').set("v.errors",null);
        }        
        if(mandCnt>0){
            var showToast = $A.get('e.force:showToast');        
            showToast.setParams(
                {
                    'message': 'Please enter values for mandatory fields.',
                    'type' : 'error'                   
                }
            );
            showToast.fire();
            return false;
        }
        var num = /^[-+]?[0-9]+$/;
        var mFrmt = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,18})+$/;
        if(!regNo.match(num)|| !phone.match(num) || !postal.match(num) || !salesphone.match(num) || !salesemail.match(mFrmt)){
            /*if(regNo.match(num)){
                a.find('regNo').set("v.errors",null);
            }else{
                a.find('regNo').set("v.errors",[{message:"Please enter a numeric value."}]);
                valCnt++;
            } */
            if(phone.match(num)){
                a.find('phone').set("v.errors",null);
            }else{
                a.find('phone').set("v.errors",[{message:"Please enter a numeric value."}]);
                valCnt++;
            } /*          
            if(postal.match(num)){
                a.find('postal').set("v.errors",null);
            }else{
                a.find('postal').set("v.errors",[{message:"Please enter only numeric value."}]);
                valCnt++;
            }   */
            if(salesemail.match(mFrmt)){
                a.find('salesemail').set("v.errors",null);
            }else{
                a.find('salesemail').set("v.errors",[{message:"Please enter valid email."}]);
                valCnt++;
            }
            if(valCnt>0){
                var showToast = $A.get('e.force:showToast');        
                //set the title and message params
                showToast.setParams(
                    {
                        'message': 'Please enter the correct values.',
                        'type' : 'error'                   
                    }
                );
                showToast.fire();
                return false;
            }            
        }
        
        if(!fax == '' && !fax.match(num)){
            a.find('fax').set("v.errors",[{message:"Please enter only numeric value"}]);
            valCnt++;
        }else{
            a.find('fax').set("v.errors",null);
        }
        
        if(!markphone == '' && !markphone.match(num)){
            a.find('markphone').set("v.errors",[{message:"Please enter only numeric value"}]);
            valCnt++;
        }else{
            a.find('markphone').set("v.errors",null);
        }
        
        if(!servphone == '' && !servphone.match(num)){
            a.find('servphone').set("v.errors",[{message:"Please enter only numeric value"}]);
            valCnt++;
        }else{
            a.find('servphone').set("v.errors",null);
        }
        if(!markemail == '' && !markemail.match(mFrmt)){
            a.find('markemail').set("v.errors",[{message:"Please enter only numeric value"}]);
            valCnt++;
        }else{
            a.find('markemail').set("v.errors",null);
        }
        if(!servemail == '' && !servemail.match(mFrmt)){
            a.find('servemail').set("v.errors",[{message:"Please enter only numeric value"}]);
            valCnt++;
        }else{
            a.find('servemail').set("v.errors",null);
        }
        if(valCnt>0){
            var showToast = $A.get('e.force:showToast');        
            //set the title and message params
            showToast.setParams(
                {
                    'message': 'Please enter the correct values.',
                    'type' : 'error'                   
                }
            );
            showToast.fire();
            return false;
        }
        if(component.get("v.conEntered").indexOf(country) == -1) {
            component.get("v.conEntered").push(country);
        }
        if(component.get('v.sectionLabels') != null){
            myMap = component.get('v.sectionLabels');
        }

        myMap[country] = values;
        component.set('v.sectionLabels' , myMap);
        helper.isFormFilled(component, event, helper);
        var a = component.find('findableAuraId');
        a.destroy();        
    },
    
    openmodalA: function(component,event,helper) {
        var isHQCountry = false;
        var id = event.currentTarget.getAttribute('data-attr');
        if(id === component.find('country').get('v.value')){
            isHQCountry = true;
        }
        var sa1 = event.currentTarget.getAttribute('');
        var valueMap = {};
        if(component.get('v.sectionLabels') != null){
            var valueMap = component.get('v.sectionLabels')[id];
        }
        //a.find('state').get('v.value')
        //a.find('distrOp').set('v.value', 'Test-Coop');
        //a.set('v.sectionLabels.distributor', 'Test-Coop');
        $A.createComponent(
            "c:ModalCmp",
            {
                "aura:id": "findableAuraId",
                "label": id,
                "sectionLabels" : valueMap,
                "onclick": component.getReference("c.closeModalA"),
                "save" : component.getReference("c.saveModalA"),
                "copyAddress" : component.getReference("c.copyHeadAddress"),
                "isHQCountry" : isHQCountry
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
    copyHeadAddress :function(component, event, helper) {
        var checkedValue = component.find('findableAuraId').find('addCheck').get('v.value');
        if(checkedValue == true) {
            component.find('findableAuraId').set('v.sectionLabels.sa1', component.find('street1').get('v.value'));
            component.find('findableAuraId').set('v.sectionLabels.sa2', component.find('street2').get('v.value'));
            component.find('findableAuraId').set('v.sectionLabels.website', component.find('compweb').get('v.value'));
            component.find('findableAuraId').set('v.sectionLabels.sa3', component.find('street3').get('v.value'));
            component.find('findableAuraId').set('v.sectionLabels.domain', component.find('emaild').get('v.value'));
            component.find('findableAuraId').set('v.sectionLabels.phone', component.find('phone').get('v.value'));
            component.find('findableAuraId').find('state').set("v.value", component.find('statep').get('v.value'));
            component.find('findableAuraId').set('v.sectionLabels.fax', component.find('fax').get('v.value'));
            component.find('findableAuraId').set('v.sectionLabels.city', component.find('city').get('v.value'));
            component.find('findableAuraId').set('v.sectionLabels.postal', component.find('postal').get('v.value'));
            
        }
    },
    ShowIRPage:function(component,event,helper){ 
        component.set("v.showIRPage",true);
        component.set("v.SaveAndReturn",false);
        
    },
    
    RetriveForm:function(component,event,helper){ 
        
        var actionOnload=component.get("c.myAction");
        actionOnload.setCallback(this, function(response){
		component.set("v.showIRPage",true);
        
          //('tree');
    var caseId = component.find('ticketNumber').get("v.value");
    component.set("v.draftTicket", caseId);
		
    var mapValue = component.get("v.sectionLabels");
	if(caseId != undefined ){
		var retrieveAction = component.get("c.caseFromCaseNo");
			retrieveAction.setParams({
				
				"loginCaseNumber":caseId
			});  
			retrieveAction.setCallback(this, function(response) {
                var state = response.getState();
                //(state);
				if (state === "SUCCESS") {
					component.set("v.casenumber", response.getReturnValue());
                    
					if( response.getReturnValue().isErrorExist == false)
					{
                        component.set("v.showIRPage",true);
                        component.set("v.caseId", response.getReturnValue().CaseObj.Id);
						component.set("v.SaveAndReturn",false);
						var optsdist=[];
                        var res = response.getReturnValue().CaseObj;
						var stateList = response.getReturnValue().caseList;
                        
                        if(res.FAX__c != undefined) {
                            component.find("fax").set("v.value", res.FAX__c);
                        }
                        if(res.Offer_your_own_Maintenance_and_Support__c != undefined) {
                            component.find("Maintenance").set("v.value", res.Offer_your_own_Maintenance_and_Support__c);
                        }
                        if(res.Current_Manufacturers_CP__c != undefined) {
                            component.find("Manufacture").set("v.value", res.Current_Manufacturers_CP__c.split(';'));
                        }
                        if(res.Who_are_your_leading_competitors__c != undefined) {
                        component.find("LeadingComp").set("v.value", res.Who_are_your_leading_competitors__c);
                        }
						if(res.Primary_Interest_CP__c != undefined){
                            if(res.Primary_Interest_CP__c.includes('Nokia Digital Automation Cloud (NDAC)'))
                            {
                                component.set("v.ShowPrimaryIntDependFields",true);
                                component.find("refand4G5GExp").set("v.value", res.List_Ref_and_4G_5G_Experience__c);
                                component.find("radioNetworksInstallationExp").set("v.value", res.Radio_Networks_Installation_Experience__c);
                                component.find("radioFrequencyExp").set("v.value", res.Radio_Frequency_Expirience__c);
                                component.find("tiersSupportLevel").set("v.value", res.Tier1_Tier2_Support_Level__c);                                
                            }
                            component.find("PrimaryInterest").set("v.value",res.Primary_Interest_CP__c.split(';'));
						}
						if(res.Top_3_Targeted_Vertical_focus_Industries__c != undefined){
						component.find("VerticalFocus").set("v.value",res.Top_3_Targeted_Vertical_focus_Industries__c.split(';'));
						}
						if(res.Which_countries__c != undefined){
						component.find("SellNokia").set("v.value",res.Which_countries__c.split(';'));
						}
                        //alert(res.Which_Sales_Territory_are_You__c);
						if(res.Which_Sales_Territory_are_You__c != undefined){
							component.find("SalesTerr").set("v.value",res.Which_Sales_Territory_are_You__c.split(';'));
						}   
						if(res.STREET_ADDRESS_1_CHQ__c != undefined){
							component.find('street1').set("v.value",res.STREET_ADDRESS_1_CHQ__c );
						}
						if(res.Which_Sales_Territory_are_You__c != undefined){
							
							//component.find('street1').set("v.value",res.STREET_ADDRESS_1_CHQ__c );
						}
						if(res.STREET_ADDRESS_2_CHQ__c != undefined){
							component.find('street2').set("v.value",res.STREET_ADDRESS_2_CHQ__c );
						}if(res.STREET_ADDRESS_3_CHQ__c != undefined){
							component.find('street3').set("v.value",res.STREET_ADDRESS_3_CHQ__c );
						}if(res.City__c != undefined){
							component.find('city').set("v.value",res.City__c );
						}if(res.POSTAL_CODE_CHQ__c != undefined){
							component.find('postal').set("v.value",res.POSTAL_CODE_CHQ__c );
						}if(res.Country__c != undefined){
							component.find('country').set("v.value",res.Country__c );
                            var country = component.find("country").get("v.value");
                            var stateValue = component.get("c.getStateValues");
                            stateValue.setParams({
                                "country" : country
                            });
                            stateValue.setCallback(this, function(a) {
                                component.set("v.optState",a.getReturnValue());
                                if(res.State__c != undefined) {
                            		component.find('statep').set("v.value",res.State__c);
                                }
                            });
                            $A.enqueueAction(stateValue);
                        }if(res.PHONE_NO_CHQ__c != undefined){
							component.find('phone').set("v.value",res.PHONE_NO_CHQ__c );
						}if(res.Company_website_CHQ__c != undefined){
							component.find('compweb').set("v.value",res.Company_website_CHQ__c );
						}if(res.EMAIL_DOMAINS_CHQ__c != undefined){
							component.find('emaild').set("v.value",res.EMAIL_DOMAINS_CHQ__c );
						}if(res.Number_of_Branch_locations_CHQ__c != undefined){
							component.find('nob').set("v.value",res.Number_of_Branch_locations_CHQ__c );
						}if(res.Branch_Offices__c != undefined){
							component.find('BranchCity').set("v.value",res.Branch_Offices__c );
						}if(res.Full_Legal_Name_of_Your_Organization_CP__c != undefined){
							component.find('legalOrgName').set("v.value",res.Full_Legal_Name_of_Your_Organization_CP__c );
						}if(res.VAT_Number__c != undefined){
							component.find('vat').set("v.value",res.VAT_Number__c );
						}if(res.Dun_Bradstreet_D_U_N_S_Number_CP__c != undefined){
							component.find('duns').set("v.value",res.Dun_Bradstreet_D_U_N_S_Number_CP__c );
						}if(res.Company_type_CP__c != undefined){
							component.find('companyType').set("v.value",res.Company_type_CP__c );
						}if(res.Number_of_years_in_business_CP__c != undefined){
							component.find('YearsinBus').set("v.value",res.Number_of_years_in_business_CP__c );
						}if(res.Annual_revenues_CP__c != undefined){
							component.find('revenue').set("v.value",res.Annual_revenues_CP__c );
						}if(res.Percentage_revenues_through_Services_CP__c != undefined){
							component.find('revServices').set("v.value",res.Percentage_revenues_through_Services_CP__c );
						}if(res.Total_Number_of_employees_CP__c != undefined){
							component.find('noOfEmployee').set("v.value",res.Total_Number_of_employees_CP__c );
						}if(res.Percentage_of_Technical_Professionals_CP__c != undefined){
							component.find('TechPro').set("v.value",res.Percentage_of_Technical_Professionals_CP__c );
						}if(res.Percentage_of_Total_Employees_in_Serv_CP__c != undefined){
							component.find('EmpInServices').set("v.value",res.Percentage_of_Total_Employees_in_Serv_CP__c );
						}if(res.Percentage_of_Total_EmployeesIn_Sales_CP__c != undefined){
							component.find('EmpInSales').set("v.value",res.Percentage_of_Total_EmployeesIn_Sales_CP__c );
						}if(res.of_Total_Employees_in_Marketing_CP__c != undefined){
							component.find('EmpInMarketing').set("v.value",res.of_Total_Employees_in_Marketing_CP__c );
						}if(res.of_Employees_to_represent_Nokia_CP__c != undefined){
							component.find('RepNokia').set("v.value",res.of_Employees_to_represent_Nokia_CP__c );
						} 
                        if(res.Are_you_already_a_Nokia_Direct_Reseller__c != undefined) {
                            if(res.Are_you_already_a_Nokia_Direct_Reseller__c == 'Yes'){
							 	document.getElementById("radio-27").checked = true;
							}else{
                            	document.getElementById("radio-28").checked = true;
							}
                        }
                        if(res.Willing_to_resell_to_USA_Federal_CP__c != undefined){
							if(res.Willing_to_resell_to_USA_Federal_CP__c == 'Yes'){
								document.getElementById("Group31").checked = true;
							}else{
								document.getElementById("Group32").checked = true;
							}
						}
						if(res.Willing_to_sell_to_non_USA_Govt_CP__c != undefined){
							if(res.Willing_to_sell_to_non_USA_Govt_CP__c == 'Yes'){
								document.getElementById("Group41").checked = true;
							}else{
								document.getElementById("Group42").checked = true;
							}
						}
                        //alert(res.Bribery_or_corruption__c);
                        if(res.Bribery_or_corruption__c != undefined){
							if(res.Bribery_or_corruption__c == 'Yes'){
								document.getElementById("Group51").checked = true;
							}else{
								document.getElementById("Group52").checked = true;
							}
						}if(res.Current_criminal_investigation_pending__c != undefined){
							if(res.Current_criminal_investigation_pending__c == 'Yes'){
								document.getElementById("Group61").checked = true;
							}else{
								document.getElementById("Group62").checked = true;
							}
						}
                        if(res.Code_of_Conduct_Compliance_program__c != undefined){
							if(res.Code_of_Conduct_Compliance_program__c == 'Yes'){
								document.getElementById("Group71").checked = true;
							}else{
								document.getElementById("Group72").checked = true;
							}
						}if(res.Anti_corruption_training_to_employees__c != undefined){
							if(res.Anti_corruption_training_to_employees__c == 'Yes'){
								document.getElementById("Group81").checked = true;
							}else{
								document.getElementById("Group82").checked = true;
							}
						}
                         if(res.Direct_Indirect_ownership_in_Company__c != undefined){
							if(res.Direct_Indirect_ownership_in_Company__c == 'Yes'){
								document.getElementById("Group91").checked = true;
							}else{
								document.getElementById("Group92").checked = true;
							}
						}
                        if(res.PRM_Is_former_Nokia__c != undefined){
							if(res.PRM_Is_former_Nokia__c == 'Yes'){
								document.getElementById("Group101").checked = true;
							}else{
								document.getElementById("Group102").checked = true;
							}
						}
                        if(res.First_Name__c != undefined){
							component.find('cfname1').set("v.value",res.First_Name__c);
						}
                        if(res.Last_Name__c != undefined){
							component.find('clname1').set("v.value",res.Last_Name__c);
						}
                        if(res.Email__c != undefined){
							component.find('cemail1').set("v.value",res.Email__c);
						}
                        if(res.Mobile_Phone__c != undefined){
							component.find('cmobile1').set("v.value",res.Mobile_Phone__c);
						}
                        if(res.Office_Phone__c != undefined){
							component.find('coffice1').set("v.value",res.Office_Phone__c);
						}
                        if(res.CRetype_Email__c != undefined){
							component.find('cRetypeEmail').set("v.value",res.CRetype_Email__c);
						}
                        if(res.Title__c != undefined){
							component.find('ctitle1').set("v.value",res.Title__c);
						}
                        if(res.PB_First_Name__c != undefined){
							component.find('primaryfname').set("v.value",res.PB_First_Name__c);
						}
                        if(res.PB_Last_Name__c != undefined){
							component.find('primarylname').set("v.value",res.PB_Last_Name__c);
						}
                        if(res.PB_Title__c != undefined){
							component.find('primarytitle').set("v.value",res.PB_Title__c);
						}if(res.PB_Email__c != undefined){
							component.find('primaryemail').set("v.value",res.PB_Email__c);
						}
                        if(res.PB_Mobile_Phone__c != undefined) {
							component.find('primarymobile').set("v.value",res.PB_Mobile_Phone__c);
						}
                        if(res.PB_Office_Phone__c != undefined){
							component.find('primaryoffice').set("v.value",res.PB_Office_Phone__c);
						}
                        if(res.Pri_Retype_Email__c != undefined){
							component.find('primaryRetypeEmail').set("v.value",res.Pri_Retype_Email__c);
						}
                        if(res.H_First_Name__c != undefined){
							component.find('HFirstName').set("v.value",res.H_First_Name__c);
						}if(res.H_Last_Name__c != undefined){
							component.find('HLastName').set("v.value",res.H_Last_Name__c);
						}if(res.PRM_H_Title__c !=undefined){
                            component.find('HTitle').set("v.value",res.PRM_H_Title__c)
                        }if(res.Describe_your_current_business_activity__c != undefined){
							component.find('busActivities').set("v.value",res.Describe_your_current_business_activity__c);
						}if(res.Describe_the_expereince_or_relationships__c != undefined){
							component.find('ExpRelation').set("v.value",res.Describe_the_expereince_or_relationships__c);
						}if(res.Organizations_which_your_company_belong__c != undefined){
							component.find('OrgBelong').set("v.value",res.Organizations_which_your_company_belong__c);
						}if(res.Annual_industry_conferences_you_attend__c != undefined){
							component.find('AnnualInd').set("v.value",res.Annual_industry_conferences_you_attend__c);
						}
                        //Bribery_or_corruption__c
                        //Current_criminal_investigation_pending__c
                        if(res.Provide_a_detailed_expelanation__c != undefined){
							component.find('DetailedExpl').set("v.value",res.Provide_a_detailed_expelanation__c);
						}if(res.Guideline_URL__c != undefined){
							component.find('guideline').set("v.value",res.Guideline_URL__c);
						}if(res.Describe__c != undefined){
							component.find('PlsDescribe').set("v.value",res.Describe__c);
						}
                        if(res.PRM_Last_Title__c != undefined){
							component.find('LastTitle').set("v.value",res.PRM_Last_Title__c);
						}
                        if(res.PRM_Year_of_Departure__c != undefined){
							component.find('YearOfDep').set("v.value",res.PRM_Year_of_Departure__c);
						}
                        //alert(res.Persons_responsible_for_work__c);
                        //alert(res.Persons_responsible_for_work__c);
                       if(res.Persons_responsible_for_work__c != undefined) {
                            var Persons = res.Persons_responsible_for_work__c.split(',');
							var person1 = Persons[0].split('-');
                            var person2 = Persons[1].split('-');
                            var person3 = Persons[2].split('-');
                           component.find('name1').set("v.value",person1[0]);
                            component.find('Position(s)1').set("v.value",person1[1]);
                            component.find('Roles/Responsibility1').set("v.value",person1[2]);
                            component.find('EmailAddress1').set("v.value",person1[3]);
                            component.find('name2').set("v.value",person2[0]);
                            component.find('Position(s)2').set("v.value",person2[1]);
                            component.find('Roles/Responsibility2').set("v.value",person2[2]);
                            component.find('EmailAddress2').set("v.value",person2[3]);
                            component.find('name3').set("v.value",person3[0]);
                            component.find('Position(s)3').set("v.value",person3[1]);
                            component.find('Roles/Responsibility3').set("v.value",person3[2]);
                            component.find('EmailAddress3').set("v.value",person3[3]);
                       }
                        //Code_of_Conduct_Compliance_program__c
                        //Anti_corruption_training_to_employees__c
                        //Direct_Indirect_ownership_in_Company__c
                        component.set("v.conSelected",response.getReturnValue().caseList);
						component.set("v.sectionLabels",response.getReturnValue().CaseMap);
                        for (var key in component.get("v.sectionLabels")) {
                            component.get("v.conEntered").push(key);
						}
                        //alert(response.getReturnValue().CaseMap.keys());
						//component.get("v.conEntered").push(response.getReturnValue().caseList.keys());
					}else{
                        component.set("v.showIRPage",false);
						var toastEvent = $A.get("e.force:showToast");
						toastEvent.setParams({
							title : 'Error Message',
							message:'Enter Valid Ticket number ',
							duration:' 5000',
							key: 'info_alt',
							type: 'error',
							mode: 'pester'
						});
						toastEvent.fire();
					}
					
				}else{
					
				} 
			}); 
			// commented the below run function as getting error while trying to create case.
			//$A.getCallback(function() { 
			$A.enqueueAction(retrieveAction); 
		}else{
            component.set("v.showIRPage",false);
			var toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({
				title : 'Error Message',
				message:'Enter Application number to retrieve',
				duration:' 5000',
				key: 'info_alt',
				type: 'error',
				mode: 'pester'
			});
			toastEvent.fire();
		}
        })
        $A.enqueueAction(actionOnload);
    },    
    
    onChangePrimaryInterest : function(component,event,helper)
    {
        if(component.find("PrimaryInterest").get("v.value").includes('Nokia Digital Automation Cloud (NDAC)'))
        {
            component.set("v.ShowPrimaryIntDependFields",true);
        }
        else
        {
            component.set("v.ShowPrimaryIntDependFields",false);
        }
    }

})