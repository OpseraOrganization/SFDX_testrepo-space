({
    MAX_FILE_SIZE: 750000, 
    CHUNK_SIZE: 750000, /* Use a multiple of 4 */ 
    save : function(component, event, helper , saveAndReturn) 
    {        
        var bCallGetCase = false;
        var flag =document.getElementById("Group81").checked;
   	 	if(!saveAndReturn){
        	var guildeline = component.find("guideline").get("v.value");
		}
        var valueForUpload= component.find("required");
        $A.util.addClass(valueForUpload, 'Hide');
        $A.util.removeClass(valueForUpload, 'Show');
    	helper.prepareChildFiles(component, event, helper, this.CHUNK_SIZE);
    },
    prepareChildFiles:function(component, event, helper, chunkSize) 
	{
    	var countryList = component.get("v.conSelected");
        var ccNumber = countryList.length;
        var caseMap = component.get('v.sectionLabels');
        var childFilesMap = {};
        var fileAttached = false;
        /*var childElementFiltered = component.find('child-files').getElements();
        //Removing empty upload elements
        for (var pos in component.find('child-files').getElements())
        {
            var childFileElement = component.find('child-files').getElements()[pos].getElementsByClassName('file')[0]; 
            if(childFileElement.value === '')
            {
                delete childElementFiltered[pos];
            }
            else
            {
                fileAttached = true;
            }
        }
        var index = 0;
        for (var pos in childElementFiltered)
        {
            var country = countryList[pos];
            var childFileElement = childElementFiltered[pos].getElementsByClassName('file')[0]; 
            var fileChild = childFileElement.files[0];
            if (fileChild.size > this.MAX_FILE_SIZE)
            {
                currentSize=(fileChild.size/1048576).toFixed(2);
                maxSize = (this.MAX_FILE_SIZE/1048576).toFixed(2);
                var showToast = $A.get('e.force:showToast');
                showToast.setParams(
                    {
                        'message': 'File size should not exceed ' + maxSize + ' MB.\n'+'Selected file size for ' + country + ': ' + currentSize + ' MB.',
                        'type' : 'error'
                    }
                );
                showToast.fire();
                return;
            }
            var childfr = new FileReader();
            var self = this;
            childfr.onload = function(filereader)
            {
                var childFileObj = {};
                fileContents = filereader.target.result;
                base64Mark = 'base64,';
                dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
                childFileObj['file'] = childElementFiltered[index].getElementsByClassName('file')[0].files[0]
                childFileObj['fileContents'] = fileContents.substring(dataStart);
                childFileObj['fromPos'] = 0;
                childFileObj['toPos'] = Math.min(fileContents.length, childFileObj['fromPos'] + chunkSize);
                childFilesMap[countryList[index]] = childFileObj;
                index++;
                if(index === ccNumber)
                {
                	helper.prepareMainUpload(component, event, helper, childFilesMap);
                }
            };
            childfr.readAsDataURL(fileChild);

        }*/
        if (!fileAttached) 
        {
        	helper.prepareMainUpload(component, event, helper, childFilesMap);	   
        }
    },
    prepareMainUpload : function(component, event, helper, childFilesMap)
    {
        /*var fileInput = component.find("file").getElement();
        var file = fileInput.files[0];
        var fr = new FileReader();
        if(fileInput.value === '')*/
        
        console.log('jotatr');
        var file='';
        if(childFilesMap)
        {
           
            
            var fileContents ='';
            var fromPos='';
            var toPos='';
            this.mgetCase(component, file, fileContents, fromPos, toPos, '', childFilesMap);  
        }
        else
        {
            if (file.size > this.MAX_FILE_SIZE) 
			{
                var currentSize=(file.size/1048576).toFixed(2);
                var maxSize = (this.MAX_FILE_SIZE/1048576).toFixed(2);
                var showToast = $A.get('e.force:showToast');
                showToast.setParams(
                    {
                        'message': 'File size should not exceed ' + maxSize + ' MB.\n' + 'Selected file size: ' + currentSize + ' MB.',
                        'type' : 'error'
                    }
                );
                showToast.fire();
                return;
            }
            var self = this;
            fr.onload = function()
            {
                var fileContents = fr.result;
                var base64Mark = 'base64,';
                var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
                fileContents = fileContents.substring(dataStart);
                self.upload(component, file, fileContents, childFilesMap);
            };
            fr.readAsDataURL(file);
        }
    },
    upload: function(component, file, fileContents, childFilesMap)
	{
        var fromPos = 0;
        var toPos = Math.min(fileContents.length, fromPos + this.CHUNK_SIZE);
        // start with the initial chunk
        this.mgetCase(component, file, fileContents, fromPos, toPos, '', childFilesMap);   
    },
    mgetCase : function(component,file, fileContents, fromPos, toPos, attachId, childFilesMap)
	{ 
        
        var rate_value;
        var businessRealation;
        var nokiaDirectReseller;
        var resell = '';
        var sellTo = '';
        var bribery = '';
        var criminalInv = '';
        var CodeOfConduct = '';
        var antiCorruption = '';
        var directOrIndirect = '';
        var resellerMarket = '';
        var isFormerNokia ='';
        //var resellerMarket = component.find("SelectMarket").get("v.value");
        if(document.getElementById("radio-27").checked){
            nokiaDirectReseller = "Yes";
        }
        else{
            nokiaDirectReseller = "No";
        }
        
        if(document.getElementById("Group31").checked){
            resell   = "Yes";
        }
        else if(document.getElementById("Group32").checked){
            resell = "No";
        }
        
        if(document.getElementById("Group41").checked){
            sellTo  = "Yes";
        }
        else if(document.getElementById("Group42").checked){
            sellTo  = "No";
        }
        
        if(document.getElementById("Group51").checked){
            bribery = "Yes";
        }
        else if(document.getElementById("Group52").checked){
            bribery = "No";
        }
        
        if(document.getElementById("Group61").checked){
            criminalInv = "Yes";
        }
        else if(document.getElementById("Group62").checked){
            criminalInv = "No";
        }
        
        if(document.getElementById("Group71").checked){
            CodeOfConduct  = "Yes";
        }
        else if(document.getElementById("Group72").checked){
            CodeOfConduct = "No";
        }
        
        if(document.getElementById("Group81").checked){
            antiCorruption = "Yes";
        }
        else if(document.getElementById("Group82").checked){
            antiCorruption  = "No";
        }
        
        if(document.getElementById("Group91").checked){
            directOrIndirect = "Yes";
        }
        else if(document.getElementById("Group92").checked){
            directOrIndirect = "NO";
        }
        if(document.getElementById("Group101").checked){
            isFormerNokia = "Yes";
        }
        else if(document.getElementById("Group102").checked){
            isFormerNokia = "NO";
        }
        
        if (document.getElementById("BusinessType").checked) {
            rate_value = document.getElementById("BusinessType").value;
            businessRealation='Value Added Reseller - purchase through distribution';
        }
        if (document.getElementById("Reseller").checked) {
            rate_value = document.getElementById("Reseller").value;
            businessRealation='Value Added Reseller - purchase direct';
        }
        if (document.getElementById("Distributor").checked) {
            rate_value = document.getElementById("Distributor").value;
            businessRealation='Distributor';
        }
        if (document.getElementById("Integrator").checked) {
            rate_value = document.getElementById("Integrator").value;
            businessRealation='Systems Integrator';
        }
        if (document.getElementById("OEM").checked) {
            rate_value = document.getElementById("OEM").value;
            businessRealation='OEM';
        }
        if (document.getElementById("Consultant").checked) {
            rate_value = document.getElementById("Consultant").value;
            businessRealation='Consultant';
        }
        var street1 = component.find("street1").get("v.value");
        var cityValue = component.find("city").get("v.value");
        var postal = component.find("postal").get("v.value");
        var country = component.find("country").get("v.value");
        var phone = component.find("phone").get("v.value");
        var state = component.find("statep").get("v.value");
        var emaild = component.find("emaild").get("v.value");
        var legalOrgName = component.find("legalOrgName").get("v.value");
        var ctype = component.find("companyType").get("v.value");
        var annual = component.find("revenue").get("v.value");
        var totalemp = component.find("noOfEmployee").get("v.value");
        var resellToFed = document.getElementById("Group31");
        var ContactFName = component.get("v.cfname");
        var ContactLName = component.get("v.clname");
        var ContactEmail = component.get("v.cemail");
        var ContactTitle = component.find("ctitle1").get("v.value");
        var ContactOffice = component.find("coffice1").get("v.value");
        var ContactMobile = component.find("cmobile1").get("v.value");           
        var BusinessFName = component.find("primaryfname").get("v.value");
        var BusinessLName = component.find("primarylname").get("v.value");
        var BusinessTitle = component.find("primarytitle").get("v.value");
        var BusinessEmail = component.find("primaryemail").get("v.value");
        var BusinessOffice = component.find("primaryoffice").get("v.value");
        var BusinessMobile = component.find("primarymobile").get("v.value");
        var Street2 = component.find("street2").get("v.value");
        var Street3 = component.find("street3").get("v.value");
        var Fax = component.find("fax").get("v.value");
        var CompanyWeb = component.find("compweb").get("v.value");
        var NumberOfBranchLoc = component.find("nob").get("v.value");
        var BranchCity = component.find("BranchCity").get("v.value");
        var DUNS = component.find("duns").get("v.value");
        var StockEx = component.find("stock").get("v.value");
        var Shareholder = component.find("CompShareholder").get("v.value");
        var YearsinBusiness = component.find("YearsinBus").get("v.value");
        var PerORevSer = component.find("revServices").get("v.value");
        var PerTechPro = component.find("TechPro").get("v.value");
        var EmpInSales = component.find("EmpInSales").get("v.value");
        var EmpInServices = component.find("EmpInServices").get("v.value");
        var EmpInMarketing = component.find("EmpInMarketing").get("v.value");
        var RepNokia = component.find("RepNokia").get("v.value");
        var SalesTerr = component.find("SalesTerr").get("v.value");
        var vat = component.find("vat").get("v.value");
        var VerticalFocus = component.find("VerticalFocus").get("v.value");
        var ManufactureRep = component.find("Manufacture").get("v.value");
        var PrimaryInterest = component.find("PrimaryInterest").get("v.value");
        if(PrimaryInterest.includes('Nokia Digital Automation Cloud (NDAC)'))
        {
            var refand4G5GExp = component.find("refand4G5GExp").get("v.value");
            var radioNetworksInstallationExp = component.find("radioNetworksInstallationExp").get("v.value");
            var radioFrequencyExp = component.find("radioFrequencyExp").get("v.value");
            var tiersSupportLevel = component.find("tiersSupportLevel").get("v.value");
        }
        else
        {
            var refand4G5GExp = "";
            var radioNetworksInstallationExp = "";
            var radioFrequencyExp =  "";
            var tiersSupportLevel =  "";
        }

        var SellNokia = component.find("SellNokia").get("v.value");
        var SaleTerr = component.get("v.conSelected");
        var LeadingComp = component.find("LeadingComp").get("v.value");
        var Maintenance = component.find("Maintenance").get("v.value");	
        var HeadFName = component.find("HFirstName").get("v.value");
        var HeadLName = component.find("HLastName").get("v.value");
        var HeadTitle = component.find('HTitle').get("v.value");
        //var MarkFName = component.find("MFName").get("v.value");
        //var MarkLName = component.find("MLName").get("v.value");
        //var MarkEmail = component.find("MEmail").get("v.value");
        //var MarkPri = component.find("MarkPrimary").get("v.value");
        //var SCFName = component.find("SCFName").get("v.value");
        //var SCLName = component.find("SCLName").get("v.value");
        //var SCEmail = component.find("SCEmail").get("v.value");
        //var SCOffice = component.find("SCOffice").get("v.value");
        //var  SerCFName = component.find("SerCFName").get("v.value");
        //var  SerCLName = component.find("SerCLName").get("v.value");
        //var  SerCEmail = component.find("SerCEmail").get("v.value");
        //var  SerCOffice = component.find("SerCOffice").get("v.value");
        var MarkFName = '';
        var MarkLName = '';
        var MarkEmail = '';
        var MarkPri = '';
        var SCFName = '';
        var SCLName = '';
        var SCEmail = '';
        var SCOffice = '';
        var  SerCFName = '';
        var  SerCLName = '';
        var  SerCEmail = '';
        var  SerCOffice = '';
        var  guideline = component.find("guideline").get("v.value");
        var  businessAct = component.find("busActivities").get("v.value");
        var  ExperienceRel = component.find("ExpRelation").get("v.value");
        var  OrganisationBelong = component.find("OrgBelong").get("v.value");
        var  AnnualIndustry = component.find("AnnualInd").get("v.value");
        var  DetailedExplan = component.find("DetailedExpl").get("v.value");
        var  PleaseDesc = component.find("PlsDescribe").get("v.value");
        var LastTitle = component.find("LastTitle").get("v.value");
        var YearOfDep = component.find("YearOfDep").get("v.value");
        var def = '';
        var cRetype= component.find("cRetypeEmail").get("v.value");
        var primaryretype=component.find("primaryRetypeEmail").get("v.value");
        var persons = component.find("name1").get("v.value") + "-" + component.find("Position(s)1").get("v.value") + "-" +
            component.find("Roles/Responsibility1").get("v.value") + "-" + component.find("EmailAddress1").get("v.value")
        + "," + component.find("name2").get("v.value") + "-" + component.find("Position(s)2").get("v.value") + "-" +
            component.find("Roles/Responsibility2").get("v.value") + "-" + component.find("EmailAddress2").get("v.value")
        + "," + component.find("name3").get("v.value") + "-" + component.find("Position(s)3").get("v.value") + "-" +
            component.find("Roles/Responsibility3").get("v.value") + "-" + component.find("EmailAddress3").get("v.value");
        //alert("fax++"+Fax);
        var mActionGetMappedValues = component.get("c.mGetCaseDetails");
        var chunk = fileContents.substring(fromPos, toPos); 
        for(var country in childFilesMap)
        {
            var childChunk = childFilesMap[country]['fileContents'].substring(childFilesMap[country]['fromPos'], childFilesMap[country]['toPos']);
            childFilesMap[country]['base64Data'] = encodeURIComponent(childChunk);
            childFilesMap[country]['fileName'] = childFilesMap[country]['file'].name;
            childFilesMap[country]['contentType'] =  childFilesMap[country]['file'].type;
            childFilesMap[country]['fileId'] = '';
        }
        var details = [resellerMarket,businessRealation,street1,cityValue,
                       postal,country,phone,state,emaild,legalOrgName,
                       ctype,annual,totalemp,def,def,ContactFName,
                       ContactLName,ContactEmail,ContactTitle,ContactOffice,ContactMobile,
                       BusinessFName,BusinessLName,BusinessTitle,BusinessEmail,BusinessOffice,BusinessMobile,
                       HeadFName,HeadLName,MarkFName,MarkLName,MarkEmail,SCFName,SCLName,SCEmail,
                       SCOffice,MarkPri,SerCFName,SerCLName,SerCEmail,SerCOffice,Street2,Street3,Fax,CompanyWeb,
                       NumberOfBranchLoc,def,def,DUNS,StockEx,Shareholder,YearsinBusiness,BranchCity,def,
                       PerORevSer,PerTechPro,EmpInSales,EmpInServices,EmpInMarketing,RepNokia,def,def,
                       def,LeadingComp,Maintenance,nokiaDirectReseller,resell,sellTo,bribery,criminalInv,
                       CodeOfConduct,antiCorruption,directOrIndirect,businessAct,ExperienceRel,OrganisationBelong,AnnualIndustry,
                       DetailedExplan,PleaseDesc,persons,cRetype,primaryretype,vat,guideline,HeadTitle,isFormerNokia,LastTitle,YearOfDep
                      ];
        for(var a=0;a<details.length;a++)
        {
            if(details[a] == undefined)
            {
                details[a] = ' ';
            }
        }
        var countryJSON = JSON.stringify(component.get('v.sectionLabels'));
        mActionGetMappedValues.setParams(
        {
            "details": JSON.stringify(details),
            "parentId":component.get("v.parentId"),
            "fileName": file.name,
            "base64Data": encodeURIComponent(chunk), 
            "contentType": file.type,
            "fileId": attachId,
            "vertical": VerticalFocus,
            "ManufactureRep": ManufactureRep,
            "PrimaryInterest": PrimaryInterest,
            "refand4G5GExp": refand4G5GExp,
            "radioNetworksInstallationExp": radioNetworksInstallationExp,
            "radioFrequencyExp": radioFrequencyExp,
            "tiersSupportLevel": tiersSupportLevel,
            "CountryToSell": SellNokia,
            "SalesTerritory":SaleTerr,
            "CountryData":countryJSON,
            "terrSelected":component.get("v.conSelected"),
            "saveAndReturn" : component.get("v.isSaveReturn"),
            "caseId" : component.get("v.caseId"),
            "childFilesMap": JSON.stringify(childFilesMap)
        });
        // Set the response data on the component attribute  
        var self = this;
        mActionGetMappedValues.setCallback(this, function(response) 
        {
            attachId = response.getReturnValue();                
            fromPos = toPos;
            toPos = Math.min(fileContents.length, fromPos + self.CHUNK_SIZE);    
            if (fromPos < toPos) 
            {
                self.mgetCase(component, file, fileContents, fromPos, toPos, attachId); 
                
            }
            
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                component.set("v.casenumber", response.getReturnValue());
                if( response.getReturnValue()!= null)
                {
                    
                    var firstPage = component.find("waitingCase");
                    $A.util.addClass(firstPage,'Hide');                            
                    $A.util.removeClass(firstPage,'Show');
                    var firstPage = component.find("firstPage");
                    $A.util.addClass(firstPage,'Hide');                            
                    $A.util.removeClass(firstPage,'Show');
                    var SecondPage = component.find("SecondPage");
                    $A.util.addClass(SecondPage,'Hide');                            
                    $A.util.removeClass(SecondPage,'Show');
                    var finalPage = component.find("finalPage");
                    $A.util.addClass(finalPage,'Hide');                            
                    $A.util.removeClass(finalPage,'Show');
                    var finalButton = component.find("finalButton");
                    $A.util.addClass(finalButton,'Hide');                            
                    $A.util.removeClass(finalButton,'Show');
                    var required = component.find("required");
                    $A.util.addClass(required,'Hide');                            
                    $A.util.removeClass(required,'Show');
                    var successMessage = component.find("successMessage");
                    $A.util.addClass(successMessage,'Show');                            
                    $A.util.removeClass(successMessage,'Hide');
                    var saveReturn = component.find("SaveReturn");
                    $A.util.toggleClass(saveReturn, "toggle");
                    var next = component.find("Next");
                    $A.util.toggleClass(next, "toggle");
                    var SrcTarget = component.find('CountryPage');
                    $A.util.addClass(SrcTarget, 'Hide');
                    $A.util.removeClass(SrcTarget, 'Show');
                    var countryPageButton = component.find("countryPageButton");
                    $A.util.addClass(countryPageButton, 'Hide');
                    $A.util.removeClass(countryPageButton, 'Show');
                    var secondPageButton = component.find("secondPageButton");
                    $A.util.addClass(secondPageButton, 'Hide');
                    $A.util.removeClass(secondPageButton, 'Show');
                }
                
            } 
        }); 
        $A.enqueueAction(mActionGetMappedValues);  
        
        var WaitMsg = component.find("waitingCase");
        $A.util.addClass(WaitMsg,'Show');                            
        $A.util.removeClass(WaitMsg,'Hide');
        for(var i= 0 ; i<5 ; i++)
        {
            setTimeout(
                $A.getCallback(function() {
             
            }),(i)*1000);
        }         
    },        
    isFormFilled : function(component, event, helper){
        var valCnt = 0;
        var mapPushToList = [];
        var childCasesMap = component.get('v.sectionLabels');
        var listCountries = component.get('v.conSelected');

        for(var country of listCountries){
            if(childCasesMap == null || typeof childCasesMap[country] === 'undefined'){
                mapPushToList.push({value:false , key:country})
            }else{
                mapPushToList.push({value:true , key:country})                
            }
        }
        
        component.set('v.countryChecked', mapPushToList);
    },
	validateChildFiles : function(component, event, helper)
	{
        var childFilesReady = true;
		var childElementFiltered = component.find('child-files').getElements();
        for (var pos in component.find('child-files').getElements())
        {
            var childFileElement = component.find('child-files').getElements()[pos].getElementsByClassName('file')[0]; 
            if(childFileElement.value === '')
            {
                childFilesReady = false;
                break;
            }
        }
        return childFilesReady;
    }
});