({
    MAX_FILE_SIZE: 4 500 000, /* 6 000 000 * 3/4 to account for base64 */
    CHUNK_SIZE: 950 000, /* Use a multiple of 4 */
   
    getParameterByName : function(cmp,event,name) {
    	var url = window.location.href;
    	name = name.replace(/[\[\]]/g, "\\$&");
        var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    	if (!results) return null;
        if (!results[2]) return '';
        return decodeURIComponent(results[2].replace(/\+/g, " "));
	},
    save : function(component, event, helper) {
  
    var bCallGetCase = false;
    var file = '';
    var fileContents ='';
    var fromPos='';
    var toPos='';
	
    this.mgetCase(component, file, fileContents, fromPos, toPos, '');
},
    
    upload: function(component, file, fileContents) {
        
        var fromPos = 0;
        var toPos = Math.min(fileContents.length, fromPos + this.CHUNK_SIZE);
        
        
        // start with the initial chunk
        this.mgetCase(component, file, fileContents, fromPos, toPos, '');   
    },
        mgetCase : function(component,file, fileContents, fromPos, toPos, attachId){ 
            // to get the values of form
      
            var rate_value;
            var businessRealation;
            var nokiaDirectReseller;
            var resell = 'false';
            //Line Modified by Deeksha
            var sellTo = 'No';
            //End Modification by Deeksha
            var bribery = 'false';
            var criminalInv = 'false';
            var CodeOfConduct = 'false';
            var antiCorruption = 'false';
            var directOrIndirect = 'false';
           // var resellerMarket = component.find("SelectMarket").get("v.value");
            //Start Modification By Deeksha
            /*if(document.getElementById("radio-27").checked){
                nokiaDirectReseller = "Yes";
            }
            else{
                nokiaDirectReseller = "No";
            }*/
            
            /*if(document.getElementById("Group31").checked){
                resell   = "Yes";
            }
            else if(document.getElementById("Group32").checked){
                resell = "No";
            }*/
            
            /*if(document.getElementById("Group41").checked){
                sellTo  = "Yes";
	            }
            else if(document.getElementById("Group42").checked){
                sellTo  = "No";
            }*/
            
            /*if(document.getElementById("Group51").checked){
                bribery = "Yes";
            }
            else if(document.getElementById("Group52").checked){
                bribery = "No";
            }*/
            
            /*if(document.getElementById("Group61").checked){
                criminalInv = "Yes";
            }
            else if(document.getElementById("Group62").checked){
                criminalInv = "No";
            }*/
            
            /*if(document.getElementById("Group71").checked){
                CodeOfConduct  = "Yes";
            }
            else if(document.getElementById("Group72").checked){
                CodeOfConduct = "No";
            }*/
            
            /*if(document.getElementById("Group81").checked){
                antiCorruption = "Yes";
            }
            else if(document.getElementById("Group82").checked){
                antiCorruption  = "No";
            }*/
            
            if(document.getElementById("Group91").checked){
                directOrIndirect = "Yes";
            }
            else if(document.getElementById("Group92").checked){
                directOrIndirect = "NO";
            }
            //End Modification By Deeksha
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
            //var resellToFed = document.getElementById("Group31");
            var ContactFName = component.find("cfname1").get("v.value");
            var ContactLName = component.find("clname1").get("v.value");
            var ContactEmail = component.find("cemail1").get("v.value");
            var ContactTitle = component.find("ctitle1").get("v.value");
            var ContactOffice = component.find("coffice1").get("v.value");
            var ContactMobile = component.find("cmobile1").get("v.value");
            
            var BusinessFName = ContactFName;
            var BusinessLName = ContactLName;
            var BusinessTitle = '';
            var BusinessEmail = ContactEmail;
            var BusinessOffice = '';
            var BusinessMobile = '';
            var Street2 = component.find("street2").get("v.value");
            var Street3 = component.find("street3").get("v.value");
            var Fax = component.find("fax").get("v.value");
            var CompanyWeb = component.find("compweb").get("v.value");
            var NumberOfBranchLoc = 0;
            var BranchCity = '';
            var DUNS = '';
            var StockEx = component.find("stock").get("v.value");
            var Shareholder = component.find("CompShareholder").get("v.value");
            var YearsinBusiness = component.find("YearsinBus").get("v.value");
            //alert(YearsinBusiness);
            var PerORevSer = component.find("revServices").get("v.value");
            var PerTechPro = component.find("TechPro").get("v.value");
            var EmpInSales = component.find("EmpInSales").get("v.value");
            var EmpInServices = component.find("EmpInServices").get("v.value");
            var EmpInMarketing = component.find("EmpInMarketing").get("v.value");
            var RepNokia = component.find("RepNokia").get("v.value");
            //var SalesTerr = component.find("SalesTerr").get("v.value");
            var vat = '';
            var accountId = component.get("v.accid");
            //alert(accountId);
            var VerticalFocus = [];
            var x=document.getElementById("VerticalFocus");
            //('001');
            for (var i = 0; i < x.options.length; i++) {
                if(x.options[i].selected){
                    VerticalFocus.push(x.options[i].value);
                }
            }
            var ManufactureRep = [];
            var x2=document.getElementById("Manufacture");
            for (var i = 0; i < x2.options.length; i++) {
                if(x2.options[i].selected){
                    ManufactureRep.push(x2.options[i].value);
                }
            }
            var PrimaryInterest = [];
            /*var x3=document.getElementById("PrimaryInterest");
            for (var i = 0; i < x3.options.length; i++) {
                if(x3.options[i].selected){
                    PrimaryInterest.push(x3.options[i].value);
                }
            }*/
            /*var distributorOption = [];
            var x4=document.getElementById("distributorOption");
            for (var i = 0; i < x4.options.length; i++) {
                if(x4.options[i].selected){
                    distributorOption.push(x4.options[i].value);
                }
            } */
            
            var SellNokia = [];
            /*var x5=document.getElementById("SellNokia");
            for (var i = 0; i < x5.options.length; i++) {
                if(x5.options[i].selected){
                    SellNokia.push(x5.options[i].value);
                }
            }*/
            
            var SaleTerr = [];
            var x6=document.getElementById("SalesTerr");
            for (var i = 0; i < x6.options.length; i++) {
                if(x6.options[i].selected){
                    SaleTerr.push(x6.options[i].value);
                }
            }
            
            var LeadingComp = '';
            
            var Maintenance = component.find("Maintenance").get("v.value");	
            //alert('002');
            var HeadFName = '';
            var HeadLName = '';
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
            
            var  businessAct = component.find("busActivities").get("v.value");
            var  ExperienceRel = component.find("ExpRelation").get("v.value");
            var  OrganisationBelong = component.find("OrgBelong").get("v.value");
            var  AnnualIndustry = component.find("AnnualInd").get("v.value");
            var  DetailedExplan = '';
            var  PleaseDesc = component.find("PlsDescribe").get("v.value");
            var def = '';
            var cRetype= component.find("cRetypeEmail").get("v.value");
            var primaryretype='';
            var persons = '';
            //alert("fax++"+Fax);
            //alert('003');
            var countryJSON = JSON.stringify(component.get('v.sectionLabels'));
            var mActionGetMappedValues = component.get("c.mGetCaseDetails");
            var chunk = fileContents.substring(fromPos, toPos); 
            var details = [country,businessRealation,street1,cityValue,
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
                           DetailedExplan,PleaseDesc,persons,cRetype,primaryretype,SalesTerr,vat,accountId
                          ];
            for(var a=0;a<details.length;a++){
                if(details[a] == undefined){
                    details[a] = ' ';
                }
            }
            //alert("Fax++"+Fax);
            //alert('004');
            mActionGetMappedValues.setParams({
                
                "details": JSON.stringify(details),
                "parentId":component.get("v.parentId"),
                "fileName": file.name,
                "base64Data": encodeURIComponent(chunk), 
                "contentType": file.type,
                "fileId": attachId,
                "vertical": VerticalFocus,
                "ManufactureRep": ManufactureRep,
                "PrimaryInterest": PrimaryInterest,
                "CountryToSell": SellNokia,
                "SalesTerritory":SaleTerr,
                "CountryData":countryJSON,
                "terrSelected":component.get("v.conSelected")
            });  
            var self = this;
            //alert('005');
            // Set the response data on the component attribute 
            mActionGetMappedValues.setCallback(this, function(response) {
                attachId = response.getReturnValue();
                //alert('attachId::'+attachId);
                fromPos = toPos;
                
                toPos = Math.min(fileContents.length, fromPos + self.CHUNK_SIZE);    
                
                if (fromPos < toPos) 
                {
                    self.mgetCase(component, file, fileContents, fromPos, toPos, attachId); 
                    
                }
                var state = response.getState();
                //alert('state::'+state);
                if (state === "SUCCESS") {
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
                    }
                    
                } 
            }); 
            // commented the below run function as getting error while trying to create case.
            //$A.getCallback(function() { 
            $A.enqueueAction(mActionGetMappedValues);  
            // });
            
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
            
        },
            
});