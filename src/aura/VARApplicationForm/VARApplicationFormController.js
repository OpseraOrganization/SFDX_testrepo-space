({
    myAction : function(component, event, helper) {
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
        var validation1 = component.find("validationFirstPage");
        $A.util.addClass(validation1, 'Hide');
        $A.util.removeClass(validation1, 'Show'); 
        var validation2 = component.find("validationSecondPage");
        $A.util.addClass(validation2, 'Hide');
        $A.util.removeClass(validation2, 'Show'); 
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
       
        var userInfo = component.get("c.getCurrentUser");
        userInfo.setCallback(this, function(a) {
            //alert(a.getReturnValue().Contact);
            if(a.getReturnValue().Contact.FirstName != '') {
                //component.find("cfname1").set("v.disabled", "true");
                component.find("cfname1").set("v.value",a.getReturnValue().Contact.FirstName);
             }
            if(a.getReturnValue().Contact.LastName != '') {
              //  component.find("clname1").set("v.disabled", "true");
                component.find("clname1").set("v.value",a.getReturnValue().Contact.LastName);
            }
            if(a.getReturnValue().Contact.Title != '') {
             //   component.find("ctitle1").set("v.disabled", "true");
                component.find("ctitle1").set("v.value",a.getReturnValue().Contact.Title);
            }
            if(a.getReturnValue().Contact.Email != '') {
               // component.find("cemail1").set("v.disabled", "true");
               // component.find("cRetypeEmail").set("v.disabled", "true");
                component.find("cemail1").set("v.value",a.getReturnValue().Contact.Email);
          		component.find("cRetypeEmail").set("v.value",a.getReturnValue().Contact.Email);
             }
            if(a.getReturnValue().Contact.Phone != '') {
             //   component.find("coffice1").set("v.disabled", "true");
                component.find("coffice1").set("v.value",a.getReturnValue().Contact.Phone);
            }
            if(a.getReturnValue().Contact.MobilePhone != '') {
               // component.find("cmobile1").set("v.disabled", "true");
                component.find("cmobile1").set("v.value",a.getReturnValue().Contact.MobilePhone);
            }     
        });
        $A.enqueueAction(userInfo);
        
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
            component.set("v.optverfocus",a.getReturnValue());
        });
        $A.enqueueAction(actionCaseVerFocus);
        
        var actionCaseManufacture = component.get("c.getCaseManufacture");
        actionCaseManufacture.setCallback(this, function(a) {
            component.set("v.optManufacture",a.getReturnValue());
            
        });
        $A.enqueueAction(actionCaseManufacture);
       
        var actionCaseMaintenance = component.get("c.getCaseMaintenanceSupport");
        actionCaseMaintenance.setCallback(this, function(a) {
            component.set("v.optMaintenance",a.getReturnValue());
            
        });
        $A.enqueueAction(actionCaseMaintenance);
        
        var actionSalesTerr = component.get("c.getCaseSalesTerr");
        actionSalesTerr.setCallback(this, function(a) {
            component.set("v.optSalesTerr",a.getReturnValue());
            
        });
        $A.enqueueAction(actionSalesTerr);
        var variablevalue = helper.getParameterByName(component ,event,'accid');
        component.set("v.accid", variablevalue);//set the value
        
        var getValuesFromAccountParam = component.get("c.getValuesFromAccount");
        getValuesFromAccountParam.setParams({
            "accId":component.get("v.accid")
        });
        getValuesFromAccountParam.setCallback(this, function(a) {
            
            if(a.getReturnValue().BillingStreet != '') {
             //   component.find("street1").set("v.disabled", "true");
                component.find("street1").set("v.value",a.getReturnValue().BillingStreet);
            }
            if(a.getReturnValue().BillingCity != '') {
             //   component.find("city").set("v.disabled", "true");
                component.find("city").set("v.value",a.getReturnValue().BillingCity);
            }
            if(a.getReturnValue().BillingPostalCode != '') {
              //  component.find("postal").set("v.disabled", "true");
                component.find("postal").set("v.value",a.getReturnValue().BillingPostalCode);
            }
			if(a.getReturnValue().BillingCountry != '') {
                component.find("country").set("v.disabled", "true");
               //alert(a.getReturnValue().BillingState)
                component.set("v.IsCountryPopulated", true);
                component.set("v.countryPopulated", a.getReturnValue().BillingCountry);
                
                //get state when country populated- start
               /* var country =  a.getReturnValue().BillingCountry;
                var stateValue = component.get("c.getStateValues");
                stateValue.setParams({
                    "country" : country
                });
                stateValue.setCallback(this, function(a) {
                    alert(a.getReturnValue());
                    component.set("v.optState",a.getReturnValue());
                });
                $A.enqueueAction(stateValue);*/
                   // end
            	 component.find("country").set("v.value", a.getReturnValue().BillingCountry);
            } else {
                component.set("v.IsCountryPopulated", false);
                var actionCaseCountry = component.get("c.getCaseCountry");
        		actionCaseCountry.setCallback(this, function(a) {
            		component.set("v.optCountry",a.getReturnValue());
            	});
        		$A.enqueueAction(actionCaseCountry);
            }
            if(a.getReturnValue().BillingState != '') {
                //component.set("v.optState",a.getReturnValue().BillingState);
                 component.find("statep").set("v.disabled", "true");
                component.find("statep").set("v.value",a.getReturnValue().BillingState);
            }
            if(a.getReturnValue().Phone != '') {
                //component.find("phone").set("v.disabled", "true");
                component.find("phone").set("v.value",a.getReturnValue().Phone);
            }
            if(a.getReturnValue().Website != '') {
               // component.find("compweb").set("v.disabled", "true");
                component.find("compweb").set("v.value",a.getReturnValue().Website);
            }
            if(a.getReturnValue().Email_Domain__c != '') {
               // component.find("emaild").set("v.disabled", "true");
                component.find("emaild").set("v.value",a.getReturnValue().Email_Domain__c);
            }
            if(a.getReturnValue().Name != '') {
                component.find("legalOrgName").set("v.disabled", "true");
                component.find("legalOrgName").set("v.value",a.getReturnValue().Name);
            } 
            if(a.getReturnValue().Market__c != '') {
                component.find("SelectMarket").set("v.disabled", "true");
                component.find("SelectMarket").set("v.value",a.getReturnValue().Market__c);
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
            } 
        });
     	$A.enqueueAction(getValuesFromAccountParam); 
        ;
    },
    
    OnNextPage : function(component, event, helper)
    {
        window.scrollTo(0,0);
        //Review This Code
        var SaleTerr = [];
        var x6=document.getElementById("SalesTerr");
        for (var i = 0; i < x6.options.length; i++) {
            if(x6.options[i].selected){
                SaleTerr.push(x6.options[i].value);
            }
        }
        component.set("v.conSelected",SaleTerr);
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
        //var SalesTerr = component.find("SalesTerr").get("v.value");
        //var SalesTerrField = component.find("SalesTerr");
        var Maintenance = component.find("Maintenance").get("v.value");
        var MaintenanceField = component.find("Maintenance");
        var companyWeb = component.find("compweb").get("v.value");
        var companyWebField = component.find("compweb");
        var Maintenance = component.find("Maintenance").get("v.value");
        var MaintenancetField = component.find("Maintenance");
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
        /*if(SalesTerr == '' || SalesTerr == undefined){
            SalesTerrField.set("v.errors",[{message:"Please enter the mandatory field"}]);
            validCnt++;
        }
        else{
            SalesTerrField.set("v.errors",null);
        }*/
        if(Maintenance == '' || Maintenance == undefined){
            MaintenanceField.set("v.errors",[{message:"Please enter the mandatory field"}]);
            validCnt++;
        }
        else{
            MaintenanceField.set("v.errors",null);
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
        
        var salesTrr=document.getElementById("SalesTerr").value;
        if(salesTrr == '' || salesTrr == undefined){
            document.getElementById("message10").innerHTML = "Please enter the mandatory field";
            validCnt++;
        }
        else{
            document.getElementById("message10").innerHTML = "";
        }
        
        var x5=document.getElementById("VerticalFocus").value;
        if(x5 == '' || x5 == undefined){
            document.getElementById("message9").innerHTML = "Please enter the mandatory field";
            validCnt++;
        }
        else{
            document.getElementById("message9").innerHTML = "";
        }
        var count = 0;
        
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
        var isCountryMatch = true;
        for(var i=0; i<conSelectedVar.length; i++){                
            if(conEnteredVar[i] != conSelectedVar[i]) {
                isCountryMatch = false;
                break;
            }
        }
        
        //if(component.get("v.conEntered").length != component.get("v.conSelected").length){
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
        var ConFName = component.find("cfname1").get("v.value");
        var ConFNameField = component.find("cfname1");
        var ConLName = component.find("clname1").get("v.value");
        var ConLNameField = component.find("clname1");
        var ConTitle = component.find("ctitle1").get("v.value");
        var ConTitleField = component.find("ctitle1");
        var ConEmail = component.find("cemail1").get("v.value");
        var ConEmailField = component.find("cemail1");
        var ConOffice = component.find("coffice1").get("v.value");
        var ConOfficeField = component.find("coffice1");
        var ConMobile = component.find("cmobile1").get("v.value");
        var ConMobileField = component.find("cmobile1");
        var ConRetypeEmail = component.find("cRetypeEmail").get("v.value");
        var ConRetypeEmailField = component.find("cRetypeEmail");
        
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
        if(ConRetypeEmail == '' || ConRetypeEmail == undefined){
            ConRetypeEmailField.set("v.errors",[{message:"Please enter the mandatory field"}]);
            validCntt++;
        }
        else{
            ConRetypeEmailField.set("v.errors",null);
        }
        
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
        var ConRetypeEmailField = component.find("cRetypeEmail");
       
        var mailformat = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,4})+$/;
        var cnt = 0;
        if(ConEmail.match(mailformat)){
            ConEmailField.set("v.errors",null);
        }
        else{
            ConEmailField.set("v.errors",[{message:"Please enter valid email format"}]);
            cnt++;
        }
        
        if(ConRetypeEmail.match(mailformat)){
            ConRetypeEmailField.set("v.errors",null);
        }
        else{
            ConRetypeEmailField.set("v.errors",[{message:"Please enter valid email format"}]);
            cnt++;
        }
        
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
        if(ConEmail != ConRetypeEmail){
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
        
        if(!document.getElementById("Group91").checked && !document.getElementById("Group92").checked){
            document.getElementById("message7").innerHTML = "Please enter the mandatory field";
            counter++;
        }
        else{
            document.getElementById("message7").innerHTML = "";
        }
        if(counter>0){
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
       	var cntr = 0;
        var  PleaseDes = component.find("PlsDescribe");
        var  PleaseDesc = component.find("PlsDescribe").get("v.value");
        if(document.getElementById("Group91").checked && (PleaseDesc == '' || PleaseDesc == undefined)){
            PleaseDes.set("v.errors",[{message:"Describe section is required if you select Yes above"}]);
            cntr++;
        }
        else{
            PleaseDes.set("v.errors",null);
        }
        if(cntr>0){
            return false;
        }
       // var checkCmp = component.find("Agretc").get("v.value");
        //var checkCmpField = component.find("Agretc");
        // added for multi language
        var checkCmp=component.get("v.closeModal");
        if(checkCmp != false) {
            //document.getElementById("message8").innerHTML = "Please enter the mandatory field";
            var showToast = $A.get('e.force:showToast');
            
            //set the title and message params
            showToast.setParams(
                {
                    'message': 'Please Click on the URL to check agreement',
                    'type' : 'error'
                    
                }
            );
            
            showToast.fire(); 
            
            
            return false;
            
        }
        helper.save(component, event, helper);
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
        // var required = component.find("firstPage");
        $A.util.addClass(HideModa, 'Show');
        $A.util.removeClass(HideModa, 'Hide');
        
        var HideModal=component.find("CLoseTab");
        // var required = component.find("firstPage");
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
    downloadForm : function(component, event, helper)
    {
        var staticLabel = $A.get("$Label.c.CommunityUrl3");
        
        $A.get("e.force:navigateToURL").setParams(
            {"url": 'https://'+staticLabel+'?Id='+component.get("v.casenumber[0]")
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
        });
        $A.enqueueAction(stateValue);
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
        //var errorDistributor = document.getElementById("distrOp").value;
        //var errorState = a.find('state').get('v.value');
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
        var mFrmt = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,4})+$/;
        if(!regNo.match(num)|| !phone.match(num) || !postal.match(num) || !salesphone.match(num) || !salesemail.match(mFrmt)){
          /*  if(regNo.match(num)){
                a.find('regNo').set("v.errors",null);
            }else{
                a.find('regNo').set("v.errors",[{message:"Please enter a numeric value."}]);
                valCnt++;
            }*/
            if(phone.match(num)){
                a.find('phone').set("v.errors",null);
            }else{
                a.find('phone').set("v.errors",[{message:"Please enter a numeric value."}]);
                valCnt++;
            }           
          /*  if(postal.match(num)){
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
        var a = component.find('findableAuraId');
        a.destroy();        
    },
    
    openmodalA: function(component,event,helper) {
        var id = event.currentTarget.getAttribute('data-attr');
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
})